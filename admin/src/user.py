from typing import Generator
from models import User

from sqlalchemy import select
from passlib.hash import pbkdf2_sha512
from database import get_db_session


async def _get_user_by_username(username: str) -> User | None:
    async for session in get_db_session():
        user = (await session.execute(
            select(User).where(User.username == username)
        )).scalars().first()
        return user


async def check_username_exists(username: str) -> bool:
    return bool(await _get_user_by_username(username))


async def verify_user(username: str, password: str) -> bool:
    user = await _get_user_by_username(username)
    return bool(user) and pbkdf2_sha512.verify(password, user.password_hash)
