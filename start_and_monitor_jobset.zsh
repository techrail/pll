#!/usr/bin/env zsh 

# This file is here to start and monitor the jobs, check status and if it needs to start another job or not

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

__jobset=$1

# Read the PJC
__pjc=$(<"$ZSHY_PLL_HOME/$__jobset/pjc")

if [[ ! "$__pjc" =~ ^[0-9]+$ ]]; then
  echo "E#29DKVC: PJC was not an integer: $__pjc"
  return 35
fi 

# Create the variables for various type of counts 
__pending_job_count=0
__running_job_count=0
__errored_job_count=0
__finished_job_count=0

# The variables for holding the job IDs of pending tasks
__first_pending_lowprio_jobid=""
__first_pending_highprio_jobid=""

# We need to iterate through the jobs directory looking for the list of job directories 
__jobset_dir="$ZSHY_PLL_HOME/$__jobset/jobs"
__loop_more="yes"
__loop_interval=5
if [[ -d "$__jobset_dir" ]]; then
  # The jobset directory exists
  while [[ $__loop_more == "yes" ]]; do 
    for ((i = 0; i <= __pjc; i++)); do
      __status=$(cat "$ZSHY_PLL_HOME/$__jobset/jobs/$i/status")
      __priority=$(cat "$ZSHY_PLL_HOME/$__jobset/jobs/$i/priority")
      if [[ $__status == "pending" ]]; then
        # Check if the task was a high-priority task or not
        if [[ $__priority == "high" ]]; then
          if [[ $__first_pending_highprio_jobid == "" ]]; then
            __first_pending_highprio_jobid="$i"
          fi
        else
          if [[ $__first_pending_lowprio_jobid == "" ]]; then
            __first_pending_lowprio_jobid="$i"
          fi
        fi
  
        echo "I#29K59J: Job $i is - pending"
        # Increment the pending task count anyway
        ((__pending_job_count++))
      elif [[ $__status == "running" ]]; then
        echo "I#29K5F3: Job $i is - running"
        ((__running_job_count++))
      elif [[ $__status == "errored" ]]; then
        echo "I#29K5F9: Job $i is - errored"
        ((__errored_job_count++))
      elif [[ $__status == "finished" ]]; then
        echo "I#29K5FH: Job $i is - finished"
        ((__finished_job_count++))
      else
        echo "E#29K5JF: Job $i is in unknown state: $__status"
      fi
    done
  
    # Check if the number of running jobs is less than the pjc or not
    if [ $__running_job_count -lt $__pjc ]; then
      # We need to run a job
      if [[ $__first_pending_highprio_jobid != "" ]]; then
        # There is a high priority job that is pending. Run that one and disown the process
        source "${0:a:h}/run_job.zsh $__jobset $__first_pending_highprio_jobid" &!
      elif [[ $__first_pending_lowprio_jobid != "" ]]; then
        # There is no high priority job pending but a low priority one exists
        # Run that one and disown the process
        source "${0:a:h}/run_job.zsh $__jobset $__first_pending_lowprio_jobid" &!
      else
        echo "E#29K8ZH: Fatal error: There is neither a low priority nor a high priority job and yet you can see this!"
        return 35
      fi
    else
      echo "I#29K5P1: Running job count is more than or equal to the pjc"
    fi

    # If all jobs have stopped, we will exit 
    if [ $__running_job_count -eq 0 ]; then
    __total_stopped_jobs=$((__finished_job_count+__errored_job_count))
      if [ $_total_stopped_jobs -eq $__pjc ]; then
        # All jobs have finished
        __loop_more="no"
      fi
    fi

    # Sleep for some time before running the next loop iteration
    echo "I#29KCVE: Iteration complete. Sleeping for $__loop_interval seconds"
    sleep $__loop_interval
  done
else
  echo "E#29DCJL: Error: $__jobset_dir is not a valid directory."
fi

