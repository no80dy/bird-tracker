from passlib.hash import pbkdf2_sha512
from fastapi import Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession


from models.models import User
from core.database import get_db_session


class UserService:
	def __init__(self, session: AsyncSession):
		self.session = session

	async def get_user_by_username(self, username: str) -> User:
		user = (await self.session.execute(
			select(User).where(User.username==username)
		)).scalar()

		return user

	async def check_password(self, username: str, password: str) -> bool:
		user = await self.get_user_by_username(username)
		return pbkdf2_sha512.verify(password, user.password_hash)


async def get_user_service(
	db: AsyncSession = Depends(get_db_session)
):
	return UserService(db)
