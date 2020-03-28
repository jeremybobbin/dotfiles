#!/bin/sh -e
OUT="${PREFIX:-"/usr"}/share/regex"

mkdir -p "$OUT"
cd src
for i in *; do
	"./$i" > "$OUT/$i"
done
