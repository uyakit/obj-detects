# -*- coding: utf-8 -*-

# https://miyashinblog.com/detectron2/#toc4

import io
import os
import sys
import subprocess
import shutil

path_me = os.path.abspath(os.path.realpath(__file__)).replace(os.sep,'/')
pathd_me = os.path.abspath(os.path.dirname(path_me)).replace(os.sep,'/')
basename_me = os.path.splitext(os.path.basename(path_me))[0]
os.chdir(pathd_me)

pathd_target = os.path.abspath(sys.argv[1]).replace(os.sep,'/')
dname_target = os.path.splitext(os.path.basename(pathd_target))[0]

# The result .zip is to be outputted in the same directory as this .py
path_zip = shutil.make_archive(dname_target, 'zip', root_dir=pathd_target)
print('# Zipped successfully : ' + path_zip)
