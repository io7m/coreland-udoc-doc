#!/bin/sh
printf '(item docid "%s")\n' `echo | tai64n | sed 's/@/UDD/'`
