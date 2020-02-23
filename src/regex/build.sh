#!/bin/sh
OUT="${PREFIX?}/share/regex"

mkdir -p "$OUT"
cd src
for i in *; do
	"./$i" > "$OUT/$i"
done
