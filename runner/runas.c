#define _GNU_SOURCE
#include <err.h>
#include <pwd.h>
#include <grp.h>
#include <stdio.h>
#include <unistd.h>


int main(int argc, char **argv) {
  struct passwd *pwd;

  if (argc < 3) {
    printf("Usage: %s user cmd...\n", argv[0]);
    return 2;
  }

  pwd = getpwnam(argv[1]);
  if (!pwd) {
    printf("Could not find user: %s\n", argv[1]);
    return 1;
  }

  if (setgroups(0, NULL) < 0)
    err(1, "setgroups");
  if (setresgid(pwd->pw_gid, pwd->pw_gid, pwd->pw_gid) < 0)
    err(1, "setresgid");
  if (setresuid(pwd->pw_uid, pwd->pw_uid, pwd->pw_uid) < 0)
    err(1, "setresuid");

  execvp(argv[2], argv+2);
  err(1, "execvp");

}
