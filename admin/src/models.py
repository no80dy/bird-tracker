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

	def __str__(self):
		return f'{self.status_name}'

	def __repr__(self):
		return f'<status_name: {self.status_name}>'


class BirdFamily(Base):
	__tablename__ = 'bird_families'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	family_name: Mapped[str] = mapped_column(Text())
	description: Mapped[str] = mapped_column(Text())

	def __str__(self):
		return f'{self.family_name}'

	def __repr__(self):
		return f'<family_name: {self.family_name}>'


class BirdLocation(Base):
	__tablename__ = 'bird_locations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	longitude: Mapped[float] = mapped_column(Float())
	latitude: Mapped[float] = mapped_column(Float())

	def __str__(self):
		return f'{self.longitude}, {self.latitude}'

	def __repr__(self):
		return f'<longitude: {self.longitude}, latitude: {self.latitude}>'


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
		super().__init__()
		self.username = username
		self.email = email
		self.password_hash = password_hash

	def __str__(self):
		return f'{self.username}'

	def __repr__(self):
		return f'<user_name: {self.username}>'


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
	status: Mapped[BirdStatus] = relationship(lazy='joined')
	family: Mapped[BirdFamily] = relationship(lazy='joined')

	def __str__(self):
		return f'{self.bird_name}'

	def __repr__(self):
		return f'<bird_name: {self.bird_name}>'


class BirdObservation(Base):
	__tablename__ = 'bird_observations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)
	observation_name: Mapped[str] = mapped_column(String(30))
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
	location: Mapped[BirdLocation] = relationship(lazy='joined')
	bird: Mapped[Bird] = relationship(lazy='joined')
	user: Mapped[User] = relationship(lazy='joined')

	def __str__(self):
		return f'{self.observation_name}'

	def __repr__(self):
		return (
			f'<bird_name: {self.bird.bird_name}',
			f'user_name: {self.user.username}',
			f'bird_location: ({self.location.latitude})>'
		)


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
	observation: Mapped[BirdObservation] = relationship(lazy='joined')

	def __str__(self):
		return f'{self.image}'

	def __repr__(self):
		return f'<image: {self.observation}, observation: {self.observation.observation_name}>'
