import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import { encodeId } from "../../helpers/relay";
import DivisionSeed from "./DivisionSeed";

interface Props extends RouteComponentProps<any> {}

class DivisionSeedContainer extends React.Component<Props> {
  render() {
    const divisionId = encodeId("Division", this.props.match.params.divisionId);

    const query = graphql`
      query DivisionSeedContainerQuery($divisionId: ID!) {
        division(id: $divisionId) {
          ...DivisionSeed_division
        }
      }
    `;

    return renderQuery(query, {divisionId}, DivisionSeed);
  }
}

export default withRouter(DivisionSeedContainer);
