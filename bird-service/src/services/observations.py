from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from sqlalchemy import select
from models.models import BirdLocation, BirdObservation, Bird
from core.database import get_db_session

from models.models import User


class ObservationService:
	def __init__(
		self,
		session: AsyncSession
	):
		self.session = session

	async def create_bird_observation(
		self,
		username: str,
		bird_observation_data: dict
	) -> BirdObservation | None:
		user = (await self.session.execute(
			select(User).where(User.username==username)
		)).scalar()
		bird = (await self.session.execute(
			select(Bird).where(Bird.bird_name==bird_observation_data['bird_name'])
		)).scalar()
		location = (await self.session.execute(
			select(BirdLocation).where(
				BirdLocation.location_name==bird_observation_data['location_name']
			)
		)).scalar()

		if not user or not location or not bird:
			return None

		observation = BirdObservation(
			observation_name=bird_observation_data['observation_name'],
			gender=bird_observation_data['gender'],
			description=bird_observation_data['description'],
			bird=bird,
			user=user,
			location=location
		)
		self.session.add(observation)

		await self.session.commit()
		await self.session.refresh(observation)

		return observation


async def get_bird_observation_service(
	db: AsyncSession = Depends(get_db_session)
):
	return ObservationService(db)