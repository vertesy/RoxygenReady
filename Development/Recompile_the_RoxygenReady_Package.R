######################################################################################################
# Recompile_the_RoxygenReady_Package.R
######################################################################################################
# ~/RoxygenReady/Development/Recompile_the_RoxygenReady_Package.R
rm(list=ls(all.names = TRUE));
try(dev.off())

# Functions ------------------------
try (source ('~/Github_repos/TheCorvinas/R/CodeAndRoll.R'),silent= F)
library(devtools, roxygen2)

# Setup ------------------------

PackageDir = 	"~/Github_repos/RoxygenReady/"
PackageName = 	"RoxygenReady"
fname = 	kollapse(PackageName,".R")
Package_FnP = 	kollapse(PackageDir, PackageName, "/R/", fname)
Our_FnP = 	kollapse(PackageDir, PackageName, "/", fname)
DESCRIPTION <- list("Title" = "A package documentation generator.",
					"Authors@R" = 'person(given = "Abel", family = "Vertesy", email = "a.vertesy@hubrecht.eu", role = c("aut", "cre"))',
					"Description" = "Prepare your function-script to compile into a package by Roxygen2",
					"License" = "GNU GPL 3"
)

setwd(PackageDir)
if ( !dir.exists(PackageName) ) { create(PackageName, description = DESCRIPTION) }



# Compile a package ------------------------------------------------
setwd("~/Github_repos/RoxygenReady/RoxygenReady")
getwd()
document()


# Install your package ------------------------------------------------
setwd(PackageDir)
install(PackageName)
require("RoxygenReady")

# Test your package ------------------------------------------------
help("rr_extract_all_descriptions_from_comment")

