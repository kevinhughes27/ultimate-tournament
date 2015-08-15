module ScheduleHelper
  COLORS = [
    '#a6cee3',
    '#1f78b4',
    '#b2df8a',
    '#33a02c',
    '#fb9a99',
    '#e31a1c',
    '#fdbf6f',
    '#ff7f00',
    '#cab2d6',
    '#6a3d9a',
    '#ffff99',
    '#b15928',
  ]

  def color_for_bracket(bracket)
    "color: #{COLORS[bracket.id % 12]};"
  end

  def color_for_game(game)
    "background-color: #{COLORS[game.bracket_id % 12]};"
  end

  def time_for_datetimepicker(time)
    if time
      time.to_formatted_s(:datetimepicker)
    else
      ""
    end
  end

end
