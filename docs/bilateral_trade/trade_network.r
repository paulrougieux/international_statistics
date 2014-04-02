# See Michael Kao's example on Maize and wine trade
# http://mkao006.blogspot.it/2013/02/maize-trade-part-ii-comparison-and.html
library(plyr)
library(network)



#### Wine trade #####

## Download the data
wine.df = read.csv("https://dl.dropbox.com/u/18161931/wine_trade.csv", header = TRUE,
    stringsAsFactors = FALSE)

## Take only the trade
wineEx.df = subset(wine.df,subset = type == "Export",
    c("reporting_country", "partner_country", "Wine"))

## Sort the data and take only the top 80% of the trade
wineEx.df = arrange(wineEx.df, desc(Wine))
wineEx.df$sWine = scale(wineEx.df$Wine, center = FALSE)
wineEx.df$cs = cumsum(wineEx.df$Wine)
wineEx.df[wineEx.df[, 1] == "China, Hong Kong SAR ", 1] = "China, Hong Kong SAR"
wineFinal.df = subset(wineEx.df, cs < tail(wineEx.df$cs, 1) * 0.8)

## Set edge and arrow size
wineFinal.df$edgeSize = with(wineFinal.df, Wine/sum(Wine))
wineFinal.df$arrowSize = ifelse(wineFinal.df$edgeSize * 30 < 0.5 , 0.5,
    wineFinal.df$edgeSize * 15)

## Create the network and plot
wine.net = network(wineFinal.df[, 1:2])
plot(wine.net, displaylabels = TRUE, label.col = "steelblue",
     edge.lwd = c(wineFinal.df$edgeSize) * 100,
     arrowhead.cex = c(wineFinal.df$arrowSize),
     label.cex = 0.5, vertex.border = "white",
     vertex.col = "skyblue", edge.col = rgb(0, 0, 0, alpha = 0.5))


#### Roundwood trade #####
# Download the data

