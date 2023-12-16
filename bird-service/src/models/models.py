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


class IdentifierMixin:
	id: Mapped[UUID] = mapped_column(
		postgresql.UUID, primary_key=True, default=uuid.uuid4
	)


class TimestampMixin:
	created_at: Mapped[datetime] = mapped_column(
		TIMESTAMP(timezone=True), default=datetime.utcnow
	)
	updated_at: Mapped[datetime] = mapped_column(
		TIMESTAMP(timezone=True), default=datetime.utcnow
	)


class BirdStatus(TimestampMixin, IdentifierMixin, Base):
	__tablename__ = 'bird_statuses'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	status_name: Mapped[str] = mapped_column(String(30))

	def __str__(self):
		return f'{self.status_name}'

	def __repr__(self):
		return f'<status_name: {self.status_name}>'


class BirdFamily(TimestampMixin, IdentifierMixin, Base):
	__tablename__ = 'bird_families'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	family_name: Mapped[str] = mapped_column(Text())
	description: Mapped[str] = mapped_column(Text())

	def __str__(self):
		return f'{self.family_name}'

	def __repr__(self):
		return f'<family_name: {self.family_name}>'


class BirdLocation(TimestampMixin, IdentifierMixin, Base):
	__tablename__ = 'bird_locations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	location_name: Mapped[str] = mapped_column(String(50))
	longitude: Mapped[float] = mapped_column(Float())
	latitude: Mapped[float] = mapped_column(Float())

	def __init__(self, **kwargs):
		super(BirdLocation, self).__init__(**kwargs)

	def __str__(self):
		return f'{self.location_name}: ({self.longitude}, {self.latitude})'

	def __repr__(self):
		return f'<location_name: {self.location_name}, latitude: {self.latitude}, longitude: {self.longitude}>'


class User(TimestampMixin, IdentifierMixin, Base):
	__tablename__ = 'users'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

	username: Mapped[str] = mapped_column(String(30), nullable=False)
	email: Mapped[str] = mapped_column(String(30))
	password_hash: Mapped[str] = mapped_column(Text())

	def __init__(self, **kwargs):
		super(User, self).__init__(**kwargs)

	def __str__(self):
		return f'{self.username}'

	def __repr__(self):
		return f'<user_name: {self.username}>'


class Bird(TimestampMixin, IdentifierMixin, Base):
	__tablename__ = 'birds'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

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


class BirdObservation(IdentifierMixin, TimestampMixin, Base):
	__tablename__ = 'bird_observations'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

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


class BirdImage(IdentifierMixin, TimestampMixin, Base):
	__tablename__ = 'bird_images'
	__table_args__ = {'schema': TABLE_SCHEMA_NAME}

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
