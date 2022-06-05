#!/usr/bin/env python3

import sys
import os
import argparse
import configparser
import subprocess
from pathlib import Path
import winreg
import glob
import multiprocessing
import time
import shutil
__version__ = 2.5

configPath = os.path.join(str(Path.home()), '.config','armadev')
configFilePath = os.path.join(configPath, 'config')

# default values
defaultArmaPProjectPath = os.path.join(str(Path.home()), 'Documents', 'Arma 3 Projects')

def process_exists(process_name):
    call = 'TASKLIST', '/FI', 'imagename eq %s' % process_name
    # use buildin check_output right away
    output = subprocess.check_output(call).decode()
    # check in last line for process name
    last_line = output.strip().split('\r\n')[-1]
    # because Fail message could be translated
    return last_line.lower().startswith(process_name.lower())

# Helper functions
def mount_status():
    if not os.path.exists('P:'):
        return "No"
    return "Yes"

def confirm(message='confirm?'):
    for x in range(0,3):
        confirm = input('{} (Yes/No): '.format(message))
        confirm = confirm.lower()
        if confirm in ['y', 'yes']:
            return True
        if confirm in ['n', 'no']:
            return False
        print('Please type yes or no')
    else:
        return False

def printExit(msg='', exitCode=1):
    print(msg)
    sys.exit(exitCode)


def get_key_HKCU(regKey='', key='path'):
    try:
        registry = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        keypath = winreg.OpenKey(registry, regKey)
    except:
        pass
    try:
        path = winreg.QueryValueEx(keypath, key)
        return path[0]
    except:
        pass

def get_key_HKLM(regKey='', key='main'):
    try:
        registry = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        keypath = winreg.OpenKey(registry, regKey)
    except:
        pass
    try:
        path = winreg.QueryValueEx(keypath, key)
        return path[0]
    except:
        pass

def handle_config():
    config = configparser.ConfigParser()
    if not os.path.exists(configFilePath):
        if not os.path.exists(configPath):
            os.makedirs(configPath)    
        config['Paths'] = {'pdrive': defaultArmaPProjectPath}
        with open(configFilePath, 'w') as configfile:
            config.write(configfile)
    return config

config = handle_config()
config.read(configFilePath)
ppath = config.get('Paths','pdrive', fallback=defaultArmaPProjectPath)

Arma3InstallFolder  = get_key_HKLM(os.path.join('Software','wow6432Node','bohemia interactive','arma 3'))
Arma3WorkshopFolder = os.path.join(Arma3InstallFolder, '!Workshop')
Arma3AppdataFolder  = os.path.join(os.getenv('LOCALAPPDATA'), 'Arma 3')
MikeroToolFolder    = get_key_HKCU(os.path.join('Software','Mikero','pboProject'))
Arma3ToolsFolder    = get_key_HKCU(os.path.join('Software','Bohemia Interactive','Arma 3 Tools'))
Arma3SampleFolder   = get_key_HKCU(os.path.join('Software','Bohemia Interactive','Arma 3 Tools'), 'path_assetSamples')

# RPT Program
def prog_rpt (args, parser):
    rptlogfiles = glob.glob(os.path.join(Arma3AppdataFolder, '*.rpt'))

    def printLogHighlight(text):
        if args.highlight:
            if 'error' in text.lower():
                return print('{}{}{}'.format('\033[91m', text, '\033[0m'), end='')
            if 'not found' in text.lower():
                return print('{}{}{}'.format('\033[31m', text, '\033[0m'), end='')
            elif 'warning' in text.lower():
                return print('{}{}{}'.format('\033[93m', text, '\033[0m'), end='')
            elif 'info' in text.lower():
                return print('{}{}{}'.format('\033[94m', text, '\033[0m'), end='')
            elif 'debug' in text.lower():
                return print('{}{}{}'.format('\033[37m', text, '\033[0m'), end='')
            else:
                return print('{}{}{}'.format('\033[90m', text, '\033[0m'), end='')
        else:
            return print(text, end='')

    def prog_rpt_watch(arg):
        arg = '' if arg == None else arg
        try:
            latestLogfine = max(rptlogfiles, key=os.path.getctime)
            logFile = open(latestLogfine, 'r')
        except ValueError:
            print("No logs avalible.")
            sys.exit(1)

        os.system("title armadev rpt")

        try:
            armaRunning = process_exists("arma3_x64.exe") or process_exists("arma3.exe")
            if armaRunning:
                print('Starting monitoring of latest RPT log file', os.path.basename(latestLogfine))
            else:
                print('Showing latest RPT log file', os.path.basename(latestLogfine))
        except:
            armaRunning = True
            print('WARN: Not possible to determin if Arma 3 is running...')
            print('Starting monitoring of latest RPT log file', os.path.basename(latestLogfine))

        if arg:
            os.system("title armadev rpt \"{}\"".format(arg))
            print('Filter: {}'.format(arg)) 
        try:
            while True:
                where = logFile.tell()
                line = logFile.readline()
                if not line:
                    time.sleep(0.25)
                    logFile.seek(where)
                    if not armaRunning:
                        sys.exit(0)
                else:
                    if arg:
                        if arg in line:
                            printLogHighlight(line)
                    else:
                            printLogHighlight(line)
        except KeyboardInterrupt:
            sys.exit(0)

    def prog_rpt_list():
        if len(rptlogfiles) <= 1:
            print("No logs avalible.")
            sys.exit(1)

        print("Avalible logs")
        for f in rptlogfiles:
            print(' ', os.path.basename(f))
        sys.exit(0)

    def prog_rpt_clear():
        for f in rptlogfiles:
            try:
                os.remove(f)
            except:
                print (os.path.basename(f), "seams to be in use.")
        print("Logs have been removed")
        sys.exit(0)

    if args.watch or args.watch == None:
        prog_rpt_watch(args.watch)
        
    if args.list:
        prog_rpt_list()

    if args.clear:
        prog_rpt_clear()

    # if nothing
    parser.parse_args(['rpt', '--help'])
    sys.exit(1)

