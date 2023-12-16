from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from models.models import BirdLocation, BirdObservation
from core.database import get_db_session


class ObservationService:
	def __init__(
		self,
		session: AsyncSession
	):
		self.session = session

	# async def create_bird_observation(self, bird_observation_data: dict):
	# 	location = BirdLocation(
	# 		latitude=bird_observation_data['latitude'],
	# 		longitude=bird_observation_data['longitude']
	# 	)


async def get_bird_observation_service(
	db: AsyncSession = Depends(get_db_session)
):
	return ObservationService(db)
