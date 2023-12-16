from typing import Any

from fastapi import FastAPI
from sqladmin import Admin, ModelView
from sqlalchemy.ext.asyncio import AsyncEngine
from passlib.hash import pbkdf2_sha512

from .auth import AdminAuth
from core.settings import settings
from models.models import (
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

	form_columns = [
		User.username,
		User.email,
		User.password_hash,
	]

	column_list = [
		User.id,
		User.username,
		User.email,
	]

	async def on_model_change(
		self,
		data: dict,
		model: Any,
		is_created: bool
	) -> None:
		data['password_hash'] = pbkdf2_sha512.hash(data['password_hash'])
		await super().on_model_change(data, model, is_created)


class BirdAdmin(ModelView, model=Bird):
	form_columns = [
		Bird.bird_name,
		Bird.scientific_name,
		Bird.description,
		Bird.status,
		Bird.family,
	]

	column_list = [
		Bird.id,
		Bird.bird_name,
		Bird.scientific_name,
	]

	name = 'Bird'
	name_plural = 'Birds'


class BirdFamilyAdmin(ModelView, model=BirdFamily):
	form_columns = [
		BirdFamily.family_name,
	]

	column_list = [
		BirdFamily.id,
		BirdFamily.family_name,
	]

	name = 'Bird family'
	name_plural = 'Bird families'


class BirdObservationAdmin(ModelView, model=BirdObservation):
	form_columns = [
		BirdObservation.observation_name,
		BirdObservation.description,
		BirdObservation.bird,
		BirdObservation.user,
		BirdObservation.gender,
		BirdObservation.location
	]

	column_list = [
		BirdObservation.id,
		BirdObservation.observation_name,
		BirdObservation.description,
	]

	name = 'Bird observation'
	name_plural = 'Bird observations'


class BirdLocationAdmin(ModelView, model=BirdLocation):
	form_columns = [
		BirdLocation.location_name,
		BirdLocation.latitude,
		BirdLocation.longitude,
	]

	column_list = [
		BirdLocation.id,
		BirdLocation.location_name,
		BirdLocation.latitude,
		BirdLocation.longitude,
	]

	name = 'Bird location'
	name_plural = 'Bird locations'


class BirdStatusAdmin(ModelView, model=BirdStatus):
	form_columns = [
		BirdStatus.status_name,
	]

	column_list = [
		BirdStatus.id,
		BirdStatus.status_name,
	]

	name = 'Bird status'
	name_plural = 'Bird statuses'


class BirdImageAdmin(ModelView, model=BirdImage):
	form_columns = [
		BirdImage.image,
		BirdImage.observation
	]

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
