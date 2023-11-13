from collections.abc import AsyncGenerator

from sqlalchemy import exc
from sqlalchemy.ext.asyncio import (
	AsyncSession,
	async_sessionmaker,
	create_async_engine
)

from settings import settings


async def get_db_session() -> AsyncGenerator[AsyncSession, None]:
	engine = create_async_engine(
		settings.POSTGRESQL_CONNECTION.unicode_string()
	)
	factory = async_sessionmaker(engine)

	async with factory() as session:
		try:
			yield session
			await session.commit()
		except exc.SQLAlchemyError as err:
			await  session.rollback()
			raise err
