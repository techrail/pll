#!/usr/bin/env zsh 

if [ $# -lt 1 ]; then
  echo "You are not supposed to call this command manually"
  return 10
fi 

if [[ ! -v ZSHY_PLL_HOME ]]; then
  echo "E#292VQP: ZSHY_PLL_HOME is not set. Please set it to the full path of a directory where zshy-pll can read and write files and directories"
  return 10
fi 

if [ -e "$ZSHY_PLL_HOME" ]; then
  # path exists
  # Check if it is a file 
  if [ -f "$ZSHY_PLL_HOME" ]; then
    echo "E#292WRD: ZSHY_PLL_HOME is a file. It needs to be a directory"
    echo "Please make sure that the values of ZSHY_PLL_HOME points to a directory when zsh can read and write files and directories"
    return 10
  fi

  # Check that it is not a symbolic link
  if [ -d "$ZSHY_PLL_HOME" ]; then
    if [ -L "$ZSHY_PLL_HOME" ]; then
      echo "E#292WV2: ZSHY_PLL_HOME is a symlink to a directory."
      echo "Please make sure that it points to a directory, not to a symlink."
      return 10
    fi
  else
    echo "E#292WZK: ZSHY_PLL_HOME points to an address which is not a directory."
    echo "Please make sure that it points to a directory."
    return 10
  fi
else
  echo "E#292WKH: ZSHY_PLL_HOME points to a non-existent path"
  echo "pll needs a directory to store jobsets and jobs data"
  echo "Create the directory and set ZSHY_PLL_HOME to that value."

  echo "Run this to create the directory:"
  echo ""
  echo "mkdir -p $ZSHY_PLL_HOME"
fi



