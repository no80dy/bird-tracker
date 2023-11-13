from typing import Any

from pydantic import PostgresDsn, field_validator, ValidationInfo
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
	POSTGRESQL_USER: str
	POSTGRESQL_PASSWORD: str
	POSTGRESQL_HOST: str
	POSTGRESQL_PORT: int
	POSTGRESQL_DB_NAME: str
	POSTGRESQL_SCHEME: str = 'postgresql+asyncpg'

	POSTGRESQL_CONNECTION: PostgresDsn | None = None

	@field_validator('POSTGRESQL_CONNECTION', mode='before')
	@classmethod
	def build_db_connection(
		cls,
		connection: PostgresDsn | None,
		info: ValidationInfo
	) -> Any:
		if not connection:
			return PostgresDsn.build(
			scheme=info.data['POSTGRESQL_SCHEME'],
			username=info.data['POSTGRESQL_USER'],
			password=info.data['POSTGRESQL_PASSWORD'],
			host=info.data['POSTGRESQL_HOST'],
			path=info.data['POSTGRESQL_DB_NAME']
		)
		return connection


settings = Settings()
