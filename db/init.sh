#!/bin/bash
#
# DBの初期化
# ==========

set -e
trap 'echo "ERROR $0" 1>&2' ERR

## entrypointのshell scriptから実行されるので、$BASH_SOURCE からディレクトリを求める
basedir=$(cd $(dirname $BASH_SOURCE) && pwd)

MYSQL_DATABASE=sampledb
MYSQL_USER=scott
MYSQL_PASSWORD=tiger

echo "$MYSQL_DATABASE を作成します"
export MYSQL_PWD=${MYSQL_ROOT_PASSWORD}
mysql -u root -e "
    DROP DATABASE IF EXISTS ${MYSQL_DATABASE};
    CREATE DATABASE ${MYSQL_DATABASE} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    FLUSH PRIVILEGES;
"

export MYSQL_PWD=${MYSQL_PASSWORD}
MYSQL="mysql -u ${MYSQL_USER} --force ${MYSQL_DATABASE} --default_character_set utf8 "

if [ -e $basedir/ddl ]; then
  echo "$MYSQL_DATABASE にDDLを実行します"
  for file in `\find $basedir/ddl -type f`; do
    echo "$file ..."
    $MYSQL < ${file}
	done
fi

if [ -e $basedir/csv-sjis ]; then
  echo "$MYSQL_DATABASE にCSV(SJIS)の初期データを登録します"
  for file in `\find $basedir/csv-sjis -type f | sort`; do
    basefile=$(basename $file)
    tablename=`echo ${basefile%.*} | sed -e 's/^[0-9]\+[_.]\?//'`
    echo "$file -> $tablename ..."
    iconv -c -f cp932 -t utf-8 $file > $file.utf8
    $MYSQL -e "LOAD DATA LOCAL INFILE '$file.utf8' INTO TABLE \`$tablename\` FIELDS TERMINATED BY ',' ENCLOSED BY '\"'"
    rm $file.utf8
  done
fi

if [ -e $basedir/data ]; then
  echo "$MYSQL_DATABASE に初期データを登録します"
  for file in `\find $basedir/data -type f | sort`; do
    echo "$file ..."
    $MYSQL < ${file}
	done
fi

if [ -e $basedir/csv-utf8 ]; then
  echo "$MYSQL_DATABASE にCSV(UTF-8)の初期データを登録します"
  for file in `\find $basedir/csv-utf8 -type f | sort`; do
    basefile=$(basename $file)
    tablename=`echo ${basefile%.*} | sed -e 's/^[0-9]\+[_.]\?//'`
    echo "$file -> $tablename ..."
    $MYSQL -e "LOAD DATA LOCAL INFILE '$file' INTO TABLE \`$tablename\` FIELDS TERMINATED BY ',' ENCLOSED BY '\"'"
  done
fi

