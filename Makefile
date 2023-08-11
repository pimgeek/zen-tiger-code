# 设置脚本文件/源文件/目标文件/临时文件的存放路径
tooldir := ./script
srcdir  := ./source
destdir := ./dist
tempdir := ./tmp

# ----------------
# 设置数据处理脚本缩略名
vlookup    = $(tooldir)/vlookup.sh
vlookupext = $(tooldir)/vlookupext.sh

# ----------------
# 设置源文件缩略名
tigerdict = $(srcdir)/tiger-code-rime-dict.txt
breakdown = $(srcdir)/cn-char-tiger-breakdown.txt
rvariants = $(srcdir)/tiger-root-variants.txt
3c1rchars = $(srcdir)/tiger-3c-root-char.txt

# ----------------
# 设置中间目标文件缩略名
freq       = $(tempdir)/freq.txt       # 所有虎码单字的字频列表（从上到下，从高频到低频）
f6500      = $(tempdir)/f6500.txt      # 前 6500 虎码单字的字频列表（从上到下，从高频到低频）
rcnt       = $(tempdir)/root-cnt.txt   # 每个虎码单字及字根数对应表（无序）
1z2r       = $(tempdir)/1z2r.txt       # 从 rcnt 中提取所有字根数量为 2 的单字，保持原始根数 2
1z2rup     = $(tempdir)/1z2rup.txt     # 从 rcnt 中提取所有字根数量为 2 的单字，根数统一改为 3
1z3r       = $(tempdir)/1z3r.txt       # 从 rcnt 中提取所有字根数量为 3 的单字，保持原始根数 3
1z3rup     = $(tempdir)/1z3rup.txt     # 从 rcnt 中提取所有字根数量为 3 的单字，根数统一改为 4
1z4r       = $(tempdir)/1z4r.txt       # 从 rcnt 中提取所有字根数量为 4 的单字，保持原始根数 4
1z1c       = $(tempdir)/1z1c.txt       # 从 tigerdict 中提取所有码长为 1 的单字及编码
1z2c       = $(tempdir)/1z2c.txt       # 从 tigerdict 中提取所有码长为 2 的单字及编码
rv2c       = $(tempdir)/rv2c.txt       # rvariants 复制为 rv2c，包含所有主根及变体，码长为 2
1z3c       = $(tempdir)/1z3c.txt       # 从 tigerdict 中提取所有码长为 3 的单字及编码
1z3ck2     = $(tempdir)/1z3ck2.txt     # 基于 1z3c 码表，截取所有编码的前两位，用于为 1z2r 表中的部分单字提供编码
rc3c       = $(tempdir)/rc3c.txt       # 利用 tigerdict 和 3c1rchars 生成码长为 3 的字根字列表
1z4c       = $(tempdir)/1z4c.txt       # 从 tigerdict 中提取所有码长为 4 的单字及编码
1z4ck3     = $(tempdir)/1z4ck3.txt     # 基于 1z4c 码表，截取所有编码的前三位，用于为 1z3r 表中的部分单字提供编码
zt1c       = $(tempdir)/zt1c.txt       # 1z1c 复制为 zt1c，包含禅意虎码方案中码长为 1 的单字及编码
zt2c       = $(tempdir)/zt2c.txt       # 禅意虎码方案中码长为 2 的单字及编码
zt3c       = $(tempdir)/zt3c.txt       # 禅意虎码方案中码长为 3 的单字及编码
zt4c       = $(tempdir)/zt4c.txt       # 禅意虎码方案中码长为 4 的单字及编码
zt2c_wo_3c = $(tempdir)/zt2c_wo_3c.txt #
zt3c_wo_4c = $(tempdir)/zt3c_wo_4c.txt #
zt2dup     = $(tempdir)/zt2dup.txt     #
zt3dup     = $(tempdir)/zt3dup.txt     #
zt4dup     = $(tempdir)/zt4dup.txt     #

# ----------------
# 设置最终目标文件缩略名
ztdict = $(destdir)/ztdict.txt     #
diffs  = $(destdir)/diffs.txt      # 如果存在 t6500 中的单字未被 ztdict 收录，则存储在这个列表中

