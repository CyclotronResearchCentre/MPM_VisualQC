function ss_boxplot_html(fid_html,full_list,subj_val,y_title,minVal,maxVal)




fprintf(fid_html,'<!-- Create a div where the graph will take place --> \n');

fprintf(fid_html,'<div id="my_dataviz"></div> \n');



fprintf(fid_html,'<script> \n');


fprintf(fid_html,'// set the dimensions and margins of the graph \n');

fprintf(fid_html,'var margin = {top: 10, right: 10, bottom: 30, left: 60}, \n');

fprintf(fid_html,'  width = 120 - margin.left - margin.right, \n');

fprintf(fid_html,'  height = 200 - margin.top - margin.bottom; \n');


fprintf(fid_html,'// append the svg object to the body of the page \n');

fprintf(fid_html,'var svg = d3.select("#my_dataviz") \n');

fprintf(fid_html,'.append("svg") \n');

fprintf(fid_html,'  .attr("width", width + margin.left + margin.right) \n');

fprintf(fid_html,'  .attr("height", height + margin.top + margin.bottom) \n');

fprintf(fid_html,'.append("g") \n');

fprintf(fid_html,'  .attr("transform", \n');

fprintf(fid_html,'        "translate(" + margin.left + "," + margin.top + ")"); \n');


fprintf(fid_html,'// create dummy data \n');

% data

data_tmp = [];
for i=1:length(full_list)
    if i==length(full_list)
        data_tmp = strcat(data_tmp,sprintf('%.2f',full_list(i)));
    else
        data_tmp = strcat(data_tmp,sprintf('%.2f',full_list(i)),',');
    end
end

% fprintf(fid_html,'var data = [12,19,11,13,12,22,12,14,15,16,17,18,19,15] \n');
fprintf(fid_html,'var data = [%s] \n',data_tmp);

fprintf(fid_html,'var data2 = [%0.2f] \n',subj_val);


fprintf(fid_html,'// Compute summary statistics used for the box: \n');

fprintf(fid_html,'var data_sorted = data.sort(d3.ascending) \n');

fprintf(fid_html,'var q1 = d3.quantile(data_sorted, .25) \n');

fprintf(fid_html,'var median = d3.quantile(data_sorted, .5) \n');

fprintf(fid_html,'var q3 = d3.quantile(data_sorted, .75) \n');

fprintf(fid_html,'var interQuantileRange = q3 - q1 \n');

fprintf(fid_html,'var min = q1 - 1.5 * interQuantileRange \n');

fprintf(fid_html,'var max = q3 + 1.5 * interQuantileRange \n');


fprintf(fid_html,'// Show the Y scale \n');

fprintf(fid_html,'var y = d3.scaleLinear() \n');

% fprintf(fid_html,'  .domain([0,25]) \n');
fprintf(fid_html,'  .domain([%0.2f,%0.2f]) \n',minVal,maxVal);

fprintf(fid_html,'  .range([height, 0]); \n');

fprintf(fid_html,'svg \n');

fprintf(fid_html,'  .append("g") \n');

fprintf(fid_html,'  .call(d3.axisLeft(y)) \n');

fprintf(fid_html,'// Add Y axis \n');

fprintf(fid_html,'// var y = d3.scaleLinear().domain([0, 100]).range([ height, 0]); \n');


fprintf(fid_html,'// svg \n');

fprintf(fid_html,'//   .append("g") \n');

fprintf(fid_html,'// .call(d3.axisLeft(y)); \n');

fprintf(fid_html,'// Y axis label: \n');
fprintf(fid_html,'svg.append("text") \n');
fprintf(fid_html,'    .attr("text-anchor", "end") \n');
fprintf(fid_html,'    .attr("transform", "rotate(-90)") \n');
fprintf(fid_html,'    .attr("y", -margin.left+20) \n');
fprintf(fid_html,'    .attr("x", -margin.bottom) \n');
fprintf(fid_html,'    .text("%s") \n',y_title);


fprintf(fid_html,'// a few features for the box \n');
fprintf(fid_html,'var center = 20 \n');
fprintf(fid_html,'var width = 20 \n');

fprintf(fid_html,'// Show the main vertical line \n');
fprintf(fid_html,'svg \n');
fprintf(fid_html,'.append("line") \n');
fprintf(fid_html,'  .attr("x1", center) \n');
fprintf(fid_html,'  .attr("x2", center) \n');
fprintf(fid_html,'  .attr("y1", y(min) ) \n');
fprintf(fid_html,'  .attr("y2", y(max) ) \n');
fprintf(fid_html,'  .attr("stroke", "black") \n');

fprintf(fid_html,'// Show the box \n');
fprintf(fid_html,'svg \n');
fprintf(fid_html,'.append("rect") \n');
fprintf(fid_html,'  .attr("x", center - width/2) \n');
fprintf(fid_html,'  .attr("y", y(q3) ) \n');
fprintf(fid_html,'  .attr("height", (y(q1)-y(q3)) ) \n');
fprintf(fid_html,'  .attr("width", width ) \n');
fprintf(fid_html,'  .attr("stroke", "black") \n');
fprintf(fid_html,'  .style("fill", "#69b3a2") \n');

fprintf(fid_html,'// show median, min and max horizontal lines \n');
fprintf(fid_html,'svg \n');
fprintf(fid_html,'.selectAll("toto") \n');
fprintf(fid_html,'.data([min, median, max]) \n');
fprintf(fid_html,'.enter() \n');
fprintf(fid_html,'.append("line") \n');
fprintf(fid_html,'  .attr("x1", center-width/2) \n');
fprintf(fid_html,'  .attr("x2", center+width/2) \n');
fprintf(fid_html,'  .attr("y1", function(d){ return(y(d))} ) \n');
fprintf(fid_html,'  .attr("y2", function(d){ return(y(d))} ) \n');
fprintf(fid_html,'  .attr("stroke", "black") \n');
  


fprintf(fid_html,'// Add individual points with jitter \n');
fprintf(fid_html,'var jitterWidth = 10 \n');
fprintf(fid_html,'svg \n');
fprintf(fid_html,'.selectAll("indPoints") \n');
fprintf(fid_html,'.data(data) \n');
fprintf(fid_html,'.enter() \n');
fprintf(fid_html,'.append("circle") \n');
fprintf(fid_html,'  .attr("cx", function(d){return(center+25 - jitterWidth/2 + Math.random()*jitterWidth )}) \n');
fprintf(fid_html,'  .attr("cy", function(d){return(y(d))}) \n');
fprintf(fid_html,'  .attr("r", 4) \n');
fprintf(fid_html,'  .style("fill", "white") \n');
fprintf(fid_html,'  .attr("stroke", "black") \n');
  
  
  

fprintf(fid_html,'var jitterWidth = 10 \n');
fprintf(fid_html,'svg \n');
fprintf(fid_html,'.selectAll("indPoints") \n');
fprintf(fid_html,'.data(data2) \n');
fprintf(fid_html,'.enter() \n');
fprintf(fid_html,'.append("circle") \n');
fprintf(fid_html,'  .attr("cx", function(d){return(center)}) \n');
fprintf(fid_html,'  .attr("cy", function(d){return(y(d))}) \n');
fprintf(fid_html,'  .attr("r", 4) \n');
fprintf(fid_html,'  .style("fill", "black") \n');
fprintf(fid_html,'  .attr("stroke", "black") \n');
  

fprintf(fid_html,'</script> \n');

end