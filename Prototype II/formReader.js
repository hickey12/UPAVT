//FILE: formReader.js
//AUTHOR: Jace Raile
//MODIFIED: 15 October 2011

//USAGE: contains functions that index.html and map.js will use to display the proper information

/*
 * Globals!
 */
	var selectedLocation;
	var selectedGroup;
	var selectedMetric;
	var selectedYear;
	var selectedGPA;
	var selectedMath;
	var selectedVerbal;
	var selectedGender;
	var importantMetric;

/*
 * getFormValues(<form> formname)
 * 
 * finds all the elements within a form and gets the value
 * associated with the checked radio button for each
 * category referecned by names: 'group', 'metric' and 'year'
 * 
 * @param form - the name of the form one wishes to search for elements
 */
function getFormValues(form) 
{
	//initialize vars
	var locationOption = "";
	var groupOption = "";
    var metricOption = "";
    var yearOption = "";
    var gpaOption = "";
    var mathOption = "";
    var verbalOption = "";
    var genderOption = "";
    
    //for each element in the form...
    for (var i = 0; i < form.elements.length; i++ ) {
    	
    	//get which location the user has selected
    	if (form.elements[i].name == "Location") {
        	locationOption += form.elements[i].value;
        }
    	
    	//get which "group" button is checked
        if (form.elements[i].name == "groups") {
            if (form.elements[i].checked == true) {
                groupOption += form.elements[i].value;
            }
        }
        
        //and which "metric" button is checked
        if (form.elements[i].name == "metrics") {
            if (form.elements[i].checked == true) {
                metricOption += form.elements[i].value;
            }
        }
        
        //get the metric drop-down-menu values
        if (form.elements[i].name == "gpaSelector") {
        	gpaOption += form.elements[i].value;
        }
        
        if (form.elements[i].name == "satMathSelector") {
        	mathOption += form.elements[i].value;
        }
        
        if (form.elements[i].name == "satVerbalSelector") {
        	verbalOption += form.elements[i].value;
        }
        
        if (form.elements[i].name == "genderSelector") {
        	genderOption += form.elements[i].value;
        }
                
        //and which "year" button is checked
        if (form.elements[i].name == "years") {
            if (form.elements[i].checked == true) {
                yearOption += form.elements[i].value;
            }
        }
    }
    
    //update globals
    selectedLocation = locationOption;
    selectedGroup = groupOption;
    selectedMetric = metricOption;
    selectedYear = yearOption;
    selectedGPA = gpaOption;
	selectedMath = mathOption;
	selectedVerbal = verbalOption;
	selectedGender = genderOption;
	
	//we only care about the drop-down associated with the selected metric
	switch(selectedMetric)
	{
		case "None":
			importantMetric = "None";
			break;
		case "GPA":
			importantMetric = selectedGPA;
			break;
		case "SAT Math":
			importantMetric = selectedMath;
			break;
		case "SAT Verbal":
			importantMetric = selectedVerbal;
			break;
		case "Male / Female":
			importantMetric = selectedGender;
			break;
		case "Visited":
			importantMetric = "Visited";
			break;
		default:
			importantMetric = "ERROR";
	}
    
    //create associative array
	var optionSettings = {};
	optionSettings['location'] = selectedLocation;
	optionSettings['group'] = selectedGroup;
	optionSettings['metric'] = selectedMetric;
	optionSettings['year'] = selectedYear;
	optionSettings['dropVal'] = importantMetric;
	
	return optionSettings;    
}//end getValues


function getPath(settings) {
	var year = settings['year'];
	var group = settings['group'];
    var state = settings['location'];
    var metric = settings['metric'];
    if (metric != "None") {
    	var metricBin = settings['dropVal'];
    }
    var path = "./dataParsing/schoolData/" + year + "/" + state;
    
    switch(metric) {
		case "None":
			path += "/summary" + year + state + ".csv";
			break;
		case "GPA":
			path += "/gpa" + year + state + metricBin + ".csv";
			break;
		case "SAT Math":
			path += "/satMath" + year + state + metricBin + ".csv";			
			break;
		case "SAT Verbal":
			path += "/satVerbal" + year + state + metricBin + ".csv";
			break;
		case "Male / Female":
			path += "/gender" + year + state + metricBin + ".csv";
			break;
		case "Visited":
			path += "/visited" + year + state + "V.csv";
			break;
		default:
			break;
	}
	
	return path;

}
