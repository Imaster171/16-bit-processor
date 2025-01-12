all: compile run

compile:
	iverilog -o processor_tb src/Processor.v src/Processor_tb.v

run:
	vvp processor_tb
§