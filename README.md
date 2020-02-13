# Buildscript

This is a simple harness for building/running code used to grade lots of student
submissions. Don't worry, all compilation + running are all sandboxed with least
privileges ;)

Also if a user decides to make an "dangerous" syscall, the seccomp rules will
quickly boot out the program and this will be logged. (This helps audit for any
"hackers").

## Directory structure
Due to sensitivity of data here, many of the subdirectories are ignored out, but
here is an explanation of what the missing files should be. To make it clear, we
represent various assignment subdirectories as "assign", and NetID
subdirectories as "abc123456". 

```
input/ - contains inputs fed into the run portion
  assign/
    case1
    case2
    ...
netids - should be a list of all NetIDs (i.e. individual user IDs), line separated.
notes/ - just my own notes ;)
output/ - contains all the outputs of build + run actions
  assign/
    abc123456/
      case1.err
      case1.out 
      case2.err
      case2.out - stderr and stdout of all the run cases 
      ...
      compile_log - the logfile when compiling
      input - symlink to the input directory of this assignment
      prog - the built program binary
      src - symlink to the source (i.e. submission files)
submits/ - contains all the raw submissions (downloaded from elearning/bb)
  assign/
    abc123456/
      ...
```
