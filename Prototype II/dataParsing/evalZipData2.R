#Author Trever Hickey
#Date Created: Oct 3, 2011
#Date Modified: Oct 3, 2011

#Calls State Level and National
#level data analysis.
wrapperFuncion()
{
	stateWrapper()
	nationalLevelWrapper()
}

#Creates tables for all states
stateWrapper <- function() {
	#Creates a list of the states
	#states <- c("AL", "AK", "AZ", "AR", "CA"); 
	#"CO", "CT", "DE", "FL", "GA"
	#"HI", "ID", "IL", "IN", "IA", 
	#"KS", "KY", "LA", "ME", "MD", 
	#"MA", "MI", "MN", "MS", "MO", 
	#"MT", "NE", "NV", "NH", "NJ", 
	#"NM", "NY", "NC", "ND", "OH", 
	#"OK", "OR", "PA", "RI", "SC", 
	#"SD", "TN", "TX", "UT", "VT", 
	#"VA", "WA", "WV", 
	states <- c("WI", "WY");	

	#Go through each state
	for(state in states)
	{
		stateSummary(state)
		satVerbalWrapper(state);
		satMathWrapper(state);
		gpaWrapper(state);
		genderWrapper(state);
		visited(state);
	
	}
}

#This function goes through all of the CSV files, all csv and figures
#out how many people were interested, applied, accepted, and enrolled
#in all zip codes within a state.
stateSummary <- function(state) {	
	
	#Initializes variables to null
	acceptedCount <- NULL;
	appliedCount <- NULL;
	inquiryCount <- NULL;
	stateSummary <- NULL;
	enrolledCount <- NULL;

	#Creates a zip codes variable.
	zips <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a state level summary
	#Go through each file sequentially
	for(i in filenames) {
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(i, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
	
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);

		#Does the general summary information.
		for(zip in zips)
		{
			inquiryCounter <- schoolTable$Zip[schoolTable$Zip == zip];
			#Counts how many people are interested from a zip code
			inquiryCount <- c(inquiryCount, length(inquiryCounter));
			
			
			appliedCounter <- schoolTable$Applied[schoolTable$Applied == "Y" & schoolTable$Zip == zip];
			#Counts how many people applied from a zipcode
			appliedCount <- c(appliedCount, length(appliedCounter));

			acceptedCounter <- schoolTable$Accepted[schoolTable$Accepted == "A" & schoolTable$Zip == zip];
			#Counts how many were accepted from a zipcode
			acceptedCount <- c(acceptedCount, length(acceptedCounter));

			enrolledCounter <- schoolTable$Enrolled[schoolTable$Enrolled == "Y" & schoolTable$Zip == zip];
			#Counts how many students enrolled from a zipcode
			enrolledCount <- c(enrolledCount, length(enrolledCounter));

		}
		
		
		# Once a zips are complete, create a data frame to store these entries in a table
		stateSummary <- (data.frame(Zipcodes = zips, Inquiry=inquiryCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));	

		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "summary", year, state, ".csv", sep=""); 
		write.csv(stateSummary, fileName);
	}
}

#This is a wrapper function that builds a table that contains how many students
#exist in an sat bin. This will tell us how many students in a zipcode fall into
#a certain sat bin.
satMathWrapper <- function(state)
{
	#Create all eight required dataframes.
	satMathHelper(state, 100, 100);
	satMathHelper(state, 100, 200);
	satMathHelper(state, 100, 300);
	satMathHelper(state, 100, 400);
	satMathHelper(state, 100, 500);
	satMathHelper(state, 100, 600);
	satMathHelper(state, 100, 700);
	satMathHelper(state, 100, 800);
	
}

