#Author Trever Hickey
#Date Created: Oct 3, 2011
#Date Modified: Oct 3, 2011

#This function goes through all of the CSV files, assumed to be those used
#by admissions and parses the data into a summary of admission data by state.
stateCount <- c();

evalStateData <- function() {	
	
	#Initializes variables to null
	acceptedCount <- NULL;
	appliedCount <- NULL;
	interestCount <- NULL;
	enrolledCount <- NULL
	stateSummary <- NULL;

	path <- NULL;

	#Creates a state variable.
	states <- c(1:50);
	
	#stores all states into a variable.

	# TLC: Save a vector of state names.  Do not use the built-in
        #  names() function.  I'm not sure what your intention was for
        #  using names(), but I don't think it does what you think it
        #  does.  Not sure.  At any rate, just save a plain old vector
        #  of state names.

	states <- c("AL", "AK", "AZ", "AR", "CA", "CO", 
	"CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", 
	"KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", 
	"MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", 
	"ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", 
	"TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY");
	
	#list all of the csv files in home directory
	filenames <- list.files(pattern=".csv");

	#determine how many csv files there are.
	n <- length(filenames);

	#go through each file and create a state level summary.

	#append the admissions data to a list.
	admissionsData <- c();

	#Go through each file sequentially
	for(i in filenames) {

		#load the csv file
		schoolTable <- read.csv(i, header=TRUE, stringsAsFactors=FALSE);
		
		#Get the year
		year <- schoolTable$EntryYear[1];

		# look for each state
		for(state in states)
		{
			interestCounter <- schoolTable$Zip[schoolTable$State == state];
			#Counts how many people are interested from a state
			interestCount <- c(interestCount, length(interestCounter));
			
			appliedCounter <- schoolTable$Applied[schoolTable$State == state & schoolTable$Applied == "Y"];
			#Counts how many people applied from a state
			appliedCount <- c(appliedCount, length(appliedCounter));

			acceptedCounter <- schoolTable$Accepted[schoolTable$State == state &schoolTable$Accepted == "A"];
			#Counts how many were accepted
			acceptedCount <- c(acceptedCount, length(acceptedCounter));

			enrolledCounter <- schoolTable$Enrolled[schoolTable$State == state & schoolTable$Enrolled == "Y"];
			#Counts how many students enrolled from a state
			enrolledCount <- c(enrolledCount, length(enrolledCounter));


		}

		# Once a state is complete, create a data frame to store these entries in a table
		stateSummary <-(data.frame(State = states, Interested=interestCount, Applied=appliedCount, Accepted=acceptedCount, Enrolled=enrolledCount));
		
		#Store into state level directory
		path <- "schoolData/";
		dir.create(path);

		path <- paste("schoolData/", year, sep="");
		dir.create(path);
		


		filename <- paste(path, "/summary", as.character(year), ".csv", sep="");
		write.csv(stateSummary, filename);
	}
}