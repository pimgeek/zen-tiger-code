#!/bin/sh

if [ $# -ne 1 ]; then
  echo "\n使用方法: finddup.sh codemap"
  echo "\n功能说明: \n"
  echo "此脚本的主要功能是将 codemap 码表中的编码做重复次数分析。

codemap 是 TSV 格式的文件，它包含两列数据，第一列是汉字，可能重复
出现于多行；第二列是与该汉字对应的字母序列，也可能重复出现于多行。
finddup.sh 将以汉字为分组依据，对字母序列做汇总处理，不仅要对每个
汉字对应的所有字母序列做汇总，还要统计各序列在文件中出现的次数。"
else
  CODEMAP=$1
  awk 'BEGIN { FS = "\t"; OFS = "\t" } { hanzi = $1; letters = $2; count[letters]++; map[hanzi] = map[hanzi] ? map[hanzi] OFS letters : letters; } END { for (hanzi in map) { output = hanzi; split(map[hanzi], lettersArr, OFS); for (i = 1; i <= length(lettersArr); i++) { output = output OFS lettersArr[i] "-" count[lettersArr[i]]; } print output; }}' $CODEMAP
fi

