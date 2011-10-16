#! /usr/bin/env python
#File: test.py
#Author: jace raile
#Last modified: 8 October 2011 @ 8:05 PM
#Usage: software engineering datafile parse test script
import os
import re
import glob
import sys

#notice: this script is of very poor quality and does no error checking-
#------- you have been warned.

#initialize variables
mylist = [0]
lastLine = ""

#due to needing to open zip code text files in append mode, they must not exist beforehand
if os.path.exists(".\Zipcodes"):
        print "Please remove Zipcodes directory before running this script."
        print "Program will terminate now."
        sys.exit(0)
        

#open datafile and create a temp file
#CURRENTLY USES .txt VERSION OF DATAFILE
fin = open("zt41_d00a.txt", "r")
fout = open("temp.txt", "w")

#copy datafile contents to temp file except sequentially duplicated lines
for line in fin:
        if not line == lastLine:
                fout.write(line)
        lastLine = line

#close files
fin.close()
fout.close()

#open temp file
fin = open("temp.txt", "r")

#add zip codes of temp file into array such that the
#zip code at a specific index corresponds to the index
#number that preceeds it in the datafile
p = re.compile('\"(\w\w\w\w\w)\"')

for line in fin:
        if p.search(line):
                m = p.search(line)
                mylist.append(m.group(1))
print "Array created."

#close and remove temp file
fin.close()
os.remove("temp.txt")

#open datafile and create temp file
#NEEDTO: REMOVE ALL -99999 ZIP CODE POLYGONS FROM DATAFILE
fin = open("zt41_d00.txt", "r")
fout = open("temp2.txt", "w")

#copy datafile into temp file with leading whitespace removed
for line in fin:
        line = line.lstrip(" ")
        fout.write(line)

#close files
fin.close()
fout.close()

#try to make Zipcodes directory
try:
    os.makedirs('./Zipcodes')
except OSError:
    pass

#open temp file 2
fin = open("temp2.txt", "r")

#make a zipcode text file for each zip code in temp file
for line in fin:
        indexString = ""
        i = 0
        if line[i].isdigit():
                while line[i].isdigit():
                        indexString += line[i]
                        i = i + 1
                mystring = "./Zipcodes/zip" + mylist[int(indexString)] + ".txt"
                fout = open(mystring, "a")
        else:
                if not line == "END":
                        fout.write(line)
                else:
                        fout.close()
                        
#close files and remove temp file
fin.close()
print "Zipcode files created. Note: Each file may contain multiple polygon data sets separated by \"END\"."
os.remove("temp2.txt")

#convert long/lat to lat/long
path = './Zipcodes'
j = re.compile('^([\S]{22})[\s]{7}([\S]{21})$')
for infile in glob.glob( os.path.join(path, '*.txt') ):
        fin = open(infile, "r")
        lines = fin.readlines()
        fin.close()

        fin = open(infile, "w")
        for line in lines:
                if j.search(line):
                        k = j.search(line)
                        line = k.group(2) + "," + k.group(1) + "\n"
                        fin.write(line)
                else:
                        fin.write(line)
        fin.close()
print "Done."




                        
        





