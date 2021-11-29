#!/usr/bin/env bash

source ~/.rvm/scripts/rvm
rvm use default
pod trunk push --verbose | ruby -e 'ARGF.each{ print "." }'
