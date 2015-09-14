container = d3.select ig.containers.base
geojson = topojson.feature ig.data.data, ig.data.data.objects."data"
for feature in geojson.features
  feature.properties.celkem = feature.properties.neobydlene
  feature.properties.neobydlene = parseInt feature.properties.neobydle_1, 10
  feature.properties.ratio = feature.properties.neobydlene / feature.properties.celkem
geojson.features .= filter (.properties.neobydlene)
geojson.features .= filter (.properties.celkem >= 100)
new ig.Map container, geojson
