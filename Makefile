all:
	rm -rf out && mkdir -p out
	rm -rf vhdl && mkdir -p vhdl
	cd out && ../synthesijer_20191116  ../src/main/java/moduledynamic/*.java && mv *.vhd ../vhdl
	

clean:
	rm -rf out
