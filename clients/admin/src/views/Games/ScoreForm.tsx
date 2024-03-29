import * as React from 'react';
import { FormikValues, FormikProps, FormikErrors } from 'formik';
import { isEmpty } from 'lodash';

import TextField from '@material-ui/core/TextField';
import FormButtons from '../../components/FormButtons';

import Form from '../../components/Form';
import UpdateScoreMutation from '../../mutations/UpdateScore';

interface Props {
  input: UpdateScoreMutationVariables['input'];
  game: GameListQuery_games;
  cancel: () => void;
}

class ScoreForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    return {
      homeScore: input.homeScore || '',
      awayScore: input.awayScore || ''
    };
  };

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (values.homeScore && values.homeScore <= 0) {
      errors.homeScore = 'Invalid score';
    }

    if (values.awayScore && values.awayScore <= 0) {
      errors.awayScore = 'Invalid score';
    }

    return errors;
  };

  mutation = () => {
    return UpdateScoreMutation;
  };

  mutationInput = (values: FormikValues) => {
    return {
      input: {
        gameId: this.props.input.gameId,
        homeScore: values.homeScore,
        awayScore: values.awayScore
      }
    };
  };

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const { game } = this.props;
    const {
      values,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <div style={{ display: 'flex', justifyContent: 'space-around' }}>
          <TextField
            name="homeScore"
            label={game.homeName}
            type="number"
            margin="normal"
            autoComplete="off"
            fullWidth
            value={values.homeScore}
            onChange={handleChange}
            helperText={errors.homeScore}
            style={{ flexBasis: '40%' }}
          />
          <TextField
            name="awayScore"
            label={game.awayName}
            type="number"
            margin="normal"
            autoComplete="off"
            fullWidth
            value={values.awayScore}
            onChange={handleChange}
            helperText={errors.awayScore}
            style={{ flexBasis: '40%' }}
          />
        </div>
        <FormButtons
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancel={this.props.cancel}
        />
      </form>
    );
  };
}

export default ScoreForm;
