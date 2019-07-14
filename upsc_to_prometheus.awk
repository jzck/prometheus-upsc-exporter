#!/usr/bin/awk -f
# Rationale:
# 	The output of upsc contains numerical metrics and strings. The
#	numerical ones are made into prometheus series, while the strings
#	are made into labels that are attaches to series by prefix.

# $1 == metric name
# $2 == metric value
BEGIN { FS=": "; RS="\n" }
# replace dots with underscores
{gsub(/\./,"_",$1)}

# split outlet_N into outletN to make multiple timeseries
$1 ~ /^outlet_[0-9]+/ {gsub("outlet_","outlet",$1)}

# convert status into number
$1 ~ /ups_status/ {
	if ($2 ~ /OL/) {$2 = "0"};
	if ($2 ~ /OB/) {$2 = "1"};
}

# numerical values are metrics
{ if ($2 ~ /^[0-9]*\.?[0-9]+$/) {
	metrics[$1] = $2
}
# non numerical values are metric labels
else {
	prefix = getprefix($1)
	gsub(prefix"_","",$1);
	label=$1;
	value=$2;
	if (labels[prefix] != "")
		labels[prefix]=labels[prefix]", "
	else
		labels[prefix]="{"
	labels[prefix]=labels[prefix]label"=\""value"\"";
}}

# print all ,etrics with corresponding labels
END {
	for (metric in labels) { labels[metric]=labels[metric]"}" }
	for (metric in metrics) {
		prefix = getprefix(metric)
		print "upsc_" metric labels[prefix], metrics[metric]
	}
}

function getprefix(str) {
	n=split(str,array,"_");
	return array[1]
	# if (array[1] == "ups")
	# 	prefix=array[1]"_"array[2]
	# else
	# 	prefix=array[1]
	# return prefix
}
