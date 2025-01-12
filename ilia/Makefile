all: compile run

compile:
	iverilog -g2012 -o processor_tb ../ilia/registerfile.v ../ilia/opcodedecoder.v ../ilia/processor.v ../ilia/processor_tb.v

run:
	vvp processor_tb

clean:
	rm -f processor_tb