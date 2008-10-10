#!/bin/sh
echo | tai64 | sed 's/@/UDD/' | sed 's/ *//g' | tr [:lower:] [:upper:]
