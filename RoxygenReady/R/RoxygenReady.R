## RoxygenReady.R

#' kollapse
#'
#' # paste0 values and string to one string. It also prints the results (good for a quick check)
#' @param ...
#' @param print
#' @examples kollapse("Hello ", "you ", 3, ", " , 11, " year old kids.")
#' @export

kollapse <- function(..., print =T) {
	if (print==T) {print (paste0(c(...), collapse = "")) }
	paste0(c(...), collapse = "")
}

#' substrRight
#'
#' # Take the right substring of a string
#' @param x
#' @param n
#' @examples substrRight  ("Not cool", n=4)
#' @export

substrRight <- function (x, n){
	substr(x, nchar(x)-n+1, nchar(x))
}

#' toClipboard
#'
#' # Copy an R-object to your clipboard on OS X.
#' @param x
#' @param sep
#' @param header
#' @param row.names
#' @param col.names
#' @examples toClipboard(11)
#' @export

toClipboard <- function(x, sep="\t", header=FALSE, row.names=FALSE, col.names =F) { # Copy an R-object to your clipboard on OS X.
	write.table(x, pipe("pbcopy"), sep=sep, row.names=row.names, col.names =col.names, quote = F)
}

#' RoxygenReady.FileToFile
#'
#' Read in a file, annotate and write out all functions documentation with Roxygen skeleton (FileToFile)
#' @param FileWithFunctions An .R file containing all the function definitions of your library
#' @param outFile Filename and path where the annotated version will be written out
#' @param overview If true, a function overview .md file is created next to your input file. See rr_function_overview_document() for details.
#' @examples
#' @export

