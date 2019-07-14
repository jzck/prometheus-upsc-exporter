#!/bin/bash
# small http wrapper for bash scripts via inetd

file="$1"
mime='text/plain'

if [ ! -f "$file" ]; then
	echo "$1: No such file or directory" >&2
	exit 1
fi

. $file > /tmp/.$$.output

size=$(stat -c "%s" "/tmp/.$$.output")

printf 'HTTP/1.1 200 OK\r\nDate: %s\r\nContent-Length: %s\r\nContent-Type: %s\r\nConnection: close\r\n\r\n' "$(date)" "$size" "$mime"

cat /tmp/.$$.output

rm -f /tmp/.$$.output
