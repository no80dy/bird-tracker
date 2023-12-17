import jwt
from typing import Annotated

from http import HTTPStatus
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from fastapi.encoders import jsonable_encoder

from core.settings import settings
from services.observations import (
	ObservationService, get_bird_observation_service
)
from services.users import UserService, get_user_service
from schemas.schemas import BirdObservationCreate


router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/api/v1/users/token')


@router.post('/observations')
async def add_bird_observation(
	bird_observation: BirdObservationCreate,
	token: Annotated[OAuth2PasswordBearer, Depends(oauth2_scheme)],
	user_service: Annotated[UserService, Depends(get_user_service)],
	bird_observation_service: Annotated[ObservationService, Depends(get_bird_observation_service)]
):
	observation_data = jsonable_encoder(bird_observation)
	user_data = jwt.decode(
		token, settings.FASTAPI_SECRET_KEY, algorithms=['HS256', ]
	)
	if not await user_service.get_user_by_username(user_data['username']):
		raise HTTPException(
			status_code=HTTPStatus.BAD_REQUEST,
			detail='Некорректный пользователь'
		)
	created_observation = await bird_observation_service.create_bird_observation(
		user_data['username'], observation_data
	)

	if not created_observation:
		raise HTTPException(
			status_code=HTTPStatus.BAD_REQUEST,
			detail='Некорректные данные'
		)

	return {
		'observation_name': created_observation.observation_name
	}


@router.get('/observations')
async def get_bird_observations(
	token: Annotated[OAuth2PasswordBearer, Depends(oauth2_scheme)],
	bird_observation_service: Annotated[ObservationService, Depends(get_bird_observation_service)]
):
	observations = await bird_observation_service.get_all_bird_observations()
	return [dict(observation) for observation in observations]
