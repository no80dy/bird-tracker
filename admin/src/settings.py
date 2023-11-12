from typing import Any

from pydantic import PostgresDsn, field_validator
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
	POSTGRESQL_USER: str
	POSTGRESQL_PASSWORD: str
	POSTGRESQL_HOST: str
	POSTGRESQL_PORT: str
	POSTGRESQL_DB_NAME: str
	POSTGRESQL_SCHEME: str

	POSTGRESQL_CONNECTION: PostgresDsn

	@field_validator('POSTGRESQL_CONNECTION', mode='before')
	def build_db_connection(
		self,
		connection: str | None,
		values: dict[str, Any]
	) -> Any:
		if isinstance(connection, str):
			return connection
		return PostgresDsn.build(
			scheme=values.get('POSTGRESQL_SCHEME'),
			username=values.get('POSTGRESQL_USER'),
			password=values.get('POSTGRESQL_PASSWORD'),
			host=values.get('POSTGRESQL_HOST'),
			path=values.get('POSTGRESQL_DB_NAME')
		)


settings = Settings()
