import uuid
from uuid import UUID
from datetime import datetime

from sqlalchemy.orm import Mapped, mapped_column, relationship, DeclarativeBase
from sqlalchemy import String, Text, Float, TIMESTAMP, ForeignKey
from sqlalchemy.dialects import postgresql
from fastapi_storages import FileSystemStorage
from fastapi_storages.integrations.sqlalchemy import ImageType


TABLE_SCHEMA_NAME = 'content'


class Base(DeclarativeBase):
	pass


class BirdStatus(Base):
	__tablename__ = 'bird_statuses'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	status_name: Mapped[str] = mapped_column(String(30))



class BirdFamily(Base):
	__tablename__ = 'bird_families'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	family_name: Mapped[str] = mapped_column(Text())
	description: Mapped[str] = mapped_column(Text())


class BirdLocation(Base):
	__tablename__ = 'bird_locations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	longitude: Mapped[float] = mapped_column(Float())
	latitude: Mapped[float] = mapped_column(Float())


class User(Base):
	__tablename__ = 'users'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	username: Mapped[str] = mapped_column(String(30), nullable=False)
	email: Mapped[str] = mapped_column(String(30))
	password_hash: Mapped[str] = mapped_column(Text())
	created_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))

	def __init__(self, username: str, email:  str, password_hash: str):
		self.username = username
		self.email = email
		self.password_hash = password_hash


class UserTokens(Base):
	__tablename__ = 'user_tokens'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)

	user_id: Mapped[UUID] = mapped_column(postgresql.UUID, ForeignKey(f'{TABLE_SCHEMA_NAME}.users.id'))
	user: Mapped[User] = relationship()


class Bird(Base):
	__tablename__ = 'birds'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	bird_name: Mapped[str] = mapped_column(String(30))
	scientific_name: Mapped[str] = mapped_column(String(30))
	description: Mapped[str] = mapped_column(Text())
	status_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.bird_statuses.id')
	)
	family_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.bird_families.id')
	)
	status: Mapped[BirdStatus] = relationship()
	family: Mapped[BirdFamily] = relationship()


class BirdObservtion(Base):
	__tablename__ = 'bird_observations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	gender: Mapped[str] = mapped_column(String(30))
	description: Mapped[str] = mapped_column(Text())
	location_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.bird_locations.id')
	)
	bird_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.birds.id')
	)
	user_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.users.id')
	)
	location: Mapped[BirdLocation] = relationship()
	bird: Mapped[Bird] = relationship()
	user: Mapped[User] = relationship()


storage = FileSystemStorage(path="/tmp")


class BirdImage(Base):
	__tablename__ = 'bird_images'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	image = mapped_column(ImageType(storage=storage))
	observation_id: Mapped[UUID] = mapped_column(
		postgresql.UUID,
		ForeignKey(f'{TABLE_SCHEMA_NAME}.bird_observations.id')
	)
	observation: Mapped[BirdObservtion] = relationship()
