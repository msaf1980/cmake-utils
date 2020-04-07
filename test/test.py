#!/usr/bin/env python3

# Copyright (c) 2013-2014, Ruslan Baratov
# All rights reserved.

import os
import platform
import argparse
import re
import sys
import shutil
import subprocess
import copy

#import detail.trash
#import detail.os_detect
#import detail.argparse

configs = []
done_list = []


builddir = '_builds'
installdir = '_install'

os.chdir(os.path.dirname(sys.argv[0]))

top_dir = os.getcwd()

parser = argparse.ArgumentParser()

parser.add_argument('--include',
                    type=str,
                    nargs='*',
                    help="include this directory patterns (low priority)")

parser.add_argument('--exclude',
                    type=str,
                    nargs='*',
                    help="exclude this directory patterns (high priority)")

parser.add_argument('--libcxx',
                    action='store_true',
                    help='compile and link with libcxx library')

parser.add_argument('--sim',
                    action='store_true',
                    help='build for ios simulator (Xcode only)')

args = parser.parse_args()

if args.exclude:
    print('exclude directories: {}'.format(args.exclude))

if args.include:
    print('include directories: {}'.format(args.include))

# test:
#  Unix Makefiles _builds/make-debug
#  Xcode _builds/xcode
#  Visual Studio 11 _builds/msvc


class Config:
    def __init__(self, generator, generator_params, directory, build, install):
        self.generator = generator
        self.generator_params = generator_params
        self.directory = directory
        self.build = build
        self.install = install

    def info(self, test):
        info = '[{}] [{}'.format(test, self.generator)
        if self.generator_params:
            info += ' + {}'.format(self.generator_params)
        info += '] [{}]'.format(self.build)
        return info

def run_cmake_test(test, dirname, config_in, install=None):
    config = copy.deepcopy(config_in)

    build_dir = os.path.join(dirname, builddir, config.directory)
    shutil.rmtree(build_dir, ignore_errors=True)

    os.makedirs(build_dir)
    os.chdir(build_dir)

    config_info = config.info(test)
    try:
        print('##### {}'.format(config_info))

        command = ['cmake', '-G', '{}'.format(config.generator)]
        command += config.generator_params.split()
        if install is not None:
            command.append('-DCMAKE_INSTALL_PREFIX={}'.format(installdir))

        command.append('../..')
        print('build...')
        subprocess.check_call(command)
        subprocess.check_call(config.build.split())
        if install is not None:
            subprocess.check_call(config.install.split())
            if not os.path.isdir(installdir):
                sys.exit("install target not executed")
            for i in install:
                path = os.path.join(installdir, i)
                if not os.path.exists(path):
                    sys.exit("{} not installed".format(i))

        print('done')
    except subprocess.CalledProcessError:
        sys.exit('run failed in "{}" directory'.format(dirname))

    done_list.append(config_info)
    os.chdir(top_dir)



def hit_regex(root, pattern_list):
    if not pattern_list:
        return False
    for pattern_entry in pattern_list:
        if pattern_entry and re.match(pattern_entry, root):
            return True
    return False


if platform.system() == "Windows":
    sys.exit("Not tested")
else:
    if args.libcxx:
        stdlib_flag = "'-stdlib=libc++'"
        libcxx_flag = "-DCMAKE_CXX_FLAGS={}".format(stdlib_flag)
    else:
        libcxx_flag = ''
        debug_opt = '-DCMAKE_BUILD_TYPE=Debug {}'.format(libcxx_flag)
        release_opt = '-DCMAKE_BUILD_TYPE=Release {}'.format(libcxx_flag)

    configs.append(Config('Unix Makefiles', release_opt, 'make-release', 'make', 'make install'))
    configs.append(Config('Unix Makefiles', debug_opt, 'make-debug', 'make', 'make install'))

test = []

for test in sorted(os.listdir(top_dir)):
    path = os.path.join(top_dir, test)
    if not os.path.isdir(path):
        continue
    if hit_regex(test, args.exclude):
        print("skip (exclude list): '{}'".format(test))
        continue
    if args.include and not hit_regex(test, args.include):
        print("skip (not in include list): '{}'".format(test))
        continue

    install = None
    external = False
    if not os.path.isfile(os.path.join(path, 'CMakeLists.txt')):
        continue
    install_file = os.path.join(path, ".install")
    if os.path.isfile(install_file):
        with open(install_file) as f:
            install = [line.rstrip() for line in f]

    for config in configs:
        run_cmake_test(test, path, config, install)

    build_dir = os.path.join(path, builddir)
    shutil.rmtree(build_dir, ignore_errors=True)

print('DONE LIST:')
for x in done_list:
    print(x)
