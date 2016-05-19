all:
	ghdl -a fpu2.vhdl tb_fpu.vhdl  
	ghdl -e tb_fpu

run:
	ghdl -r tb_fpu --stop-time=50ns --vcd=data.vcd
	gtkwave data.vcd 

clean:
	ghdl --clean
	rm data.vcd
	rm work-obj93.cf
