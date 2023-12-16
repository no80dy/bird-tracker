import uvicorn

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.responses import JSONResponse

from admin.admin import init_admin_session
from core.database import engine
from core.settings import settings
from api.v1 import user, bird


@asynccontextmanager
async def lifespan(app_: FastAPI):
	init_admin_session(app_, engine)
	yield


app = FastAPI(
	version='1.0.0',
	title=settings.PROJECT_NAME,
	docs_url='/api/openapi',
	openapi_url='/api/openapi.json',
	default_response_class=JSONResponse,
	lifespan=lifespan
)

app.include_router(user.router, prefix='/api/v1/users', tags=['users', ])
app.include_router(bird.router, prefix='/api/v1/birds', tags=['birds', ])

if __name__ == '__main__':
	uvicorn.run(
		'main:app',
		host='0.0.0.0',
		port=8000,
		reload=True
	)
