#!/usr/bin/env python3
import sys, subprocess
__version__ = 1.0

def getLocation(path='',data=''):
    reg = subprocess.check_output(['REG.exe QUERY "{}" /f {}'.format(path,data)],
        stderr=subprocess.STDOUT,
        shell=True)
    reg = str(reg)
    reg = reg[:-1]
    reg = reg[2:]
    reg = reg.replace('\\r','\n')
    reg = reg.replace('\\n','')
    reg = reg.replace('\\\\','/')
    reg = reg.replace('    ','\n')
    reg = reg.split('\n')
    if reg[7] == 'End of search: 1 match(es) found.':
        path = reg[5]
        path = path[3:]
        path = '/mnt/c/{}'.format(path)
        return path
    else:
        return sys.exit('error with path')

def main():
    if not os.name == 'nt':
        x = getLocation('HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders','Desktop')
        subprocess.run('ln -s {} ~/Desktop'.format(x))
        x = getLocation('HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders','{374DE290-123F-4565-9164-39C4925E467B}')
        subprocess.run('ln -s {} ~/Download'.format(x))
        x = getLocation('HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders','Personal')
        subprocess.run('ln -s {} ~/Personal'.format(x))
        x = getLocation('HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders','AppData')
        subprocess.run('ln -s {} ~/AppData'.format(x))
    else:
        sys.exit('Your not running a linux subsystem on a windows computer')
if __name__ == "__main__":
    sys.exit(main())
