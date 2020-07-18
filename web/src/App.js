import React from 'react';

class myComponent extends React.Component {
  componentDidMount() {
    const apiUrl = process.env.API_HOST + '/api/status';
    fetch(apiUrl)
      .then((response) => response.json())
      .then((data) => console.log('This is your api status: ', data));
  }
  render() {
    return <h1>REST API call with REACT, Check the Browser Console for Output. </h1>;
  }
}
export default myComponent;

{/* This is a simple rest call with react JS.
There are few .js files in this folder that has some dummy data

https://www.smashingmagazine.com/2020/06/rest-api-react-fetch-axios/

*/}
