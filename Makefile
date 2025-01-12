all: compile run

compile:
	iverilog -o processor_tb src/register_file.v src/instruction_memory.v src/alu.v src/Processor.v src/Processor_tb.v

run:
	vvp processor_tb

clean:
	rm -f processor_tb
