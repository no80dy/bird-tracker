from fastapi import FastAPI
from sqladmin import Admin, ModelView
from sqlalchemy.ext.asyncio import AsyncEngine

from .models import (
	Bird,
	BirdFamily,
	BirdObservtion,
	BirdLocation,
	BirdStatus,
	BirdImage
)


class BirdAdmin(ModelView, model=Bird):
	name = 'Bird'
	name_plural = 'Birds'

	column_list = [Bird.id, Bird.bird_name, ]


class BirdFamilyAdmin(ModelView, model=BirdFamily):
	name = 'Bird family'
	name_plural = 'Bird families'

	column_list = [BirdFamily.id, BirdFamily.family_name, ]


class BirdObservationAdmin(ModelView, model=BirdObservtion):
	name = 'Bird observation'
	name_plural = 'Bird observations'

	column_list = [BirdObservtion.id, BirdObservtion.description, ]


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


def init_admin_session(app: FastAPI, sql_engine: AsyncEngine) -> None:
	admin = Admin(app, sql_engine)

	admin.add_view(BirdAdmin)
	admin.add_view(BirdStatusAdmin)
	admin.add_view(BirdImageAdmin)
	admin.add_view(BirdLocationAdmin)
	admin.add_view(BirdFamilyAdmin)
	admin.add_view(BirdObservationAdmin)
