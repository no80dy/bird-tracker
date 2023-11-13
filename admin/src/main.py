import uvicorn

from fastapi import FastAPI
from sqladmin import Admin, ModelView

from .database import get_db_session, engine
from .models import (
	Bird,
	BirdFamily,
	BirdObservtion,
	BirdLocation,
	BirdStatus,
	BirdImage
)


class BirdAdmin(ModelView, model=Bird):
	column_list = [Bird.id, Bird.bird_name, ]


class BirdFamilyAdmin(ModelView, model=BirdFamily):
	column_list = [BirdFamily.id, BirdFamily.family_name, ]


class BirdObservationAdmin(ModelView, model=BirdObservtion):
	column_list = [BirdObservtion.id, BirdObservtion.description, ]


class BirdLocationAdmin(ModelView, model=BirdLocation):
	column_list = [
		BirdLocation.id, BirdLocation.latitude, BirdLocation.longitude,
	]


class BirdStatusAdmin(ModelView, model=BirdStatus):
	column_list = [BirdStatus.id, BirdStatus.status_name, ]


class BirdImageAdmin(ModelView, model=BirdImage):
	column_list = [BirdImage.id, BirdImage.image, ]


app = FastAPI()
admin = Admin(app, engine)

admin.add_view(BirdAdmin)
admin.add_view(BirdStatusAdmin)
admin.add_view(BirdImageAdmin)
admin.add_view(BirdLocationAdmin)
admin.add_view(BirdFamilyAdmin)
admin.add_view(BirdObservationAdmin)


if __name__ == '__main__':
	uvicorn.run(
		'main:app',
		host='0.0.0.0',
		port=8000,
		reload=True
	)
