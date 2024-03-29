BracketDb.define 'single_elimination_8' do
  name 'Single Elimination'
  teams 8
  days 1

  games [
    {round: 1, "seed_round": 1, bracket_uid: "q1", home_prereq: 1, away_prereq: "8"},
    {round: 1, "seed_round": 1, bracket_uid: "q2", home_prereq: 2, away_prereq: "7"},
    {round: 1, "seed_round": 1, bracket_uid: "q3", home_prereq: 3, away_prereq: "6"},
    {round: 1, "seed_round": 1, bracket_uid: "q4", home_prereq: 4, away_prereq: "5"},

    {round: 2, bracket_uid: "s1", home_prereq: "Wq1", away_prereq: "Wq4"},
    {round: 2, bracket_uid: "s2", home_prereq: "Wq2", away_prereq: "Wq3"},
    {round: 2, bracket_uid: "c1", home_prereq: "Lq1", away_prereq: "Lq4"},
    {round: 2, bracket_uid: "c2", home_prereq: "Lq2", away_prereq: "Lq3"},

    {round: 3, bracket_uid: "1", home_prereq: "Ws1", away_prereq: "Ws2"},
    {round: 3, bracket_uid: "3", home_prereq: "Ls1", away_prereq: "Ls2"},
    {round: 3, bracket_uid: "5", home_prereq: "Wc1", away_prereq: "Wc2"},
    {round: 3, bracket_uid: "7", home_prereq: "Lc1", away_prereq: "Lc2"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7)
end
