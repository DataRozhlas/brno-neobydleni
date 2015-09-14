class ig.Map
  (@container, @geojson) ->
    @init!
    @addTiles!
    @addGeojson!

  addGeojson: ->
    color = d3.scale.quantile!
      ..domain @geojson.features.map (.properties.ratio)
      ..range ['rgb(247,244,249)','rgb(231,225,239)','rgb(212,185,218)','rgb(201,148,199)','rgb(223,101,176)','rgb(231,41,138)','rgb(206,18,86)','rgb(152,0,67)','rgb(103,0,31)']
    @geojsonLayer := L.geoJson do
      * @geojson
      * style: (feature) ->
          weight: 1
          color: color feature.properties.ratio
          fillOpacity: 0.7
        onEachFeature: (feature, layer) ~>
          {properties} = feature
          layer.bindPopup "<b>#{properties.NAZ_ZSJ}</b><br>
          Neobsazených bytů: <b>#{ig.utils.formatNumber properties.ratio * 100, 1} %</b> (#{properties.neobydlene} z #{properties.celkem})"
    @geojsonLayer.addTo @map

  init: ->
    @element = @container.append \div
      ..attr \class \map

    @map = L.map do
      * @element.node!
      * minZoom: 10,
        maxZoom: 16,
        zoom: 13,
        center: [49.189 16.61]
        maxBounds: [[49.124,16.475], [49.289,16.716]]

  addTiles: ->
    baseLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
      * zIndex: 1
        opacity: 1
        attribution: 'mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

    labelLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_l2/{z}/{x}/{y}.png"
      * zIndex: 3
        opacity: 0.75

    @map.addLayer baseLayer
    @map.addLayer labelLayer


