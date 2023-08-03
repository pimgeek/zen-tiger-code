.PHONY: all clean

clean:
	rm -f ./tmp/* ./dist/*

freq: # 生成虎码码表中所有单字的优先顺序表（很可能代表字频）
	sort -k3,3n ./source/tiger-code-rime-dict.txt | awk 'BEGIN {FS=OFS="\t"} NR==FNR {freq[$$1]=$$3; next} END {for (z in freq) {print z, freq[z]}}' > ./tmp/tiger-all-z-freq.txt

1z1c: # 生成一简字及其编码对应表
	egrep "^.\t[a-z]\t" ./source/tiger-code-rime-dict.txt | awk '{ print $$1 "\t" $$2 }' > ./tmp/1z1c.txt

mr2c: freq # 生成主根及其编码对应表（自动过滤无法独立成字的字根及其编码）
	./script/vlookupext.sh ./source/tiger-241-main-root.txt ./tmp/tiger-all-z-freq.txt | egrep -v "\-\-\-" | awk '{ print $$1 "\t" $$2 }' > ./tmp/mr2c.txt

