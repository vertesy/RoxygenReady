## RoxygenReady.R


#' funnotator_RoxygenReady
#'
#' Compile and write out all functions documentation in a script for Roxygen (Extended version)
#' @param FileWithFunctions An .R file containing all the function definitions of your library
#' @param outFile Filename and path where the annotated version will be written out
#' @examples funnotator_RoxygenReady (FileWithFunctions =  , outFile = kollapse(FileWithFunctions, ".annot.R", print = F))
#' @export

funnotator_RoxygenReady <-function (FileWithFunctions, outFile = kollapse(FileWithFunctions, ".annot.R", print = F)) {
	x = strsplit(FileWithFunctions, split = "/")[[1]]
	ScriptName = x[length(x)]
	write(kollapse("## ", ScriptName, "\n\n", print = F), file = outFile)
	list_of_functions = rr_extract_all_function_names_in_a_script(FileWithFunctions)
	funnames = names(list_of_functions)
	commentz = rr_extract__all_descriptions_from_comment(FileWithFunctions)
	for (i in 1:l(list_of_functions)) {
		function_to_parse = list_of_functions[[i]]
		if (!is.function(function_to_parse)) {
			any_print("No function called", funnames[i])
		}
		s = "#' "
		desc = NULL
		desc[[1]] = kollapse(s, funnames[i], " ", print = F)
		desc[[2]] = s
		desc[[3]] = kollapse(s, commentz[i], print = F)
		argz = names(formals(fun = function_to_parse))
		nr_of_args = l(argz)
		for (j in 1:nr_of_args) {
			desc[[j + 3]] = kollapse(s, "@param ", argz[j], " ", print = F)
		}
		desc[[nr_of_args + 4]] = kollapse(s, "@examples ", funnames[i], " (", rr_extract_default_args(funnames[i]),
			")", print = F)
		desc[[nr_of_args + 5]] = kollapse(s, "@export \n", print = F)
		write(desc, file = outFile, append = T)
		code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
		code_ = gsub(paste0("  ", "  "), "\t", code_, perl = T)
		code = c(kollapse(funnames[i], " <-", code_[1:2], print = F), code_[3:l(code_)], sep = "\n")
		write(code, file = outFile, append = T)
	}
}

#' rr_extract_all_function_names_in_a_script
#'
#' Scan a script for function's defined there.
#' @param inFile input file with function definitions to be scanned
#' @examples rr_extract_all_function_names_in_a_script (inFile =  )
#' @export

rr_extract_all_function_names_in_a_script <-function (inFile) {
	ScriptAsStringsPerLine = readLines(inFile)
	source(inFile)
	patt = " *<- *function *\\(.+"
	index = grep(patt, ScriptAsStringsPerLine, perl = T)
	funnames = gsub(patt, "", ScriptAsStringsPerLine[index])
	funnames = as.list(gsub("[[:space:]]*$", "", funnames))
	list_of_functions = lapply(funnames, get)
	names(list_of_functions) = funnames
	return(list_of_functions)
}


#' rr_extract__all_descriptions_from_comment
#'
#' Scan a script for (descriptive) comments in the first line of each function's definition.
#' @param inFile input file with function definitions to be scanned
#' @examples rr_extract__all_descriptions_from_comment (inFile =  )
#' @export

rr_extract__all_descriptions_from_comment <-function (inFile) {
	ScriptAsStringsPerLine = readLines(inFile)
	patt = " *<- *function *\\(.+"
	index = grep(patt, ScriptAsStringsPerLine, perl = T)
	FirstLineComments = gsub(".+# ", "", ScriptAsStringsPerLine[index])
	funnames = gsub(patt, "", ScriptAsStringsPerLine[index])
	funnames = as.list(gsub("[[:space:]]*$", "", funnames))
	names(FirstLineComments) = funnames
	return(FirstLineComments)
}


#' rr_extract_default_args
#'
#' get the defaults argument calls of a function
#' @param function_to_parse Name of the function with the arguments of interest.
#' @examples rr_extract_default_args (yaFun =  )
#' @export

rr_extract_default_args <-function (function_to_parse) {
	a = as.named.vector(formals(function_to_parse))
	a[a == ""] = " "
	return(paste(names(a), a, sep = " = ", collapse = ", "))
}


#' funnotator_RoxygenReady.headerOnly
#'
#' Compile a single functions documentation for Roxygen
#' @param function_to_parse Name of the function with the arguments of interest.
#' @examples funnotator_RoxygenReady.headerOnly (function_to_parse =  )
#' @export

funnotator_RoxygenReady.headerOnly <-function (function_to_parse) {
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


#' funnotator_RoxygenReady.singleFunction
#'
#' Compile and write out a single functions documentation for Roxygen
#' @param function_to_parse Name of the function with the arguments of interest.
#' @param outFile Filename and path where the annotated version will be written out
#' @examples funnotator_RoxygenReady.singleFunction (function_to_parse =  , outFile = )
#' @export

funnotator_RoxygenReady.singleFunction <-function (function_to_parse, outFile) {
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
	write(desc, file = outFile)
	write("", file = outFile, append = T)
	code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
	code_ = print(gsub("	", "\t", code_, perl = T))
	code = c(kollapse(funname, " <-", code_[1:2], print = F), code_[3:l(code_)], sep = "\n")
	write(code, file = outFile, append = T)
}


#' descriptor_roxy_old
#'
#' Compile and write out all functions documentation in a script for Roxygen
#' @param FuncNames a vector of function names (of functions in the memory space) to be annotated
#' @param outFile Filename and path where the annotated version will be written out
#' @examples descriptor_roxy_old (FuncNames =  , outFile)
#' @export

descriptor_roxy_old <-function (FuncNames, outFile) {
	write(kollapse("## ", substitute(FuncNames), " \n\n", print = F), file = outFile)
	funnames = names(FuncNames)
	for (i in 1:l(FuncNames)) {
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
		write(desc, file = outFile, append = T)
		code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
		code_ = print(gsub("	", "\t", code_, perl = T))
		code = c(kollapse(funnames[i], " <-", code_[1:2], print = F), code_[3:l(code_)], sep = "\n")
		write(code, file = outFile, append = T)
	}
}
