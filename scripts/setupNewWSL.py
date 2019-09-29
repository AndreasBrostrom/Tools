#!/usr/bin/env python3
import os, sys, subprocess
__version__ = 1.0

def get_location(path='',data=''):
    if not path:
        sys.exit('create_symplink: missing param: path')
    if not data:
        sys.exit('create_symplink: missing param: data')

    reg = subprocess.check_output(['REG.exe QUERY "{}" /f "{}"'.format(path,data)],
        stderr=subprocess.STDOUT,
        shell=True)
    if len(reg) >= 10:
        reg = str(reg)
        reg = reg[:-1]
        reg = reg[2:]
        reg = reg.replace('\\r','\n')
        reg = reg.replace('\\n','')
        reg = reg.replace('\\\\','/')
        reg = reg.replace('    ','\n')
        reg = reg.split('\n')

        new_path = reg[5]
        new_path = new_path[3:]
        new_path = '/mnt/c/{}'.format(new_path)

    if "End of search: 1 match(es) found." in reg[7]:
        new_path = new_path
    else:
        new_path = path

    return new_path



def create_symplink(path='', name=''):
    if not path:
        sys.exit('create_symplink: missing param: path')
    if not name:
        sys.exit('create_symplink: missing param: name')

    if not os.path.isdir('{}/{}'.format(os.path.expanduser('~'), name)):
        subprocess.call('ln -s {} ~/{}'.format(path,name),
        stderr=subprocess.STDOUT,
        shell=True)
        return print('Symplink for {} have been linked to your windows users corresponding directory.'.format(name))
    else:
        return print('Symplink for {} already exist.'.format(name))
    
    

def main():
    print('Prepering to set up symplinks...')

    if not os.name == 'nt':
        path = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
        regestry = 'Desktop'
        create_symplink(get_location(path,regestry),regestry)
        regestry = 'Download'
        create_symplink(get_location(path,regestry),'Downloads')
        regestry = 'Personal'
        create_symplink(get_location(path,regestry),'Documents')
        regestry = 'My Music'
        create_symplink(get_location(path,regestry),'Music')
        regestry = 'My Video'
        create_symplink(get_location(path,regestry),'Videos')
        regestry = 'My Pictures'
        create_symplink(get_location(path,regestry),'Pictures')
    else:
        sys.exit('Your not running a linux subsystem on a windows computer')

    print('Script completed, happy browsing!')

if __name__ == "__main__":
    sys.exit(main())
