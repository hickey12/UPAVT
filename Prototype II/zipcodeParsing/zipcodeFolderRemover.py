#! /usr/bin/env python
#File: zipcodeFolderRemover.py
#Author: Jace Raile
#Last modified: 5 November 2011
#Usage: Removes Zipcodes folder from each folder in directory
import os
import shutil

#notice: this script is of very poor quality and does no error checking-
#------- you have been warned.
for root, dirs, files in os.walk('./'):
        for d in dirs:
                os.chdir('./' + d)
                shutil.rmtree(os.getcwd() + '\Zipcodes')
                print "Done."                
                os.chdir('../')
                
print "Really Done."
                
                






                        
        





