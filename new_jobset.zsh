#!/usr/bin/env zsh

#### This script is here to create a new jobset

# In case someone calls this script by hand
if ! source "${0:a:h}/startup_check.zsh"; then
  echo "E#293Q31: Startup check failed. Also, please don't call this script manually!"
  return 15
fi 

# Must have exactly one argument
if [ $# -ne 1 ]; then
  echo "E#293Q0N: Extra arguments recieved. Not expected"
  return 15
fi

__jobset=$1 

# Check that the directory name already exists or not
if [ -d "$ZSH_PLL_HOME/$__jobset" ]; then 
  echo "E#293QER: Jobset directory already exists: $ZSHY_PLL_HOME/$__jobset"
  return 15
fi 

# Make the directory and subdirectories
echo "Creating jobset directory: $ZSHY_PLL_HOME/$__jobset"
mkdir -p "$ZSHY_PLL_HOME/$__jobset"

if [ $? -ne 0 ]; then
  echo "E#293QOW: Could not create the jobset directory."
  return 15
fi 

# Make the subdirectories and files
echo "Creating status file: $ZSHY_PLL_HOME/$__jobset/status"
echo "pending" > "$ZSHY_PLL_HOME/$__jobset/status"

if [ $? -ne 0 ]; then
  echo "E#293QYY: Status file creation failed!!"
  return 15
fi 

echo "Creating log file: $ZSHY_PLL_HOME/$__jobset/logfile"

if [ $? -ne 0 ]; then
  echo "E#293VO6: Logfile creation failed!!"
  return 15
fi 
echo "Logfile for the jobset. Activities related to jobset itself (not any individual job) will be sent here" > "$ZSH_PLL_HOME/$__jobset/logfile"

echo "Creating jobcount file: $ZSHY_PLL_HOME/$__jobset/pjc"
echo "0" > "$ZSHY_PLL_HOME/$__jobset/pjc"

if [ $? -ne 0 ]; then
  echo "E#2941OE: jobcount file creation failed!!"
  return 15
fi 

echo "Creating jobs directory: $ZSHY_PLL_HOME/$__jobset/jobs/"
mkdir -p "$ZSHY_PLL_HOME/$__jobset/jobs"

echo "Jobset $__jobset is ready to get jobs"

