import jwt
from typing import Annotated

from http import HTTPStatus
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

from services.users import UserService, get_user_service
from core.settings import settings


router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/api/v1/users/token')


@router.post(
	'/token'
)
async def login(
	form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
	user_service: UserService = Depends(get_user_service)
):
	user = await user_service.get_user_by_username(form_data.username)

	if not user or not await user_service.check_password(
		form_data.username, form_data.password
	):
		raise HTTPException(
			status_code=HTTPStatus.BAD_REQUEST,
			detail='Неверный логин или пароль'
		)

	return {
		'access_token': jwt.encode(
			{'username': form_data.username},
			settings.FASTAPI_SECRET_KEY,
			algorithm='HS256'
		),
		'token_type': 'bearer'
	}


@router.get('/user')
async def get_current_user(
	token: Annotated[str, Depends(oauth2_scheme)],
	user_service: UserService = Depends(get_user_service)
):
	user_data = jwt.decode(token, settings.FASTAPI_SECRET_KEY, algorithms=['HS256', ])
	if not await user_service.get_user_by_username(user_data['username']):
		raise HTTPException(
			status_code=HTTPStatus.BAD_REQUEST,
			detail='Некорректный пользователь'
		)
	return {
		'username': user_data['username']
	}
