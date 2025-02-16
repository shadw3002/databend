#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$CURDIR"/../../../shell_env.sh

echo "create table t17_0003(a int)" | $MYSQL_CLIENT_CONNECT
echo "insert into t17_0003 values(1)" | $MYSQL_CLIENT_CONNECT

# alter table add a column
echo "alter table add a column"
echo "alter table t17_0003 add column c int default 100" | $MYSQL_CLIENT_CONNECT

echo "insert into t17_0003 values(3,2)" | $MYSQL_CLIENT_CONNECT

# update should return error, if fix this error, please change the case
echo "update table column"
echo "update t17_0003 set a=3 where a=1" | $MYSQL_CLIENT_CONNECT

# alter table drop a column
echo "alter table drop a column"
echo "alter table t17_0003 drop column a" | $MYSQL_CLIENT_CONNECT

# update should return error, if fix this error, please change the case
echo "update table column"
echo "update t17_0003 set c=2 where c=1" | $MYSQL_CLIENT_CONNECT

## Drop table.
echo "drop table t17_0003 all" | $MYSQL_CLIENT_CONNECT

## create two column table
echo "create table t17_0003(a int, b int)" | $MYSQL_CLIENT_CONNECT
echo "insert into t17_0003 values(1, 2)" | $MYSQL_CLIENT_CONNECT

# alter table add a column
echo "alter table add a column"
echo "alter table t17_0003 add column c int default 100" | $MYSQL_CLIENT_CONNECT

echo "insert into t17_0003 values(3,2,2)" | $MYSQL_CLIENT_CONNECT

# two column table update success
echo "update table column"
echo "update t17_0003 set a=3 where a=1" | $MYSQL_CLIENT_CONNECT

# alter table drop a column
echo "alter table drop a column"
echo "alter table t17_0003 drop column b" | $MYSQL_CLIENT_CONNECT

# two column table update success
echo "update table column"
echo "update t17_0003 set a=3 where a=1" | $MYSQL_CLIENT_CONNECT

## Drop table.
echo "drop table t17_0003 all" | $MYSQL_CLIENT_CONNECT