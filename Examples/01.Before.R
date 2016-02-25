# Example Functions

rescale <- function(vec, from=0, upto=100) { # linear transformation to a given range of values
	vec = vec-min(vec, na.rm = T)
	vec = vec*((upto-from)/max(vec, na.rm = T))
	vec = vec+ from
	return (vec)
} # fun


pc_TRUE <- function(logical_vector, percentify =T) { # Percentage of true values in a logical vector, parsed as text (useful for reports.)
	out = sum(logical_vector, na.rm=T) / length(logical_vector)
	if (percentify) {out = percentage_formatter (out) }
	return(out)
}
