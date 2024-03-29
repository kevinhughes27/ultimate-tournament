import * as React from 'react';
import Stepper from '@material-ui/core/Stepper';
import Step from '@material-ui/core/Step';
import StepButton from '@material-ui/core/StepButton';
import StepContent from '@material-ui/core/StepContent';
import { isEmpty, sumBy } from 'lodash';
import Plan from './Plan';
import Schedule from './Schedule';
import Seed from './Seed';
import Play from './Play';

interface Props {
  fields: HomeQuery['fields'];
  teams: HomeQuery['teams'];
  divisions: HomeQuery['divisions'];
  games: HomeQuery['games'];
  scoreDisputes: HomeQuery['scoreDisputes'];
}

interface State {
  activeStep: number;
  completed: Set<number>;
}

const count = (array: ReadonlyArray<any> | null) => {
  return (array || []).length;
};

class Checklist extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    const { fields, teams, divisions, games } = this.props;

    const divisionsAndFields = !isEmpty(divisions) && !isEmpty(fields);
    const enoughTeams =
      divisions && sumBy(divisions, 'numTeams') === count(teams);

    const completed = new Set([-1]);

    if (divisionsAndFields && enoughTeams) {
      completed.add(0);
    }

    const scheduleBuilt =
      games && games.filter(g => g.scheduled).length === games.length;

    if (completed.has(0) && scheduleBuilt) {
      completed.add(1);
    }

    const divisionsSeeded =
      divisions &&
      divisions.filter(d => d.isSeeded).length === divisions.length;

    if (completed.has(1) && divisionsSeeded) {
      completed.add(2);
    }

    const lastCompleted = Math.max(...completed.values());
    const activeStep = lastCompleted + 1;

    this.state = {
      activeStep,
      completed
    };
  }

  handleStep = (step: number) => () => {
    this.setState({
      activeStep: step
    });
  };

  render() {
    const { activeStep } = this.state;
    const { fields, teams, divisions, games, scoreDisputes } = this.props;

    const maxTeams = sumBy(divisions, 'numTeams');

    const scheduledGames = games && games.filter(g => g.scheduled);

    const seededDivisions = divisions && divisions.filter(d => d.isSeeded);

    const scoredGames = games && games.filter(g => g.scoreConfirmed);

    const missingScores =
      games &&
      games.filter(g => {
        const finished = g.endTime && new Date(g.endTime) < new Date();
        return finished && !g.scoreConfirmed;
      });

    return (
      <div style={{ height: '100%' }}>
        <Stepper nonLinear activeStep={activeStep} orientation="vertical">
          <Step key="plan">
            <StepButton
              onClick={this.handleStep(0)}
              completed={this.state.completed.has(0)}
            >
              Plan
            </StepButton>
            <StepContent>
              <Plan
                fields={count(fields)}
                teams={count(teams)}
                maxTeams={maxTeams}
                divisions={count(divisions)}
              />
            </StepContent>
          </Step>

          <Step key="schedule">
            <StepButton
              onClick={this.handleStep(1)}
              completed={this.state.completed.has(1)}
            >
              Schedule
            </StepButton>
            <StepContent>
              <Schedule
                games={count(games)}
                scheduled={count(scheduledGames)}
              />
            </StepContent>
          </Step>

          <Step key="seed">
            <StepButton
              onClick={this.handleStep(2)}
              completed={this.state.completed.has(2)}
            >
              Seed
            </StepButton>
            <StepContent>
              <Seed
                divisions={count(divisions)}
                seeded={count(seededDivisions)}
              />
            </StepContent>
          </Step>

          <Step key="play">
            <StepButton onClick={this.handleStep(3)} completed={false}>
              Play
            </StepButton>
            <StepContent>
              <Play
                games={count(games)}
                scored={count(scoredGames)}
                missing={count(missingScores)}
                disputes={count(scoreDisputes)}
              />
            </StepContent>
          </Step>
        </Stepper>
      </div>
    );
  }
}

export default Checklist;
