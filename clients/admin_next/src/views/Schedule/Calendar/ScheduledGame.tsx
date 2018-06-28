import * as React from "react";
import {
  DragSource,
  DragSourceSpec,
  ConnectDragSource,
  DragSourceCollector
} from "react-dnd";

import GameColor from "../GameColor";
import Position from "./Position";
import GameText from "../GameText";

interface Props {
  game: Game;
  error: boolean;
  gameLength: number;
  startResize: (game: Game) => void;
  unschedule: (game: Game) => void;
  connectDragSource?: ConnectDragSource;
  isDragging?: boolean;
}

const gameSource: DragSourceSpec<Props> = {
  beginDrag(props) {
    return props.game;
  },

  endDrag(props, monitor) {
    if (monitor && !monitor.didDrop()) {
      props.unschedule(props.game);
    }
  }
};

const collect: DragSourceCollector = (connect, monitor) => {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
};

class ScheduledGame extends React.Component<Props> {
  private gameRef: React.RefObject<HTMLDivElement>;

  constructor(props: Props) {
    super(props);
    this.gameRef = React.createRef();
  }

  onMouseDown = (ev: React.MouseEvent<HTMLElement>) => {
    const game = this.props.game;
    const ref = this.gameRef.current;

    if (ref) {
      const bounds = ref.getBoundingClientRect();

      if (bounds.bottom - ev.clientY < 10) {
        this.props.startResize(game);
        ev.preventDefault();
      }
    }
  }

  render() {
    const { connectDragSource, isDragging, game, error, gameLength } = this.props;
    const position = new Position(game.startTime, gameLength);
    const color = GameColor(game);
    const style = {
      opacity: isDragging ? 0.75 : 1,
      backgroundColor: color,
      ...position.inlineStyles()
    };

    let klass = "game";
    if (error) { klass += " error"; }

    if (connectDragSource) {
      return connectDragSource(
        <div className={klass} style={style} onMouseDown={this.onMouseDown}>
          <div ref={this.gameRef} className="body">
            {GameText(game, gameLength)}
          </div>
        </div>
      );
    } else {
      return null;
    }
  }
}

export default DragSource("game", gameSource, collect)(ScheduledGame);
