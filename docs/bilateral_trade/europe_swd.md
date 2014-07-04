Europe
========================================================

# There are large discrepancies between reported import and export volumes.
# Should we restric to a year? see France section below


```r
setwd("../..")
load("enddata/sawnwood_flows_Europe.RDATA")
library(plyr)
library(ggplot2)
library(reshape2)
# products of interest
unique(sawnwood_europe$item)
```

```
## [1] "Sawnwood (NC)" "Sawnwood (C)"
```



### Trade flows in EU from 1997 to 2011

```r
# Total volumes reported by EU countries to other countries
tfeu2o <- ddply(subset(sawnwood_europe, reporting_EU),
                .(item, element), summarise, value_EU = sum(value) )

# Total volumes reported by other countries - an EU country is their partner
tfo2eu <- ddply(subset(sawnwood_europe, partner_EU),
                .(item, element), summarise, value_partner = sum(value) )

tfo2eu$element <- sub("Export", "aaa", tfo2eu$element)
tfo2eu$element <- sub("Import", "Export", tfo2eu$element)
tfo2eu$element <- sub("aaa", "Import", tfo2eu$element)
tfeu <- mutate(merge(tfeu2o, tfo2eu), 
               diff_reporting_partner = value_EU - value_partner,
               diff_percent = diff_reporting_partner/value_EU*100) 
# Ther is certainly somehting wrong with these figures.
kable(tfeu)
```



|item          |element                 |  value_EU| value_partner| diff_reporting_partner| diff_percent|
|:-------------|:-----------------------|---------:|-------------:|----------------------:|------------:|
|Sawnwood (C)  |Export Quantity (m3)    | 429250147|     526667982|              -97417835|      -22.695|
|Sawnwood (C)  |Export Value (1000 US$) |  98673709|     128982399|              -30308690|      -30.716|
|Sawnwood (C)  |Import Quantity (m3)    | 462941733|     517322388|              -54380655|      -11.747|
|Sawnwood (C)  |Import Value (1000 US$) | 105206701|     112495462|               -7288761|       -6.928|
|Sawnwood (NC) |Export Quantity (m3)    |  55654608|     110666435|              -55011827|      -98.845|
|Sawnwood (NC) |Export Value (1000 US$) |  22351657|      30633245|               -8281588|      -37.051|
|Sawnwood (NC) |Import Quantity (m3)    |  66394219|     111894380|              -45500161|      -68.530|
|Sawnwood (NC) |Import Value (1000 US$) |  23275492|      47495107|              -24219615|     -104.056|

```r

# Volume of Import from outside to EU

# Voluöe of export from EU to EU
```



# from Europe to Europe

```r
# Volume of import 

```


# Trade flows from France to EU countries

```r
# Total volumes reported by France to EU 
ddply(subset(sawnwood_europe, reporting_country=="France" & partner_EU &
                 year==2011),
      .(item, element), summarise, value_France = sum(value) )
```

```
##            item                 element value_France
## 1  Sawnwood (C)    Export Quantity (m3)       183524
## 2  Sawnwood (C) Export Value (1000 US$)        80260
## 3  Sawnwood (C)    Import Quantity (m3)      2302573
## 4  Sawnwood (C) Import Value (1000 US$)       941670
## 5 Sawnwood (NC)    Export Quantity (m3)       219846
## 6 Sawnwood (NC) Export Value (1000 US$)       122867
## 7 Sawnwood (NC)    Import Quantity (m3)       134017
## 8 Sawnwood (NC) Import Value (1000 US$)       112435
```

```r

# Total volumes reported by other EU countries - France is their partner
ddply(subset(sawnwood_europe, reporting_EU & partner_country=="France" & 
                 year==2011),
      .(item, element), summarise, value_partner = sum(value) )
```

