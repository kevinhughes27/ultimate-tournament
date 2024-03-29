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
    '#ffcc00',
    '#ff0066',
  ]

  def color_for_division(division)
    "color: #{COLORS[division.id % 12]};"
  end

  def background_color_for_division(division)
    "background-color: #{COLORS[division.id % 12]};"
  end

  def color_for_game(game)
    "background-color: #{COLORS[game.division_id % 12]};"
  end

  def game_draggable_text(game)
    if game.bracket_game?
      content_tag(:p, game.bracket_uid) +
      content_tag(:p, "#{game.home_prereq} v #{game.away_prereq}")
    elsif game.pool_game?
      content_tag(:p, game.pool) +
      content_tag(:p, "#{game.home_pool_seed} v #{game.away_pool_seed}")
    end
  end
end
