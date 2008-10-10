#!/bin/sh

if [ $# -ne 1 ]
then
  echo "usage: data" 1>&2
  exit 111
fi

IFS="
"

cat <<EOF
(table supported
  (t-row
    (item "system name")
    (item "system version")
    (item "C compiler name")
    (item "C compiler version")
    (item "architecture"))

EOF

for line in `sort < "$1"`
do
  sys=`echo $line | awk '{print $1}'`
  ver=`echo $line | awk '{print $2}'`
  ccn=`echo $line | awk '{print $3}'`
  ccv=`echo $line | awk '{print $4}'`
  arc=`echo $line | awk '{print $5}'`

  cat <<EOF
  (t-row (item "${sys}") (item "${ver}") (item "${ccn}") (item "${ccv}") (item "${arc}"))
EOF
done

cat <<EOF
)
EOF
