#!/bin/bash
# this code it horrible as hell
#TODO: better code

run(){
  touch arg
  echo $1 > arg
  $term -e './XTools.sh $(cat arg)'
  rm arg
}

term=$(cat runat)
run $1
