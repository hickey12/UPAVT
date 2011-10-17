//FILE: formReader.js
//AUTHOR: Jace Raile
//MODIFIED: 15 October 2011

//USAGE: contains functions that index.html and map.js will use to display the proper information

/*
 * Globals!
 */
	var selectedGroup;
	var selectedMetric;
	var selectedYear;
	
	var selectedGPA;
	var satMathBin;
	var satVerbalBin;

/*
 * getValues(<form> formname)
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
	var groupOption = ""
    var metricOption = "";
    var yearOption = "";
    
    //for each element in the form...
    for (var i = 0; i < form.elements.length; i++ ) {
    	
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
        
        //and which "year" button is checked
        if (form.elements[i].name == "years") {
            if (form.elements[i].checked == true) {
                yearOption += form.elements[i].value;
            }
        }
    }
    
    //update globals
    selectedGroup = groupOption;
    selectedMetric = metricOption;
    selectedYear = yearOption;
    
	var optionSettings = {};
	optionSettings['group'] = selectedGroup;
	optionSettings['metric'] = selectedMetric;
	optionSettings['year'] = selectedYear;
	
	return optionSettings;    
}//end getValues