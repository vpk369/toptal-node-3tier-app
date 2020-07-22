import React from 'react';

class myComponent extends React.Component {
   constructor(props) {
      super(props);
		
      this.state = {
         request_uuid: "<REQUEST_UUID>",
      }
   }

  componentDidMount() {
  	const apiUrl = process.env.API_HOST + '/api/status'
    fetch(apiUrl)
      .then(response => response.json())
      .then(data => { console.log(data);
        this.setState({request_uuid: data.request_uuid})
      });
  }
  render() {
    return <h1>Request uuid from api server is {this.state.request_uuid}</h1>;
  }
}
export default myComponent;
