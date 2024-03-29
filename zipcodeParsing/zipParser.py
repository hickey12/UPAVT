#! /usr/bin/env python
#File: zipParser.py
#Author: Jace Raile, Max Ackley
#Last modified: 5 November 2011
#Usage: software engineering datafile parse test script
import os
import re
import glob
import sys
import fnmatch

#notice: this script is of very poor quality and does no error checking-
#------- you have been warned.
for root, dirs, files in os.walk('./'):
        if (root == './'):
                for d in dirs:
                        print d
                        os.chdir('./' + d)
                        #initialize variables
                        mylist = [0]
                        lastLine = ""
                        filename = ""

                        #due to needing to open zip code text files in append mode, they must not exist beforehand
                        if os.path.exists(".\Zipcodes"):
                                print "Please remove Zipcodes directory before running this script."
                                print "Program will terminate now."
                                sys.exit(0)
                                

                        #open datafile and create a temp file
                        #CURRENTLY USES .txt VERSION OF DATAFILE
                        for file in os.listdir('.'):
                            if fnmatch.fnmatch(file, 'zt??_d00a.dat'):
                                    filename = file

                        fin = open(filename, "r")
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
                        for file in os.listdir('.'):
                            if fnmatch.fnmatch(file, 'zt??_d00.dat'):
                                fin = open(file, "r")
                                
                        fout = open("temp2.txt", "w")

                        #copy datafile into temp file with leading whitespace removed
                        foundValidZip = True
                        for line in fin:
                                line = line.lstrip(" ")

                                if len(line) >= 5 and line[:6] == "-99999":
                                        foundValidZip = False

                                if foundValidZip:
                                        if not line == "END\n" or line[0].isdigit():
                                                coords = line.split()
                                                line = coords[0] + "," + coords[1] + "\n"
                                        fout.write(line)

                                if line == "END\n":
                                        foundValidZip = True

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
                        lastLine = ""
                        for line in fin:

                                #check for the end of the file
                                if line == "END\n" and lastLine == "END\n":
                                        break;
                                lastLine = line;

                                #extract the zip code index corresponding to the coordinates...
                                indexString = ""
                                i = 0
                                if line[i].isdigit():
                                        if not line[i+1] == '.':
                                                while line[i].isdigit():
                                                        indexString += line[i]
                                                        i = i + 1
                                                mystring = "./Zipcodes/zip" + mylist[int(indexString)] + ".csv"
                                                if os.path.exists(mystring):
                                                        fout = open(mystring, "a")
                                                else:
                                                        fout = open(mystring, "w")
                                                        fout.write("LAT,LON\n")
                                        else:
                                                #write until the end marker is reached
                                                if not line == "END\n":
                                                        fout.write(line)
                                                else:
                                                        fout.write("END,END\n")
                                                        fout.close()
                                #...or write the coordinates   
                                else:
                                        #write until the end marker is reached
                                        if not line == "END\n":
                                                fout.write(line)
                                        else:
                                                fout.write("END,END\n")
                                                fout.close()
                                
                                                              
                        #close files and remove temp file
                        fin.close()
                        print "Zipcode files created. Note: Multiple polygon sets separated by \"END, END\"."
                        os.remove("temp2.txt")

                        #convert long/lat to lat/long
                        path = './Zipcodes'
                        j = re.compile('^([\S]{22}),([\S]{21})$')
                        for infile in glob.glob( os.path.join(path, '*.csv') ):
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
                        print "Files converted."      
                        print "Done. \n"
                        os.chdir('../')
                        
print "Really Done."
                
                






                        
        





