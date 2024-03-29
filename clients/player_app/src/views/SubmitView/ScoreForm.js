import React, { Component } from 'react';
import { connect } from 'react-redux';
import Button from '@material-ui/core/Button';
import Input from '@material-ui/core/Input';
import ScoreInput from './ScoreInput';
import SpiritQuestion from './SpiritQuestion';
import { submitScore } from '../../actions/submitScore';
import Fingerprint2 from 'fingerprintjs2sync';

const QUESTIONS = [
  '1. Rules knowledge and Use',
  '2. Fouls and Body Contact',
  '3. Fair-Mindedness',
  '4. Positive Attitude and Self-Control',
  '5. Communication'
];

const EXAMPLES = [
  "Examples: They didn't purposefully misinterpret the rules. They kept to time limits. When they didn't know the rules they showed a real willingness to learn",
  'Examples: They avoided fouling, contact, and dangerous plays.',
  'Examples: They apologized in situations where it was appropriate, informed teammates about wrong/unnecessary calls. Only called significant breaches',
  'Examples: They were polite. They played with appropriate intensity irrespective of the score. They left an overall positive impression during and after the game.',
  'Examples: They communicated respectfully. They listened. They kept to discussion time limits.'
];

const HANDLES = [
  'rulesKnowledge',
  'fouls',
  'fairness',
  'attitude',
  'communication'
];

// init state with a report if present.
// otherwise use default the default state.
const defaultState = (props) => {
  if (props.report) {
    const {
      homeScore,
      awayScore,
      rulesKnowledge,
      fouls,
      fairness,
      attitude,
      communication,
      comments,
    } = props.report

    return {
      homeScore,
      awayScore,
      rulesKnowledge,
      fouls,
      fairness,
      attitude,
      communication,
      comments
    };
  } else {
    return {
      homeScore: '',
      awayScore: '',
      rulesKnowledge: 2,
      fouls: 2,
      fairness: 2,
      attitude: 2,
      communication: 2,
      comments: ''
    };
  }
}

class ScoreForm extends Component {
  constructor(props) {
    super(props);

    let state = defaultState(props);

    if (props.deepLink) {
      state.homeScore = props.deepLink.homeScore;
      state.awayScore = props.deepLink.awayScore;
    }

    this.state = state;

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    const target = event.target;
    const value = isNaN(parseInt(target.value, 10))
      ? target.value
      : parseInt(target.value, 10);
    const name = target.name;

    this.setState({
      [name]: value
    });
  }

  handleSubmit(event) {
    event.preventDefault();

    const { team, game, dispatch, handleClose } = this.props;

    if (this.state.homeScore === '' || this.state.awayScore === '') {
      alert('Please enter a score');
      return;
    }

    const payload = {
      gameId: game.id,
      teamId: team.id,
      submitterFingerprint: new Fingerprint2().getSync().fprint,
      ...this.state
    };

    dispatch(submitScore(payload));
    handleClose();
  }

  buttonCopy() {
    const { team, game } = this.props;

    if (this.state.homeScore === this.state.awayScore) {
      return "Submit Tie";
    }

    const userIsHomeTeam =  game.homeName === team.name;
    const homeTeamWins = this.state.homeScore > this.state.awayScore;

    if (userIsHomeTeam) {
      if (homeTeamWins) {
        return "Submit Win";
      // homeTeamLoses
      } else {
        return "Submit Loss";
      }
    // userIsAwayTeam
    } else {
      if (homeTeamWins) {
        return "Submit Loss";
      // homeTeamLoses
      } else {
        return "Submit Win";
      }
    }
  }

  render() {
    const { game, handleClose } = this.props;
    const { homeScore, awayScore } = this.state;

    return (
      <form onSubmit={this.handleSubmit}>
        <ScoreInput
          game={game}
          homeScore={homeScore}
          awayScore={awayScore}
          onChange={this.handleChange}
        />
        {renderSpiritQuestions(this.state, this.handleChange)}
        <div
          style={{
            paddingLeft: '20px',
            paddingRight: '20px',
            paddingBottom: '40px'
          }}
        >
          <Input
            placeholder="Comments ..."
            name="comments"
            onChange={this.handleChange}
            value={this.state.comments}
            multiline
            fullWidth
          />
        </div>
        <div
          style={{
            textAlign: 'right',
            paddingBottom: '10px',
            paddingRight: '10px'
          }}
        >
          <Button onClick={handleClose}>Cancel</Button>
          <Button key="submit" type="submit">
            {this.buttonCopy()}
          </Button>
        </div>
      </form>
    );
  }
}

function renderSpiritQuestions(state, onChange) {
  return (
    <div style={{ padding: 20 }}>
      {[0, 1, 2, 3, 4].map(i =>
        renderSpiritQuestion(i, state[HANDLES[i]], onChange)
      )}
    </div>
  );
}

function renderSpiritQuestion(index, value, onChange) {
  return (
    <SpiritQuestion
      key={index}
      value={value}
      question={QUESTIONS[index]}
      handle={HANDLES[index]}
      example={EXAMPLES[index]}
      onChange={onChange}
    />
  );
}

export default connect()(ScoreForm);
