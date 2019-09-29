#!/usr/bin/env python3
import os, sys
import winreg


def setup_PDrive(tool_path,pdrive=''):
    if not os.path.exists('P:'):
        os.system('start /d "{}" WorkDrive.exe /Mount {}'.format(tool_path,pdrive))
        print('Setting up workdrive path.'.format())
    else:
        print('P drive already exists skipping the creation.'.format())
        

def create_mount_unmount(tool_path,pdrive=''):
    print('Creating quick mount and unmount shortcuts.')
    os.system('echo start /d "{}" WorkDrive.exe /Mount {} > PDrive_mount.cmd'.format(tool_path,pdrive))
    os.system('echo start /d "{}" WorkDrive.exe /Dismount > PDrive_umount.cmd'.format(tool_path,pdrive))


def request_action(text='Continue?'):
    Continue_Count = 0
    while(True):
        yes_no = input('{} (Yes or No)\n> '.format(text))
        yes_no = yes_no.lower()
        if (yes_no == 'yes' or yes_no == 'y'):
            return True
        elif (yes_no == 'no' or yes_no == 'n'):
            return False
        else:
            pass
        Continue_Count += 1
        if Continue_Count >= 3:
            sys.exit()


def get_program_path_HKCU(lable='Program', regKey='', key='path'):
    print('Checking for {}...'.format(lable))
    try:
        registry = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        keypath = winreg.OpenKey(registry, regKey)
    except:
        sys.exit('{} is not installed.'.format(lable))
    try:
        path = winreg.QueryValueEx(keypath, key)
        print('{} found...'.format(lable))
        return path[0]
    except:
        sys.exit('Some thing whent wrong when looking for {}'.format(key))


def get_program_path_HKLM(lable='Program', regKey='', key='main'):
    print('Checking for {}.'.format(lable))
    try:
        registry = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        keypath = winreg.OpenKey(registry, regKey)
    except:
        sys.exit('{} is not installed.'.format(lable))
    try:
        path = winreg.QueryValueEx(keypath, key)
        print('{} found...'.format(lable))
        return path[0]
    except:
        sys.exit('Some thing whent wrong when looking for {}'.format(key))


def main():
    # Get script path
    scriptPath = os.path.realpath(__file__)
    projectPath = os.path.dirname(scriptPath)

    linking = get_program_path_HKCU('Arma 3 Tool - Workdrive','Software\\Bohemia Interactive\\workdrive')
    check = request_action('Is "{}" were you whant to set up your arma 3 P drive?'.format(projectPath))
    if check:
        setup_PDrive(linking,projectPath)
        create_mount_unmount(linking,projectPath)
    else:
        custom_path = input('Type out full path: ')
        setup_PDrive(linking,custom_path)
        create_mount_unmount(linking,custom_path)

    os.chdir(projectPath)

    linking = get_program_path_HKLM('Arma 3','Software\\wow6432Node\\bohemia interactive\\arma 3')
    os.system('mklink /J "! ROOT" "{}"'.format(linking))
    if not os.path.exists('{}/!Workshop'.format(linking)):
        os.system('mklink /J "! Workshop" "{}/!Workshop"'.format(linking))

    linking = get_program_path_HKCU('Arma 3 Tool','Software\\Bohemia Interactive\\arma 3 tools')
    os.system('mklink /J "! Arma 3 Tools" "{}"'.format(linking))

    linking = get_program_path_HKCU('Mikero Tool','Software\Mikero\pboProject')
    os.system('mklink /J "! Workshop" "{}\\!Workshop"'.format(linking))
    os.system('mklink "Unpack_A3" "{}/bin/Arma3P.cmd"'.format(linking))

    # Get AppData
    appdata_path = '%userprofile%\\appdata\\local\\Arma 3\\'
    if not os.path.exists(appdata_path):
        os.system('mklink /J "! AppData" "{}"'.format(appdata_path))
    else:
        pass


if __name__ == "__main__":
    sys.exit(main())
