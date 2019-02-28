#!/usr/bin/env python3
import os, sys
import winreg


def setupPDrive(TOOL_LOCATION,LOCATION_TO_P=''):
    if not os.path.exists('P:'):
        os.system('start /d "{}" WorkDrive.exe /Mount {}'.format(TOOL_LOCATION,LOCATION_TO_P))
    else:
        os.chdir("P:")


def main():
    # Get script path
    scriptPath = os.path.realpath(__file__)
    projectPath = os.path.dirname(scriptPath)
    
    # Get ARMA TOOLS; workdrive
    try:
        workdrive_reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        workdrive_key = winreg.OpenKey(workdrive_reg, 'Software\\Bohemia Interactive\\workdrive')
    except:
        sys.exit('Arma 3 Tool is not installed.')
    try:
        workdrive_val = winreg.QueryValueEx(workdrive_key, 'path')
    except:
        sys.exit('Arma 3 Tool is not installed.')
    workdrive_path = workdrive_val[0]

    # Check and set up P_DRIVE if it does not exist
    setupPDrive(workdrive_path,projectPath)

    os.chdir(projectPath)

    # Get Arma3 ROOT
    try:
        arma_reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        arma_key = winreg.OpenKey(arma_reg, 'Software\\wow6432Node\\bohemia interactive\\arma 3')
    except:
        sys.exit('Arma 3 is not installed.')
    try:
        arma_val = winreg.QueryValueEx(arma_key, 'main')
    except:
        sys.exit('Arma 3 is not installed.')
    arma_path = arma_val[0]
    os.system('mklink /J "! ROOT" "{}"'.format(arma_path))


    # Check if !Workshop exist in Arma Root
    if not os.path.exists('{}\\!Workshop'.format(arma_path)):
        os.system('mklink /J "Workshop" "{}\\!Workshop"'.format(arma_path))
    else:
        pass



    # Get TOOLS
    try:
        tool_reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        tool_key = winreg.OpenKey(tool_reg, 'Software\\Bohemia Interactive\\arma 3 tools')
    except:
        sys.exit('Arma 3 Tool is not installed.')
    try:
        tool_val = winreg.QueryValueEx(tool_key, 'path')
    except:
        sys.exit('Arma 3 Tool is not installed.')
    tool_path = tool_val[0]
    os.system('mklink /J "! Tools" "{}"'.format(tool_path))



    # Get TOOLS Mikero
    try:
        mikero_reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        mikero_key = winreg.OpenKey(mikero_reg, 'Software\Mikero\pboProject')
    except:
        print('Mikero Tool is not installed. Download it from here: https://mikero.bytex.digital/Downloads')
    try:
        mikero_val = winreg.QueryValueEx(mikero_key, 'path')
        mikero_path = mikero_val[0]
        os.system('mklink /J "! Mikero Tools" "{}"'.format(mikero_path))
    except:
        pass



    # Get AppData
    appdata_path = '%userprofile%\\appdata\\local\\Arma 3\\'
    if not os.path.exists(appdata_path):
        os.system('mklink /J "! AppData" "{}"'.format(appdata_path))
    else:
        pass



    # get Arma 3 profiles
    # profile = "Dokument\\Arma"
    # other_profile = "Dokument\\Arma 3 - Other Profiles"

    # if os.path.exists(profile):
    #     print('exist!')
    # else:
    #     print('dont exist!')

    # if os.path.exists(other_profile):
    #     print('exist!')
    # else:
    #     print('dont exist!')

    # other_profiles = os.listdir(other_profile)
    # print(other_profiles)

    # select valid


if __name__ == "__main__":
    sys.exit(main())
