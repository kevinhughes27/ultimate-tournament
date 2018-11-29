class Resolvers::SeedDivision < Resolvers::BaseResolver
  SEED_ROUND = 1
  DIVISION_SEED_CONFIRM_MSG = """This division has games that have been scored.\
 Seeding this division will reset those games.\
 Are you sure this is what you want to do?"""

  def call(inputs, ctx)
    division_id = database_id(inputs[:division_id])
    team_ids = inputs[:team_ids] && inputs[:team_ids].map { |id| database_id(id) }

    @tournament = ctx[:tournament]
    @division = @tournament.divisions.find(division_id)

    if !(inputs[:confirm] || @division.safe_to_seed?)
      return {
        success: false,
        confirm: true,
        message: DIVISION_SEED_CONFIRM_MSG
      }
    end

    update_teams(team_ids, inputs[:seeds])

    if ambiguous_seeds(inputs[:seeds])
      return {
        success: false,
        message: 'Ambiguous seed list'
      }
    end

    if (num_seats != num_teams)
      return {
        success: false,
        message: "#{num_seats} seats but #{num_teams} teams present"
      }
    end

    seed

    return {
      success: true,
      message: 'Division seeded'
    }
  end

  private

  def update_teams(team_ids, seeds)
    return unless team_ids

    Team.transaction do
      team_ids.each_with_index do |team_id, idx|
        team = teams.detect { |t| t.id == team_id.to_i}
        next if team.seed == seeds[idx]
        team.assign_attributes(seed: seeds[idx])
        team.save!
      end
    end
  end

  def ambiguous_seeds(seeds)
    return unless seeds.present?

    seeds.sort.each_with_index do |seed, idx|
      return true unless seed == (idx+1)
    end
    return false
  end

  def seed
    Tournament.transaction do
      update_games
      reset_games
      update_division
    end
  end

  def update_games
    games.each do |game|
      game.home = seed_index_for_prereq(game.home_prereq)
      game.away = seed_index_for_prereq(game.away_prereq)
      game.reset_score!
      game.save!
    end
  end

  def reset_games
    games = Game.where(
      tournament_id: @division.tournament_id,
      division_id: @division.id,
    ).where.not(
      bracket_uid: nil,
      seed_round: SEED_ROUND
    )

    games.each do |game|
      game.home = nil
      game.away = nil
      game.home_score = nil
      game.away_score = nil
      game.save!
    end
  end

  def seed_index_for_prereq(prereq)
    return unless prereq.is_i?
    teams[prereq.to_i - 1]
  end

  def teams
    @teams ||= @division.teams.order(:seed)
  end

  def num_teams
    teams.size
  end

  def seats
    @seats ||= games.pluck(:home_prereq, :away_prereq)
      .flatten
      .uniq
      .reject{ |s| !s.to_s.is_i? }
  end

  def num_seats
    seats.size
  end

  def games
    @games ||= if @division.bracket_type == "CUUC 23"
      Game.where(
        tournament_id: @division.tournament_id,
        division_id: @division.id,
        seed_round: SEED_ROUND
      )
    elsif @division.bracket.pools.present?
      Game.where(
        tournament_id: @division.tournament_id,
        division_id: @division.id
      ).where.not(
        pool: nil
      )
    else
      Game.where(
        tournament_id: @division.tournament_id,
        division_id: @division.id,
        seed_round: SEED_ROUND
      )
    end
  end

  def update_division
    @division.update_attribute(:seeded, true)
  end
end
