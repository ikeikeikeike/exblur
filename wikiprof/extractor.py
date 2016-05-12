# -*- coding: utf-8 -*-
import re
import urllib

import requests
from pyquery import PyQuery as pq

from . import bracalc
from . import detector


ENDPOINT = "http://ja.wikipedia.org/w/api.php?action=parse&format=json&prop=text&uselang=ja&page="


class Wikipedia(object):

    def __init__(self):
        self._doc = None

    def request(self, query):
        if not self._doc:
            r = requests.get(ENDPOINT + urllib.quote_plus(query))
            self._doc = r.json()['parse']['text']['*']
        return self._doc

    def birthday(self, query=None):
        dom = pq(self.request(query))
        text = dom(u'tr th:contains(生年月日),tr td:contains(生年月日)').nextAll().text()
        return detector.find_date(text)

    def blood(self, query=None):
        dom = pq(self.request(query))
        text = dom(u'tr th:contains(血液型),tr td:contains(血液型)').nextAll().text()
        return text.replace(u'型', u'')

    def hw(self, query=None):
        dom = pq(self.request(query))

        for d in dom(u'tr th:contains(体重), tr td:contains(体重)').nextAll():
            t = pq(d).text()
            if 'cm' in t:
                return ''.join(t.split()).replace('cm', '').replace('kg', '')

    def height(self, query=None):
        hw = self.hw(query)
        if hw:
            return int(hw.split('/')[0])

    def weight(self, query=None):
        hw = self.hw(query)
        if hw and u'―' not in hw:
            return int(hw.split('/')[1])

    def bwh(self, query=None):
        dom = pq(self.request(query))
        for d in dom(u'tr th:contains(スリーサイズ), tr td:contains(スリーサイズ)').nextAll():
            t = pq(d).text()
            if 'cm' in t:
                return ''.join(t.split()).replace('cm', '')

    def bust(self, query=None):
        bwh = self.bwh(query)
        if bwh:
            return int(bwh.split('-')[0])

    def waist(self, query=None):
        bwh = self.bwh(query)
        if bwh:
            return int(bwh.split('-')[1])

    def hip(self, query=None):
        bwh = self.bwh(query)
        if bwh:
            return int(bwh.split('-')[2])

    def bracup(self, query=None):
        dom = pq(self.request(query))
        ptn = re.compile(r"(?:[a-z]|[A-Z]){1}")

        r = ""

        for d in dom(u'tr th:contains(ブラのサイズ), tr th:contains(カップサイズ)').nextAll():
            t = pq(d).text()
            if ptn.match(t):
                r = ''.join(t.split()).replace(u'カップ', '')

        if not r:
            h, b, w = self.height(), self.bust(), self.waist()
            if h > 10 and b > 10 and w > 10:
                r = bracalc.calc(h, b, w)['cup']

        return r
