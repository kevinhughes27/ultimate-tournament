class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields, @teams, @games) ->
    window.initializeMap = @initializeMap
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=drawing&callback=initializeMap'
    document.body.appendChild(script)

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
      disableDefaultUI: true
    })

    @drawFields()
    @initApp()

  drawFields: ->
    for field in @fields
      @_initField(field)
      @_drawField(field)

  _initField: (field) ->
    field.center = new google.maps.LatLng(field.lat, field.long)

    field.points = []
    for pt in JSON.parse(field.polygon)
      field.points.push new google.maps.LatLng(pt.A, pt.F)


  _drawField: (field) ->
    polygon = new google.maps.Polygon(
      paths: field.points,
      fillColor: '#7FC013'
    )

    field.shape = polygon
    polygon.setMap(@map)

  initApp: ->
    @$findDrawer = $('#find-drawer')
    @$searchBar = $('#search-bar')
    @$selectNode = @$searchBar.find('select')
    @$selectNode.on('change', @selectedCallback)
    @$selectNode.selectize(valueField: 'name', labelField: 'name', searchField: 'name')
    @selectize = @$selectNode[0].selectize
    @selectize.on 'blur', (event) => @$searchBar.addClass('hidden')
    pointMeThere = $('#point-me-there')
    @pointMeThere = new TournamentApp.PointMeThere(pointMeThere)
    $('#find-field').on 'touchend', @_showFieldSelect
    $('#find-team').on 'touchend', @_showTeamSelect

  _showFieldSelect: =>
    @selectize.clearOptions()
    @selectize.addOption(@fields)
    @selectize.refreshOptions(false)
    @_selectedCallback = @_fieldSelected
    @$searchBar.removeClass('hidden')
    @selectize.focus()
    @$findDrawer.removeClass('active')

  _showTeamSelect: =>
    @selectize.clearOptions()
    @selectize.addOption(@teams)
    @selectize.refreshOptions(false)
    @_selectedCallback = @_teamSelected
    @$searchBar.removeClass('hidden')
    @selectize.focus()
    @$findDrawer.removeClass('active')

  selectedCallback: (event) =>
    selected = $(event.target).val()
    @_selectedCallback(selected)

  _fieldSelected: (selected) =>
    @$searchBar.addClass('hidden')
    field = _.find(@fields, (field) -> field.name is selected)

    if field
      @pointMeThere.setDestination(field.lat, field.long, field.name)
      @pointMeThere.start()

  _teamSelected: (selected) =>
    @$searchBar.addClass('hidden')
    team = _.find(@teams, (team) -> team.name is selected)
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)
    games = _.sortBy(games, (game) -> game.start_time)
    debugger
