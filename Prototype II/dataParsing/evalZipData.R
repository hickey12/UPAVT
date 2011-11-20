#Author Trever Hickey
#Date Created: Oct 3, 2011
#Date Modified: Oct 3, 2011

#This function goes through all of the CSV files, assumed to be those used
#by admissions and parses the data into a summary of admission data by state.
evalZipData <- function(state) {	
	
	#Initializes variables to null
	acceptedCount <- NULL;
	appliedCount <- NULL;
	inquiryCount <- NULL;
	stateSummary <- NULL;
	enrolledCount <- NULL;

	#Creat directory for output
	path <- "schoolData/";
	dir.create(path);

	#Creates a zip codes variable.
	zips <- c();
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#go through each file and create a state level summary.

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
		
		return (satVerbalHelperFunction(zips, schoolTable));

		# Once a zips are complete, create a data frame to store these entries in a table
		stateSummary <- (data.frame(Zipcodes = zips, Inquiries=inquiryCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));	

		filename <- paste(path, paste("/summary", state, year, sep="_"), ".csv", sep="");;
		write.csv(stateSummary, filename);
	}
}

#Sorts the table into the bins to seperate the SAT verbal values.
satVerbalHelperFunction <- function(zips, table)
{	
	#Holds the SAT seperators.
	sats <- c(100, 200, 300, 400, 500, 600, 700, 800);
	
	satFrame <- data.frame(SATVerb100= c(), SATVerb200= c(), SATVerb300= c(), 
										SATVerb400= c(), SATVerb500= c(), SATVerb600= c(), 
										SATVerb700= c(), SATVerb800= c());
	
	#SAT subcounter
	satSubCount <- c();
	
	#SAT counter
	satCounter <- c();
		
	#Go through and makes all of the SAT bins
	for(sat in sats)
	{
		#Clear the sat column.
		satSubCount <- c();
		
		#Goes through all of the zipcodes
		for(zip in zips)
		{
			#Go through bins of 100.
			satCounter <- table$Zip[table$Zip == zip & 
				table$SATVerbal <= sat & 
				table$SATVerbal > sat-100];
			
			#Append the calculated SAT value to the zipcode.
			satSubCount <- c(satSubCount, length(satCounter)); 
		
		}
			

	}

	#Returns the SATbins.
	#return (satSubCount);
}

#Sorts the table into bins to seperate the SAT math values.
satMathHelperFunction <- function(zip, table)
{
	#SAT subcounter
	satSubCount <- c();

	#SAT counter
	satCounter <- c();

	#Holds the SAT seperators.
	sats <- c(100, 200, 300, 400, 500, 600, 700, 800);
	
	#Go through and makes all of the SAT bins
	for(sat in sats)
	{
		satCounter <- table$Zip[table$Zip == zip & 
			table$SATMath <= sat & 
			table$SATMath > sat-100]

		satSubCount <- c(satSubCount, length(satCounter)); 
	}

	#Returns the SATbins for the zipcode.
	return (satSubCount);
}

#Sorts the gpa values
gpaHelperFunction <- function(table)
{
	#Holds the gpa seperators.
	gpa <- c(1.0, 2.0, 3.0, 4.0);

}