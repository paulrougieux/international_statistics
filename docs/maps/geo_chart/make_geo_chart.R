# Make an html file fom a R data frame of country values
# Pass a list to the function 
# For the mutli maps page, I could make several lists
# One for 

library(xtable)

html <- list()
html$before_data_table <- "<html>
  <head>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
    <script type='text/javascript'>
     google.load('visualization', '1', {'packages': ['geochart']});
     google.setOnLoadCallback(drawRegionsMap);

      function drawRegionsMap() {
        var data = google.visualization.arrayToDataTable([
"

html$data_table <- ""

# Add a variable for the region option World or western Europe
html$after_data_table <- "
        ]);

    
          var options = {
     //       width: 600, height: 400,
            region: '150', // Western Europe
          };
      
        var chart = new google.visualization.GeoChart(document.getElementById('chart_div'));
        chart.draw(data, options);
    };
    </script>
  </head>
  <body>"

html$header1 <- ""
html$end_of_file <- "<div id='chart_div' style='width: 900px; height: 500px;'></div>
  </body>
</html>"

geo_chart_page <- function(dtf, title = "", region = 150){
    #' @description Makes an html page that contains a google geo chart 
    #' a choropleth maps corresponding to the list of countries
    #' values will be mapped to a color gradient
    #' 
       #' @param dtf : dataframe with a column "country" a column "value" 
       #'              and a column "element" that has a unique value
       #'              This "element" will be the name displayed on 
       #'              hovering countries witht the mouse
       #' @param title : title of the page
       #' @param region : 
       #' 
       #' @author Paul Rougieux    
    
    html$data_table = paste(c(paste0("['Country','", unique(dtf$element),"'],"), 
                              paste0("['",dtf$country,"',", dtf$value,"],")), 
                            collapse="\n")
    html$header1 = paste("<h1>", title, "</h1>", collapse="")
    cat(as.character(html), 
        file=paste0("docs//maps//geo_chart/", title,".html"))
}


# geo_chart_page <- function()
# Makes several geo_charts on one page
# based on a list of lists containg data frames, titles, value, name
# add following variables in html list
# html$drawRegionsMap <- 

if(FALSE) {
    # Load data for testing purposes
    load("enddata/sawnwood_flows_Europe.RDATA")
    # France imports
    fr <- subset(sawnwood_europe, reporting_country =="France" &
                     partner_EU & year ==2011 & 
                     element=="Import Quantity (m3)" & item=="Sawnwood (C)")
    # Rename country column
    names(fr)[names(fr)=="partner_country"] <- "country"
    geo_chart_page(fr,"French Sawnwood (C) Imports in 2011")

    # Finland exports
    fi <- subset(sawnwood_europe, reporting_country =="Finland" &
                     partner_EU & year ==2011 & 
                     element=="Export Quantity (m3)" & item=="Sawnwood (C)")
    # Rename country column
    names(fi)[names(fi)=="partner_country"] <- "country"
    geo_chart_page(fi,"Finland Sawnwood (C) Exports in 2011")
    
    
}
