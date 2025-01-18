#!/usr/bin/env zsh 

# This script is part of zshy pll extension and is supposed to add a new job to a jobset
# NOTE: This program is not supposed to be by user. Running is handled by the runner separately

# This script will accept only two arguments - jobset name and the job that needs to be run

# In case someone calls this script by hand
if ! source "${0:a:h}/startup_check.zsh"; then
  echo "E#2940LA: Startup check failed. Also, please don't call this script manually!"
  return 25
fi 

# Make sure that the script is called with 2 arguments only
if [ $# -ne 2 ]; then
  echo "E#2940MC: 2 arguments required (only) - jobset name and the program to run"
  return 25
fi 

# Read the current job number, increment by one and put the command inside the jobs directory
__zshy_pll_curr_job_num=$(cat "$ZSHY_PLL_HOME/$1/pjc")

if [ $? -ne 0 ]; then
  echo "E#2942QG: Could not get the current job count of this jobset"
  return 25
fi 

((__zshy_pll_curr_job_num++))

if [ $? -ne 0 ]; then
  echo "E#2942VD: Incrementing the job count ( $__zshy_pll_curr_job_num ) failed."
  echo $__zshy_pll_curr_job_num
  return 25
fi 

__jobdir="$ZSHY_PLL_HOME/$1/jobs/$__zshy_pll_curr_job_num"

# Try to create the directory
mkdir -p "$__jobdir"

# Try to create the statusfile, stdout, stderr, priority, cmd file and the data directory
echo "normal" > "$__jobdir/priority"
if [ $? -ne 0 ]; then
  echo "E#29455X: Setting priority for job #( $__zshy_pll_curr_job_num ) failed."
  return 25
fi 

echo "$2" > "$__jobdir/cmd"
if [ $? -ne 0 ]; then
  echo "E#294563: Saving command for job #( $__zshy_pll_curr_job_num ) failed."
  return 25
fi 

echo "" > "$__jobdir/stdout"
if [ $? -ne 0 ]; then
  echo "E#294569: Creating the stdout file for job #( $__zshy_pll_curr_job_num ) failed."
  return 25
fi 

echo "" > "$__jobdir/stderr"
if [ $? -ne 0 ]; then
  echo "E#29456I: Creating the stderr file for job #( $__zshy_pll_curr_job_num ) failed."
  return 25
fi 

echo "pending" > "$__jobdir/status"
if [ $? -ne 0 ]; then
  echo "E#29456O: Incrementing the job count ( $__zshy_pll_curr_job_num ) failed."
  return 25
fi 

echo $__zshy_pll_curr_job_num > "$ZSHY_PLL_HOME/$1/pjc"
if [ $? -ne 0 ]; then 
  echo "E#29DFRF: Could not set the new pjc"
  return 25
fi


