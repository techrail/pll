#!/usr/bin/env zsh 

# This file is here to monitor the jobs, check status and if it needs to start another job or not

# In case someone calls this script by hand
if ! source "${0:a:h}/startup_check.zsh"; then
  echo "E#29D9P9: Startup check failed. Also, please don't call this script manually!"
  return 35
fi 

# Check if the argument was sent or not
if [ $# -ne 1 ]; then
  echo "E#29D9UF: The jobset name was not sent. Cannot proceed!!"
  return 35
fi 

# Read the PJC
__pjc=$(cat "$ZSHY_PLL_HOME/$1/pjc")

# Create the variables for various type of counts 
__pending_task_count=0
__running_task_count=0
__finished_task_count=0

# We need to iterate through the jobs directory looking for the list of job directories 
jobset_dir="$ZSHY_PLL_HOME/$1/jobs"
if [[ -d "$jobset_dir" ]]; then
  echo "Directories in $jobset_dir"


#  for item in "$jobset_dir"/*; do
#    if [[ -d "$item" ]]; then
#      echo "$item ----> $(basename $item)"
#      # Let's check the status of the job and add it to the right variable
#      cat "$ZSHY_PLL_HOME/$1/jobs/"
#    fi
#  done
else
  echo "E#29DCJL: Error: $jobset_dir is not a valid directory."
fi



