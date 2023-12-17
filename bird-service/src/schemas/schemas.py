from pydantic import BaseModel


class BirdObservationCreate(BaseModel):
	observation_name: str
	description: str
	gender: str
	bird_name: str
	location_name: str


class BirdObservationRead(BaseModel):
	observation_name: str
	description: str
	user_name: str
	location_name: str
	bird_name: str
	bird_images: list[str]
