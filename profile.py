#!/usr/bin/env python
# -*- coding: utf-8 -*-
import re
import argparse
import datetime

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


from wikiprof import extractor
from wikiprof.models import Diva


DBSession = None


def fillup():
    updates(
        DBSession.query(Diva)
        .filter(Diva.bust.is_(None))
        .order_by(Diva.updated_at.asc())
        .limit(100)
    )


def brushup():
    updates(
        DBSession.query(Diva)
        .filter(Diva.appeared > 0)
        .order_by(Diva.updated_at.asc())
        .limit(200)
    )


def everything():
    updates(
        DBSession.query(Diva)
        .order_by(Diva.updated_at.asc())
        .limit(100)
    )


def updates(query):
    for diva in query:
        for name in re.split(ur'、|（|）', diva.name):
            wiki = extractor.Wikipedia()

            if wiki.request(name):
                diva.birthday = diva.birthday or wiki.birthday()
                diva.blood = diva.blood or wiki.blood()
                diva.height = diva.height or wiki.height()
                diva.weight = diva.weight or wiki.weight()
                diva.bust = diva.bust or wiki.bust()
                diva.waste = diva.waste or wiki.waist()
                diva.hip = diva.hip or wiki.hip()
                diva.bracup = diva.bracup or wiki.bracup()

        diva.updated_at = datetime.datetime.now()
        DBSession.commit()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--user")
    parser.add_argument("--pass", default="")
    parser.add_argument("--host")
    parser.add_argument("--dbname")
    args = parser.parse_args()

    dbpath = 'postgresql://{user}:{pass}@{host}:5432/{dbname}'.format(**vars(args))
    engine = create_engine(dbpath)
    DBSession = sessionmaker(bind=engine)()

    fillup()
    brushup()
    everything()