RoxygenReady <-function (FileWithFunctions, outFile = kollapse(FileWithFunctions, ".annot.R", print = F, overview = T)) {
	x = strsplit(FileWithFunctions, split = "/")[[1]]
	ScriptName = x[length(x)]
	write(kollapse("## ", ScriptName, "\n\n", print = F), file = outFile)
	list_of_functions = rr_extract_all_function_names_in_a_script(FileWithFunctions)
	funnames = names(list_of_functions)
	commentz = rr_extract_all_descriptions_from_comment(FileWithFunctions)
	for (i in 1:length(list_of_functions)) {
		function_to_parse = list_of_functions[[i]]
		if (!is.function(function_to_parse)) {
			any_print("     No function called: ", funnames[i])
		} else { print(funnames[i]) }
		s = "#' "
		desc = NULL
		desc[[1]] = kollapse(s, funnames[i], " ", print = F)
		desc[[2]] = s
		desc[[3]] = kollapse(s, commentz[i], print = F)
		argz = names(formals(fun = function_to_parse))
		nr_of_args = length(argz)
		for (j in 1:nr_of_args) {
			desc[[j + 3]] = kollapse(s, "@param ", argz[j], " ", print = F)
		}
		desc[[nr_of_args + 4]] = kollapse(s, "@examples ", funnames[i], " (", rr_extract_default_args(funnames[i]),
			")", print = F)
		desc[[nr_of_args + 5]] = kollapse(s, "@export \n", print = F)
		write(desc, file = outFile, append = T)
		code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
		code_ = gsub(paste0("  ", "  "), "\t", code_, perl = T)
		code = c(kollapse(funnames[i], " <-", code_[1:2], print = F), code_[3:length(code_)], sep = "\n")
		write(code, file = outFile, append = T)
		if (overview) { rr_function_overview_document(FileWithFunctions) }
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


#' rr_extract_all_descriptions_from_comment
#'
#' Scan a script for (descriptive) comments in the first line of each function's definition.
#' @param inFile input file with function definitions to be scanned
#' @examples rr_extract_all_descriptions_from_comment (inFile =  )
#' @export

rr_extract_all_descriptions_from_comment <-function (inFile) {
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

#' rr_function_overview_document
#'
#' Create a Markdown document with a numbered list of all functions and their descriptions from the "inFile", saved right next to it!
#' @param inFile File with the funcitons to be listed and displayed in a .md file.
#' @param outFile The location of the created markdown document with the list of functions in the  "inFile". By default, it saves next to it, with the extension ".FunctionOverview.md".
#' @examples rr_function_overview_document (inFile =  , outFile = paste0(inFile, ".FunctionOverview.md"))
#' @export

rr_function_overview_document <-function (inFile, outFile = paste0(inFile, ".FunctionOverview.md") ) { # Create a Markdown document with a numbered list of all functions and their descriptions from the "inFile", saved right next to it!
	FunctionNames = names(rr_extract_all_function_names_in_a_script(inFile) )
	n = length(FunctionNames)
	FunctionNames = paste0("### ", (1:n), ". ",names(rr_extract_all_function_names_in_a_script(inFile) ) )
	Descriptions = paste0("- ", rr_extract_all_descriptions_from_comment(inFile) )

	FunctionNames = FunctionNames[order(FunctionNames)]
	Descriptions = Descriptions[order(FunctionNames)] # Reorder by
	body = paste0( "\n\n", FunctionNames, "\n", Descriptions)
	write("## Function Overview", file = outFile)
	write("You find the list of function of this library below. For details, please use the `help()` function. <br>", file = outFile, append = T)
	write(body, file = outFile, append = T)

}


#' RoxygenReady.MemoryToClipboard.singleFunction
#'
#' Compile a single functions documentation for Roxygen
#' @param function_to_parse Name of the function with the arguments of interest.
#' @examples RoxygenReady.MemoryToClipboard (function_to_parse =  )
#' @export

RoxygenReady.MemoryToClipboard.singleFunction <-function (function_to_parse) { #' Compile a single functions documentation for Roxygen
	if (!is.function(function_to_parse)) {
		any_print("No function called", function_to_parse)
	}
	s = "#' "
	desc = NULL
	funname = substitute(function_to_parse)
	commentz =gsub(".+# ", "", capture.output(function_to_parse) [1])
	desc[[1]] = kollapse(s, funname, " ", print = F)
	desc[[2]] = s
	desc[[3]] = kollapse(s, commentz, print = F)
	argz = names(formals(fun = function_to_parse))
	i = 2
	for (a in argz) {
		i = i + 1
		desc[[i + 1]] = kollapse(s, "@param ", a, " ", print = F)
	}
	desc[[length(argz) + 4]] = kollapse(s, "@examples ", funname, " (", rr_extract_default_args(function_to_parse), ")", print = F)
	desc[[length(argz) + 5]] = kollapse(s, "@export \n", print = F)
	print(desc, quote = F)
	code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
	code_ = print(gsub("	", "\t", code_, perl = T))
	code = c(kollapse(funname, " <-", code_[1:2], print = F), code_[3:length(code_)], sep = "\n")
	toClipboard(c(desc, code))
	print("		 >>> Function header is also copied to your clipboard")
}


#' RoxygenReady.MemoryToFile.singleFunction
#'
#' Compile and write out a single functions documentation for Roxygen
#' @param function_to_parse Name of the function with the arguments of interest.
#' @param outFile Filename and path where the annotated version will be written out
#' @examples RoxygenReady.singleFunction.MemoryToFile (function_to_parse =  , outFile = )
#' @export


RoxygenReady.MemoryToFile.singleFunction <-function (function_to_parse, outFile) {
	if (!is.function(function_to_parse)) {
		any_print("No function called", function_to_parse)
	}
	s = "#' "
	desc = NULL
	funname = substitute(function_to_parse)
	commentz =gsub(".+# ", "", capture.output(function_to_parse) [1])
	desc[[1]] = kollapse(s, funname, " ", print = F)
	desc[[2]] = s
	desc[[3]] = kollapse(s, commentz, print = F)
	argz = names(formals(fun = function_to_parse))
	i = 2
	for (a in argz) {
		i = i + 1
		desc[[i + 1]] = kollapse(s, "@param ", a, " ", print = F)
	}
	desc[[length(argz) + 4]] = kollapse(s, "@examples ", funname, " (", rr_extract_default_args(function_to_parse), ")", print = F)
	desc[[length(argz) + 5]] = kollapse(s, "@export \n", print = F)
	print(desc, quote = F)
	write(desc, file = outFile)
	write("", file = outFile, append = T)
	code_ = noquote(deparse(function_to_parse, width.cutoff = 100L))
	code_ = print(gsub("	", "\t", code_, perl = T))
	code = c(kollapse(funname, " <-", code_[1:2], print = F), code_[3:length(code_)], sep = "\n")
	# toClipboard(c(desc, code))
	write(code, file = outFile, append = T)
}