#Builds a data frame of how many people in a zip code are inquired, 
#applied, accepted, and enrolled in UP and fall in a certain range
#of math sat scores.
satMathHelper <- function(state, size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size

	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		class(schoolTable$SATMAth) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the SAT requirements
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
		
		
			#Find all applicants who applied in a zip code and meet the SAT requirements
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			#Find all applicants who were accepted in a zip code and meet the SAT requirements
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Accepted == "A");
			#Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
		
		
			#Find all applicants who enrolled in a zip code and meet the SAT requirements
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Enrolled == "Y");
			#Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
		
			#Clears the counters for the next zipcode
			inquiryCounter <- 0;
			appliedCounter <- 0;
			acceptedCounter <- 0;
			enrolledCounter <- 0;
		}	
	
		#Turn data into a dataFrame
		satMathSummary <- (data.frame(	Zipcodes = zips, 
										InquirySATMath=inquiryCount, 
										AppliedSATMath=appliedCount, 
										AcceptedSATMath=acceptedCount, 
										EnrolledSATMath=enrolledCount));
	
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(satMathSummary)[2] <- c("Inquiry");
		names(satMathSummary)[3] <- c("Applied");
		names(satMathSummary)[4] <- c("Accepted");
		names(satMathSummary)[5] <- c("Enrolled");
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "satMath", year, state, endLimit, ".csv", sep=""); 
		write.csv(satMathSummary, fileName);
	}

}

#This is a wrapper function that builds a table that contains how many students
#exist in an sat bin. This will tell us how many students in a zipcode fall into
#a certain sat bin.
satVerbalWrapper <- function(state)
{
	#Create all eight required dataframes.
	satVerbalHelper(state, 100, 100);
	satVerbalHelper(state, 100, 200);
	satVerbalHelper(state, 100, 300);
	satVerbalHelper(state, 100, 400);
	satVerbalHelper(state, 100, 500);
	satVerbalHelper(state, 100, 600);
	satVerbalHelper(state, 100, 700);
	satVerbalHelper(state, 100, 800);
}

#Builds a data frame of how many people in a zip code are inquired, 
#applied, accepted, and enrolled in UP and fall in a certain range
#of verbal sat scores.
satVerbalHelper <- function(state, size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Set the Verbal column as numeric so you can use relational operators.
		class(schoolTable$SATVerbal) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);
	
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the SAT requirements
			inquiryCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and meet the SAT requirements
			appliedCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) &
														schoolTable$Applied == "Y");
			# Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and meet the SAT requirements
			acceptedCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) &
														schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and meet the SAT requirements
			enrolledCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) & 
														schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		satVerbalSummary <- (data.frame(Zipcodes = zips, 
										InquirySATVerbal=inquiryCount, 
										AppliedSATVerbal=appliedCount, 
										AcceptedSATVerbal=acceptedCount, 
										EnrolledSATVerbal=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(satVerbalSummary)[2] <- c("Inquiry");
		names(satVerbalSummary)[3] <- c("Applied");
		names(satVerbalSummary)[4] <- c("Accepted");
		names(satVerbalSummary)[5] <- c("Enrolled");
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "satVerbal", year, state, endLimit, ".csv", sep=""); 
		write.csv(satVerbalSummary, fileName);
	}

}

#This is a wrapper function that builds a table that contains how many students
#exist in an gpa bin. This will tell us how many students in a zipcode fall into
#a certain gpa bin.
gpaWrapper <- function(state)
{
	#Create all required dataframes.
	gpaHelper(state, 1.0, 1.0);
	gpaHelper(state, 1.0, 2.0);
	gpaHelper(state, 1.0, 3.0);
	gpaHelper(state, 1.0, 4.0);
	
}

