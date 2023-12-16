from pydantic import BaseModel

class BirdObservationCreate(BaseModel):
	observation_name: str
	description: str
	gender: str
	bird_name: str
	location_name: str
