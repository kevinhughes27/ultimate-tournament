import React, { Component } from 'react';
import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

const theme = createMuiTheme({
  typography: {
    useNextVariants: true
  }
});

class Layout extends Component {
  render() {
    return (
      <MuiThemeProvider theme={theme}>
        <div className="layout">
          <div className="topbar">
            <TopBar />
          </div>

          <div className="content">
            {this.props.children}
          </div>

          <div className="bottombar">
            <BottomNav />
          </div>
        </div>
      </MuiThemeProvider>
    );
  }
}

export default Layout;
