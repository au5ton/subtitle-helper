#!/bin/bash
# Setting a return status for a function

print_something() {
  echo Hello $1
  return 5
}
