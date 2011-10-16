#Author Trever Hickey
#Date Created: Oct 3, 2011
#Date Modified: Oct 3, 2011

#This function goes through all of the CSV files, assumed to be those used
#by admissions and parses the data into a summary of admission data by state.
evalStateData <- function(state) {	
	
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
		stateSummary <- (data.frame(Zipcodes = zips, Inquiries=inquiryCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));	

		filename <- paste(path, paste("/summary", state, year, sep="_"), ".csv", sep="");;
		write.csv(stateSummary, filename);
	}
}