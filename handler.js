'use strict';

module.exports.hello = async event => {
  console.log(event)

  var AWS = require('aws-sdk');

  var myBucket = 'test-bucket';
  var myKey = '1.csv';
  var s3 = new AWS.S3();
  
  // Los nombres de buckets deben ser únicos entre todos los usuarios de S3
  
  var params = {};
  var buckets = s3.listBuckets(params, await function(err, data) {
    if (err) // an error occurred
      console.log(err, err.stack); 
    else{ // successful response
      console.log(data); 
      return data;
    }     
  })

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event.Records[0].doby,
      },
      null,
      2
    ),
  };

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
