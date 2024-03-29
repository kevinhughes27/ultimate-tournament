import * as React from 'react';
import { withRouter, RouteComponentProps } from 'react-router-dom';
import { FormikValues, FormikProps, FormikErrors } from 'formik';
import * as EmailValidator from 'email-validator';
import { isEmpty } from 'lodash';

import TextField from '@material-ui/core/TextField';
import FormButtons from '../../components/FormButtons';

import Form from '../../components/Form';
import runMutation from '../../helpers/runMutation';
import UpdateTeamMutation from '../../mutations/UpdateTeam';
import CreateTeamMutation from '../../mutations/CreateTeam';
import DeleteTeamMutation from '../../mutations/DeleteTeam';

interface Props extends RouteComponentProps<any> {
  input: UpdateTeamInput & CreateTeamInput;
}

class TeamForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    return {
      name: input.name,
      email: input.email || ''
    };
  };

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = 'Required';
    }

    if (values.email && !EmailValidator.validate(values.email)) {
      errors.email = 'Invalid email address';
    }

    return errors;
  };

  mutation = () => {
    const teamId = this.props.input.id;

    if (teamId) {
      return UpdateTeamMutation;
    } else {
      return CreateTeamMutation;
    }
  };

  mutationInput = (values: FormikValues) => {
    const teamId = this.props.input.id;

    if (teamId) {
      return { input: { id: teamId, ...values } };
    } else {
      return { input: values };
    }
  };

  delete = () => {
    const teamId = this.props.input.id;

    if (teamId) {
      return () => {
        runMutation(
          DeleteTeamMutation,
          { input: { id: teamId } },
          { complete: this.deleteComplete }
        );
      };
    } else {
      return undefined;
    }
  };

  deleteComplete = () => {
    this.props.history.push('/teams');
  };

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      dirty,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
          helperText={errors.name}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.email}
          onChange={handleChange}
          helperText={errors.email}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancelLink={'/teams'}
          delete={this.delete()}
        />
      </form>
    );
  };
}

export default withRouter(TeamForm);
