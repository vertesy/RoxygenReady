## funnames2



#' descriptor_roxy
#'
#' Description ...
#' @param ls_funs list of functions to include in the package: list names should be exact function names in the NAMESPACE,list elements should be the functions.
#' @param OutputFile Full path and file name of the file the Roxygen-ready script is written to
#' @examples descriptor_roxy(ls_funs = funnames2, OutputFile = Package_FnP)
#' @export

descriptor_roxy <-function (ls_funs, OutputFile) {
	write(kollapse("## ", substitute(ls_funs), " \n\n", print = F), file = OutputFile)
	funnames = names(ls_funs)
	for (i in 1:l(ls_funs)) {
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
		nr_of_args = l(argz)
		for (j in 1:nr_of_args) {
			desc[[j + 3]] = kollapse(s, "@param ", argz[j], " ", print = F)
		}
		desc[[nr_of_args + 4]] = kollapse(s, "@examples ", match.call(), print = F)
		desc[[nr_of_args + 5]] = kollapse(s, "@export \n")
		write(desc, file = OutputFile, append = T)
		code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
		code_ = print(gsub("	", "\t", code_, perl = T))
		code = c(kollapse(funnames[i], " <-", code_[1:2], print = F), code_[3:l(code_)], sep = "\n")
		write(code, file = OutputFile, append = T)
	}
}


#' descriptor_roxy.singleFunction
#'
#' Description ...
#' @param function_to_parse name of the function in the memory space to parse into a new file
#' @param OutputFile Full path and file name of the file the Roxygen-ready script is written to
#' @examples descriptor_roxy(ls_funs = funnames2, OutputFile = Package_FnP)
#' @export

descriptor_roxy.singleFunction <-function (function_to_parse, OutputFile) {
	if (!is.function(function_to_parse)) {
		any_print("No function called", function_to_parse)
	}
	s = "#' "
	desc = NULL
	funname = substrRight(match.call()[1], n = 100)
	desc[[1]] = kollapse(s, funname, " ", print = F)
	desc[[2]] = s
	desc[[3]] = kollapse(s, "Copy fun. description from inline comments", print = F)
	argz = names(formals(fun = function_to_parse))
	i = 2
	for (a in argz) {
		i = i + 1
		desc[[i + 1]] = kollapse(s, "@param ", a, " ", print = F)
	}
	desc[[l(argz) + 4]] = kollapse(s, "@examples ", match.call(), print = F)
	desc[[l(argz) + 5]] = kollapse(s, "@export")
	Clipboard_Copy(desc)
	print(desc, quote = F)
	write(desc, file = OutputFile)
	write("", file = OutputFile, append = T)
	code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
	code_ = print(gsub("	", "\t", code_, perl = T))
	code = c(kollapse(funname, " <-", code_[1:2], print = F), code_[3:l(code_)], sep = "\n")
	write(code, file = OutputFile, append = T)
}

#' descriptor_roxy.headerOnly
#'
#' Description ...
#' @param function_to_parse name of the function in the memory space to parse to clipboard
#' @examples descriptor_roxy(ls_funs = funnames2, OutputFile = Package_FnP)
#' @export

descriptor_roxy.headerOnly <-function (function_to_parse) {
	if (!is.function(function_to_parse)) {
		any_print("No function called", function_to_parse)
	}
	s = "#' "
	desc = NULL
	funname = substrRight(match.call()[1], n = 100)
	desc[[1]] = kollapse(s, funname, " ", print = F)
	desc[[2]] = s
	desc[[3]] = kollapse(s, "Copy fun. description from inline comments", print = F)
	argz = names(formals(fun = function_to_parse))
	i = 2
	for (a in argz) {
		i = i + 1
		desc[[i + 1]] = kollapse(s, "@param ", a, " ", print = F)
	}
	desc[[l(argz) + 4]] = kollapse(s, "@examples ", match.call(), print = F)
	desc[[l(argz) + 5]] = kollapse(s, "@export")
	Clipboard_Copy(desc)
	print(desc, quote = F)
	print("", quote = F)
	print("", quote = F)
	print("		 >>> Function header is also copied to your clipboard")
}
