.PHONY: all clean

clean:
	rm -f ./tmp/* ./dist/*

# 生成所有构建目标
all: ./tmp/freq.txt ./tmp/root-cnt.txt ./tmp/1z1c.txt ./tmp/1z3c.txt ./tmp/mr2c.txt ./tmp/1z1r3c.txt

# 生成虎码码表中所有单字的优先顺序表（很可能代表字频）
./tmp/freq.txt: ./source/tiger-code-rime-dict.txt
	sort -k3,3n ./source/tiger-code-rime-dict.txt | awk 'BEGIN {FS=OFS="\t"} NR==FNR {freq[$$1]=$$3; next} END {for (z in freq) {print z, freq[z]}}' | sort -k2,2nr > ./tmp/freq.txt

# 生成单字根数统计表
./tmp/root-cnt.txt: ./source/cn-char-tiger-breakdown.txt
	awk -F '[\t〔 ·]+' '{gsub(/./, "%", $$2) ; print $$1 "\t" length($$2)}' ./source/cn-char-tiger-breakdown.txt > ./tmp/root-cnt.txt

# 生成一简字及其编码对应表
./tmp/1z1c.txt: ./source/tiger-code-rime-dict.txt
	egrep "^.\t[a-z]\t" ./source/tiger-code-rime-dict.txt | awk '{ print $$1 "\t" $$2 }' > ./tmp/1z1c.txt

# 生成 3 码定长的字及其编码对应表
./tmp/1z3c.txt: ./source/tiger-code-rime-dict.txt
	egrep "^.\t[a-z]{3}\t" ./source/tiger-code-rime-dict.txt | awk '{ print $$1 "\t" $$2 }' > ./tmp/1z3c.txt

# 生成主根及其编码对应表（自动过滤无法独立成字的字根及其编码）
./tmp/mr2c.txt: ./script/vlookupext.sh ./source/tiger-241-main-root.txt ./tmp/freq.txt 
	./script/vlookupext.sh ./source/tiger-241-main-root.txt ./tmp/freq.txt | egrep -v "\-\-\-" | awk '{ print $$1 "\t" $$2 }' > ./tmp/mr2c.txt

# 生成 3 码定长字根字及其编码对应表
./tmp/1z1r3c.txt: ./script/vlookup.sh ./script/vlookupext.sh ./source/tiger-code-rime-dict.txt ./source/tiger-3c-root-char.txt ./tmp/1z3c.txt ./tmp/freq.txt
	vlookup ./source/tiger-3c-root-char.txt ./tmp/1z3c.txt > ./tmp/_0_1z1r3c.txt
	./script/vlookupext.sh ./tmp/_0_1z1r3c.txt ./tmp/freq.txt | egrep -v "\-\-\-" | awk '{ print $$1 "\t" $$2 }' > ./tmp/1z1r3c.txt
