#!/usr/bin/env python3

import os, sys, glob, subprocess
import winreg

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

def checkModFolder(workshopFolder,modPrefix):
    if (os.path.exists('{}\\{}'.format(workshopFolder,modPrefix)) == True):
        modPrefix = '{}'.format(modPrefix)
        return modPrefix
    elif(os.path.exists('{}\\@{}'.format(workshopFolder,modPrefix)) == True):
        modPrefix = '@{}'.format(modPrefix)
        return modPrefix
    else:
        sys.exit('No mod named "{}" is discoverd.'.format(modPrefix))

def unpack(modPrefix,workshopAddonFolder,outputFolder,toolPath):
    print('Starting unpacking of {}...'.format(modPrefix))

    # remove @ if itexist to unpacking folder
    if "@" in modPrefix:
        unpackModPrefix = modPrefix[1:]
    else:
        unpackModPrefix = modPrefix
    unpackModPrefix = unpackModPrefix.lower()

    for PBO in glob.glob("*.pbo"):
        pathToPBO = "{}\\{}".format(workshopAddonFolder,PBO)
        unpackModFolder = "{}".format(outputFolder)

        print('Unpacking {} to {}'.format(PBO,unpackModFolder))
        subprocess.run('"{}\\bin\\ExtractPboDos.exe" -P -D -N "{}" "{}"'.format(toolPath,pathToPBO,unpackModFolder), shell=True)

        #print("derapifying {}'s config...".format(PBO[:-4]))
        #subprocess.run('"{0}\\bin\\DeRapDos.exe" -p "{1}\\config.bin" to "{1}\\config.cpp"'.format(toolPath,unpackModFolder), shell=True)


def main():
    # Get script path

    PARAMS = sys.argv

    #check arguments
    if len(PARAMS) < 2:
        sys.exit('Missing argument: <PREFIX>')
    if len(PARAMS) > 2:
        sys.exit('Only support 1 argument: <PREFIX>')


    scriptPath = os.path.realpath(__file__)
    projectPath = os.path.dirname(scriptPath)
    linking = get_program_path_HKLM('Arma 3','Software\\wow6432Node\\bohemia interactive\\arma 3')
    toolPath = get_program_path_HKCU('Mikero Tool','Software\Mikero\pboProject')
    toolPath = '{}'.format(toolPath)

    workshopFolder = '{}\\!Workshop'.format(linking)
    outputFolder = projectPath

    modPrefix = PARAMS[1]
    modPrefix = checkModFolder(workshopFolder,modPrefix)

    # Setting workshop addon folder as root
    workshopAddonFolder = '{0}\\{1}\\addons'.format(workshopFolder,modPrefix)
    os.chdir(workshopAddonFolder)

    unpack(modPrefix,workshopAddonFolder,outputFolder,toolPath)

    print('Done')

if __name__ == "__main__":
    sys.exit(main())
