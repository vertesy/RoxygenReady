################################################################################
######## Before formatting (your function library)
################################################################################


print11more <- function(n=1, m=1) { # a function with real added value
	print (n+(11*m))
}


################################################################################
######## After formatting (by RoxygenReady's "funnotator_RoxygenReady()" function)
################################################################################

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



