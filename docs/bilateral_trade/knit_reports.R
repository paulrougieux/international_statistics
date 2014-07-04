# knit reports in pdf and html, 
# make a md page that links to them
# knit that markdonw page as well

library(knitr)
library(plyr)
library(xtable)
library(markdown)
library(ggplot2)

# Load data
load("enddata/roundwood_tropical_cam_indo_us.RDATA")

# Knitr options
opts_chunk$set(fig.width=11, echo=FALSE)
opts_knit$set(base.dir = './docs/bilateral_trade/') # Change the base dir where to save figures

##################
# Create reports #
##################
# A function that create reports based on the template and product endata
create.report <- function(product_trade_data, path="./docs/bilateral_trade/"){
    print(paste0(path, unique(product_trade_data$item),"-",
                 unique(product_trade_data$reporting_country), ".html"))
    knit2html(paste0(path,"template.Rmd"),
              paste0(path, unique(product_trade_data$item),"-",
                     unique(product_trade_data$reporting_country), ".html"), 
              options = c(markdownHTMLOptions(defaults=TRUE), "toc"))
}


################################# #
# Make a report for each country ####
################################# #
# roundwood tropical cameroon
rwd_cam <- subset(roundwood_4_countries, 
                  reporting_country == "Cameroon" & item =="Ind Rwd Wir (NC) Tropica")

# Test report with simple template
# Do this if there is a mistake in the report as knitr can have criptic error messages
# For example in the case of missing variable in inline r code 
# I had a non existing variable in a title `r max(non_existing_variable$year)`
ptd <- rwd_cam
# # Error message shown
# knit2html("docs//bilateral_trade/template.Rmd")
# # Error message not shown
# knit2html("docs//bilateral_trade/template.Rmd", "docs//bilateral_trade/template.html")


create.report(rwd_cam) 

create.report(subset(roundwood_4_countries, 
                     reporting_country == "France" & item =="Ind Rwd Wir (NC) Tropica"))
create.report(subset(roundwood_4_countries, 
                     reporting_country == "France" & item =="Ind Rwd Wir (NC) Other"))
create.report(subset(roundwood_4_countries, 
                     reporting_country == "Indonesia" & item =="Ind Rwd Wir (NC) Tropica"))
create.report(subset(roundwood_4_countries, 
                     reporting_country == "Indonesia" & item =="Ind Rwd Wir (NC) Other"))

