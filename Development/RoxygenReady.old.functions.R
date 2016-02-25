## RoxygenReady.R


#' RoxygenReady.old
#'
#' Compile and write out all functions documentation in a script for Roxygen
#' @param FuncNames a vector of function names (of functions in the memory space) to be annotated
#' @param outFile Filename and path where the annotated version will be written out
#' @examples descriptor_roxy_old (FuncNames =  , outFile)
#' @export

RoxygenReady.old <-function (FuncNames, outFile) {
	write(kollapse("## ", substitute(FuncNames), " \n\n", print = F), file = outFile)
	funnames = names(FuncNames)
	for (i in 1:length(FuncNames)) {
		function_to_parse = get(funnames[i])
		if (!is.function(function_to_parse)) {
			any_print("No function called", funnames[i])
		}
		s = "#' "
		desc = NULL
		desc[[1]] = kollapse(s, funnames[i], " ", print = F)
		desc[[2]] = s
		desc[[3]] = kollapse(s, "Description ...", print = F)
		argz = names(formals(fun = function_to_parse))
		nr_of_args =length(argz)
		for (j in 1:nr_of_args) {
			desc[[j + 3]] = kollapse(s, "@param ", argz[j], " ", print = F)
		}
		desc[[nr_of_args + 4]] = kollapse(s, "@examples ", match.call(), print = F)
		desc[[nr_of_args + 5]] = kollapse(s, "@export \n")
		write(desc, file = outFile, append = T)
		code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
		code_ = print(gsub("	", "\t", code_, perl = T))
		code = c(kollapse(funnames[i], " <-", code_[1:2], print = F), code_[3:length(code_)], sep = "\n")
		write(code, file = outFile, append = T)
	}
}
