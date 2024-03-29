import * as React from 'react';
import { ActionMenu as styles } from '../assets/jss/styles';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import Zoom from '@material-ui/core/Zoom';

import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';

import SpeedDial from '@material-ui/lab/SpeedDial';
import SpeedDialIcon from '@material-ui/lab/SpeedDialIcon';
import SpeedDialAction from '@material-ui/lab/SpeedDialAction';

const icon = (i: 'add' | 'edit' | JSX.Element) => {
  const icons = {
    add: <AddIcon />,
    edit: <EditIcon />
  };

  if (typeof i === 'string') {
    return icons[i];
  } else {
    return i;
  }
};

interface Action {
  icon: 'add' | 'edit' | JSX.Element;
  name: string;
  handler: () => void;
}

interface Props extends WithStyles<typeof styles, true> {
  actions: ReadonlyArray<Action>;
}

interface State {
  open: boolean;
}

class ActionMenu extends React.Component<Props, State> {
  state = {
    open: false
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  handleClick = () => {
    this.setState({ open: !this.state.open });
  };

  render() {
    const { theme, actions } = this.props;

    const transitionDuration = {
      enter: theme.transitions.duration.enteringScreen,
      exit: theme.transitions.duration.leavingScreen
    };

    return (
      <Zoom
        in={true}
        timeout={transitionDuration}
        style={{ transitionDelay: `${transitionDuration.exit}ms` }}
        unmountOnExit
      >
        {actions.length > 1
          ? this.renderMenu(actions)
          : this.renderButton(actions[0])}
      </Zoom>
    );
  }

  renderMenu = (actions: ReadonlyArray<Action>) => {
    const { classes } = this.props;

    return (
      <SpeedDial
        id="action-menu"
        ariaLabel="Menu"
        className={classes.fab}
        icon={<SpeedDialIcon />}
        onBlur={this.handleClose}
        onClick={this.handleClick}
        onClose={this.handleClose}
        onFocus={this.handleOpen}
        onMouseEnter={this.handleOpen}
        onMouseLeave={this.handleClose}
        open={this.state.open}
      >
        {actions.map(action => (
          <SpeedDialAction
            key={action.name}
            icon={icon(action.icon)}
            tooltipTitle={action.name}
            onClick={action.handler}
          />
        ))}
      </SpeedDial>
    );
  };

  renderButton = (action: Action) => {
    const { classes } = this.props;

    return (
      <Fab
        id="action-menu"
        variant="round"
        color="primary"
        className={classes.fab}
        onClick={action.handler}
      >
        {icon(action.icon)}
      </Fab>
    );
  };
}

export default withStyles(styles, { withTheme: true })(ActionMenu);
