//FILE: controller.js
//AUTHOR: jace raile
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
function getValues(form) 
{
	//initialize vars
	var groupOption = "Group: "
    var metricOption = "Metric: ";
    var yearOption = "Year: ";
    
    //for each element in the form...
    for (var i = 0; i < form.elements.length; i++ ) {
    	
    	//get which "group" button is checked
        if (form.elements[i].name == "groups") {
            if (form.elements[i].checked == true) {
                groupOption += form.elements[i].value + ' ';
            }
        }
        
        //and which "metric" button is checked
        if (form.elements[i].name == "metrics") {
            if (form.elements[i].checked == true) {
                metricOption += form.elements[i].value + ' ';
            }
        }
        
        //and which "year" button is checked
        if (form.elements[i].name == "years") {
            if (form.elements[i].checked == true) {
                yearOption += form.elements[i].value + ' ';
            }
        }
    }
    
    //update globals
    selectedGroup = groupOption;
    selectedMetric = metricOption;
    selectedYear = yearOption;
    
    //for now, write these values to the page.
    document.getElementById("groupOption").innerHTML = selectedGroup;
    document.getElementById("metricOption").innerHTML = selectedMetric;
    document.getElementById("yearOption").innerHTML = selectedYear;
    
}//end getValues