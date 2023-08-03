.PHONY: all clean

clean:
	rm -f ./tmp/* ./dist/*

1z1c: # 生成一简字表
	 egrep "^.\t[a-z]\t" ./source/tiger-code-rime-dict.txt | awk '{ print $$1 "\t" $$2 }' > ./tmp/1z1c.txt


