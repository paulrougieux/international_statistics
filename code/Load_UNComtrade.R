# This script loads data from the UN COMTRADE website
# Author: Paul Rougieux, European Forest Institute
#
# Input: csv or sdmx files
# Output: data frames stored in a .RDATA file



# Try to download a SDMX file from UNCOMTRADE
# It seems it's an HTML file instead of what I want
download.file("http://comtrade.un.org/db/dqBasicQueryResultsd.aspx?action=sdmx&cc=TOTAL&px=H2&r=372&y=2006", 
              destfile="rawdata/comtrade_Ireland_Exports")

# Try to download a csv file from UNCOMTRADE
download.file("http://comtrade.un.org/db/dqBasicQueryResultsd.aspx?action=csv&cc=TOTAL&px=H2&r=372&y=2006",
              destfile="rawdata/comtrade_Ireland_Exports.csv")




# Based on http://technistas.com/2012/06/11/using-rest-apis-from-r/
# Delete if not used
library("RCurl")
library("XML")
