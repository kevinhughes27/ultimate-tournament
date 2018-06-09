FactoryBot.define do
  factory :game do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    round 1
    bracket_uid { Faker::Number.hexadecimal(3) }
    pool nil
    home_prereq '1'
    away_prereq '3'
    home { FactoryBot.build(:team, tournament: tournament, division: division) }
    away { FactoryBot.build(:team, tournament: tournament, division: division) }

    factory :pool_game do
      bracket_uid nil
      pool 'A'
      home_pool_seed '1'
      away_pool_seed '3'
    end

    trait :finished do
      home_score { Faker::Number.between(0,15) }
      away_score { Faker::Number.between(0,15) }
      score_confirmed true
    end

    trait :scheduled do
      home_prereq '2'
      away_prereq '4'
      field { FactoryBot.create(:field, tournament: tournament) }
      start_time { '2015-06-06 12:06:53 UTC' }
      end_time { '2015-06-06 13:36:53 UTC' }
    end
  end
end
