# Load FAOSTAT data
# Author Paul Rougieux


# Source function from the other project FOREST Products Demand.
source("code/func.R")

# Structure of the FAO list of functions
str(FAO)

# Load Raw data for wood residues
FAO$itemname(1620)
residues <- FAO$download(1620, 5516, 5616, 5622, 5916, 5922)

save(residues, file="rawdata/residues.RDATA")
