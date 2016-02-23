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

RepositoryDir = 	"/Users/abelvertesy/RoxygenReady/"
PackageName = 	"RoxygenReady"
	fname = 	kollapse(PackageName,".R")

PackageDir = kollapse(RepositoryDir, PackageName)
Package_FnP = 	kollapse(PackageDir, "/R/", fname)
# file.exists(Package_FnP)
# dir.exists(PackageDir)
DESCRIPTION <- list("Title" = "Package documentation generator ",
					"Authors@R" = 'person(given = "Abel", family = "Vertesy", email = "a.vertesy@hubrecht.eu", role = c("aut", "cre"))',
					"Description" = "Prepare your function-script to compile into a package by Roxygen2",
					"License" = "GNU GPL 3"
					)

setwd(RepositoryDir)
if ( !dir.exists(PackageName) ) { create(PackageName, description = DESCRIPTION) }


# go and write fun's ------------------------------------------------------------------------
file.edit(Package_FnP)


# Extract all function names from the script ------------------------------------------------
source(Package_FnP)

funnotator_RoxygenReady(Package_FnP)

# replace output files ------------------------------------------------
BackupOldFile = 	kollapse(Package_FnP, ".bac", print = F)
AnnotatedFile = 	kollapse(Package_FnP, ".annot.R", print = F)
file.copy(from = Package_FnP, to = BackupOldFile, overwrite = T)
file.copy(from = AnnotatedFile, to = Package_FnP, overwrite = T)

# Manual editing of descriptors ------------------------------------------------
file.edit(Package_FnP)

# Compile a package ------------------------------------------------
setwd(PackageName)
getwd()
document()

# Install your package ------------------------------------------------
setwd(RepositoryDir)
install(PackageName)
require("RoxygenReady")
# Test your package ------------------------------------------------
help("funnotator_RoxygenReady")
help("print11more")

# Test if you can install from github ------------------------------------------------
devtools::install_github(username ="vertesy" ,repo = "TheCorvinas", subdir = "R/R_Packages/RoxygenReady")
require("RoxygenReady")

# Clean up if not needed anymore ------------------------------------------------
# installed.packages()
# remove.packages("RoxygenReady")
