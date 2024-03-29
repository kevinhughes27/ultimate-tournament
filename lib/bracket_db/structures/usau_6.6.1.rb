BracketDb.define 'USAU 6.6.1' do
  name 'Six teams advance (USAU 6.6.1)'
  teams 6
  days 1

  games [
    {pool: "A", round:1, home_prereq: 1, home_pool_seed: 1, away_prereq: 3, away_pool_seed: 3},
    {pool: "A", round:2, home_prereq: 1, home_pool_seed: 1, away_prereq: 5, away_pool_seed: 5},
    {pool: "A", round:3, home_prereq: 1, home_pool_seed: 1, away_prereq: 6, away_pool_seed: 6},
    {pool: "A", round:4, home_prereq: 1, home_pool_seed: 1, away_prereq: 4, away_pool_seed: 4},
    {pool: "A", round:5, home_prereq: 1, home_pool_seed: 1, away_prereq: 2, away_pool_seed: 2},

    {pool: "A", round:1, home_prereq: 2, home_pool_seed: 2, away_prereq: 5, away_pool_seed: 5},
    {pool: "A", round:2, home_prereq: 2, home_pool_seed: 2, away_prereq: 4, away_pool_seed: 4},
    {pool: "A", round:3, home_prereq: 2, home_pool_seed: 2, away_prereq: 3, away_pool_seed: 3},
    {pool: "A", round:4, home_prereq: 2, home_pool_seed: 2, away_prereq: 6, away_pool_seed: 6},
    {pool: "A", round:5, home_prereq: 3, home_pool_seed: 3, away_prereq: 4, away_pool_seed: 4},

    {pool: "A", round:1, home_prereq: 4, home_pool_seed: 4, away_prereq: 6, away_pool_seed: 6},
    {pool: "A", round:2, home_prereq: 3, home_pool_seed: 3, away_prereq: 6, away_pool_seed: 6},
    {pool: "A", round:3, home_prereq: 4, home_pool_seed: 4, away_prereq: 5, away_pool_seed: 5},
    {pool: "A", round:4, home_prereq: 3, home_pool_seed: 3, away_prereq: 5, away_pool_seed: 5},
    {pool: "A", round:5, home_prereq: 5, home_pool_seed: 5, away_prereq: 6, away_pool_seed: 6}
  ]

  places %w(A1 A2 A3 A4 A5 A6)
end
