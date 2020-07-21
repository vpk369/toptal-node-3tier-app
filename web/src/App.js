import React from 'react';

class myComponent extends React.Component {
   constructor(props) {
      super(props);
		
      this.state = {
         request_uuid: "<REQUEST_UUID>",
      }
   }

  componentDidMount() {
  	const apiUrl = 'http://toptal-prod-api.us-east-1.elasticbeanstalk.com/api/status'
    fetch(apiUrl)
      .then((response) => {
      	console.log(response)
      	this.setState({request_uuid: response.request_uuid})
      })
      // .then();
  }
  render() {
    return <h1>Request uuid from api server is {this.state.request_uuid}</h1>;
  }
}
export default myComponent;
