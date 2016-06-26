CUPS = [
    "less than AAA",
    "AAA", "AA", "A",
    "B", "C", "D", "E",
    "F", "G", "H", "I",
    "J", "K", "L", "M",
    "N", "O", "P",
    "more than P",
]


def calc(height, bust, waist, correct=True):
    num = 0
    diff = 0.0

    h, b, w = float(height), float(bust), float(waist)

    #  Height correction
    if correct:
        diff = (b - (h * 0.54)) + (((h * 0.38) - w) * 0.73) + ((h - 158.8) * 0.3261)
    else:
        diff = (b - (h * 0.54)) + (((h * 0.38) - w) * 0.73) + ((h - 158.8) * 0.1087)

    if h <= 0.0:
        num = 20
    elif bust <= 0.0:
        num = 21
    elif waist <= 0.0:
        num = 22
    elif diff < -13.75:
        num = 0
    elif diff < -11.25:
        num = 1
    elif diff < -8.75:
        num = 2
    elif diff < -6.25:
        num = 3
    elif diff < -3.75:
        num = 4
    elif diff < -1.25:
        num = 5
    elif diff < 1.25:
        num = 6
    elif diff < 3.75:
        num = 7
    elif diff < 6.25:
        num = 8
    elif diff < 8.75:
        num = 9
    elif diff < 11.25:
        num = 10
    elif diff < 13.75:
        num = 11
    elif diff < 16.25:
        num = 12
    elif diff < 18.75:
        num = 13
    elif diff < 21.25:
        num = 14
    elif diff < 23.75:
        num = 15
    elif diff < 26.25:
        num = 16
    elif diff < 28.75:
        num = 17
    elif diff < 31.25:
        num = 18
    else:
        num = 19

    return {
        'under': b - (diff + 17.5) if num < 20 else 0.0,
        'cup': CUPS[num],
    }
