# This file is generated by https://github.com/adoyle-h/shell-colors
# Author: ADoyle <adoyle.h@gmail.com>
# License: BSD 3-clause License
# Attentions: GREY may not work in some shells

case "${TERM:-}" in
  *-color|*-256color) COLOR_ENABLED=yes;;
  *) COLOR_ENABLED= ;;
esac

if [[ -n "${COLOR_FORCE_ENABLED:-}" ]]; then
  if tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429).
    # (Lack of such support is extremely rare, and such a case would tend to support setf rather than setaf.)
    COLOR_ENABLED=yes
  fi
fi

# General Foreground Colors
BLACK='\e[30m'
BLACK_ESC=$'\e[30m'
RED='\e[31m'
RED_ESC=$'\e[31m'
GREEN='\e[32m'
GREEN_ESC=$'\e[32m'
YELLOW='\e[33m'
YELLOW_ESC=$'\e[33m'
BLUE='\e[34m'
BLUE_ESC=$'\e[34m'
PURPLE='\e[35m'
PURPLE_ESC=$'\e[35m'
CYAN='\e[36m'
CYAN_ESC=$'\e[36m'
WHITE='\e[37m'
WHITE_ESC=$'\e[37m'
GREY='\e[90m'
GREY_ESC=$'\e[90m'

# General Background Colors
BG_BLACK='\e[30;40m'
BG_BLACK_ESC=$'\e[30;40m'
BG_RED='\e[31;41m'
BG_RED_ESC=$'\e[31;41m'
BG_GREEN='\e[32;42m'
BG_GREEN_ESC=$'\e[32;42m'
BG_YELLOW='\e[33;43m'
BG_YELLOW_ESC=$'\e[33;43m'
BG_BLUE='\e[34;44m'
BG_BLUE_ESC=$'\e[34;44m'
BG_PURPLE='\e[35;45m'
BG_PURPLE_ESC=$'\e[35;45m'
BG_CYAN='\e[36;46m'
BG_CYAN_ESC=$'\e[36;46m'
BG_WHITE='\e[37;47m'
BG_WHITE_ESC=$'\e[37;47m'
BG_GREY='\e[100m'
BG_GREY_ESC=$'\e[100m'

# BOLD
BOLD_BLACK='\e[30;1m'
BOLD_BLACK_ESC=$'\e[30;1m'
BOLD_RED='\e[31;1m'
BOLD_RED_ESC=$'\e[31;1m'
BOLD_GREEN='\e[32;1m'
BOLD_GREEN_ESC=$'\e[32;1m'
BOLD_YELLOW='\e[33;1m'
BOLD_YELLOW_ESC=$'\e[33;1m'
BOLD_BLUE='\e[34;1m'
BOLD_BLUE_ESC=$'\e[34;1m'
BOLD_PURPLE='\e[35;1m'
BOLD_PURPLE_ESC=$'\e[35;1m'
BOLD_CYAN='\e[36;1m'
BOLD_CYAN_ESC=$'\e[36;1m'
BOLD_WHITE='\e[37;1m'
BOLD_WHITE_ESC=$'\e[37;1m'
BOLD_GREY='\e[1;90m'
BOLD_GREY_ESC=$'\e[1;90m'

# UNDERLINE
UL_BLACK='\e[30;4m'
UL_BLACK_ESC=$'\e[30;4m'
UL_RED='\e[31;4m'
UL_RED_ESC=$'\e[31;4m'
UL_GREEN='\e[32;4m'
UL_GREEN_ESC=$'\e[32;4m'
UL_YELLOW='\e[33;4m'
UL_YELLOW_ESC=$'\e[33;4m'
UL_BLUE='\e[34;4m'
UL_BLUE_ESC=$'\e[34;4m'
UL_PURPLE='\e[35;4m'
UL_PURPLE_ESC=$'\e[35;4m'
UL_CYAN='\e[36;4m'
UL_CYAN_ESC=$'\e[36;4m'
UL_WHITE='\e[37;4m'
UL_WHITE_ESC=$'\e[37;4m'
UL_GREY='\e[4;90m'
UL_GREY_ESC=$'\e[4;90m'