#Builds a data frame of how many people in a zip code are inquired,
#applied, accepted, and enrolled in UP and fall in a certain range
#of gpa scores.
gpaHelper <- function(state, size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Set the Verbal column as numeric so you can use relational operators.
		class(schoolTable$HS_GPA) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the GPA requirements
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and meet the GPA requirements
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and meet the GPA requirements
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and meet the GPA requirements
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		gpaSummary <- (data.frame(	Zipcodes = zips, 
										InquiryGPA=inquiryCount, 
										AppliedGPA=appliedCount, 
										AcceptedGPA=acceptedCount, 
										EnrolledGPA=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(gpaSummary)[2] <- c("Inquiry");
		names(gpaSummary)[3] <- c("Applied");
		names(gpaSummary)[4] <- c("Accepted");
		names(gpaSummary)[5] <- c("Enrolled");
		
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "gpa", year, state, endLimit, ".csv", sep=""); 
		write.csv(gpaSummary, fileName);
		
	}
}

#This is a wrapper function that builds a table that contains how many students
#are a certain gender. This will tell us how many students in a zipcode fall into
#a certain gender bin.
genderWrapper <- function(state)
{
	#Create all required dataframes.
	genderHelper(state, "M");
	genderHelper(state, "F");
	genderHelper(state, "N");
}

#Builds a data frame of how many people in a zip code are inquired,
#applied, accepted, and belong to a certain gender
genderHelper <- function(state, genderChar)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");
	
	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code that are a certain gender
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip &
													schoolTable$Gender == genderChar);
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and are a certain gender
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and are a certain gender
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and are a certain gender
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		genderSummary <- (data.frame(	Zipcodes = zips, 
										Inquirygender=inquiryCount, 
										Appliedgender=appliedCount, 
										Acceptedgender=acceptedCount, 
										Enrolledgender=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(genderSummary)[2] <- c("Inquiry");
		names(genderSummary)[3] <- c("Applied");
		names(genderSummary)[4] <- c("Accepted");
		names(genderSummary)[5] <- c("Enrolled");
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "gender", year, state, genderChar, ".csv", sep=""); 
		write.csv(genderSummary, fileName);
		
	}
}

#Builds a data frame of how many people in a zip code are inquired,
#applied, accepted, and enrolled who have visited UP.
visited <- function(state)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");
	
	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip[schoolTable$State == state]);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code that have visited.
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip &
													schoolTable$UPVisits != "");
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and have visited
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and have visited.
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and have visited
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		visitedSummary <- (data.frame(	Zipcodes = zips, 
										Inquirygender=inquiryCount, 
										Appliedgender=appliedCount, 
										Acceptedgender=acceptedCount, 
										Enrolledgender=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(visitedSummary)[2] <- c("Inquiry");
		names(visitedSummary)[3] <- c("Applied");
		names(visitedSummary)[4] <- c("Accepted");
		names(visitedSummary)[5] <- c("Enrolled");
		
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, state, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "visited", year, state, "V", ".csv", sep=""); 
		write.csv(visitedSummary, fileName);
		
	}
}

#This function goes through all of the CSV files and figures out how many people
#in the US were interested, applied, accepted, and enrolled in all zip codes in
#the country
nationalLevelWrapper <- function() {
	
	#Gets the general information
	nationalLevelSummary()
	#Gets SAT math information
	satMathNationalWrapper()
	#Gets SAT verbal information
	satVerbalNationalWrapper()
	#Gets the gpa information
	gpaNationalWrapper()
	#Gets the gender information
	genderNationalWrapper()
	#Gets the Visited Information
	visitedNational()
}

