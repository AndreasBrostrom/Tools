#!/usr/bin/env python3

import os, sys, time
import argparse, shutil
import ctypes, getpass

_VERSION_ = 1.2

BLACKLIST = ['desktop.ini','Steam.lnk','Misc']

def getDownload():
    if os.name == 'nt':
        import winreg
        sub_key = r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
        downloads_guid = '{374DE290-123F-4565-9164-39C4925E467B}'
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, sub_key) as key:
            location = winreg.QueryValueEx(key, downloads_guid)[0]
        return location
    else:
        return os.path.join(os.path.expanduser('~'), 'downloads')

def cleanDownload():
    clearCount = 0
    failCount = 0
    folderPath = getDownload()
    folderFiles = os.listdir(folderPath)
    for f in folderFiles:
        filePath = '' if os.name == 'nt' '{}\\{}'.format(folderPath,f) else '{}/{}'.format(folderPath,f)
        if not f in BLACKLIST:
            try:
                os.remove(filePath)
                clearCount += 1
            except:
                shutil.rmtree(filePath)
                clearCount += 1
    return print('{} files in \'{}\' have been removed.'.format(clearCount, folderPath))



def getDesktop():
    if os.name == 'nt':
        import winreg
        sub_key = r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
        downloads_guid = 'Desktop'
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, sub_key) as key:
            location = winreg.QueryValueEx(key, downloads_guid)[0]
        return location
    else:
        return os.path.join(os.path.expanduser('~'), 'desktop')

def cleanDesktop():
    clearCount = 0
    failCount = 0
    folderPath = getDesktop()
    folderFiles = os.listdir(folderPath)

    if os.name == 'nt':
        miscFolder = '{}\\Misc'.format(folderPath)
    else:
        miscFolder = '{}/Misc'.format(folderPath)

    try:
        os.stat(miscFolder)
    except:
        os.mkdir(miscFolder)
        ctypes.windll.kernel32.SetFileAttributesW(miscFolder, 2)

    date = time.strftime('%Y-%m-%d')
    if os.name == 'nt':
        miscFolderArchive = miscFolder + '\\{}'.format(date)
    else:
        miscFolderArchive = miscFolder + '/{}'.format(date)

    try:
        os.stat(miscFolderArchive)
    except:
        os.mkdir(miscFolderArchive)
        ctypes.windll.kernel32.SetFileAttributesW(miscFolder, 2)

    for f in folderFiles:
        filePath = '' if os.name == 'nt' '{}\\{}'.format(folderPath,f) else '{}/{}'.format(folderPath,f)
        if not f in BLACKLIST:
            try:
                if os.name == 'nt':
                    shutil.move('{}\\{}'.format(folderPath,f), '{}\\{}'.format(miscFolderArchive,f))
                else:
                    shutil.move('{}/{}'.format(folderPath,f), '{}/{}'.format(miscFolderArchive,f))
                clearCount += 1
            except:
                failCount += 1
    return print('{} objects in \'{}\' have been archived and moved to \'{}\' and {} could not be moved.'.format(clearCount, folderPath, miscFolderArchive, failCount))

def getTemp():
    location = []
    if os.name == 'nt':
        location.append(os.path.join(os.path.expanduser('~\\AppData\\Local\\Temp')))
        location.append(os.path.join(os.path.dirname('C:\\Windows\\Temp\\')))
        if os.path.ismount('D:/..') and os.path.isdir('D:\\Temp'):
            location.append(os.path.join(os.path.dirname('D:\\Temp\\')))
    else:
        location.append(os.path.join(os.path.dirname('/mnt/c/Users/{}/AppData/Local/Temp/'.format(getpass.getuser()))))
        location.append(os.path.join(os.path.dirname('/mnt/c/Windows/Temp/')))
        if os.path.ismount('/mnt/d/') and os.path.isdir('/mnt/d/Temp'):
            location.append(os.path.join(os.path.dirname('/mnt/d/Temp/')))
    return location

def cleanTemp():
    clearTot = 0
    failTot = 0
    folderPaths = getTemp()
    for folderPath in folderPaths:
        clearCount = 0
        failCount = 0
        folderFiles = os.listdir(folderPath)
        for f in folderFiles:
            filePath = '' if os.name == 'nt' '{}\\{}'.format(folderPath,f) else '{}/{}'.format(folderPath,f)
            if not f in BLACKLIST:
                try:
                    os.remove(f)
                    clearCount += 1 
                except FileNotFoundError:
                    failCount += 1
                except PermissionError:
                    failCount += 1
                except:
                    shutil.rmtree(f)
                    clearCount += 1 

                try:        
                    shutil.rmtree(filePath)
                    clearCount += 1 
                except:
                    failCount += 1
        clearTot += clearCount
        failTot += failCount
        print('{} files and directories in \'{}\' have been removed and {} could not be moved.'.format(clearCount, folderPath, failCount))
    return print('a total of {} temp files and directories have been removed and {} could not be removed.'.format(clearTot, failTot))



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-all', '--all', help='cleaned the download folder', action="store_true")
    parser.add_argument('-d', '--download', help='cleaned the download folder', action="store_true")
    parser.add_argument('-i', '--desktop', help='archive all desktop objects', action="store_true")
    parser.add_argument('-t', '--temp', help='cleaned the temp folder', action="store_true")
    parser.add_argument('-v', '--version', action='version', version='Cleanup script version {}'.format(_VERSION_))

    args = parser.parse_args()


    ALL = args.all
    DESKTOP = args.desktop
    DOWNLOAD = args.download
    TEMP = args.temp

    if DESKTOP or ALL:
        folderPath = getDesktop()
        folderFiles = os.listdir(folderPath)
        if len(folderFiles) <= len(BLACKLIST):
            print('Your desktop is already clean', end='')
            if ALL:
                print(', moving on...')
            else:
                print('.')
        else:
            cleanDesktop()

    if DOWNLOAD or ALL:
        cleanDownload()

    if TEMP or ALL:
        cleanTemp()

    if not DESKTOP and not DOWNLOAD and not TEMP and not ALL:
        parser.print_help()


if __name__ == "__main__":
    sys.exit(main())