# BLINK
BLK_BLACK='\e[30;5m'
BLK_BLACK_ESC=$'\e[30;5m'
BLK_RED='\e[31;5m'
BLK_RED_ESC=$'\e[31;5m'
BLK_GREEN='\e[32;5m'
BLK_GREEN_ESC=$'\e[32;5m'
BLK_YELLOW='\e[33;5m'
BLK_YELLOW_ESC=$'\e[33;5m'
BLK_BLUE='\e[34;5m'
BLK_BLUE_ESC=$'\e[34;5m'
BLK_PURPLE='\e[35;5m'
BLK_PURPLE_ESC=$'\e[35;5m'
BLK_CYAN='\e[36;5m'
BLK_CYAN_ESC=$'\e[36;5m'
BLK_WHITE='\e[37;5m'
BLK_WHITE_ESC=$'\e[37;5m'
BLK_GREY='\e[5;90m'
BLK_GREY_ESC=$'\e[5;90m'

# REVERSE
REV_BLACK='\e[30;7m'
REV_BLACK_ESC=$'\e[30;7m'
REV_RED='\e[31;7m'
REV_RED_ESC=$'\e[31;7m'
REV_GREEN='\e[32;7m'
REV_GREEN_ESC=$'\e[32;7m'
REV_YELLOW='\e[33;7m'
REV_YELLOW_ESC=$'\e[33;7m'
REV_BLUE='\e[34;7m'
REV_BLUE_ESC=$'\e[34;7m'
REV_PURPLE='\e[35;7m'
REV_PURPLE_ESC=$'\e[35;7m'
REV_CYAN='\e[36;7m'
REV_CYAN_ESC=$'\e[36;7m'
REV_WHITE='\e[37;7m'
REV_WHITE_ESC=$'\e[37;7m'
REV_GREY='\e[7;90m'
REV_GREY_ESC=$'\e[7;90m'

# BRIGHT
BRI_BLACK='\e[90m'
BRI_BLACK_ESC=$'\e[90m'
BRI_RED='\e[91m'
BRI_RED_ESC=$'\e[91m'
BRI_GREEN='\e[92m'
BRI_GREEN_ESC=$'\e[92m'
BRI_YELLOW='\e[93m'
BRI_YELLOW_ESC=$'\e[93m'
BRI_BLUE='\e[94m'
BRI_BLUE_ESC=$'\e[94m'
BRI_PURPLE='\e[95m'
BRI_PURPLE_ESC=$'\e[95m'
BRI_CYAN='\e[96m'
BRI_CYAN_ESC=$'\e[96m'
BRI_WHITE='\e[97m'
BRI_WHITE_ESC=$'\e[97m'

# BRIGHT & BOLD
BRI_BOLD_BLACK='\e[90;1m'
BRI_BOLD_BLACK_ESC=$'\e[90;1m'
BRI_BOLD_RED='\e[91;1m'
BRI_BOLD_RED_ESC=$'\e[91;1m'
BRI_BOLD_GREEN='\e[92;1m'
BRI_BOLD_GREEN_ESC=$'\e[92;1m'
BRI_BOLD_YELLOW='\e[93;1m'
BRI_BOLD_YELLOW_ESC=$'\e[93;1m'
BRI_BOLD_BLUE='\e[94;1m'
BRI_BOLD_BLUE_ESC=$'\e[94;1m'
BRI_BOLD_PURPLE='\e[95;1m'
BRI_BOLD_PURPLE_ESC=$'\e[95;1m'
BRI_BOLD_CYAN='\e[96;1m'
BRI_BOLD_CYAN_ESC=$'\e[96;1m'
BRI_BOLD_WHITE='\e[97;1m'
BRI_BOLD_WHITE_ESC=$'\e[97;1m'

# RESET
RESET_FG='\e[39m'
RESET_FG_ESC=$'\e[39m'
RESET_BG='\e[49m'
RESET_BG_ESC=$'\e[49m'
RESET_ALL='\e[0m'
RESET_ALL_ESC=$'\e[0m'