#This function goes through all of the CSV files, all csv and figures
#out how many people were interested, applied, accepted, and enrolled
#in all zip codes.
nationalLevelSummary <- function() {	
	
	#Initializes variables to null
	acceptedCount <- NULL;
	appliedCount <- NULL;
	inquiryCount <- NULL;
	stateSummary <- NULL;
	enrolledCount <- NULL;

	#Creates a zip codes variable.
	zips <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a state level summary
	#Go through each file sequentially
	for(i in filenames) {
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(i, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
	
		#Get the zips.
		zips <- unique(schoolTable$Zip);

		#sorts the zips before processing.
		zips <- sort(zips);

		#Does the general summary information.
		for(zip in zips)
		{
			inquiryCounter <- schoolTable$Zip[schoolTable$Zip == zip];
			#Counts how many people are interested from a zip code
			inquiryCount <- c(inquiryCount, length(inquiryCounter));
			
			
			appliedCounter <- schoolTable$Applied[schoolTable$Applied == "Y" & schoolTable$Zip == zip];
			#Counts how many people applied from a zipcode
			appliedCount <- c(appliedCount, length(appliedCounter));

			acceptedCounter <- schoolTable$Accepted[schoolTable$Accepted == "A" & schoolTable$Zip == zip];
			#Counts how many were accepted from a zipcode
			acceptedCount <- c(acceptedCount, length(acceptedCounter));

			enrolledCounter <- schoolTable$Enrolled[schoolTable$Enrolled == "Y" & schoolTable$Zip == zip];
			#Counts how many students enrolled from a zipcode
			enrolledCount <- c(enrolledCount, length(enrolledCounter));

		}
		
		
		# Once a zips are complete, create a data frame to store these entries in a table
		stateSummary <- (data.frame(Zipcodes = zips, Inquiry=inquiryCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));	

		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, "US", "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "summary", year, "US", ".csv", sep=""); 
		write.csv(stateSummary, fileName);
	}
}

#This is a wrapper function that builds a table that contains how many students
#exist in an sat bin. This will tell us how many students in all zipcodes fall into
#a certain sat bin.
satMathNationalWrapper <- function()
{
	#Create all eight required dataframes.
	satMathNationalHelper(100, 100);
	satMathNationalHelper(100, 200);
	satMathNationalHelper(100, 300);
	satMathNationalHelper(100, 400);
	satMathNationalHelper(100, 500);
	satMathNationalHelper(100, 600);
	satMathNationalHelper(100, 700);
	satMathNationalHelper(100, 800);
	
}

#Builds a data frame of all zip codes in are inquired, 
#applied, accepted, and enrolled in UP and fall in a certain range
#of math sat scores.
satMathNationalHelper <- function(size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size

	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		class(schoolTable$SATMAth) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips.
		zips <- unique(schoolTable$Zip);
		
		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the SAT requirements
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
		
		
			#Find all applicants who applied in a zip code and meet the SAT requirements
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			#Find all applicants who were accepted in a zip code and meet the SAT requirements
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Accepted == "A");
			#Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
		
		
			#Find all applicants who enrolled in a zip code and meet the SAT requirements
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size) &
													schoolTable$Enrolled == "Y");
			#Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
		
			#Clears the counters for the next zipcode
			inquiryCounter <- 0;
			appliedCounter <- 0;
			acceptedCounter <- 0;
			enrolledCounter <- 0;
		}	
	
		#Turn data into a dataFrame
		satMathSummary <- (data.frame(	Zipcodes = zips, 
										InquirySATMath=inquiryCount, 
										AppliedSATMath=appliedCount, 
										AcceptedSATMath=acceptedCount, 
										EnrolledSATMath=enrolledCount));
	
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(satMathSummary)[2] <- c("Inquiry");
		names(satMathSummary)[3] <- c("Applied");
		names(satMathSummary)[4] <- c("Accepted");
		names(satMathSummary)[5] <- c("Enrolled");
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, US, "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "satMath", year, "US", endLimit, ".csv", sep=""); 
		write.csv(satMathSummary, fileName);
	}

}

#This is a wrapper function that builds a table that contains how many students
#exist in an sat bin. This will tell us how many students in all zipcodes fall into
#a certain sat bin.
satVerbalNationalWrapper <- function()
{
	#Create all eight required dataframes.
	satVerbalNationalHelper(100, 100);
	satVerbalNationalHelper(100, 200);
	satVerbalNationalHelper(100, 300);
	satVerbalNationalHelper(100, 400);
	satVerbalNationalHelper(100, 500);
	satVerbalNationalHelper(100, 600);
	satVerbalNationalHelper(100, 700);
	satVerbalNationalHelper(100, 800);
}

