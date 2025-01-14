all: compile run

compile:
	cd src && iverilog -o processor_tb.vvp processor_tb.v data_memory.v
	cd src && iverilog -o processor_tb_sw.vvp processor_tb_sw.v data_memory.v

run:
	cd src && vvp processor_tb.vvp

run_sw:
	cd src && vvp processor_tb_sw.vvp

clean:
	rm -f src/*.vvp