# P Program
def prog_p (args, parser):
    try:
        mountTool = os.path.join(Arma3ToolsFolder, 'WorkDrive', 'WorkDrive.exe')
    except:
        print('ERROR: Not possible to find WorkDrive.exe. Is ARMA 3 Tools installed and have you preformed first time setup?')
        return sys.exit(1)

    def prog_p_set(arg):
        if not os.path.exists(arg):
            print('Path "{}" does not exist...'.format(arg))
            sys.exit(1)
        if ppath == arg:
            print('Your P drive is already set to "{}"'.format(arg))
            sys.exit(1)
        setNewPath = confirm('Do you want to change path from "{}" to "{}"'.format(ppath, arg))
        if setNewPath:
            config.set('Paths', 'pdrive', args.set)
            with open(configFilePath, 'w') as configfile:
                config.write(configfile)
        else: 
            sys.exit(1)
        sys.exit(0)

    def prog_p_mount():
        if not os.path.exists('P:'):
            print('Mounting {}'.format(ppath))
            subprocess.call('"{}" /Mount P "{}"'.format(Path(mountTool), Path(ppath)), shell=True)
        else: 
            print('P-Drive already mounted')
        sys.exit(0)

    def prog_p_umount():
        if os.path.exists('P:'):
            print('Unmounting P-Drive')
            subprocess.call('"{}" /Dismount'.format(mountTool), shell=True)
        else: 
            print('P-Drive not mounted')
        sys.exit(0)


    if args.mount:
        prog_p_mount()

    if args.umount:
        prog_p_umount()

    if args.set:
        prog_p_set(args.set)

    if args.open:
        if os.path.exists('P:'):
            subprocess.Popen('explorer P:', shell=True)
        else: 
            subprocess.Popen('explorer {}'.format(ppath), shell=True)

    # if nothing
    parser.parse_args(['p', '--help'])
    sys.exit(1)