#Builds a data frame of how many people in all zip codes are inquired, 
#applied, accepted, and enrolled in UP and fall in a certain range
#of verbal sat scores.
satVerbalNationalHelper <- function(size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Set the Verbal column as numeric so you can use relational operators.
		class(schoolTable$SATVerbal) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get all the zips
		zips <- unique(schoolTable$Zip);

		#sorts the zips before processing.
		zips <- sort(zips);
	
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the SAT requirements
			inquiryCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and meet the SAT requirements
			appliedCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) &
														schoolTable$Applied == "Y");
			# Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and meet the SAT requirements
			acceptedCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) &
														schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and meet the SAT requirements
			enrolledCounter <- subset(schoolTable,		schoolTable$Zip == zip & 
														schoolTable$SATVerbal <= endLimit &
														schoolTable$SATVerbal > (endLimit - size) & 
														schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		satVerbalSummary <- (data.frame(Zipcodes = zips, 
										InquirySATVerbal=inquiryCount, 
										AppliedSATVerbal=appliedCount, 
										AcceptedSATVerbal=acceptedCount, 
										EnrolledSATVerbal=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(satVerbalSummary)[2] <- c("Inquiry");
		names(satVerbalSummary)[3] <- c("Applied");
		names(satVerbalSummary)[4] <- c("Accepted");
		names(satVerbalSummary)[5] <- c("Enrolled");
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, "US", "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "satVerbal", year, "US", endLimit, ".csv", sep=""); 
		write.csv(satVerbalSummary, fileName);
	}

}

#This is a wrapper function that builds a table that contains how many students
#exist in an gpa bin. This will tell us how many students in all zipcodes fall into
#a certain gpa bin.
gpaNationalWrapper <- function()
{
	#Create all required dataframes.
	gpaNationalHelper(1.0, 1.0);
	gpaNationalHelper(1.0, 2.0);
	gpaNationalHelper(1.0, 3.0);
	gpaNationalHelper(1.0, 4.0);
	
}

#Builds a data frame of how many people in a zip code are inquired,
#applied, accepted, and enrolled in UP and fall in a certain range
#of gpa scores.
gpaNationalHelper <- function(size, endLimit)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Set the Verbal column as numeric so you can use relational operators.
		class(schoolTable$HS_GPA) <- "numeric";
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code and meet the GPA requirements
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size));
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and meet the GPA requirements
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and meet the GPA requirements
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and meet the GPA requirements
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$HS_GPA <= endLimit &
													schoolTable$HS_GPA > (endLimit - size) &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		gpaSummary <- (data.frame(	Zipcodes = zips, 
										InquiryGPA=inquiryCount, 
										AppliedGPA=appliedCount, 
										AcceptedGPA=acceptedCount, 
										EnrolledGPA=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(gpaSummary)[2] <- c("Inquiry");
		names(gpaSummary)[3] <- c("Applied");
		names(gpaSummary)[4] <- c("Accepted");
		names(gpaSummary)[5] <- c("Enrolled");
		
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, "US", "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "gpa", year, "US", endLimit, ".csv", sep=""); 
		write.csv(gpaSummary, fileName);
		
	}
}

#This is a wrapper function that builds a table that contains how many students
#are a certain gender. This will tell us how many students in all zipcodes fall into
#a certain gender bin.
genderNationalWrapper <- function(state)
{
	#Create all required dataframes.
	genderNationalHelper("M");
	genderNationalHelper("F");
	genderNationalHelper("N");
}

