from uuid import UUID

from datetime import datetime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Text, Float, TIMESTAMP

from database import Base, engine


class BirdStatus(Base):
	__tablename__ = 'bird_statuses'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	status_name: Mapped[str] = mapped_column(String(30))



class BirdFamily(Base):
	__tablename__ = 'bird_families'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	family_name: Mapped[str] = mapped_column(Text)


class BirdLocation(Base):
	__tablename__ = 'bird_locations'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	longitude: Mapped[float] = mapped_column(Float)
	latitude: Mapped[float] = mapped_column(Float)

class User(Base):
	__tablename__ = 'users'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	username: Mapped[str] = mapped_column(String(30), nullable=False)
	email: Mapped[str] = mapped_column(String(30))
	password_hash: Mapped[str] = mapped_column(Text)
	created_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True))


class Bird(Base):
	__tablename__ = 'birds'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	bird_name: Mapped[str] = mapped_column(String(30))
	scientific_name: Mapped[str] = mapped_column(String(30))
	description: Mapped[str] = mapped_column(Text)
	status: Mapped[BirdStatus] = relationship()
	family: Mapped[BirdFamily] = relationship()


class BirdObservtion(Base):
	__tablename__ = 'bird_observations'
	id: Mapped[UUID] = mapped_column(primary_key=True)
	gender: Mapped[str] = mapped_column(String(30))
	description: Mapped[str] = mapped_column(Text)
	location: Mapped[BirdLocation] = relationship()
	bird: Mapped[Bird] = relationship()
	user: Mapped[User] = relationship()


class BirdImage(Base):
	id: Mapped[UUID] = mapped_column(primary_key=True)
	observation: Mapped[BirdObservtion] = relationship()
	image: Mapped[str] = mapped_column(Text)


Base.metadata.create_all(engine)