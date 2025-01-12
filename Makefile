all: compile run

compile:
	iverilog -o processor_tb src/register_file.v src/instruction_memory.v src/alu.v src/пrocessor.v src/пrocessor_tb.v src/program_counter.v

run:
	vvp processor_tb

clean:
	rm -f processor_tb
