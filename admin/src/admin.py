import uuid
from typing import Union
import jwt

from passlib.hash import pbkdf2_sha512
from urllib.parse import parse_qsl
from fastapi import FastAPI
from starlette.requests import Request
from sqlalchemy import select
from sqladmin import Admin, ModelView
from sqlalchemy.ext.asyncio import AsyncEngine
from sqladmin.authentication import AuthenticationBackend
from starlette.responses import Response

from database import get_db_session
from models import (
	Bird,
	BirdFamily,
	BirdObservation,
	BirdLocation,
	BirdStatus,
	BirdImage,
	User
)


class BirdAdmin(ModelView, model=Bird):
	name = 'Bird'
	name_plural = 'Birds'

	column_list = [Bird.id, Bird.bird_name, ]


class BirdFamilyAdmin(ModelView, model=BirdFamily):
	name = 'Bird family'
	name_plural = 'Bird families'

	column_list = [BirdFamily.id, BirdFamily.family_name, ]


class BirdObservationAdmin(ModelView, model=BirdObservation):
	name = 'Bird observation'
	name_plural = 'Bird observations'

	column_list = [BirdObservation.id, BirdObservation.description, ]


class BirdLocationAdmin(ModelView, model=BirdLocation):
	name = 'Bird location'
	name_plural = 'Bird locations'

	column_list = [
		BirdLocation.id, BirdLocation.latitude, BirdLocation.longitude,
	]


class BirdStatusAdmin(ModelView, model=BirdStatus):
	name = 'Bird status'
	name_plural = 'Bird statuses'

	column_list = [BirdStatus.id, BirdStatus.status_name, ]


class BirdImageAdmin(ModelView, model=BirdImage):
	name = 'Bird image'
	name_plural = 'Bird images'

	column_list = [BirdImage.id, BirdImage.image, ]


async def check_username(username: str) -> bool:
	async for session in get_db_session():
		user = (await session.execute(
			select(User).where(User.username == username)
		)).scalars().all()
		return bool(user)


async def check_password(username: str, password: str) -> bool:
	async for session in get_db_session():
		user = (await session.execute(
			select(User).where(User.username == username)
		)).scalars().first()
		return pbkdf2_sha512.verify(password, user.password_hash)


class AdminAuth(AuthenticationBackend):
	async def login(self, request: Request):
		if request.method == 'POST':
			body = (await request.body()).decode()
			data = dict(parse_qsl(body))
			if not await check_username(data['username']):
				return False
			if not await check_password(data['username'], data['password']):
				return False
			request.session.update(
				{'token': jwt.encode({'username': data['username']}, 'secret', algorithm='HS256')}
			)
			return True
		return False

	async def logout(self, request: Request):
		request.session.clear()
		return True

	async def authenticate(self, request: Request) -> bool:
		token = request.session.get('token')
		if not token:
			return False
		data = jwt.decode(token, 'secret', algorithms=['HS256', ])
		if not await check_username(data['username']):
			return False
		return True


def init_admin_session(app: FastAPI, sql_engine: AsyncEngine) -> None:
	authentication_backend = AdminAuth(secret_key='secret')
	admin = Admin(app, sql_engine, authentication_backend=authentication_backend)

	admin.add_view(BirdAdmin)
	admin.add_view(BirdStatusAdmin)
	admin.add_view(BirdImageAdmin)
	admin.add_view(BirdLocationAdmin)
	admin.add_view(BirdFamilyAdmin)
	admin.add_view(BirdObservationAdmin)
