#!/bin/sh

if [ $# -ne 2 ]; then
  echo "\n使用方法: vlookup.sh src ref"
  echo "\n功能说明: \n"
  echo "此脚本的主要功能是合并两个文件 src (源码表) 和 ref (参照码表) 中的数据。

首先，它会读取 ref 文件的内容，并将第一列作为“名字”，第二列作为“编码”
存储在一个字典 a 中。然后，它会读取 src 文件的内容，并对每一行进行查询
处理：如果 src 文件第一列的“名字”在字典 a 中存在对应的“编码”，它会输出
“名字”和 a 中对应的编码；否则，它会输出 src 文件原来的第一列和第二列。

!!特别注意!! 如果 ref 文件中第一列“名字”有重复项，程序将以最后一次出现
的“名字”对应的“编码”为准"
else
  SRC=$1
  REF=$2
  awk 'BEGIN {FS=OFS="\t"} NR==FNR {a[$1]=$2; next} {if ($1 in a) {print $1, a[$1]} else {print $1, $2}}' $REF $SRC
fi

