<!--# RoxygenReady
Prepare your R function library to be compiled into an R package by Roxygen-->
<!--      site under construction-->

[**Roxygen2**](https://cran.r-project.org/web/packages/roxygen2/index.html) is an awesome tool to easily create a package from your function library. 

[**RoxygenReady**](https://github.com/vertesy/RoxygenReady) helps in creating the function annotations needed to compile a proper package (where help() works for your functions!) by **Roxygen2**.

## Workflow: stream lined package creation

1. *You start out with your .R file containing your favorite scripts*

 		print11more <- function(n=1, m=1) { # a function with real added value
			print (n+(11*m))
		}

- *Create function annotation scaffold by **RoxygenReady** from all functions in your script.*

		#' print11more
		#'
		#' # a function with real added value
		#' @param n
		#' @param m
		#' @examples print11more(n=1, m=1)
		#' @export


		print11more <- function(n=1, m=1) {
			print (n+(11*m))
		}


- After compiling and installing you package,
	- your functions have a working help

![](/Users/abelvertesy/RoxygenReady/Images/03.b.Final.png)


- You can share it on github and everyone can super easily install your package.
	


## Installation

Install directly from github via devtools:

```
# install.packages("devtools")
devtools::install_github(username ="vertesy" ,repo = "RoxygenReady", subdir = "RoxygenReady")
require("RoxygenReady")
```

## Package content

A couple of functions to generate inline description from your functions, using their names and arguments as input. These can be later parsed by Roxygen to proper package's help section
An example inline description:


## How to create an R package (overview)
> check: Workflow_to_Create_an_R_Package.R for details

1. Write or collect your favorite functions into an R script 
-  Create a new package by **roxygen2**'s `create()` function, copy your function script.
- **Prepare** in-line documentation **with RoxygenReady**
- Manual editing of in-line description
- **Compile** a package & documentation **by roxygen2**
- **Install** your package locally
- Test your package
- Upload to github
- Share it with others

<br>
*Check out a great introduction to writing your first package in R by [Hillary Parker](http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/)*


 <br/> <br/> <br/> <br/> <br/>
[*edit the website*](https://github.com/vertesy/RoxygenReady/generated_pages/new)