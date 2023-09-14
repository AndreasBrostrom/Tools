#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  if (argc > 1) {
    int cmdlen = 62;
    for (int i = 1; i < argc; i++) {
      cmdlen += strlen(argv[0])+1;
    };

    char *cmd = malloc(sizeof(char)*cmdlen);
    strcpy(cmd, "C:/Windows/system32/wsl.exe --distribution Arch --exec bash "); // add ls to start of cmd

    int charcount = 60;
    for (int i = 1; i < argc; i++) {
      strcpy(cmd+charcount, argv[i]);
      charcount += strlen(argv[i])+1;
      cmd[charcount-1] = ' ';
    };
    system(cmd);
  } else {
    system("C:/Windows/system32/wsl.exe --distribution Arch --exec bash");
  }
  return 0;
}