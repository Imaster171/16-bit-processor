all: compile run

compile:
	cd src && iverilog -o processor_tb.vvp processor_tb.v 

run:
	cd src && vvp processor_tb.vvp

clean:
	rm -f src/*.vvp

