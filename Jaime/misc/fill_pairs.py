#!/user/bin/python
import sys 
import re 

input=sys.argv[1]
output=input[:input.rfind(".")] + ".out.txt"
i=0
prev=""
f = open(output,'w')
for line in open(input):
    i=i+1
    linea = int(line)
    mod = linea % 2
    if prev == linea:
	continue
    if i == 1:
	if mod == 0:
	    f.write(str(linea - 1)+"\n")
	    f.write(str(linea)+"\n")
	    prev = linea
	else:
	    prev = linea
	continue
    if mod != 0:
	if prev %2 != 0:
	    f.write(str(prev)+"\n")
	    f.write(str(prev + 1)+"\n")
	    f.write(str(linea)+"\n")
	    f.write(str(linea +1)+"\n")
	    prev = linea + 1
	elif prev % 2 == 0:
	    prev = linea
    elif mod == 0:
	if prev % 2 == 0:
	    f.write(str(linea - 1)+"\n")
	    f.write(str(linea)+"\n")
	    prev = linea
	if prev % 2 != 0:
	    if (linea - 1) == prev:
		f.write(str(prev)+"\n")
		f.write(str(linea)+"\n")
		prev = linea
	    else:
		f.write(str(prev)+"\n")
		f.write(str(prev + 1)+"\n")
		f.write(str(linea - 1)+"\n")
		f.write(str(linea)+"\n")
		prev = linea
