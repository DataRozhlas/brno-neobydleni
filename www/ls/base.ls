container = d3.select ig.containers.base
geojson = topojson.feature ig.data.data, ig.data.data.objects."data"
kvalitaAssoc = {}
kvality = d3.tsv.parse ig.data.kvalita, (row) ->
  for key, value of row
    row[key] = parseInt value
  row

for datum in kvality
  kvalitaAssoc[datum.kod_ZSJ] = datum

for feature in geojson.features
  feature.properties.celkem = feature.properties.neobydlene
  feature.properties.neobydlene = parseInt feature.properties.neobydle_1, 10
  feature.properties.ratio = feature.properties.neobydlene / feature.properties.celkem
geojson.features .= filter (.properties.neobydlene)
geojson.features .= filter (.properties.celkem >= 100)
for feature in geojson.features
  kod = parseInt feature.properties.KOD_ZSJ, 10
  kvalita = kvalitaAssoc[kod]
  total = parseInt kvalita['Obydlené byty v bytových domech'], 10
  feature.properties.bezKoupelny = 1 - (parseInt kvalita['Obydlené byty v bytových domech    - s vlastní koupelnou, sprchovým koutem']) / total
  feature.properties.bezTepleVody = 1 - (parseInt kvalita['Obydlené byty v bytových domech    - s teplou vodou']) / total
  feature.properties.snizenaKvalita = (parseInt kvalita['Obydlené byty  v bytových domech - se sníženou kvalitou']) / total
  feature.properties.bezZachodu = 1 -(parseInt kvalita['Obydlené byty v bytových domech    - s vlastním splachovacím záchodem']) / total
  feature.properties.bezVodovodu = 1 -(parseInt kvalita['Obydlené byty v bytových domech    - vodovod v bytě']) / total
  feature.properties.sKamny = (parseInt kvalita['Obydlené byty v bytových domech - způsob vytápění: kamna']) / total
  feature.properties.najemni = (parseInt kvalita['Obydlené byty v bytových domech - právní důvod užívání bytu: nájemní']) / total
  feature.properties.qualityAverage = 0
  for property in <[bezKoupelny bezZachodu bezVodovodu]>
    feature.properties.qualityAverage += feature.properties[property]
new ig.Map container, geojson
