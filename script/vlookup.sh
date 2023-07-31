#!/bin/sh

if [ $# -ne 2 ]; then
  echo "\n使用方法: vlookup src ref"
  echo "\n功能说明: \n"
  echo "此脚本的主要功能是将两个文件 src (代表源码表) 和 ref (代表参照码表) 中的数据进行合并。\n首先，它会读取 ref 文件的内容，并将第一列作为“名字”，第二列作为“编码”存储在一个字典 a 中。\n然后，它会读取 src 文件的内容，并对每一行进行查询处理，查询步骤如下：\n\n如果 src 文件第一列的“名字”在字典 a 中存在对应的“编码”，它会输出“名字”和 a 中对应的编码；\n否则，它会输出 src 文件当前行原来的第一列和第二列。\n"
  echo "!!特别注意!! 如果 ref 文件中的第一列“名字”有重复项，将以后出现的“名字”对应的“编码”为准"
else
  SRC=$1
  REF=$2
  awk 'BEGIN {FS=OFS="\t"} NR==FNR {a[$1]=$2; next} {if ($1 in a) {print $1, a[$1]} else {print $1, $2}}' $REF $SRC
fi

