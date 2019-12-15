#!/bin/bash

#S3
awslocal s3 mb s3://test-bucket
awslocal s3 cp example.csv s3://test-bucket/1.csv
