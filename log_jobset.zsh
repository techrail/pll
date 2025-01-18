#!/usr/bin/env zsh 

#### This file would log a message to the supplied jobset's logfile with supplied log level and message
## It will also log the current time at which the log message was recieved

# In case someone calls this script by hand
if ! source "${0:a:h}/startup_check.zsh"; then
  echo "E#29LH6I: Startup check failed. Also, please don't call this script manually!"
  return 11
fi 

# Must have exactly one argument
if [ $# -ne 3 ]; then
  echo "E#29LH6O: 3 arguments are needed (jobset, log-level and message). $# were given"
  return 11
fi

# Get the values
$__jobset=$1
$__loglevel=$2
$__msg=$3

# Make sure that the jobset directory exists. 
if [ -d "$ZSHY_PLL_HOME/$__jobset" ]; then
  # Put the message in the logfile
  echo "$(date +%Y-%m-%d_%H-%M-%S) [$__loglevel]: $__msg" > "$ZSHY_PLL_HOME/$__jobset/logfile"
else
  echo "E#29LHGG: Jobset with name $__jobset does not exist."
  return 11
fi 
