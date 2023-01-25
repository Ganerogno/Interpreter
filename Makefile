all:
	bison -d Parser.y
	flex Scanner.l
	gcc Parser.tab.c -o result
	result
clean:
	rm -rf lex.yy.c
	rm -rf Parser.tab.c
	rm -rf Parser.tab.h
	rm -rf result.exe
	rm -rf output.txt