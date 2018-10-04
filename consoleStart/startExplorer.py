#!/usr/bin/env python3

import os, sys, time, subprocess
_VERSION_ = 1.1

def main():
    if os.name == 'nt':
        os.system('start .')
    else:
        subprocess.Popen(['/mnt/c/Windows/System32/cmd.exe', '/C', 'start .'])
        
if __name__ == "__main__":
    sys.exit(main())