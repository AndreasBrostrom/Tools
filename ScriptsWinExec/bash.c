#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char command[] = "C:/Windows/system32/wsl.exe --distribution Arch --exec bash ";

int main(int argc, char *argv[]) {
  int cmdlen = sizeof(command)+1; // Length of string with null
  for (int i = 1; i < argc; i++) {
    cmdlen += strlen(argv[i])+3;
  };

  char *cmd = malloc(cmdlen);
  strcpy(cmd, command); // add ls to start of cmd

  for (int i = 1; i < argc; i++) {
    strcat(cmd, "'"); // string (" ") and null byte at end due to " "
    strcat(cmd, argv[i]);
    strcat(cmd, "' "); // string (" ") and null byte at end due to " "
  };
  
  return system(cmd) >> 8;
}
