$.getScript 'https://maps.google.com/maps/api/js?sensor=false&callback=initGoogleMap'
mapsLoaded = $.Deferred()
directionsService = undefined
directionsDisplay = undefined
window.initGoogleMap = -> 
  mapsLoaded.resolve()
  directionsService = new google.maps.DirectionsService()
  directionsDisplay = new google.maps.DirectionsRenderer()
  spb = new google.maps.LatLng(59.958104,30.390244)
  mapOptions =
    zoom: 12
    mapTypeId: google.maps.MapTypeId.ROADMAP
    center: spb
  map = new google.maps.Map($(".map-canvas")[0], mapOptions)
  directionsDisplay.setMap(map)

createRoute = (from, to) ->
  mapsLoaded.done ->
    request =
      origin: from,
      destination: to,
      travelMode: google.maps.TravelMode.TRANSIT
      unitSystem: google.maps.UnitSystem.METRIC

    directionsService.route request, (response, status) ->
      if (status == google.maps.DirectionsStatus.OK)
        console.log response 
        directionsDisplay.setDirections(response)

Meteor.startup ->
  i = 0
  $('.route').select2
    width: '200px'
    data: metroStations.map (el) ->
      id: i++
      text: el.name
  $('button[role="build"]').click ->
    from = metroStations[$('input[name="from"]').val()]
    to = metroStations[$('input[name="to"]').val()]
    from = new google.maps.LatLng from.lat, from.lang
    to = new google.maps.LatLng to.lat, to.lang
    createRoute from ,to