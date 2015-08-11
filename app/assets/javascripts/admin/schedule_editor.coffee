class Admin.ScheduleEditor

  constructor: (@$tableNode) ->
    @initDraggable()
    @initDropzone()

  addRow: ->
    tr = @$tableNode.find('tr')[1]
    tr = $(tr).clone()
    $(tr).find('input').val('')
    @$tableNode.append(tr[0])
    Twine.bind()

  gameDropped: (game, slot) ->
    fieldId = $(slot).data('field-id')
    rowIdx = $(slot).parent().index()
    startTime = $(slot).parent().find('input').val()

    $(game).attr('data-field-id', fieldId)
    $(game).attr('data-row-idx', rowIdx)
    $(game).attr('data-start-time', startTime)

  timeUpdated: (event) ->
    time = $(event.target).val()
    rowIdx = $(event.target).parent().index()
    games = $("[data-row-idx=#{rowIdx}]")
    games.attr('data-start-time', time)

  saveSchedule: (form) ->
    # disable if times blank
    Turbolinks.ProgressBar.start()

    games = _.filter $('.game'), (g) -> $(g).data('row-idx') != undefined
    games = _.map games, (g) ->
      {
        id: $(g).data('game-id')
        field_id: $(g).data('field-id')
        start_time: $(g).data('start-time')
      }

    $.ajax
      type: 'POST'
      url: form.action
      data: {games: games}
      success: (response) ->
         Turbolinks.ProgressBar.done()

  initDraggable: ->
    interact('.draggable').draggable({
      inertia: true,

      restrict:
        restriction: "parent",
        endOnly: true,
        elementRect: { top: 0, left: 0, bottom: 1, right: 1 }

      onmove: (event) =>
        @_moveElement(event.target, event.dx, event.dy)
    })

  _moveElement: (target, dx, dy) ->
    x = (parseFloat(target.getAttribute('data-x')) || 0) + dx
    y = (parseFloat(target.getAttribute('data-y')) || 0) + dy

    target.style.webkitTransform =
    target.style.transform =
      'translate(' + x + 'px, ' + y + 'px)'

    target.setAttribute('data-x', x)
    target.setAttribute('data-y', y)

  initDropzone: ->
    interact('.dropzone').dropzone({
    accept: '.game',
    overlap: 0.5,

    ondropactivate: (event) ->
      event.target.classList.add('drop-active')

    ondragenter: (event) ->
      draggableElement = event.relatedTarget
      dropzoneElement = event.target

      dropzoneElement.classList.add('drop-target')
      draggableElement.classList.add('can-drop')

    ondragleave: (event) ->
      event.target.classList.remove('drop-target')
      event.relatedTarget.classList.remove('can-drop')

    ondrop: (event) =>
      @gameDropped(event.relatedTarget, event.target)

    ondropdeactivate: (event) ->
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
  })
