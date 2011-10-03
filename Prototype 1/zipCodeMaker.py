# Name: zipCodeMaker.py
# Description: To parse the US Census Bureau ZCTA data for the zip
# code 97303 and from it automatically generate the google maps call
# to overlay that area on a Google Map.
# Written by:  Tanya L. Crenshaw

import csv
import datetime

# Read in Longitude and Latitude Information
reader = csv.reader(open('pdxcoords.txt'), delimiter = ',')

# Open the .js file that will be generated.  Note that if the
# file already exists, it will be over-written.
output = open('zip97203.js', 'w')

# Get the current date and time to timestamp
# the automatically generated file.
now = datetime.datetime.now()

# Write the comment that will head the file
output.write("// This file was automatically generated on ")
output.write(now.strftime("%Y-%m-%d %H:%M. \n"))
output.write("// DO NOT EDIT. Use zipCodeMaker.py to generate. \n\n\n")

# Write the function header
output.write("function constructZipCodeArray() \n")
output.write("{ \n\n")

# Begin the array of geographical points
output.write("    var zipCoords = [ \n")

for row in reader:
    try:
        lat = row[1]
        lon = row[0]

        # Construct the call to make a new geographical point using the
        # longitude and latitude read from the ZCTA information.        
        output.write("         new google.maps.LatLng(")
        output.write(lat)
        output.write(",")
        output.write(lon)
        output.write("),\n")
        
    except:
        pass
    
# Delete that last comma since the last new geographical point written
# out to the file was the last one in the array of points.
output.seek(-2, 2)

# Complete the array
output.write("\n    ];\n\n")

# Complete the function with a return value and a final curly bracket.
output.write("    return zipCoords\n")
output.write("}")
