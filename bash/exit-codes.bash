# shellcheck disable=2034

# Exit statuses fall between 0 and 255
# https://www.gnu.org/software/bash/manual/bash.html#Exit-Status
# https://man.freebsd.org/cgi/man.cgi?sysexits(3)
# When a command terminates on a fatal signal whose number is N, Bash uses the value 128+N as the exit status.
# All builtins return an exit status of 2 to indicate incorrect usage, generally invalid options or missing arguments.

# Successful
readonly ONE_EX_OK=0

# The command was used incorrectly, e.g. with the wrong number of arguments, a bad flag, a bad syntax in a parameter, or whatever.
readonly ONE_EX_USAGE=64

# The input data was incorrect in some way. This should only be used for user's data and not system files.
readonly ONE_EX_DATAERR=65

# An input file (not a system file) did not exist or was not readable. This could also include errors like "No message" to a mailer (if it cared to catch it).
readonly ONE_EX_NOINPUT=66

# The user specified did not exist. This might be used for mail addresses or remote logins.
readonly ONE_EX_NOUSER=67

# The host specified did not exist. This is used in mail addresses or network requests.
readonly ONE_EX_NOHOST=68

# A service is unavailable. This can occur if a sup- port program or file does not exist. This can also be used as a catchall message when something you wanted to do does not work, but you do not know why.
readonly ONE_EX_UNAVAILABLE=69

# An internal software error has been detected. This should be limited to non-operating system related errors as possible.
readonly ONE_EX_SOFTWARE=70

# An operating system error has been detected. This is intended to be used for such things as "cannot fork", "cannot create pipe", or the like. It in- cludes things like getuid returning a user that does not exist in the passwd file.
readonly ONE_EX_OSERR=71

# Some system file (e.g., /etc/passwd, /var/run/utx.active, etc.) does not exist, cannot be opened, or has some sort of error (e.g., syntax error).
readonly ONE_EX_OSFILE=72

# A (user specified) output file cannot be created.
readonly ONE_EX_CANTCREAT=73

# An error occurred while doing I/O on some file.
readonly ONE_EX_IOERR=74

# Temporary failure, indicating something that is not really an error. In sendmail, this means that a mailer (e.g.) could not create a connection, and the request should be reattempted later.
readonly ONE_EX_TEMPFAIL=75

# The remote system returned something that was "not possible" during a protocol exchange.
readonly ONE_EX_PROTOCOL=76

# You did not have sufficient permission to perform the operation. This is not intended for file sys- tem problems, which should use EX_NOINPUT or EX_CANTCREAT, but rather for higher level permis- sions.
readonly ONE_EX_NOPERM=77

# Something was found in an unconfigured or miscon- figured state.
readonly ONE_EX_CONFIG=78
