# -*- coding: utf-8 -*-

import regex
import unicodedata

import dateparser


def find_date(orig):
    s = unicodedata.normalize('NFKC', orig)
    s = "".join(s.split())
    s = regex.sub(ur'\d{1,2}歳', '', s)

    try:
        for _ in s:
            date = dateparser.parse(s)
            if date:
                return date

            s = _remove_right(s)

        for _ in s:
            date = dateparser.parse(s)
            if date:
                return date

            s = _remove_left(s)

    except ValueError:
        pass

    return None


def _remove_right(letters):
    length = len(letters)
    letter = letters[length - 1]

    if letter == u"日":
        return letters
    try:
        int(letter)
        return letters
    except ValueError:
        pass

    return letters[:length - 1]


def _remove_left(letters):
    letter = letters[0]

    try:
        int(letter)
        return letters
    except ValueError:
        pass

    return letters[1::]


