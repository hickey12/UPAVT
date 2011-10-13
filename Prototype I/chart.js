//File: chart.js; Authors: Max Ackley; Last modified: 18 Sep 2011 @ 7:25 PM
//Adapted from original code by: Dr. Tanya Crenshaw, University of Portland

var bar = d3.select("body")
            .select(".chart")
            .select(".info")
            .append("div")
            .attr("class", "bar");
            
var label = d3.select("body")
            .select(".chart")
            .select(".labels")
            .append("div")
            .attr("class","label");            
           
d3.csv("hsdata.csv", function(data) {
    // Convert strings to numbers.
    data.forEach(function(d) {
        d.value = parseInt(d.value);
    });

    bar.selectAll("div")
            .data(data)
            .enter().append("div")
            .style("width", function(d) { return d.value * 0.50 + "px"; })
            .text(function(d) { return d.value; });
                  
    label.selectAll("div")
            .data(data)
            .enter().append("div")
            .text(function(d) {return d.label});             
});


