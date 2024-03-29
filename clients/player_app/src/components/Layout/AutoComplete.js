import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Autosuggest from 'react-autosuggest';
import TextField from '@material-ui/core/TextField';
import Paper from '@material-ui/core/Paper';
import MenuItem from '@material-ui/core/MenuItem';
import match from 'autosuggest-highlight/match';
import parse from 'autosuggest-highlight/parse';
import { omit } from 'lodash';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  container: {
    flexGrow: 1,
    position: 'relative'
  },
  suggestionsContainerOpen: {
    position: 'absolute',
    marginTop: theme.spacing(),
    marginBottom: theme.spacing(3),
    left: 0,
    right: 0
  },
  suggestion: {
    display: 'block'
  },
  suggestionsList: {
    margin: 0,
    padding: 0,
    listStyleType: 'none'
  },
  textField: {
    width: '100%'
  },
  input: {
    color: 'white'
  }
});

class AutoComplete extends Component {
  constructor(props) {
    super(props);

    this.state = {
      value: this.props.value,
      suggestions: []
    };
  }

  handleSuggestionsFetchRequested = ({ value }) => {
    this.setState({
      suggestions: getSuggestions(this.props.suggestions, value)
    });
  };

  handleSuggestionsClearRequested = () => {
    this.setState({
      suggestions: []
    });
  };

  handleChange = (event, { newValue }) => {
    this.props.onChange(newValue);
    this.setState({
      value: newValue
    });
  };

  render() {
    const { classes, placeholder } = this.props;
    const { value, suggestions } = this.state;

    return (
      <Autosuggest
        theme={{
          container: classes.container,
          suggestionsContainerOpen: classes.suggestionsContainerOpen,
          suggestionsList: classes.suggestionsList,
          suggestion: classes.suggestion
        }}
        suggestions={suggestions}
        getSuggestionValue={getSuggestionValue}
        onSuggestionsFetchRequested={this.handleSuggestionsFetchRequested}
        onSuggestionsClearRequested={this.handleSuggestionsClearRequested}
        renderInputComponent={renderInput}
        renderSuggestion={renderSuggestion}
        renderSuggestionsContainer={renderSuggestionsContainer}
        shouldRenderSuggestions={shouldRenderSuggestions}
        inputProps={{
          id: 'search',
          classes,
          placeholder: placeholder,
          value: value,
          onChange: this.handleChange
        }}
      />
    );
  }
}

function renderInput(inputProps) {
  const { classes, value, ref } = inputProps;
  const otherProps = omit(inputProps, 'classes', 'value', 'ref')

  return (
    <TextField
      className={classes.textField}
      value={value}
      inputRef={ref}
      InputProps={{
        classes: {
          input: classes.input
        },
        disableUnderline: true,
        ...otherProps
      }}
    />
  );
}

function renderSuggestionsContainer(options) {
  const { containerProps, children } = options;

  return (
    <Paper {...containerProps}>
      {children}
    </Paper>
  );
}

function renderSuggestion(suggestion, { query, isHighlighted }) {
  const matches = match(suggestion, query);
  const parts = parse(suggestion, matches);

  return (
    <MenuItem selected={isHighlighted} component="div">
      <div>
        {parts.map((part, index) => {
          return part.highlight ? (
            <span key={String(index)} style={{ fontWeight: 800 }}>
              {part.text}
            </span>
          ) : (
            <strong key={String(index)} style={{ fontWeight: 300 }}>
              {part.text}
            </strong>
          );
        })}
      </div>
    </MenuItem>
  );
}

function getSuggestionValue(suggestion) {
  return suggestion;
}

function escapeRegexCharacters(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function getSuggestions(suggestions, value) {
  const escapedValue = escapeRegexCharacters(value.trim());
  const regex = new RegExp('^' + escapedValue, 'i');

  return suggestions.filter(s => regex.test(s));
}

function shouldRenderSuggestions() {
  return true;
}

AutoComplete.propTypes = {
  classes: PropTypes.object.isRequired,
  value: PropTypes.string.isRequired,
  placeholder: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired
};

export default withStyles(styles)(AutoComplete);
