import React, { Component } from 'react';
import { connect } from 'react-redux';
import Button from 'material-ui/Button';
import Input from 'material-ui/Input';
import ScoreInput from './ScoreInput';
import SpiritQuestion from './SpiritQuestion';
import { submitScore } from '../../actions/submitScore';
import Fingerprint2 from 'fingerprintjs2sync';
import _find from 'lodash/find';

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
  'rules_knowledge',
  'fouls',
  'fairness',
  'attitude',
  'communication'
];

class ScoreForm extends Component {
  constructor(props) {
    super(props);

    let initialState = {};
    HANDLES.forEach(h => {
      initialState[h] = 3;
    });

    this.state = {
      home_score: props.homeScore,
      away_score: props.awayScore,
      ...initialState
    };

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

    const { game, dispatch, handleClose } = this.props;
    const teamName = this.props.search;
    const team = _find(this.props.teams, t => t.name === teamName);

    if (this.state.home_score === '' || this.state.away_score === '') {
      alert('Please enter a score');
      return;
    }

    const payload = {
      game_id: parseInt(game.id, 10),
      team_id: parseInt(team.id, 10),
      submitter_fingerprint: new Fingerprint2().getSync().fprint,
      ...this.state
    };

    dispatch(submitScore(payload));
    handleClose();
  }

  render() {
    const { game, handleClose } = this.props;
    const { home_score, away_score } = this.state;

    return (
      <form onSubmit={this.handleSubmit}>
        <ScoreInput
          game={game}
          home_score={home_score}
          away_score={away_score}
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
            Submit
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

export default connect(state => ({
  teams: state.tournament.teams,
  search: state.search
}))(ScoreForm);
