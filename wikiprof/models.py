# -*- coding: utf-8 -*-

import datetime

from sqlalchemy.ext.declarative.api import declarative_base
from sqlalchemy.sql.schema import Column
from sqlalchemy.sql.sqltypes import (
    DateTime,
    Integer,
    String
)
# from sqlalchemy.orm import (
#     scoped_session,
#     sessionmaker,
# )

Base = declarative_base()
#  DBSession = scoped_session(sessionmaker())


class Diva(Base):
    __tablename__ = 'divas'
    #  query = DBSession.query_property()

    id = Column(Integer, primary_key=True)

    name = Column(String(255))
    kana = Column(String(255))
    romaji = Column(String(255))
    gyou = Column(String(255))

    height = Column(Integer)
    weight = Column(Integer)

    bust = Column(Integer)
    bracup = Column(String(255))
    waste = Column(Integer)
    hip = Column(Integer)

    blood = Column(String(255))
    birthday = Column(DateTime)

    appeared = Column(Integer)

    created_at = Column(DateTime)
    updated_at = Column(DateTime, onupdate=datetime.datetime.now)
