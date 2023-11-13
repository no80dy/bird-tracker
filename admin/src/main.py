import uuid

from fastapi import FastAPI, Depends

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db_session
from models import BirdFamily

app = FastAPI()


@app.get('/')
async def root(
	session: AsyncSession = Depends(get_db_session)
):
	result = await session.execute(select(BirdFamily).order_by(BirdFamily.id))
	await session.commit()

	return {'message': 'Hello world!'}
