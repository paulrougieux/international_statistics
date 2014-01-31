Load international statistics online
====================================
__Input__: online databases from EUROSTAT, UNCOMTRADE, FAOSTAT and World Bank

__Output__: Documents with sample visualisation of the datasets relevant to forest sector analysis.

__R modules used__: FAOSTAT, SmarterPoland

__Author__: Paul Rougieux, European Forest Institute



Data sources 
------------
### EUROSTAT
Employment data
* See [employment.md](docs/EUROSTAT/Employment.md) or [employment.html](docs/EUROSTAT/Employment.html)
* See also code/load Eurostat.R


### UN COMTRADE
* See code/UNComtrade.R


### FAOSTAT
Use the FAOSTAT module. Lastest version on github.


### World Bank
Use the FAOSTAT module.

Folder structure
--------------
./code contains load scripts. 

./rawdata contains loaded datasets to be used by other scripts.

./docs contains documents with data visualisation.


Git 
---
Project versions are tracked by Git. 
I ignore automatically generated files: .png images, .pdf and .html documents in all subfolders.
The ./rawdata folder contains a .gitignore so that it's bulky content is not backed-up.
```
*
!.gitignore
```
