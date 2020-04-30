#!/usr/bin/env python3
import os, sys, subprocess, re, pathlib 

def get_location(path='',data=''):
    sys.exit('get_location: missing param: path') if not path else ''
    sys.exit('get_location: missing param: data') if not data else ''

    # checking windows regestry
    reg = (subprocess.check_output(
        ['REG.exe QUERY "{}" /f "{}" /t REG_SZ'.format(path,data)],
        stderr=subprocess.STDOUT,
        shell=True)).decode('utf-8')
    
    for key in reg.split('\n'):
        if 'REG_SZ' in key:
            reg = key
            reg = re.sub(r'^(.*REG_SZ)|\s+', '', reg)
            reg = re.sub(r'\\', '/', reg)
            drive = reg[0].lower()
            path = re.sub(r'.*:/', '/mnt/{}/'.format(drive), reg)
            break
    return path



def create_symplink(path='', name=''):
    sys.exit('create_symplink: missing param: path') if not path else ''
    sys.exit('create_symplink: missing param: name') if not name else ''
    fullHomePath = os.path.join(pathlib.Path.home(), name)

    try:
        os.symlink(path, fullHomePath, True)
        return print('Symplink for {} have been linked to your windows users corresponding directory.'.format(name))
    except:
        return print('Symplink for {} already exist.'.format(name))



def main():
    sys.exit('Your not running a linux subsystem on a windows computer') if os.name == 'nt' else print('Prepering to set up symplinks...')
 
    # Get Home linked
    winUserName = subprocess.run(['whoami.exe'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    winUserName = re.sub(r'^(.*\\)|(\r)|(\n)', '', winUserName)
    winHome = os.path.join(os.sep, 'mnt', 'c', 'Users', winUserName)
    create_symplink(winHome, 'Home')
       
    # Link Home directories
    regPath = 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders'
    regestry = 'Desktop'
    create_symplink(get_location(regPath,regestry), regestry)
    regestry = 'Download'
    create_symplink(get_location(regPath,regestry), 'Downloads')
    regestry = 'Personal'
    create_symplink(get_location(regPath,regestry), 'Documents')
    regestry = 'My Music'
    create_symplink(get_location(regPath,regestry), 'Music')
    regestry = 'My Video'
    create_symplink(get_location(regPath,regestry), 'Videos')
    regestry = 'My Pictures'
    create_symplink(get_location(regPath,regestry), 'Pictures')

if __name__ == "__main__":
    sys.exit(main())
