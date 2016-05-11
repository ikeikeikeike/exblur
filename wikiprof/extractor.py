# -*- coding: utf-8 -*-
import urllib

import requests
from pyquery import PyQuery as pq

from . import detector


ENDPOINT = "http://ja.wikipedia.org/w/api.php?action=parse&format=json&prop=text&uselang=ja&page="


class Wikipedia(object):

    def __init__(self):
        self._dom = None
        self._doc = None
        self._unit = 'cm'

    def request(self, query):
        if not self._dom:
            r = requests.get(ENDPOINT + urllib.quote_plus(query))
            self._dom = r.json()['parse']['text']['*']
        return self._dom

    def birthday(self, query=None):
        dom = pq(self.request(query))
        text = dom(u'tr th:contains(生年月日),tr td:contains(生年月日)').nextAll().text()
        return detector.find_date(text)

    def blood(self, query=None):
        dom = pq(self.request(query))
        return

    def hw(self, query=None):
        dom = pq(self.request(query))
        return

    def height(self, query=None):
        dom = pq(self.request(query))
        return

    def weight(self, query=None):
        dom = pq(self.request(query))
        return

    def bwh(self, query=None):
        dom = pq(self.request(query))
        return

    def bust(self, query=None):
        dom = pq(self.request(query))
        return

    def waist(self, query=None):
        dom = pq(self.request(query))
        return

    def hip(self, query=None):
        dom = pq(self.request(query))
        return

    def bracup(self, query=None):
        dom = pq(self.request(query))
        return
