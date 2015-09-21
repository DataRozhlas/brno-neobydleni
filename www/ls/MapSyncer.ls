icon = L.divIcon className: "slaveMarker"
viewStateChanging = no

ig.syncMaps = (mapMaster, mapSlave) ->
  mapMaster.slaveMarker = L.marker [0, 0], {icon}
  mapMaster.slaveMarkerAdded = no
  mapSlave.slaveMarker = L.marker [0, 0], {icon}
  mapSlave.slaveMarkerAdded = no

  mapMaster.on "drag" ->
    {lat, lng} = mapMaster.getCenter!
    center = [lat, lng]
    zoom = mapMaster.getZoom!
    mapSlave.setView center, zoom, animate: no

  mapSlave.on "drag" ->
    {lat, lng} = mapSlave.getCenter!
    center = [lat, lng]
    zoom = mapSlave.getZoom!
    mapMaster.setView center, zoom, animate: no

  mapMaster.on \zoomstart (evt) ->
    return if viewStateChanging
    <~ setImmediate
    return unless evt.target._animateToCenter
    return if mapMaster.getZoom! == evt.target._animateToZoom
    {lat, lng} = evt.target._animateToCenter
    center = [lat, lng]
    mapSlave.setView center, evt.target._animateToZoom

  mapSlave.on \zoomstart (evt) ->
    return if viewStateChanging
    <~ setImmediate
    return unless evt.target._animateToCenter
    return if mapSlave.getZoom! == evt.target._animateToZoom
    {lat, lng} = evt.target._animateToCenter
    center = [lat, lng]
    mapMaster.setView center, evt.target._animateToZoom

  mapSlave.on \baselayerchange ({layer}) ->
    {lat, lng} = mapMaster.getCenter!
    center = [lat, lng]
    zoom = mapMaster.getZoom!
    mapSlave.setView center, zoom, animate: no

  mapMaster.on \mousemove ({{lat, lng}:latlng}) ->
    if not mapSlave.slaveMarkerAdded
      mapSlave.addLayer mapSlave.slaveMarker
      mapSlave.slaveMarkerAdded = yes
    if mapMaster.slaveMarkerAdded
      mapMaster.removeLayer mapMaster.slaveMarker
      mapMaster.slaveMarkerAdded = no
    latlng = [lat, lng]
    mapSlave.slaveMarker.setLatLng latlng

  mapSlave.on \mousemove ({{lat, lng}:latlng}) ->
    if not mapMaster.slaveMarkerAdded
      mapMaster.addLayer mapMaster.slaveMarker
      mapMaster.slaveMarkerAdded = yes
    if mapSlave.slaveMarkerAdded
      mapSlave.removeLayer mapSlave.slaveMarker
      mapSlave.slaveMarkerAdded = no
    latlng = [lat, lng]
    mapMaster.slaveMarker.setLatLng latlng
