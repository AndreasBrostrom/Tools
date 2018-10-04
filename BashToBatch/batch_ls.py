#!/usr/bin/env python3

import os, sys, time, subprocess
_VERSION_ = 1.0

def main():
    if os.name == 'nt':
        os.system('dir /D')
    else:
        os.system('ls')

if __name__ == "__main__":
    sys.exit(main())