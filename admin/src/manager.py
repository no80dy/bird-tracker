import asyncio
import typer
from passlib.hash import pbkdf2_sha512
from sqlalchemy import select

from database import get_db_session
from models import User


async def create_user():
    username = input('Input username: ')
    email = input('Input email: ')
    password = input('Input password: ')

    async for session in get_db_session():
        user = User(username, email, pbkdf2_sha512.hash(password))
        session.add(user)
        await session.commit()
    print('User successfully created!')


def main():
    asyncio.run(create_user())


if __name__ == '__main__':
    typer.run(main)
