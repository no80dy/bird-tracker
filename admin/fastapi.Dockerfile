ARG APP_NAME=admin
ARG APP_PATH=/opt/$APP_NAME
ARG PYTHON_VERSION=3.11-alpine
ARG POETRY_VERSION=2.0.5

FROM python:$PYTHON_VERSION AS poetry_init

WORKDIR /admin

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
ENV POETRY_VERSION=$POETRY_VERSION \
    POTRY_HOME='/opt/poetry' \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python
ENV PATH="$POETRY_HOME/bin:$PATH"

WORKDIR $APP_PATH
COPY ./poetry.lock ./pyproject.toml ./
COPY ../$APP_NAME ./$APP_NAME


FROM poetry_init AS fastapi_development_init

WORKDIR $APP_PATH
RUN apk update && \
  apk add poetry && \
  poetry install


ENTRYPOINT ["poetry", "run"]
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
