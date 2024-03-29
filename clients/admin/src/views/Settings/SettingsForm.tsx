import * as React from 'react';
import { FormikValues, FormikProps, FormikErrors } from 'formik';
import { isEmpty } from 'lodash';
import TextField from '@material-ui/core/TextField';
import TimezonePicker from './TimezonePicker';
import ConfirmOptions from './ConfirmOptions';
import Form from '../../components/Form';
import FormButtons from '../../components/FormButtons';
import UpdateSettingsMutation from '../../mutations/UpdateSettings';
import { Typography, withStyles, WithStyles } from '@material-ui/core';

const styles = {
  heading: {
    paddingTop: 10
  }
}

interface Props extends WithStyles<typeof styles> {
  input: UpdateSettingsMutationVariables['input'];
}

class SettingsForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    return {
      name: input.name,
      handle: input.handle,
      timezone: input.timezone,
      scoreSubmitPin: input.scoreSubmitPin || '',
      gameConfirmSetting: input.gameConfirmSetting
    };
  };

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = 'Required';
    }

    if (!values.handle) {
      errors.handle = 'Required';
    }

    if (values.scoreSubmitPin !== '' && values.scoreSubmitPin.length !== 4) {
      errors.scoreSubmitPin = 'Invalid Pin Length it should be 4';
    }

    return errors;
  };

  mutation = () => {
    return UpdateSettingsMutation;
  };

  mutationInput = (values: FormikValues) => {
    return { input: values };
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

    const { classes } = this.props;

    return (
      <form onSubmit={handleSubmit}>
        <Typography variant="h6" component="h2" className={classes.heading}>
          Tournament Settings:
        </Typography>

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
          name="handle"
          label="Handle"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.handle}
          onChange={handleChange}
          helperText={errors.handle}
        />
        <TimezonePicker timezone={values.timezone} onChange={handleChange} />

        <Typography variant="h6" component="h2" className={classes.heading}>
          App Settings:
        </Typography>

        <TextField
          name="scoreSubmitPin"
          label="Score Submit Pin Code"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.scoreSubmitPin}
          onChange={handleChange}
          helperText={errors.scoreSubmitPin}
        />
        <ConfirmOptions
          value={values.gameConfirmSetting}
          onChange={handleChange}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
        />
      </form>
    );
  };
}

export default withStyles(styles)(SettingsForm);
