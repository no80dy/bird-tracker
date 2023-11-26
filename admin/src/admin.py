from typing import Any

from fastapi import FastAPI
from sqladmin import Admin, ModelView
from sqlalchemy.ext.asyncio import AsyncEngine
from starlette.requests import Request
from passlib.hash import pbkdf2_sha512

from auth import AdminAuth
from settings import settings
from models import (
	Bird,
	BirdFamily,
	BirdObservation,
	BirdLocation,
	BirdStatus,
	BirdImage,
	User
)


class UserAdmin(ModelView, model=User):
	name = 'User'
	name_plural = 'Users'
	can_edit = False

	column_list = [User.id, User.username, User.email, ]


class BirdAdmin(ModelView, model=Bird):
	name = 'Bird'
	name_plural = 'Birds'

	column_list = [Bird.id, Bird.bird_name, Bird.scientific_name, ]


class BirdFamilyAdmin(ModelView, model=BirdFamily):
	name = 'Bird family'
	name_plural = 'Bird families'

	column_list = [
		BirdFamily.id,
		BirdFamily.family_name,
	]


class BirdObservationAdmin(ModelView, model=BirdObservation):
	name = 'Bird observation'
	name_plural = 'Bird observations'

	column_list = [
		BirdObservation.id,
		BirdObservation.observation_name,
		BirdObservation.description,
	]


class BirdLocationAdmin(ModelView, model=BirdLocation):
	name = 'Bird location'
	name_plural = 'Bird locations'

	column_list = [
		BirdLocation.id,
		BirdLocation.latitude,
		BirdLocation.longitude,
	]


class BirdStatusAdmin(ModelView, model=BirdStatus):
	name = 'Bird status'
	name_plural = 'Bird statuses'

	column_list = [
		BirdStatus.id,
		BirdStatus.status_name,
	]


class BirdImageAdmin(ModelView, model=BirdImage):
	name = 'Bird image'
	name_plural = 'Bird images'

	column_list = [
		BirdImage.id, BirdImage.image,
	]


def init_admin_session(app: FastAPI, sql_engine: AsyncEngine) -> None:
	authentication_backend = AdminAuth(secret_key=settings.FASTAPI_SECRET_KEY)
	admin = Admin(app, sql_engine, authentication_backend=authentication_backend)

	admin.add_view(UserAdmin)
	admin.add_view(BirdAdmin)
	admin.add_view(BirdStatusAdmin)
	admin.add_view(BirdImageAdmin)
	admin.add_view(BirdLocationAdmin)
	admin.add_view(BirdFamilyAdmin)
	admin.add_view(BirdObservationAdmin)
