#!/bin/bash

sls invoke local --function hello --path event.json --docker-arg "--network localstack_default"