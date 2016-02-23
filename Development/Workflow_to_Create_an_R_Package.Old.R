######################################################################################################
# Workflow_to_Create_an_R_Package.R
######################################################################################################
# source("/Users/abelvertesy/RoxygenReady/Workflow_to_Create_an_R_Package.R")
rm(list=ls(all = TRUE));
try(dev.off())

# Functions ------------------------
try (source ('/Users/abelvertesy/TheCorvinas/R/CodeAndRoll.R'),silent= F)
# install.packages("roxygen2")
library(devtools, roxygen2)

# Setup ------------------------

PackageDir = 	"/Users/abelvertesy/RoxygenReady/"
PackageName = 	"RoxygenReady"
	fname = 	kollapse(PackageName,".R")
Package_FnP = 	kollapse(PackageDir, PackageName, "/R/", fname)
Our_FnP = 	kollapse(PackageDir, PackageName, "/", fname)
DESCRIPTION <- list("Title" = "Package documentation generator ",
					"Authors@R" = 'person(given = "Abel", family = "Vertesy", email = "a.vertesy@hubrecht.eu", role = c("aut", "cre"))',
					"Description" = "Prepare your function-script to compile into a package by Roxygen2",
					"License" = "GNU GPL 3"
					)

setwd(PackageDir)
if ( !dir.exists(PackageName) ) { create(PackageName, description = DESCRIPTION) }


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
# alternatively the above is wrapped into a function: get_all_function_names_in_a_script(Input_FnP)

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
require("RoxygenReady")

# Test your package ------------------------------------------------
help("descriptor_roxy")

# Test if you can install from github ------------------------------------------------
devtools::install_github(username ="vertesy" ,repo = "TheCorvinas", subdir = "R/R_Packages/RoxygenReady")
require("RoxygenReady")

# Clean up if not needed anymore ------------------------------------------------
# installed.packages()
# remove.packages("RoxygenReady")
