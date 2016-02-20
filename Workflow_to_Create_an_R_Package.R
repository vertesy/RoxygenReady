######################################################################################################
# Workflow_to_Create_an_R_Package.R
######################################################################################################
# source("/Users/abelvertesy/RoxygenReady/Workflow_to_Create_an_R_Package.R")
rm(list=ls(all = TRUE));
try(dev.off())

# Functions ------------------------
try (source ('/Users/abelvertesy/TheCorvinas/R/Rfunctions_AV.R'),silent= F)

# Setup ------------------------
# install.packages("roxygen2")
library(devtools, roxygen2)

PackageDir = 	"/Users/abelvertesy/TheCorvinas/R/R_Packages/"
PackageName = 	"Roxerator"
	fname = 	kollapse(PackageName,".R")
Package_FnP = 	kollapse(PackageDir, PackageName, "/R/", fname)
Our_FnP = 	kollapse(PackageDir, PackageName, "/", fname)
DESCRIPTION <- list("Title" = "Package documentation generator ",
					"Authors@R" = 'person(given = "Abel", family = "Vertesy", email = "a.vertesy@hubrecht.eu", role = c("aut", "cre"))',
					"Description" = "Prepare your function-script to compile into a package by Roxygen2"
					)

setwd(PackageDir)
create(PackageName, description = DESCRIPTION)


# go and write fun's ------------------------------------------------------------------------
file.edit(Package_FnP)

# Extract all function names from the script ------------------------------------------------
source(Package_FnP)
ScriptAsStringsPerLine = readLines(Package_FnP)
patt = ' <- function\\(.+'
index = grep( patt, ScriptAsStringsPerLine)
funnames = gsub(patt, "", ScriptAsStringsPerLine[index]) 				# Changes every occurrence of a pattern match
funnames = as.list(gsub("[[:space:]]*$","",funnames)) 	# remove trailing spaces

funnames2 = lapply(funnames, get)
names(funnames2) = funnames
funnames2

# Create Roxy-ready prepared script as a copy ------------------------------------------------
file.copy(from = Package_FnP, to = kollapse(Package_FnP, ".bac", print = F))
descriptor_roxy(funnames2, OutputFile = Package_FnP)

# Manual editing of descriptors ------------------------------------------------
file.edit(Package_FnP)

# Compile a package ------------------------------------------------
getwd()
document()


# Install your package ------------------------------------------------
setwd(PackageDir)
install(PackageName)
require("Roxerator")

# Test your package ------------------------------------------------
help("descriptor_roxy")

# Test if you can install from github ------------------------------------------------
devtools::install_github(username ="vertesy" ,repo = "TheCorvinas", subdir = "R/R_Packages/Roxerator")
require("RoxygenReady")

# Clean up if not needed anymore ------------------------------------------------
# installed.packages()
# remove.packages("RoxygenReady")
