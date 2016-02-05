class Sidebar

  toggle: ->
    if @_smallScreen()
      klass = "sidebar-open"
      if @_open(klass) then @close(klass) else @open(klass)
    else
      klass = "sidebar-collapse"
      if @_expanded(klass) then @collapse(klass) else @expand(klass)

  # desktop and tablet
  expand: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })
    delay 300, ->
      $('.user-panel').find('.info').fadeIn()
      $('.user-panel').find('.fa-chevron-up').fadeIn()

  collapse: (klass) ->
    $('body').addClass(klass)
    $('.user-panel').find('.info').hide()
    $('.user-panel').find('.fa-chevron-up').hide()
    $.cookie("sidebar", klass, {path: '/'})

  _expanded: (klass) ->
    !$('body').hasClass(klass)

  # mobile
  open: (klass) ->
    $('.user-panel').find('.info').show()
    $('.user-panel').find('.fa-chevron-up').show()
    $('body').addClass(klass)
    $.cookie("sidebar", klass, {path: '/'})

  close: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })

  _open: (klass) ->
    $('body').hasClass(klass)

  _smallScreen: ->
    $(window).width() < 767

instance = new Sidebar

Admin.Sidebar = ->
  return instance
