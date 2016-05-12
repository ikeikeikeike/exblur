#!/usr/bin/env python
# -*- coding: utf-8 -*-
from wikiprof.models import (
    Diva,
    DBSession
)
from wikiprof import extractor


def fillup():
    updates(
        Diva.query
        .filter(Diva.bust.is_(None))
        .order_by(Diva.updated_at.asc())
        .limit(100)
    )


def brushup():
    updates(
        Diva.query
        .filter(Diva.appeared > 0)
        .order_by(Diva.updated_at.asc())
        .limit(200)
    )


def everything():
    updates(
        Diva.query
        .order_by(Diva.updated_at.asc())
        .limit(100)
    )


def updates(query):
    for diva in query:
        wiki = extractor.Wikipedia()
        wiki.request(diva.name)

        diva = diva.birthday or wiki.birthday()
        diva = diva.blood or wiki.blood()
        diva = diva.height or wiki.height()
        diva = diva.weight or wiki.weight()
        diva = diva.bust or wiki.bust()
        diva = diva.waist or wiki.waist()
        diva = diva.hip or wiki.hip()
        diva = diva.bracup or wiki.bracup()

    DBSession.commit()


if __name__ == '__main__':
    fillup()
    brushup()
    everything()
