#!/usr/bin/env zsh

# Things that we want to do with pll:
# 1. Create a Parallel Jobset (given a name)
# 2. Check if a jobset by that name exists. If not, create one. If yes, tell the user that a jobset with that name exists already
# 3. Have the ability of adding job to the jobset. Each job has a serial number and a command. Jobs in a jobset are executed in the order
# 4. Each jobset must have a parallel-job-count (PJC). This is the number of jobs that get executed in parallel for that jobset.
# 5. For each jobset, pll should be able to do the following: 
#    a) The complete status of the jobset - not-started, started (number of finished, in-progress and pending jobs), finished.
#    b) stdout and stderr of each job - must be sent to files on disk and the full path of the files have to be reported right before starting the job.
#       It should be possible to set both stdout and stderr to the same file (for easier monitoring)
#    c) If the jobset is not ended, then be able to add more jobs to the jobset.
#    d) Ability to remove those jobs from the jobset which are not yet started.
#    e) Ability to end running jobs.
#    f) Ability to look at log files of any job in a jobset.
# 6. A master log file where pll will report its own activities (not the log file for jobs themselves). It will record things like:
#    a) When was a new job added. 
#    b) When a job finished.
#    c) When a job failed. 
#    d) How long did the job take to finish.
# This is the initial set of requirements using which we will try to create zshy-pll

########
# Let's first check if the required variables are set or not

if ! source ${0:a:h}/startup_check.zsh "manual_defence"; then
	echo ""
	echo "Startup checks failed"

	return 1
fi 

# Look for the primary switch
if [ $# -lt 1 ]; then
  echo "E#N292VPX: Not enough arguments."
  return 1
fi 

# Switch based on the primary action 
__zshy_pll_primary_action=$1

shift

case $__zshy_pll_primary_action in 
  new)
    if [ $# -lt 1 ]; then
      echo "E#292VW2: Name of new jobset not supplied"
      return 2 
    fi

    __zshy_pll_jobset_name=$1

    source ${0:a:h}/new_jobset.zsh $__zshy_pll_jobset_name
    ;;
  addjob)
    # We have to accept two arguments. First one is the jobset name. Second one is the job itself
    if [ $# -ne 2 ]; then
      echo "E#293YFC: Only 2 arguments (jobset name and command) are required."
      return 2
    fi

    __zshy_pll_jobset_name=$1
    __zshy_pll_job_cmd=$2

    # Call the script now to schedule the program
    source ${0:a:h}/add_job.zsh $__zshy_pll_jobset_name $__zshy_pll_job_cmd
    ;;
  start)
    # We have to accept just one argument - the name of the jobset 
    if [ $# -ne 1 ]; then
      echo "E#29DA7J: Only 1 argument (jobset name) is required!"
      return 2 
    fi

    __zshy_pll_jobset_name=$1

    # Call the script now to schedule the program
    source ${0:a:h}/start_and_monitor_jobset.zsh $__zshy_pll_jobset_name 1>"$ZSHY_PLL_HOME/$__zshy_pll_jobset_name/logfile" 2>"$ZSHY_PLL_HOME/$__zshy_pll_jobset_name/logfile" &!
    echo "The job runner has been started. You can tail the following logfile to check the runner output:\n"
    echo "$ZSHY_PLL_HOME/$__zshy_pll_jobset_name/logfile"
    echo "\n"
    ;;
  tail)
    # we will check the log file of jobs now
    echo "This feature is not yet implemented."
    ;;
  help|--help)
    source ${0:a:h}/help.zsh $0
    ;;
  *)
    echo "E#293POD - Not a valid action!\nAborting."
    ;;
esac