#Builds a data frame of how many people in all zip codes are inquired,
#applied, accepted, and belong to a certain gender
genderNationalHelper <- function(genderChar)
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");
	
	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get the zips from the desired state
		zips <- unique(schoolTable$Zip);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code that are a certain gender
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip &
													schoolTable$Gender == genderChar);
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and are a certain gender
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and are a certain gender
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and are a certain gender
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$Gender == genderChar &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		genderSummary <- (data.frame(	Zipcodes = zips, 
										Inquirygender=inquiryCount, 
										Appliedgender=appliedCount, 
										Acceptedgender=acceptedCount, 
										Enrolledgender=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(genderSummary)[2] <- c("Inquiry");
		names(genderSummary)[3] <- c("Applied");
		names(genderSummary)[4] <- c("Accepted");
		names(genderSummary)[5] <- c("Enrolled");
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, "US", "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "gender", year, "US", genderChar, ".csv", sep=""); 
		write.csv(genderSummary, fileName);
		
	}
}

#Builds a data frame of how many people in all zip codes are inquired,
#applied, accepted, and enrolled who have visited UP.
visitedNational <- function()
{
	#Initialize all variables
	inquiryCounter <- c();
	appliedCounter <- c();
	acceptedCounter <- c();
	enrolledCounter <- c();
	
	inquiryCount <- c();
	appliedCount <- c();
	acceptedCount <- c();
	enrolledCount <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");
	
	#go through each file and create a summary based sat size
	#Go through each file sequentially
	for(fileName in filenames) 
	{
		
		#Reinitialize the counter
		acceptedCount <- NULL;
		appliedCount <- NULL;
		inquiryCount <- NULL;
		enrolledCount <- NULL;

		#Load the csv file
		schoolTable <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];
		
		#Get all the zips
		zips <- unique(schoolTable$Zip);

		#sorts the zips before processing.
		zips <- sort(zips);
	
		#Go through all of the zipcodes
		for(zip in zips)
		{
			#Find all applicants interested in a zip code that have visited.
			inquiryCounter <- subset(schoolTable,	schoolTable$Zip == zip &
													schoolTable$UPVisits != "");
			#Append the number of applicants to the list.
			inquiryCount <-c(inquiryCount, nrow(inquiryCounter));
			
			
			# Find all applicants who applied in a zip code and have visited
			appliedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" &
													schoolTable$Applied == "Y");
			#Append the number of applicants to the list.
			appliedCount <-c(appliedCount, nrow(appliedCounter));
			
			
			# Find all applicants who were accepted in a zip code and have visited.
			acceptedCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" & 
													schoolTable$Accepted == "A");
			# Append the number of applicants to the list.
			acceptedCount <-c(acceptedCount, nrow(acceptedCounter));
			
			
			# Find all applicants who enrolled in a zip code and have visited
			enrolledCounter <- subset(schoolTable,	schoolTable$Zip == zip & 
													schoolTable$UPVisits != "" &
													schoolTable$Enrolled == "Y");
			# Append the number of applicants to the list.
			enrolledCount <-c(enrolledCount, nrow(enrolledCounter));
			
			#Clears the counters for the next zipcode
			inquiryCounter <- NULL;
			appliedCounter <- NULL;
			acceptedCounter <- NULL;
			enrolledCounter <- NULL;
		}
		
		#Turn data into a dataFrame
		visitedSummary <- (data.frame(	Zipcodes = zips, 
										Inquirygender=inquiryCount, 
										Appliedgender=appliedCount, 
										Acceptedgender=acceptedCount, 
										Enrolledgender=enrolledCount));
		
		#Renames the columns to include the endlimit passed to the function in the column name.
		names(visitedSummary)[2] <- c("Inquiry");
		names(visitedSummary)[3] <- c("Applied");
		names(visitedSummary)[4] <- c("Accepted");
		names(visitedSummary)[5] <- c("Enrolled");
		
		#Writes the data to a csv file.
		#Build filepath if it doesn't exist.
		#Build the folder path if it doesn't exist.
		path <- "schoolData/";
		dir.create(path);
		path <- paste(path, year, "/", sep="");
		dir.create(path);
		path <- paste(path, "US", "/", sep="");
		dir.create(path);
		
		fileName <- paste(path, "visited", year, "US", "V", ".csv", sep=""); 
		write.csv(visitedSummary, fileName);
		
	}
}