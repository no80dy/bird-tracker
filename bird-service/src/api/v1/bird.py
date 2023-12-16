from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


# class BirdObservationCreate(BaseModel):
# 	observation_name: str
# 	description: str
# 	gender: str
# 	latitude: float
# 	longitude: float
#
#
# @app.post('bird_observation/')
# async def add_bird_observation(
# 	bird_observation: BirdObservationCreate,
# ):
# 	created_latitude = ...
# 	created_bird_observation = ...