# ----------------
.PHONY: all clean debug test

clean:
	rm -f $(tempdir)/* $(destdir)/*

# 禅意虎码相关构建目标
all: $(zt1c) $(zt2c_wo_3c) $(zt3c_wo_4c) $(zt4c)

# 生成虎码码表中所有单字及字频的优先顺序表
$(freq): $(tigerdict)
	sort -k3,3n $(tigerdict) | awk 'BEGIN {FS=OFS="\t"} NR==FNR {freq[$$1]=$$3; next} END {for (z in freq) {print z, freq[z]}}' | sort -k2,2nr > $(freq)

# 生成虎码码表中前 6500 个单字及字频的优先顺序表
$(f6500): $(freq) $(3c1rchars)
	head -n 6500 $(freq) > $(f6500)
	awk '{print $$1 "\t" 257 }' $(3c1rchars) >> $(f6500)

# 生成单字根数统计表
$(rcnt): $(breakdown)
	awk -F '[\t〔 ·]+' '{gsub(/./, "%", $$2) ; print $$1 "\t" length($$2)}' $(breakdown) > $(rcnt)

# 生成 1 根字的单字及字根数对应表
$(1z1r): $(rcnt)
	egrep "^.\t1$$" $(rcnt) > $(1z1r)

# 生成 2 根字的单字及字根数对应表
$(1z2r): $(rcnt)
	egrep "^.\t2$$" $(rcnt) > $(1z2r)

# 生成 2 根字的单字及字根数对应表（根数改为 3）
$(1z2rup): $(rcnt) $(1z2r)
	awk '{ print $$1 "\t" 3 }' $(1z2r) > $(1z2rup)

# 生成 3 根字的单字及字根数对应表
$(1z3r): $(rcnt)
	egrep "^.\t3$$" $(rcnt) > $(1z3r)

# 生成 3 根字的单字及字根数对应表（根数改为 4）
$(1z3rup): $(rcnt) $(1z3r)
	awk '{ print $$1 "\t" 4 }' $(1z3r) > $(1z3rup)

# 生成 4 根字的单字及字根数对应表
$(1z4r): $(rcnt)
	egrep "^.\t4$$" $(rcnt) > $(1z4r)

# 生成码长为 1 的单字及编码对应表
$(1z1c): $(tigerdict)
	egrep "^.\t[a-z]\t" $(tigerdict) | awk '{ print $$1 "\t" $$2 }' > $(1z1c)

# 生成码长为 2 的单字及编码对应表
$(1z2c): $(tigerdict)
	egrep "^.\t[a-z]{2}\t" $(tigerdict) | awk '{ print $$1 "\t" $$2 }' > $(1z2c)

# 生成码长为 2 的主根+变体及编码对应表（过滤无法独立成字的字根及编码）
$(rv2c): $(vlookupext) $(rvariants) $(freq)
	$(vlookupext) $(rvariants) $(freq) | egrep -v "%%%" | awk '{ print $$1 "\t" $$2 }' > $(rv2c)

# 生成码长为 3 的单字及编码对应表
$(1z3c): $(tigerdict)
	egrep "^.\t[a-z]{3}\t" $(tigerdict) | awk '{ print $$1 "\t" $$2 }' > $(1z3c) 

# 截取 $(1z3c) 的前 2 位编码
$(1z3ck2): $(1z3c)
	awk '{print $$1 "\t" substr($$2,1,2)}' $(1z3c) > $(1z3ck2)

# 生成码长为 3 的字根字及编码对应表
$(rc3c): $(vlookup) $(vlookupext) $(3c1rchars) $(1z3c) $(freq)
	$(vlookup) $(3c1rchars) $(1z3c) > $(tempdir)/__rc3c.txt
	$(vlookupext) $(tempdir)/__rc3c.txt $(freq) | egrep -v "%%%" | awk '{ print $$1 "\t" $$2 }' > $(rc3c)

# 生成码长为 4 的单字及编码对应表
$(1z4c): $(tigerdict)
	egrep "^.\t[a-z]{4}\t" $(tigerdict) | awk '{ print $$1 "\t" $$2 }' > $(1z4c) 

# 截取 $(1z4c) 的前 3 位编码
$(1z4ck3): $(1z4c)
	awk '{print $$1 "\t" substr($$2,1,3)}' $(1z4c) > $(1z4ck3)

# ----------------
# 以下规则用于生成禅意虎码输入方案的码表

# 禅意虎码
# 禅意虎码：码长为 1 的单字及编码，最终版
$(zt1c): $(1z1c)
	cp $(1z1c) $(zt1c)

$(zt2c): $(vlookup) $(vlookupext) $(f6500) $(1z2r) $(1z2c) $(1z3ck2) $(rv2c)
	$(vlookup) $(1z2r) $(1z2c) > $(tempdir)/__raw2c.txt
	egrep -v "\t2$$" $(tempdir)/__raw2c.txt > $(tempdir)/__m2c.txt
	egrep "\t2$$" $(tempdir)/__raw2c.txt > $(tempdir)/__u2c.txt
	$(vlookup) $(tempdir)/__u2c.txt $(1z3ck2) > $(tempdir)/__fixu2c.txt
	cat $(tempdir)/__m2c.txt $(tempdir)/__fixu2c.txt $(rv2c) | sort -u > $(tempdir)/__sum2c.txt
	$(vlookupext) $(tempdir)/__sum2c.txt $(f6500) | egrep -v "%%%" | awk '{ print $$1 "\t" $$2 }' > $(zt2c)

$(zt3c): $(vlookup) $(vlookupext) $(f6500) $(1z2rup) $(1z3r) $(1z3c) $(1z4ck3) $(rc3c)
	$(vlookup) $(1z2rup) $(1z3c) > $(tempdir)/__2rp3c.txt
	$(vlookup) $(1z3r) $(1z3c) > $(tempdir)/__raw3r3c.txt
	egrep -v "\t3$$" $(tempdir)/__raw3r3c.txt > $(tempdir)/__m3c.txt
	egrep "\t3$$" $(tempdir)/__raw3r3c.txt > $(tempdir)/__u3c.txt
	$(vlookup) $(tempdir)/__u3c.txt $(1z4ck3) > $(tempdir)/__fixu3c.txt
	cat $(tempdir)/__2rp3c.txt $(tempdir)/__fixu3c.txt $(rc3c) | sort -u > $(tempdir)/__sum3c.txt
	$(vlookupext) $(tempdir)/__sum3c.txt $(f6500) | egrep -v "%%%" | awk '{ print $$1 "\t" $$2 }' > $(zt3c)

$(zt4c): $(vlookup) $(vlookupext) $(f6500) $(1z3rup) $(1z4r) $(1z4c) $(1z4ck3)
	$(vlookup) $(1z3rup) $(1z4c) > $(tempdir)/__3rup4c.txt
	$(vlookup) $(1z4r) $(1z4c) > $(tempdir)/__4r4c.txt
	cat $(tempdir)/__4r4c.txt $(tempdir)/__3rup4c.txt | sort -u > $(tempdir)/__sum4c.txt
	$(vlookupext) $(tempdir)/__sum4c.txt $(f6500) | egrep -v "%%%" | awk '{ print $$1 "\t" $$2 }' > $(zt4c)

$(zt2c_wo_3c): $(vlookup) $(zt2c) $(zt3c) 
	$(vlookup) $(zt2c) $(zt3c) | egrep -v "\t[a-z]{3}$$" > $(zt2c_wo_3c)

$(zt3c_wo_4c): $(vlookup) $(zt3c) $(zt4c)
	$(vlookup) $(zt3c) $(zt4c) | egrep -v "\t[a-z]{4}$$" > $(zt3c_wo_4c)

$(zt2dup): $(zt2c_wo_3c)
$(zt3dup): $(zt3c_wo_4c)
$(zt4dup): $(zt4c)

# ----------------
# 以下规则用于调试 Makefile，与虎码码表生成过程无关
uservar=srcdir

debug: # 注：执行 make debug -e uservar=freq，可以把 $($(uservar)) 变成 $(freq)
	echo $($(uservar))

test: $($(uservar)) # 注：执行 make test -e uservar=freq，实际执行过程将会从显示源码表目录 srcdir 变为构建 $(freq)

