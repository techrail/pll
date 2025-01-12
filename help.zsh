#!/usr/bin/env zsh

# This script is supposed to show the help message related to ZSHY Parallel Extension

echo "Usage: $1 action"
cat <<'EOF'
action:
  help     Prints this help
  new      Create a new jobset
  

Description:
  This script allows a user to create jobset and enqueue a list of jobs in a
  jobset. The jobs in the jobset can then be made to run in parallel.

Examples:
  myscript --help

EOF


