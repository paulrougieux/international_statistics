International Forest Statistics
===============================
This set of programms loads forest products and related statistics from online databases.
It uses the R programming language.

Metadata
* __Input__: online databases from EUROSTAT, UNCOMTRADE, FAOSTAT and World Bank
* __Output__: Documents with sample visualisation of the datasets relevant to forest sector analysis.
* __R modules used__: FAOSTAT, SmarterPoland
* __Author__: Paul Rougieux, European Forest Institute

Notice: Trade flow scripts and data moved to "trade_flows" project
---------------------------------------------------------
Remove notice when complete.

Goals:
* Harvest forest relevant statistics from different sources
* Present information in a reusable form 

Inspirational data platforms:
On general topics
* [Gapminder](http://www.gapminder.org)
* [OECD data lab](http://www.oecd.org/statistics/datalab/)
On environmental/forest topics
*[EEA Indicators, increment and fellings](http://www.eea.europa.eu/data-and-maps/indicators/forest-growing-stock-increment-and-fellings/forest-growing-stock-increment-and)

Other data platforms (move this to a wiki):
* [Open Data for Africa](http://opendataforafrica.org/IMFPCP2014Jan/imf-primary-commodity-prices-january-2014)
* EUROSTAT map gis
* World bank [World Integrated Trade Solution](http://wits.worldbank.org/Default.aspx), summary trade statistics.

R data hackers:
* [Markus Kainu](http://markuskainu.fi/r-tutorial/index.html) 
   manipulates eurostat data related to social sciences

Data sources 
------------
### EUROSTAT
* Access throught the library SmarterPoland
* Could also be accessed through the [EU Open Data portal](http://open-data.europa.eu/en/data/)
* See code/load Eurostat.R

Related work: 
* On forest sector employment data, see [employment.md](docs/EUROSTAT/Employment.md) or [employment.html](docs/EUROSTAT/Employment.html)
* [Mapping Data from Eurostat using R](http://rpubs.com/adam_dennett/8955)


### UN COMTRADE
* [UN data API](https://www.undata-api.org/docs). 
See code/load_UNComtrade.R. To access the API, you'll need to create an account.
The script downloads datasets as JSON or XML files from undata-api.org.


### FAOSTAT
* Access through the [FAOSTAT package](https://github.com/mkao006/FAOSTATpackage/raw/master/Documentation/FAOSTAT.pdf)
 * _"Compiling hundreds of statistics from different sources under 
    traditional approach such as Excel can be very labour intensive and error proned.
     Furthermore, the knowledge and the experience is almost impossible to
     sustain in the long run resulting in inconsistent results
    and treatments over time. As a result, the ESS took the initiative 
    to use R and LATEX as the
    new architecture for a sustainable and cost-effective way to 
    produce the statistical yearbook.
    This approach increases the sustainability and coherence 
    of the publication as all the data
    manipulation, and exceptions are recorded in the source code."_
 * Lastest version on [github](https://github.com/mkao006/FAOSTATpackage)
* A sample download of agriculture data can be seen in the FAOSTAT vignette
* See docs bilateral trade


### World Bank
* Use the [FAOSTAT package](https://github.com/mkao006/FAOSTATpackage).



Output 
------
### Output formats
* Reports
 * PDF
* Processed data
 * Excel, csv (comma separated values)
* visualisations
 * Maps, 
 See for example [geo_chart](docs/maps/geo_chart2.html)
 * Charts

### Crossing data sources
* Forest sector employment 
 * per 1000 ha of forest
 * per 1000 $m^3$ of wood produced
* Forest products consumption
 * per capita


Programming
-----------
### Folder structure
* ./code contains load scripts. 
* ./rawdata contains loaded datasets to be used by other scripts.
* ./docs contains documents with data visualisation.


### Git 
Project versions are tracked by Git. 
I ignore automatically generated files:
.png images, .pdf and .html documents in all subfolders.
The ./rawdata folder contains a .gitignore 
so that it's bulky content is not backed-up.
```
*
!.gitignore
```


Paul comments
-------------

### Writing to Excel
* I could use [Xlconnect](http://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf) to write data to Excel
 * [Presentation of XLconnect](http://files.meetup.com/2968362/RBelgium5_XLConnect.pdf) with short use examples
* I have been using XLSX until now. 
  I might stick to xlsx since it uses the same underlying
[Apache POI](http://poi.apache.org/) as XLconnect anyway.
 * See also [Apache POI case studies](http://poi.apache.org/casestudies.html)

### Maps
* Google geo chart is a way to generate choropleth maps from a country-value 
    data table.
* [Google fusion table](https://www.google.com/fusiontables/DataSource?dsrcid=implicit&redirectPath=data&usp=apps_start&hl=en&pli=1) is a way to produce maps. It has an automatic geocoding. But I didn't manage to produce a map of Europe.
* See other examples in the docs/maps folder

### Feature requests
* With the following commant I could make a pdf report from a markdown document, 
but there is a problem with html tables
    ```
    pandoc("docs/bilateral_trade/sawnwood.md", format='latex')
    ```
    I'd rather stick to the usual Rnw files to generating PDFs.
 * The knitr function "kable" might help there?
* In docs/residues.Rmd remove countries with 0 production before plotting.
 *  Done 
* Make a R package, check if there is a package called 
    "forestat", "foreststat" or "oef".


