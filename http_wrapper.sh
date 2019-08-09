#!/bin/bash
# small http wrapper for bash scripts via inetd

file="$1"
mime='text/plain'

read request

# ignore the header
while /bin/true; do
        read header
        [ "$header" == $'\r' ] && break
done

if [ ! -f "$file" ]; then
	echo "HTTP/1.1 500 Internal Server Error\r\nConnection: close\r\n\r\n$1: No such file or directory" >&2
	exit 1
fi

. $file > /tmp/.$$.output 2>&1

size=$(stat -c "%s" "/tmp/.$$.output")

printf 'HTTP/1.1 200 OK\r\nDate: %s\r\nContent-Length: %s\r\nContent-Type: %s\r\nConnection: close\r\n\r\n' "$(date)" "$size" "$mime"

cat /tmp/.$$.output

rm -f /tmp/.$$.output
