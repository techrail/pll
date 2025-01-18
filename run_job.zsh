#!/usr/bin/env zsh 

#### This script/file is here to launch a single job in a jobset

# In case someone calls this script by hand
if ! source "${0:a:h}/startup_check.zsh"; then
  echo "E#29K9JB: Startup check failed. Also, please don't call this script manually!"
  return 45
fi 

# Check if the argument was sent or not
if [ $# -ne 2 ]; then
  echo "E#29K9JJ: The jobset name and job id was not set. Both are required. Cannot proceed!!"
  return 45
fi

__jobset=$1
__jobid=$2

# Make sure that the jobset exists
if [ -d "$ZSHY_PLL_HOME/$__jobset" ]; then
  # Make sure that the jobid directory exists too
  if [ -d "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid" ]; then
    # We need to run the job
    # Read the command for the job
    $__cmd=$(< "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/cmd")
    if [ $? -ne 0 ]; then
      # We are not able to read the command for this job
      # So that's an error on the pll level and this problem should not be reported on the job level
      echo "E#29LGRU: Error when reading the command from $ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/cmd"
      return 45
    fi

    # Now run the command. Set the state to 'running'
    echo "running" > "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/status"
    eval "$__cmd" > "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/stdout" 2>"$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/stderr"
    if [ $? -ne 0 ]; then
      # Failure
      echo "errored" > "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/status"
      source "${0:a:h}/log_jobset.zsh" $__jobset "ERROR" "Running the command for job ID $__jobid failed!"
      return 45
    else
      # Success
      echo "success" > "$ZSHY_PLL_HOME/$__jobset/jobs/$__jobid/status"
    fi
  else
    echo "E#29K9Q7: The job directory (full path: $ZSHY_PLL_HOME/$__jobset/jobs/$__jobid) does not exist!"
    return 45
  fi
else
  echo "E#29K9Q7: The jobset directory (full path: $ZSHY_PLL_HOME/$__jobset) does not exist!"
  return 45
fi 

