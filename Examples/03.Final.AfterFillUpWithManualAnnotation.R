## 01.Before.R


#' rescale
#'
#' linear transformation to a given range of values
#' @param vec The numeric vector to rescale
#' @param from Lower end of the new scale
#' @param upto Upper end of the new scale
#' @examples rescale (vec =  , from = 0, upto = 100)
#' @export

rescale <-function (vec, from = 0, upto = 100) {
	vec = vec - min(vec, na.rm = T)
	vec = vec * ((upto - from)/max(vec, na.rm = T))
	vec = vec + from
	return(vec)
}


#' pc_TRUE
#'
#' Percentage of true values in a logical vector, parsed as text (useful for reports.)
#' @param logical_vector A boolean vector with a certain% of TRUE values.
#' @param percentify Parse to a character vector, ending with % sign. (TRUE / FALSE)
#' @examples pc_TRUE (logical_vector =  , percentify = T)
#' @export

pc_TRUE <-function (logical_vector, percentify = T) {
	out = sum(logical_vector, na.rm = T)/length(logical_vector)
	if (percentify) {
		out = percentage_formatter(out)
	}
	return(out)
}


