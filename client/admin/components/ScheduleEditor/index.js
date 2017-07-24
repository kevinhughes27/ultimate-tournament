import React from 'react'
import PropTypes from 'prop-types'

import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'

import _isEmpty from 'lodash/isEmpty'

import UnscheduledGames from './UnscheduledGames'
import Legend from './Legend'
import Schedule from './Schedule'
import GamesStore from '../../stores/GamesStore'

class ScheduleEditor extends React.Component {
  constructor (props) {
    super(props)

    GamesStore.init(JSON.parse(this.props.games))

    this.onChange = this.onChange.bind(this)

    this.state = {
      unscheduledGames: GamesStore.unscheduled(),
      scheduledGames: GamesStore.scheduled()
    }
  }

  componentDidMount () {
    GamesStore.addChangeListener(this.onChange)
  }

  componentWillUnmount () {
    GamesStore.removeChangeListener(this.onChange)
  }

  onChange () {
    this.setState({
      unscheduledGames: GamesStore.unscheduled(),
      scheduledGames: GamesStore.scheduled()
    })
  }

  render () {
    let unscheduledGames = this.state.unscheduledGames
    let scheduledGames = this.state.scheduledGames
    let fields = JSON.parse(this.props.fields)

    let top = null

    if (_isEmpty(unscheduledGames)) {
      top = (<Legend games={scheduledGames}/>)
    } else {
      top = (<UnscheduledGames games={unscheduledGames}/>)
    }

    return (
      <div>
        { top }
        <Schedule games={scheduledGames} fields={fields} gameLength={this.props.gameLength}/>
      </div>
    )
  }
}

ScheduleEditor.propTypes = {
  games: PropTypes.string.isRequired,
  fields: PropTypes.string.isRequired,
  gameLength: PropTypes.number.isRequired
}

export default DragDropContext(HTML5Backend)(ScheduleEditor)