```
##            item                 element value_partner
## 1  Sawnwood (C)    Export Quantity (m3)       2258226
## 2  Sawnwood (C) Export Value (1000 US$)        922561
## 3  Sawnwood (C)    Import Quantity (m3)        211735
## 4  Sawnwood (C) Import Value (1000 US$)         97091
## 5 Sawnwood (NC)    Export Quantity (m3)        168800
## 6 Sawnwood (NC) Export Value (1000 US$)        117618
## 7 Sawnwood (NC)    Import Quantity (m3)        219928
## 8 Sawnwood (NC) Import Value (1000 US$)        125009
```


### Trade flows from France to EU countries all years
How about trade flows with the rest of the world?

```r
# Put this into a function
# plot_tf_eu
# tfc2eu 
# tfeu2c

# Total volumes reported by France to EU 
tffreu <- ddply(subset(sawnwood_europe, reporting_country=="France" & partner_EU),
             .(item, element, year), summarise, value_France = sum(value) )

# Total volumes reported by other EU countries - France is their partner
tfeufr <- ddply(subset(sawnwood_europe, reporting_EU & partner_country=="France"),
      .(item, element, year), summarise, value_partner = sum(value) )

# Replace "Export" by "Import"
tfeufr$element <- sub("Export", "aaa", tfeufr$element)
tfeufr$element <- sub("Import", "Export", tfeufr$element)
tfeufr$element <- sub("aaa", "Import", tfeufr$element)
tffr <- merge(tffreu, tfeufr)

ggplot(data = tffr) +
    geom_point(aes(x = year, y = value_France, col="Reported by France")) + 
    geom_point(aes(x=year, y=value_partner, col="Reported by EU partners")) +
    facet_grid(element ~ item, scales="free_y")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


### Table of Differences 

```r
tffr <- mutate(tffr, diff_France_partner = value_France - value_partner)
# These could be written to Excel
kable(dcast(tffr[c("item", "element", "year", "diff_France_partner")],
                  item + element ~ year, value.var = "diff_France_partner"))
```



|item          |element                 |   1997|    1998|    1999|    2000|    2001|    2002|    2003|   2004|   2005|   2006|   2007|    2008|   2009|   2010|   2011|
|:-------------|:-----------------------|------:|-------:|-------:|-------:|-------:|-------:|-------:|------:|------:|------:|------:|-------:|------:|------:|------:|
|Sawnwood (C)  |Export Quantity (m3)    |   5764|    2805|  -29647|  -18325|  -14536|   58205|   70590|  75728| 101197|      0|   4866|    2897| -13846|  -6553| -28211|
|Sawnwood (C)  |Export Value (1000 US$) |   3287|    -207|    2235|   -5268|     456|    8434|   23076|  28510|  22636|      0|   1759|    1036|   1304|  -3150| -16831|
|Sawnwood (C)  |Import Quantity (m3)    | -71273| -168703| -103541| -174920| -165139| -275975| -896398| -99849| -85622|      0| 323441| -109947|  -1606|  34879|  44347|
|Sawnwood (C)  |Import Value (1000 US$) |  16225|    3767|   16965|  -25547|   49847|   -7065| -200199| -24317|  -7242|      0| -52968|  -39454|   9508|  16365|  19109|
|Sawnwood (NC) |Export Quantity (m3)    |  12606|   36999|   -4382|  -56068|    3745|  106915| -238190|      0|    -79|      0|   4403|   -7059|   2788|   1217|    -82|
|Sawnwood (NC) |Export Value (1000 US$) |  13695|   -5088|    3187|  -37478|  -15181|   17263| -117030|      0|    -23|      0|   3172|   -9444|    808|    906|  -2142|
|Sawnwood (NC) |Import Quantity (m3)    |  22833|    1268|    7589|  -82037|  -45516|  -38727|  -50683| -95142| -64606| -33055| -26370|  -66359| -66711| -41339| -34783|
|Sawnwood (NC) |Import Value (1000 US$) |    434|  -10262|     272|  -36933|  -11998|  -23213|  -28599| -31307| -35223|  -1015|   1421|  -41557|  -7190|  -7498|  -5183|

