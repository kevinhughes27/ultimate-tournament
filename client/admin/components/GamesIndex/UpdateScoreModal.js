import React from 'react'
import PropTypes from 'prop-types'
import { Modal } from 'react-bootstrap'
import classNames from 'classnames'
import confirm from './Confirm'

class UpdateScoreModal extends React.Component {
  constructor (props) {
    super(props)

    this.open = this.open.bind(this)
    this.close = this.close.bind(this)
    this.opened = this.opened.bind(this)
    this.setFocus = this.setFocus.bind(this)
    this.submit = this.submit.bind(this)

    const { game, resolve } = this.props

    this.state = {
      show: false,
      isLoading: false,
      resolve: resolve,
      homeScore: game.home_score,
      awayScore: game.away_score
    }
  }

  open (ev) {
    ev.preventDefault()
    this.setState({show: true})
  }

  close (ev) {
    if (ev) { ev.preventDefault() }
    this.setState({ show: false })
  }

  opened () {
    let game = this.props.game

    this.setState({
      homeScore: game.home_score,
      awayScore: game.away_score
    })
  }

  setFocus () {
    this.refs.input.focus()
  }

  submit (ev) {
    ev.preventDefault()
    this.updateScore()
  }

  updateScore (force = false) {
    let gameId = this.props.game.id
    this.setState({isLoading: true})

    $.ajax({
      url: 'games/' + gameId,
      type: 'PUT',
      beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore,
        resolve: this.state.resolve,
        force: force
      },
      success: (response) => {
        this.setState({isLoading: false})
        this.close()
        Admin.Flash.notice('Score updated')
      },
      error: (response) => {
        this.setState({isLoading: false})
        this._updateScoreError(response)
      }
    })
  }

  _updateScoreError (response) {
    let status = response.status
    let message = response.responseJSON.error

    if (message === 'unsafe score update') {
      this.close()
      this.confirmUpdateScore()
    } else if (status === 422) {
      Admin.Flash.error(message)
    } else {
      Admin.Flash.error('Error updating score')
    }
  }

  confirmUpdateScore () {
    confirm({
      title: 'Confirm Update Score',
      message: 'This update will change the teams in games that come after it\
      and some of those games have been scored. If you update this\
      score those games will be reset. This cannot be undone.'
    }).then(
      (result) => {
        this.updateScore(true)
      },
      (result) => {
        console.log('cancelled')
      }
    )
  }

  render () {
    const { game, linkText, linkClass } = this.props
    const btnClasses = classNames('btn', 'btn-primary', {'is-loading': this.state.isLoading})

    return (
      <div>
        <button className={linkClass} onClick={this.open}>
          {linkText}
        </button>

        <Modal
          show={this.state.show}
          onHide={this.close}
          onEnter={this.opened}
          onEntered={this.setFocus}>
          <Modal.Header closeButton>
            <Modal.Title>{game.home_name} vs {game.away_name}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <form>
              <div className='row'>
                <div className="col-md-5 col-sm-5 col-xs-5">
                  <input type="number"
                         value={this.state.homeScore}
                         placeholder={game.home}
                         min='0'
                         className="form-control score-input"
                         onChange={ (e) => {
                           this.setState({homeScore: e.target.valueAsNumber})
                         }}
                         ref="input"/>
                </div>
                <div className='col-md-1 col-sm-1 col-xs-1 text-center'>
                  <span><i className="fa fa-window-minimize" style={{paddingTop: '4px'}}></i></span>
                </div>
                <div className="col-md-6 col-sm-6 col-xs-5">
                  <input type="number"
                         value={this.state.awayScore}
                         placeholder={game.away}
                         min='0'
                         className="form-control score-input"
                         onChange={ (e) => {
                           this.setState({awayScore: e.target.valueAsNumber})
                         }}/>
                </div>
              </div>
            </form>
          </Modal.Body>
          <Modal.Footer>
            <button className="btn btn-default" onClick={this.close}>Cancel</button>
            <button className={btnClasses} onClick={this.submit}>
              Save
            </button>
          </Modal.Footer>
        </Modal>
      </div>
    )
  }
}

UpdateScoreModal.propTypes = {
  game: PropTypes.object.isRequired,
  resolve: PropTypes.bool,
  linkText: PropTypes.element.isRequired,
  linkClass: PropTypes.string
}

UpdateScoreModal.defaultProps = {
  resolve: false,
  linkClass: ''
}

module.exports = UpdateScoreModal
