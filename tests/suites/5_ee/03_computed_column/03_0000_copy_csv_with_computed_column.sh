#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$CURDIR"/../../../shell_env.sh

# Should be <root>/tests/data/
DATADIR=$(realpath $CURDIR/../../../data/)

echo "drop table if exists sample" | $MYSQL_CLIENT_CONNECT

## Create table
cat <<EOF | $MYSQL_CLIENT_CONNECT
CREATE TABLE sample
(
    Id     INT,
    City2  VARCHAR AS (reverse(City)) STORED,
    Score2 INT64 AS (Score + 2) VIRTUAL,
    City   VARCHAR,
    Score  INT
);
EOF

copy_from_test_csv=(
  "copy into sample from 'fs://${DATADIR}/sample.csv' FILE_FORMAT = (field_delimiter = ',' record_delimiter = '\n' type = CSV) ON_ERROR = ABORT"
)

echo "---test csv field with computed columns"
for i in "${copy_from_test_csv[@]}"; do
  echo "$i" | $MYSQL_CLIENT_CONNECT
  echo "select * from sample" | $MYSQL_CLIENT_CONNECT
  echo "truncate table sample" | $MYSQL_CLIENT_CONNECT
done

## Drop table
echo "drop table if exists sample;" | $MYSQL_CLIENT_CONNECT
