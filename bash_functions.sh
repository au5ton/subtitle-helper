#!/bin/bash
# Setting a return status for a function

# TODO: all scripts for interacting with files and subtitles

# TODO: this wont work with fdfind

print_something() {
  echo Hello $1
  return 5
}