# Addon Program
def prog_addon (args, parser):

    def prog_addon_unpack(modName, workshopModPath):
        print('Unpacking {} mod...'.format(modName))

        extractPboDos = os.path.join(MikeroToolFolder, 'bin', 'ExtractPboDos.exe')
        
        if not os.path.isfile(extractPboDos):
            print('ERROR: Not possible to find ExtractPboDos.exe in "{}"...'.format(os.path.join(MikeroToolFolder, 'bin')))
            sys.exit(1)


        modAddonFolder = os.path.join(workshopModPath, 'addons')
        os.chdir(modAddonFolder)
        
        modAddonPbos = glob.glob('*.pbo')

        existList = []
        for pbo in modAddonPbos:
            a = glob.glob(os.path.join(ppath, '*', '*', pbo[:-4]))
            b = glob.glob(os.path.join(ppath, '*', pbo[:-4]))
            c = glob.glob(os.path.join(ppath, pbo[:-4]))
            for i in a:
                existList.append(i)
            for i in b:
                existList.append(i)
            for i in c:
                existList.append(i)
            
        if args.force:
            for addon in existList:
                shutil.rmtree(addon, ignore_errors=False, onerror=None)
        else:
            if len(existList) >= 1:
                print('ERROR: Mod folder already exist.')
                sys.exit(1)

        cores = multiprocessing.cpu_count()

        print('{} addons detected starting unpacking...'.format(len(modAddonPbos)))
        
        modAddonPbos.sort(key=lambda f: os.stat(f).st_size, reverse=False)

        processes = []
        for i, pbo in enumerate(modAddonPbos):
            p = subprocess.Popen([extractPboDos, '-P', '-N', pbo, ppath], shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            processes.append((p, pbo))

        for p, pbo in processes:          
            print('Unpacking {} ({} bytes)...'.format(pbo, os.path.getsize(pbo)))
            p.wait()
            print('Done unpacking {}.'.format(pbo))

        print('Unpacking of "{}" completed...'.format(modName))
        sys.exit(0)

    def prog_addon_list():
        print('Downloaded workshop mods:')
        for a in os.listdir(Arma3WorkshopFolder):
            if a == "!DO_NOT_CHANGE_FILES_IN_THESE_FOLDERS":
                continue
            a = a.replace('@', '')
            print(' ', a)
        sys.exit(0)
    
    if args.list:
        prog_addon_list()
    
    if args.unpack:
        workshopModPath = os.path.join(Arma3InstallFolder, '!Workshop', '@{}'.format(args.unpack))
        if not os.path.exists(workshopModPath):
            sys.exit('Mod \'@{}\' does not exist...'.format(args.unpack))
        prog_addon_unpack(args.unpack, workshopModPath)

    if args.browse:
        subprocess.Popen('explorer {}'.format(Arma3WorkshopFolder), shell=True)
        sys.exit(0)
        
    # if nothing
    parser.parse_args(['addon', '--help'])
    sys.exit(1)

# Tools Program
def prog_tools (args, parser):
    Arma3ToolsVer = get_key_HKCU(os.path.join('Software','Bohemia Interactive','Arma 3 Tools'), 'version')

    def getMikeroToolAndVer(tool):
        return [tool, get_key_HKCU(os.path.join('Software', 'Mikero', tool), 'version')]

    def armakeGetVer(tool):
        version = ""
        version = subprocess.check_output([tool, '--version'])
        version = version.split(b'\r')[0].decode('utf-8')
        return version

    def hemttGetVer(tool):
        version = ""
        version = subprocess.check_output([tool, '--version'])
        version = version.split(b'\n')[0].decode('utf-8')
        version = version.split(' ')[1]
        return version

    print('Following tools have been discoverd')
    if Arma3ToolsFolder:
        print('  [BIS]             Arma 3 Tools', '({})'.format(Arma3ToolsVer))
    if Arma3ToolsFolder:
        print('  [BIS]             Arma 3 Samples')
    if shutil.which("armake"):
        print('  [KoffeinFlummi]   armake ({})'.format(armakeGetVer("armake")))
    if shutil.which("armake2"):
        print('  [KoffeinFlummi]   armake2 ({})'.format(armakeGetVer("armake2")))
    if shutil.which("hemtt"):
        print('  [BrettMayson]     hemtt ({})'.format(hemttGetVer("hemtt")))
    for tool in ['ArmA3p', 'cupCore2p', 'dayz2p', 'DeOgg', 'DePbo', 'DeRap', 'DeTex', 'Eliteness', 'ExtractPbo', 'MakePbo', 'pboProject', 'Rapify']:
        tool = getMikeroToolAndVer(tool)
        ver = '({})'.format(tool[1]) if tool[1] else ''
        print('  [MikeroTool]      {}'.format(tool[0]), ver)
    sys.exit(1)

# Project Program
def prog_proj (args, parser):
    toolsFolder = ['tools', 'tool', 'scripts', 'script']
    repo_dir = subprocess.Popen(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE).communicate()[0].rstrip().decode('utf-8')
    if repo_dir == "":
        printExit('This is not a git project and can there for not determined project type.', 1)

    def getProjectType():
        objects = []
        for (dirpath, dirnames, filenames) in os.walk(repo_dir):
            objects.extend(dirnames)
            objects.extend(filenames)
            break

        mission = 'mission'
        addon = 'addon'
        if 'mission.sqm' in objects:
            return mission
        if 'description.ext' in objects:
            return mission
        if 'init.sqf' in objects:
            return mission
        if 'addons' in objects:
            return addon
        return 'unknown'

    def prog_proj_check ():
        project = getProjectType()
        if project == 'addon':
            printExit('This looks like a addon project.', 0)
        elif project == 'mission':
            printExit('This looks like a mission project', 0)
        else:
            printExit('Not possible to determin project type.', 1)
    
    def prog_proj_make (arg):
        arg = '' if arg == None else arg
        for f in toolsFolder:
            if os.path.exists(os.path.join(repo_dir, f)):
                subprocess.call('python {} {}'.format(os.path.join(repo_dir, f, 'make.py'), arg))
                sys.exit(0)
        printExit('No make.py script seams to exist... Do you have a "scripts" or "tools" folder?', 1)

    def prog_proj_build (arg):
        arg = '' if arg == None else arg 
        for f in toolsFolder:
            if os.path.exists(os.path.join(repo_dir, f)):
                subprocess.call('python {} {}'.format(os.path.join(repo_dir, f, 'build.py'), arg))
                sys.exit(0)
        printExit('No build.py script seams to exist... Do you have a "scripts" or "tools" folder?', 1)

    if args.type:
        prog_proj_check()

    if args.make or args.make == None:
        prog_proj_make(args.make)

    if args.build or args.build == None:
        prog_proj_build(args.build)

    # if nothing
    parser.parse_args(['proj', '--help'])
    sys.exit(1)


def main():
    os.system("title armadev")

    parser = argparse.ArgumentParser(
        prog='armadev',
        description='armadev a developer, scripting and modding helper tool for ARMA 3.',
        epilog=''
    )
    subparsers = parser.add_subparsers()

    prog_parser_rpt = subparsers.add_parser('rpt',
        help='RPT log handler allow monitoring and clearing of logs',
        description='armadev a developer, scripting and modding helper tool for ARMA 3.')
    prog_parser_rpt.add_argument('--watch', '-w', nargs='?', metavar='<nothing>|filter', default=False,
        help='watch the latest rpt file (Optional parameter for filter)')
    prog_parser_rpt.add_argument('--highlight', '-i', action='store_true',
        help='highlight errors, warning, info and debug messages')
    prog_parser_rpt.add_argument('--list', '-l', action='store_true',
        help='list all avalible rpt logs')
    prog_parser_rpt.add_argument('--clear', '-D', action='store_true',
        help='remove all rpt log files')
    prog_parser_rpt.set_defaults(func=prog_rpt)

    prog_parser_proj = subparsers.add_parser('proj',
        help='Arma 3 project handler (This script require a git project intorder to function propperly)',
        description='Arma 3 project handler')
    prog_parser_proj.add_argument('--type', '-t', action='store_true',
        help='check what type of project')
    prog_parser_proj.add_argument('--make', '-m', nargs='?', metavar='<nothing>|arguments', default=False,
        help='run make script')
    prog_parser_proj.add_argument('--build', '-b', nargs='?', metavar='<nothing>|arguments', default=False,
        help='run build script')
    prog_parser_proj.set_defaults(func=prog_proj)

    prog_parser_p = subparsers.add_parser('p',
        help='Arma 3 P-drive handler (Path: "{}", Mounted: {})'.format(ppath, mount_status()),
        description='Arma 3 P-drive handler (Path: "{}", Mounted: {})'.format(ppath, mount_status()))
    prog_parser_p.add_argument('--mount', '-m', action='store_true',
        help='mount the arma 3 P-drive')
    prog_parser_p.add_argument('--umount', '-u', action='store_true',
        help='unmount the arma 3 P-drive')
    prog_parser_p.add_argument('--set', metavar='PATH',
        help='Set P-drive location')
    prog_parser_p.add_argument('--open', '-o', action='store_true',
        help='Open p dive path in explorer')
    prog_parser_p.set_defaults(func=prog_p)

    prog_parser_addon = subparsers.add_parser('addon',
        help='Arma 3 Addon unpacker',
        description='Arma 3 Addon unpacker')
    prog_parser_addon.add_argument('--unpack', '-u', metavar='MODNAME',
        help='Unpack a mods pbos and debinirize the configs')
    prog_parser_addon.add_argument('--force', '-F', action='store_true',
        help='Force unpacking by removing and replacing already exisint')
    prog_parser_addon.add_argument('--list', '-l', action='store_true',
        help='List all workshop mods')
    prog_parser_addon.add_argument('--browse', '-b', action='store_true',
        help='Opens the !Workshop directory')
    prog_parser_addon.set_defaults(func=prog_addon)

    prog_parser_tools = subparsers.add_parser('tools', help='List all avalible tools you have installed')
    prog_parser_tools.set_defaults(func=prog_tools)

    args = parser.parse_args()

    try: 
        args.func(args, parser)
    except AttributeError:
        parser.parse_args(['--help'])

if __name__ == "__main__":
    sys.exit(main())
