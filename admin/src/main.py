import uvicorn

from contextlib import asynccontextmanager

from fastapi import FastAPI
from admin import init_admin_session
from database import engine


@asynccontextmanager
async def lifespan(app_: FastAPI):
	init_admin_session(app_, engine)
	yield


app = FastAPI(lifespan=lifespan)


if __name__ == '__main__':
	uvicorn.run(
		'main:app',
		host='0.0.0.0',
		port=8000,
		reload=True
	)
