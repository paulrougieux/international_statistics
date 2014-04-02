Load international statistics online
====================================
__Input__: online databases from EUROSTAT, UNCOMTRADE, FAOSTAT and World Bank

__Output__: Documents with sample visualisation of the datasets relevant to forest sector analysis.

__R modules used__: FAOSTAT, SmarterPoland

__Author__: Paul Rougieux, European Forest Institute


The goal is to help reserachers in need of forest related statistics by
* Harvesting forest relevant statistics from different sources.
* Presenting information in a reusable form 

Inspirational platforms presenting global data:
* OECD data explorer
* EUROSTAT map gis
* World bank data 

Data sources 
------------
### EUROSTAT
Employment data
* See [employment.md](docs/EUROSTAT/Employment.md) or [employment.html](docs/EUROSTAT/Employment.html)
* See also code/load Eurostat.R


### UN COMTRADE
* See code/load_UNComtrade.R
You will need to create an account on [UN data API](https://www.undata-api.org/docs). 
The script downloads datasets as JSON or XML files from undata-api.org.


### FAOSTAT
Use the [FAOSTAT package](https://github.com/mkao006/FAOSTATpackage). Lastest version on github.

* See docs bilateral trade
 * Add discrepancies between reported reported import and exports (start with US-Canada or US-Brasil trade)


### World Bank
Use the [FAOSTAT package](https://github.com/mkao006/FAOSTATpackage).


Programming
-----------
### Folder structure
./code contains load scripts. 

./rawdata contains loaded datasets to be used by other scripts.

./docs contains documents with data visualisation.


### Git 
Project versions are tracked by Git. 
I ignore automatically generated files: .png images, .pdf and .html documents in all subfolders.
The ./rawdata folder contains a .gitignore so that it's bulky content is not backed-up.
```
*
!.gitignore
```

Paul comments
-------------

### PDF reports
With the following commant I could make a pdf report from a markdown document, 
but there is a problem with html tables 
```
pandoc("docs/bilateral_trade/sawnwood.md", format='latex')
```

