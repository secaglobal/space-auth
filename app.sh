#!/bin/bash
case $1 in
  "spec")
    mocha --compilers coffee:coffee-script --recursive --reporter spec spec/helper.coffee  spec
    ;;

  "test")
    node app > /dev/null &
    server_pid=$!
    mocha --compilers coffee:coffee-script --recursive --reporter spec test/helper.coffee test
    kill $server_pid
    ;;
esac