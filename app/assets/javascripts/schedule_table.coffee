class TournamentApp.ScheduleTable

  constructor: (@$tableNode) ->
    @$fieldTables = @$tableNode.find('.editable-table')
    @$fieldTables.editableTableWidget()
    @newIdx = 1

    @$tableNode.contextmenu
      target: '#table-menu'
      before: @menuLoad
      onItem: @menuSelect

  menuLoad: (e, context) =>
    @currentCell = e.target

  menuSelect: (context, e) =>
    switch $(e.target).data('action')
      when 'add' then @addRow()
      when 'delete' then @deleteRow()
      else nul

  addRow: (rowData = null) ->
    tr = @_newRow(rowData)
    for table in @$fieldTables
      $(table).append(tr.clone()[0])

  _newRow: (rowData) ->
    tr = @$fieldTables.find('tbody tr')[0]
    tr = $(tr).clone()
    tds = tr.find('td')
    tds.html("")

    if rowData
      $(td).html(rowData[idx]) for td, idx in tds.not('.hide')

    return tr

  deleteRow: ->
    rowIdx = $(@currentCell).parent('tr').index() + 1
    for table in @$fieldTables
      row = $(table).find("tr:eq(#{rowIdx})")
      row.remove()
