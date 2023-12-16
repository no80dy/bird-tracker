import jwt

from urllib.parse import parse_qsl
from starlette.requests import Request
from sqladmin.authentication import AuthenticationBackend

from core.settings import settings
from .user import verify_user, check_username_exists


class AdminAuth(AuthenticationBackend):
    async def login(self, request: Request):
        if request.method == 'POST':
            body = (await request.body()).decode()
            data = dict(parse_qsl(body))
            if not await verify_user(
                data['username'],
                data['password']
            ):
                return False
            request.session.update(
                {
                    'token': jwt.encode(
                        {'username': data['username']},
                        settings.FASTAPI_SECRET_KEY, algorithm='HS256'
                    )
                }
            )
            return True

    async def logout(self, request: Request):
        request.session.clear()
        return True

    async def authenticate(self, request: Request) -> bool:
        token = request.session.get('token')
        if not token:
            return False
        data = jwt.decode(token, settings.FASTAPI_SECRET_KEY, algorithms=['HS256', ])
        if not await check_username_exists(data['username']):
            return False
        return True
