# whatis.sh #

## Short Description ##

whatis.sh is a wrapper for the whatis command which integrates information on bash's buildin commands by calling bash's help and by generating a whatis like output of all program descriptions.

## Prerequisites ##

**The program "column" is needed. If not present on your system, please install it!**

## Output Comparsion ##

### standard whatis ###
```bash
BStLinux@linux-sys: ~ $ whatis ls set schlumpf export grumpf%@X^z
ls (1)               - list directory contents
LS (6)               - display animations aimed to correct users who accident...
set (3tcl)           - Read and write variables
schlumpf: nothing appropriate.
export: nothing appropriate.
grumpf%@X^z: nothing appropriate.
BStLinux@linux-sys: ~ $ 
```

### whatis.sh ###
**Attention:** "whats" was defined as alias for "whatis.sh".

```bash
BStLinux@linux-sys: ~ $ whats ls set schlumpf export grumpf%@X^z
ls (1)                 - list directory contents
LS (6)                 - display animations aimed to correct users who acciden...
set (3tcl)             - Read and write variables
set (buildin)          - Set or unset values of shell options and positional parameters.
export (buildin)       - Set export attribute for shell variables.
schlumpf (unknown)     - Command not found / Kein passendes Kommando gefunden
grumpf%@X^z (unknown)  - Command not found / Kein passendes Kommando gefunden
BStLinux@linux-sys: ~ $
```

## Further Features ##

The script gives the `-s` parameter at whatis, but this parameter has to be written as the first parameter and his values have to follow the `-s` without any blank.

| Wrong               | Correct            |
| ------------------- | ------------------ |
| `whatis.sh -s 1 ls` | `whatis.sh -s1 ls` |

**Attention:** "whats" was defined as alias for "whatis.sh".

```bash
BStLinux@linux-sys: ~ $ whats -s1,8 cd exit ls useradd
cd (buildin)    - Change the shell working directory.
exit (buildin)  - Exit the shell.
ls (1)          - list directory contents
useradd (8)     - create a new user or update default new user information
BStLinux@linux-sys: ~ $ 
```

'whatis.sh' tries to remove wrong section numbers, it will delete too great numbers in the parameter `-s` and tries to pass only allowed values to standard whatis.  

