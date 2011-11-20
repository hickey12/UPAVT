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
		
		
		return(satMathWrapper(zips, schoolTable));
		
		# Once a zips are complete, create a data frame to store these entries in a table
		stateSummary <- (data.frame(Zipcodes = zips, Inquiries=inquiryCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));	

		filename <- paste(path, paste("/summary", state, year, sep="_"), ".csv", sep="");;
		write.csv(stateSummary, filename);
	}
}

#This is a wrapper function that builds a table that contains how many students
#exist in an sat bin. This will tell us how many students in a zipcode fall into
#a certain sat bin.
satMathWrapper <- function(zips, schoolTable)
{
	#Create all eight required dataframes.
	satMath100 <- satMathHelper(zips, schoolTable, 100, 100);
	satMath200 <- satMathHelper(zips, schoolTable, 100, 200);
	satMath300 <- satMathHelper(zips, schoolTable, 100, 300);
	satMath400 <- satMathHelper(zips, schoolTable, 100, 400);
	satMath500 <- satMathHelper(zips, schoolTable, 100, 500);
	satMath600 <- satMathHelper(zips, schoolTable, 100, 600);
	satMath700 <- satMathHelper(zips, schoolTable, 100, 700);
	satMath800 <- satMathHelper(zips, schoolTable, 100, 800);
	
	#Mere all the data frames together.
	superSATStore <- merge(satMath100, satMath200, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath300, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath400, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath500, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath600, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath700, by="Zipcodes");
	superSATStore <- merge(superSATStore, satMath800, by="Zipcodes");
	
	return (superSATStore);
}


#Builds a data frame of how many people in a zip code are inquired, 
#applied, accepted, and enrolled in UP and fall in a certain range
#of math sat scores.
satMathHelper <- function(zips, schoolTable, size, endLimit)
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
	
	class(schoolTable$SATMAth) <- "numeric";
	
	#Go through all of the zipcodes
	for(zip in zips)
	{
		#Find all applicants interested in a zip code and meet the SAT requirements
		inquiryCounter <- schoolTable$SATMAth[	schoolTable$Zip == zip & schoolTable$SATMAth <= endLimit &
													schoolTable$SATMAth > (endLimit - size)];
		#Append the number of applicants to the list.
		inquiryCount <-c(inquiryCount, length(inquiryCounter));
		
		
		#Find all applicants who applied in a zip code and meet the SAT requirements
		appliedCounter <- schoolTable$SATMAth[	schoolTable$Zip == zip & schoolTable$SATMAth <= endLimit &
												schoolTable$SATMAth > (endLimit - size) &
												schoolTable$Applied == "Y"];
		#Append the number of applicants to the list.
		appliedCount <-c(appliedCount, length(appliedCounter));
		
		
		#Find all applicants who were accepted in a zip code and meet the SAT requirements
		acceptedCounter <- schoolTable$SATMAth[	schoolTable$Zip == zip & schoolTable$SATMAth <= endLimit &
												schoolTable$SATMAth > (endLimit - size) &
												schoolTable$Accepted == "A"];
		#Append the number of applicants to the list.
		acceptedCount <-c(acceptedCount, length(acceptedCounter));
		
		
		#Find all applicants who enrolled in a zip code and meet the SAT requirements
		enrolledCounter <- schoolTable$SATMAth[	schoolTable$Zip == zip & schoolTable$SATMAth <= endLimit &
												schoolTable$SATMAth > (endLimit - size) &
												schoolTable$Enrolled == "Y"];
		#Append the number of applicants to the list.
		enrolledCount <-c(enrolledCount, length(enrolledCounter));
		
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
	names(satMathSummary)[2] <- paste("InqurySATMath", endLimit, sep="");
	names(satMathSummary)[3] <- paste("AppliedSATMath", endLimit, sep="");
	names(satMathSummary)[4] <- paste("AcceptedSATMath", endLimit, sep="");
	names(satMathSummary)[5] <- paste("EnrolledSATMath", endLimit, sep="");
	
	return (satMathSummary);

}