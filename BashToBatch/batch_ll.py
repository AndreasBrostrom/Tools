#!/usr/bin/env python3

import os, sys, time, subprocess
_VERSION_ = 1.0

def main():
    if os.name == 'nt':
        os.system('dir')
    else:
        os.system('ll')

if __name__ == "__main__":
    sys.exit(main())