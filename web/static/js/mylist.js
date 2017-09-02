const elems = document.getElementsByClassName('divasearch-incrementally'),
      valueNames = [
  'ii-name',
  'ii-givenName',
  'ii-alternateName',
  'ii-birthDate',
  'ii-age',
  'ii-height',
  'ii-weight',
  'ii-bracup',
  'ii-bust',
  'ii-waist',
  'ii-hip',
  'ii-badge',
]
Array.from(elems).forEach(elm => new List(elm, {valueNames: valueNames}))
