#! /usr/bin/env python
#File: bigCopy.py
#Author: Jace Raile
#Last modified: 5 November 2011
#Usage: copy all zip codes
import os
import shutil
import tkFileDialog

#notice: this script is of very poor quality and does no error checking-
#------- you have been warned.
savedir = tkFileDialog.askdirectory()
masterRoot = os.getcwd()
for root, dirs, files in os.walk('./'):
        if (root == './'):
                for d in dirs:
                        if not (d == 'US'):
                                os.chdir('./' + d + '/Zipcodes')
                                path = os.getcwd()
                                for ro, di, fi in os.walk('./'):
                                        for f in fi:
                                                src = path + '\\' + f
                                                shutil.copy(src, savedir)
                                os.chdir(masterRoot)
print "Really Done."
                
                






                        
        





