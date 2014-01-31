Forest sector employment in the European Union
========================================================
This scripts loads forestry datasets from EUROSTAT and displays data.

Original datasets and metadata can be viewed on the [eurostat website](http://epp.eurostat.ec.europa.eu/portal/page/portal/forestry/data/database). See also the Eurostat working group on [forestry statistics and accounts](https://circabc.europa.eu/w/browse/8be55496-f9fe-4c00-923e-bbebf52f0ec6).

There was a change in classification in 2008. Therefore EUROSTAT has 2 employment tables for the forest sector: "for_emp_lfs1" Before 2008 and "for_emp_lfs" after 2008. We pull data from those 2 tables and mix them in some graph. Be aware that the employment figures before and after 2008 __are not comparable__. The difference by country for the year 2008 is computed in a table below.

Table of content
----------------
* [Load data from EUROSTAT](#load)
* [Clean data](#clean)
* Plots
 * [Employment by subsector in EU28](#empEU28)
 * [Employment by subsector by country](#empCountry)
* Maps Experimental --> See map3.1 for more details




<a name="load"></a>
Load data from EUROSTAT
---------------------------------------

```r
library(SmarterPoland)
library(ggplot2)
library(xtable)
for_emp_lfs = getEurostatRCV(kod = "for_emp_lfs")
```






Description of the forestry employment datasets
(__for_emp_lfs1__ before 2008 and __for_emp_lfs__ after 2008) :
* __unit__:
* __sex__: female (F), male (M) or total (T)
* __isced97__: education level
* __wstatus__, working status: employed persons (EMP), employees (SAL), self employed persons (SELF)
* __nace_r2__, sub sector of employment, forestry, manufacture of wood products or manufacture of paper products (see also below)
* __geo__: geographical area
* __time__: year
* __value__: number of employed persons in thousand

Sub-sectors of employment in forestry datasets:
* Before 2008, in for_emp_lfs1 : A0202, DD20, DE21
* After 2008, in for_emp_lfs : A02, C16, C17

<a name="clean"></a>
### Clean data

```r
# Change time to a numeric value
for_emp_lfs1$time = as.numeric(as.character(for_emp_lfs1$time))
for_emp_lfs$time = as.numeric(as.character(for_emp_lfs$time))

# Add a readable description of subsector of employment.  Rename column and
# factor values.  levels() keeps these columns as factor (The use of factors
# may not be needed).
for_emp_lfs1$subsector = for_emp_lfs1$nace_r1
levels(for_emp_lfs1$subsector)[levels(for_emp_lfs1$nace_r1) == "A0202"] = "Forestry and logging"
levels(for_emp_lfs1$subsector)[levels(for_emp_lfs1$nace_r1) == "DD20"] = "Manufacture of wood products except furniture"
levels(for_emp_lfs1$subsector)[levels(for_emp_lfs1$nace_r1) == "DE21"] = "Manufacture of paper products"

# Same manipulation for data after 2008
for_emp_lfs$subsector = for_emp_lfs$nace_r2
levels(for_emp_lfs$subsector)[levels(for_emp_lfs$nace_r2) == "A02"] = "Forestry and logging"
levels(for_emp_lfs$subsector)[levels(for_emp_lfs$nace_r2) == "C16"] = "Manufacture of wood products except furniture"
levels(for_emp_lfs$subsector)[levels(for_emp_lfs$nace_r2) == "C17"] = "Manufacture of paper products"
```



Plots 
-----
<a name="empEU28"></a>
### Employment by subsector in EU28
Before 2001, there is no aggregated EU data, 
however country level data is available (from 1992 onwards, see below).

Number of employees before 2008 with subsector classification nace_r1

```r
EU28_r1 = subset(for_emp_lfs1, sex == "T" & isced97 == "TOTAL" & wstatus == 
    "EMP" & geo == "EU28" & time > 2001)
p = ggplot() + geom_point(data = EU28_r1, aes(x = time, y = value, color = subsector)) + 
    ylab("Thousand employees")
# plot(p) # Uncomment to plot only before 2008
```


Number of employees after 2008 with subsector classification nace_r2

```r
EU28 = subset(for_emp_lfs, sex == "T" & isced97 == "TOTAL" & wstatus == "EMP" & 
    geo == "EU28")
p + geom_point(data = EU28, aes(x = time, y = value, color = subsector))
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 



<a name="empCountry"></a>
### Employment by subsector by country
Time series before 2008

```r
emp1 = subset(for_emp_lfs1, sex == "T" & isced97 == "TOTAL" & wstatus == "EMP" & 
    !is.na(value) & !geo %in% c("EA13", "EA17", "EA18", "EU15", "EU27", "EU28"))
p = ggplot() + geom_line(data = emp1, aes(x = time, y = value, color = subsector)) + 
    ylab("Thousand employees") + scale_x_continuous(breaks = seq(1990, 2010, 
    10), limits = c(1990, 2013))
# plot(p + facet_wrap(~geo)) # Uncomment to plot only before 2008
```


Time series before and after 2008

```r
# Select countries only
emp = subset(for_emp_lfs, sex == "T" & isced97 == "TOTAL" & wstatus == "EMP" & 
    !is.na(value) & !geo %in% c("EA13", "EA17", "EA18", "EU15", "EU27", "EU28"))
p = p + geom_line(data = emp, aes(x = time, y = value, color = subsector))
```


Plot employment by country with a fixed scale

```r
plot(p + facet_wrap(~geo))
```

```
## geom_path: Each group consist of only one observation. Do you need to adjust the group aesthetic?
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 


Plot employment by country with a free scale

```r
plot(p + facet_wrap(~geo, scales = "free_y"))
```

```
## geom_path: Each group consist of only one observation. Do you need to adjust the group aesthetic?
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


### Compare 2008 values between first and second classification.

```r
emp1_8 = emp1[emp1$time == 2008, c("subsector", "geo", "value")]
emp$valueNewClassif = emp$value
emp_8 = emp[emp$time == 2008, c("subsector", "geo", "valueNewClassif")]
empComp = merge(emp1_8, emp_8)

empComp$diff = empComp$value - empComp$valueNewClassif
empComp = transform(empComp, diff = valueNewClassif - value, diffPercent = round((valueNewClassif - 
    value)/value * 100))
print(xtable(empComp), row.names = FALSE, type = "html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-1 package -->
<!-- Thu Jan 23 14:32:06 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> subsector </TH> <TH> geo </TH> <TH> value </TH> <TH> valueNewClassif </TH> <TH> diff </TH> <TH> diffPercent </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Forestry and logging </TD> <TD> AT </TD> <TD align="right"> 10.80 </TD> <TD align="right"> 12.10 </TD> <TD align="right"> 1.30 </TD> <TD align="right"> 12.00 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Forestry and logging </TD> <TD> BE </TD> <TD align="right"> 3.40 </TD> <TD align="right"> 3.10 </TD> <TD align="right"> -0.30 </TD> <TD align="right"> -9.00 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Forestry and logging </TD> <TD> CH </TD> <TD align="right"> 8.20 </TD> <TD align="right"> 7.20 </TD> <TD align="right"> -1.00 </TD> <TD align="right"> -12.00 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Forestry and logging </TD> <TD> CY </TD> <TD align="right"> 0.90 </TD> <TD align="right"> 0.90 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Forestry and logging </TD> <TD> CZ </TD> <TD align="right"> 30.80 </TD> <TD align="right"> 30.90 </TD> <TD align="right"> 0.10 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Forestry and logging </TD> <TD> DE </TD> <TD align="right"> 42.90 </TD> <TD align="right"> 44.20 </TD> <TD align="right"> 1.30 </TD> <TD align="right"> 3.00 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Forestry and logging </TD> <TD> DK </TD> <TD align="right"> 2.70 </TD> <TD align="right"> 2.70 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Forestry and logging </TD> <TD> EE </TD> <TD align="right"> 7.20 </TD> <TD align="right"> 7.10 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> Forestry and logging </TD> <TD> EL </TD> <TD align="right"> 7.10 </TD> <TD align="right"> 7.10 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> Forestry and logging </TD> <TD> ES </TD> <TD align="right"> 31.80 </TD> <TD align="right"> 31.60 </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD> Forestry and logging </TD> <TD> FI </TD> <TD align="right"> 22.30 </TD> <TD align="right"> 22.70 </TD> <TD align="right"> 0.40 </TD> <TD align="right"> 2.00 </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD> Forestry and logging </TD> <TD> FR </TD> <TD align="right"> 51.40 </TD> <TD align="right"> 48.00 </TD> <TD align="right"> -3.40 </TD> <TD align="right"> -7.00 </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD> Forestry and logging </TD> <TD> HR </TD> <TD align="right"> 15.00 </TD> <TD align="right"> 13.30 </TD> <TD align="right"> -1.70 </TD> <TD align="right"> -11.00 </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD> Forestry and logging </TD> <TD> HU </TD> <TD align="right"> 12.20 </TD> <TD align="right"> 12.80 </TD> <TD align="right"> 0.60 </TD> <TD align="right"> 5.00 </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD> Forestry and logging </TD> <TD> IE </TD> <TD align="right"> 2.00 </TD> <TD align="right"> 2.00 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 16 </TD> <TD> Forestry and logging </TD> <TD> IT </TD> <TD align="right"> 43.10 </TD> <TD align="right"> 42.20 </TD> <TD align="right"> -0.90 </TD> <TD align="right"> -2.00 </TD> </TR>
  <TR> <TD align="right"> 17 </TD> <TD> Forestry and logging </TD> <TD> LT </TD> <TD align="right"> 14.10 </TD> <TD align="right"> 14.70 </TD> <TD align="right"> 0.60 </TD> <TD align="right"> 4.00 </TD> </TR>
  <TR> <TD align="right"> 18 </TD> <TD> Forestry and logging </TD> <TD> LV </TD> <TD align="right"> 16.60 </TD> <TD align="right"> 16.60 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 19 </TD> <TD> Forestry and logging </TD> <TD> NL </TD> <TD align="right"> 2.20 </TD> <TD align="right"> 2.20 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 20 </TD> <TD> Forestry and logging </TD> <TD> NO </TD> <TD align="right"> 4.30 </TD> <TD align="right"> 4.30 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 21 </TD> <TD> Forestry and logging </TD> <TD> PT </TD> <TD align="right"> 16.70 </TD> <TD align="right"> 16.70 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 22 </TD> <TD> Forestry and logging </TD> <TD> RO </TD> <TD align="right"> 50.00 </TD> <TD align="right"> 49.10 </TD> <TD align="right"> -0.90 </TD> <TD align="right"> -2.00 </TD> </TR>
  <TR> <TD align="right"> 23 </TD> <TD> Forestry and logging </TD> <TD> SK </TD> <TD align="right"> 25.60 </TD> <TD align="right"> 25.40 </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 24 </TD> <TD> Forestry and logging </TD> <TD> UK </TD> <TD align="right"> 21.00 </TD> <TD align="right"> 21.00 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 25 </TD> <TD> Manufacture of paper products </TD> <TD> AT </TD> <TD align="right"> 17.20 </TD> <TD align="right"> 17.40 </TD> <TD align="right"> 0.20 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 26 </TD> <TD> Manufacture of paper products </TD> <TD> BE </TD> <TD align="right"> 14.90 </TD> <TD align="right"> 15.10 </TD> <TD align="right"> 0.20 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 27 </TD> <TD> Manufacture of paper products </TD> <TD> CH </TD> <TD align="right"> 10.70 </TD> <TD align="right"> 10.80 </TD> <TD align="right"> 0.10 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 28 </TD> <TD> Manufacture of paper products </TD> <TD> CZ </TD> <TD align="right"> 22.10 </TD> <TD align="right"> 22.40 </TD> <TD align="right"> 0.30 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 29 </TD> <TD> Manufacture of paper products </TD> <TD> DE </TD> <TD align="right"> 144.30 </TD> <TD align="right"> 143.50 </TD> <TD align="right"> -0.80 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 30 </TD> <TD> Manufacture of paper products </TD> <TD> DK </TD> <TD align="right"> 7.00 </TD> <TD align="right"> 7.00 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 31 </TD> <TD> Manufacture of paper products </TD> <TD> EE </TD> <TD align="right"> 2.40 </TD> <TD align="right"> 1.80 </TD> <TD align="right"> -0.60 </TD> <TD align="right"> -25.00 </TD> </TR>
  <TR> <TD align="right"> 32 </TD> <TD> Manufacture of paper products </TD> <TD> EL </TD> <TD align="right"> 8.90 </TD> <TD align="right"> 8.90 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 33 </TD> <TD> Manufacture of paper products </TD> <TD> ES </TD> <TD align="right"> 44.00 </TD> <TD align="right"> 44.00 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 34 </TD> <TD> Manufacture of paper products </TD> <TD> FI </TD> <TD align="right"> 27.30 </TD> <TD align="right"> 27.20 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> -0.00 </TD> </TR>
  <TR> <TD align="right"> 35 </TD> <TD> Manufacture of paper products </TD> <TD> FR </TD> <TD align="right"> 84.70 </TD> <TD align="right"> 84.70 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 36 </TD> <TD> Manufacture of paper products </TD> <TD> HR </TD> <TD align="right"> 5.20 </TD> <TD align="right"> 5.40 </TD> <TD align="right"> 0.20 </TD> <TD align="right"> 4.00 </TD> </TR>
  <TR> <TD align="right"> 37 </TD> <TD> Manufacture of paper products </TD> <TD> HU </TD> <TD align="right"> 14.50 </TD> <TD align="right"> 14.50 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 38 </TD> <TD> Manufacture of paper products </TD> <TD> IT </TD> <TD align="right"> 94.90 </TD> <TD align="right"> 96.20 </TD> <TD align="right"> 1.30 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 39 </TD> <TD> Manufacture of paper products </TD> <TD> LV </TD> <TD align="right"> 1.90 </TD> <TD align="right"> 2.00 </TD> <TD align="right"> 0.10 </TD> <TD align="right"> 5.00 </TD> </TR>
  <TR> <TD align="right"> 40 </TD> <TD> Manufacture of paper products </TD> <TD> NL </TD> <TD align="right"> 22.20 </TD> <TD align="right"> 22.20 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 41 </TD> <TD> Manufacture of paper products </TD> <TD> NO </TD> <TD align="right"> 4.90 </TD> <TD align="right"> 4.90 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 42 </TD> <TD> Manufacture of paper products </TD> <TD> PT </TD> <TD align="right"> 15.60 </TD> <TD align="right"> 15.60 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 43 </TD> <TD> Manufacture of paper products </TD> <TD> RO </TD> <TD align="right"> 15.90 </TD> <TD align="right"> 17.30 </TD> <TD align="right"> 1.40 </TD> <TD align="right"> 9.00 </TD> </TR>
  <TR> <TD align="right"> 44 </TD> <TD> Manufacture of paper products </TD> <TD> SK </TD> <TD align="right"> 9.60 </TD> <TD align="right"> 9.90 </TD> <TD align="right"> 0.30 </TD> <TD align="right"> 3.00 </TD> </TR>
  <TR> <TD align="right"> 45 </TD> <TD> Manufacture of paper products </TD> <TD> UK </TD> <TD align="right"> 71.40 </TD> <TD align="right"> 71.40 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 46 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> AT </TD> <TD align="right"> 49.70 </TD> <TD align="right"> 34.20 </TD> <TD align="right"> -15.50 </TD> <TD align="right"> -31.00 </TD> </TR>
  <TR> <TD align="right"> 47 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> BE </TD> <TD align="right"> 23.50 </TD> <TD align="right"> 23.60 </TD> <TD align="right"> 0.10 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 48 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> CH </TD> <TD align="right"> 38.90 </TD> <TD align="right"> 40.00 </TD> <TD align="right"> 1.10 </TD> <TD align="right"> 3.00 </TD> </TR>
  <TR> <TD align="right"> 49 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> CY </TD> <TD align="right"> 3.50 </TD> <TD align="right"> 3.50 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 50 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> CZ </TD> <TD align="right"> 65.70 </TD> <TD align="right"> 46.10 </TD> <TD align="right"> -19.60 </TD> <TD align="right"> -30.00 </TD> </TR>
  <TR> <TD align="right"> 51 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> DE </TD> <TD align="right"> 143.70 </TD> <TD align="right"> 131.40 </TD> <TD align="right"> -12.30 </TD> <TD align="right"> -9.00 </TD> </TR>
  <TR> <TD align="right"> 52 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> DK </TD> <TD align="right"> 13.70 </TD> <TD align="right"> 13.50 </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 53 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> EE </TD> <TD align="right"> 15.60 </TD> <TD align="right"> 15.20 </TD> <TD align="right"> -0.40 </TD> <TD align="right"> -3.00 </TD> </TR>
  <TR> <TD align="right"> 54 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> EL </TD> <TD align="right"> 27.10 </TD> <TD align="right"> 27.00 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> -0.00 </TD> </TR>
  <TR> <TD align="right"> 55 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> ES </TD> <TD align="right"> 106.40 </TD> <TD align="right"> 104.60 </TD> <TD align="right"> -1.80 </TD> <TD align="right"> -2.00 </TD> </TR>
  <TR> <TD align="right"> 56 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> FI </TD> <TD align="right"> 30.50 </TD> <TD align="right"> 30.80 </TD> <TD align="right"> 0.30 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 57 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> FR </TD> <TD align="right"> 106.70 </TD> <TD align="right"> 96.30 </TD> <TD align="right"> -10.40 </TD> <TD align="right"> -10.00 </TD> </TR>
  <TR> <TD align="right"> 58 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> HR </TD> <TD align="right"> 20.60 </TD> <TD align="right"> 20.60 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 59 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> HU </TD> <TD align="right"> 34.40 </TD> <TD align="right"> 31.80 </TD> <TD align="right"> -2.60 </TD> <TD align="right"> -8.00 </TD> </TR>
  <TR> <TD align="right"> 60 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> IE </TD> <TD align="right"> 7.50 </TD> <TD align="right"> 8.70 </TD> <TD align="right"> 1.20 </TD> <TD align="right"> 16.00 </TD> </TR>
  <TR> <TD align="right"> 61 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> IT </TD> <TD align="right"> 169.10 </TD> <TD align="right"> 166.20 </TD> <TD align="right"> -2.90 </TD> <TD align="right"> -2.00 </TD> </TR>
  <TR> <TD align="right"> 62 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> LT </TD> <TD align="right"> 27.40 </TD> <TD align="right"> 27.60 </TD> <TD align="right"> 0.20 </TD> <TD align="right"> 1.00 </TD> </TR>
  <TR> <TD align="right"> 63 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> LV </TD> <TD align="right"> 28.70 </TD> <TD align="right"> 28.70 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 64 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> NL </TD> <TD align="right"> 25.30 </TD> <TD align="right"> 25.30 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 65 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> NO </TD> <TD align="right"> 16.80 </TD> <TD align="right"> 16.80 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 66 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> PT </TD> <TD align="right"> 57.20 </TD> <TD align="right"> 56.80 </TD> <TD align="right"> -0.40 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 67 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> RO </TD> <TD align="right"> 108.90 </TD> <TD align="right"> 107.60 </TD> <TD align="right"> -1.30 </TD> <TD align="right"> -1.00 </TD> </TR>
  <TR> <TD align="right"> 68 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> SK </TD> <TD align="right"> 29.00 </TD> <TD align="right"> 28.10 </TD> <TD align="right"> -0.90 </TD> <TD align="right"> -3.00 </TD> </TR>
  <TR> <TD align="right"> 69 </TD> <TD> Manufacture of wood products except furniture </TD> <TD> UK </TD> <TD align="right"> 80.40 </TD> <TD align="right"> 80.40 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.00 </TD> </TR>
   </TABLE>


Maps
----
### Map of forest sector employment per 1000 ha of forest

```r

library(maptools)
library(ggplot2)
library(ggmap)

gpclibPermit()  # Test if the General Polygon Clipping Library for R is there
# gpclib is needed otherwise fortify() returns the Error:
# isTRUE(gpclibPermitStatus()) is not TRUE

# read administrative boundaries (change folder appropriately) Data from
# http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco_Geographical_information_maps/popups/references/administrative_units_statistical_units_1
eurMap = readShapePoly(fn = "rawdata/NUTS_2010_60M_SH/data/NUTS_RG_60M_2010")
# plot(eurMap) # Would draw the map of Europe at the NUTS-3 level.

# Transform eurMap to a data frame for use with ggplot2
eurMapDf = fortify(eurMap, region = "NUTS_ID")

# Read downloaded data (change folder appropriately)
eurEdu <- read.csv("rawdata/educ_thexp_1_Data.csv", stringsAsFactors = F)
eurEdu$Value <- as.double(eurEdu$Value)  #format as numeric
################################# Merge map and Employment data # limit data to main Europe
europe.limits <- geocode(c("Cape Fligely, Rudolf Island, Franz Josef Land, Russia", 
    "Gavdos, Greece", "Faja Grande, Azores", "Severny Island, Novaya Zemlya, Russia"))

eurMapDf <- subset(eurMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & 
    lat > min(europe.limits$lat) & lat < max(europe.limits$lat))

# Merge map and data
emp2012 = subset(for_emp_lfs, sex == "T" & isced97 == "TOTAL" & wstatus == "EMP" & 
    !is.na(value) & !geo %in% c("EA13", "EA17", "EA18", "EU15", "EU27", "EU28") & 
    time == 2012 & nace_r2 == "A02")
eurEmpMapDf = merge(eurMapDf, emp2012, by.x = "id", by.y = "geo")

# limit data to main Europe
eurEmpMapDf <- subset(eurEmpMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & 
    lat > min(europe.limits$lat) & lat < max(europe.limits$lat))

# Mapping
m0 <- ggplot(data = eurEmpMapDf)
m1 <- m0 + geom_polygon(aes(x = long, y = lat, group = group, fill = value)) + 
    coord_equal()
m2 <- m1 + geom_path(aes(x = long, y = lat, group = group), color = "black")
m2

```




Future visualisations
---------------------
* Map of forest sector employment per 1000 m^3
* Employment by type (employee or self employed) and by sector
