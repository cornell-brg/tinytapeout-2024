Compiling and Running Testing:


Utbs:

CaesarCipher.sv:
iverilog -Wall -g2012 -o CaeserCipher_tb linear_pkg.sv utilities.sv CaeserCipher.sv CaeserCipher_tb.sv
./CaeserCipher_tb +dump-vcd=CaesarCipher_tb.vcd

Ps2_to_Linear.sv:
iverilog -Wall -g2012 -o Ps2_to_Linear_tb linear_pkg.sv keyboard_pkg.sv utilities.sv Ps2_to_Linear.sv  Ps2_to_Linear_tb.sv
./Ps2_to_Linear_tb +dump-vcd=Ps2_to_Linear_tb.vcd

Linear_to_ASCII.sv:
iverilog -Wall -g2012 -o linear_to_ASCII_tb linear_pkg.sv ascii_pkg.sv utilities.sv Linear_to_ASCII.sv  Linear_to_ASCII_tb.sv
./linear_to_ASCII_tb +dump-vcd=linear_to_ASCII.vcd

Ps2DataCollection.sv:

LCD_display

Testing: Ps2 -> CaesarCipher -> ASCII
iverilog -Wall -g2012 -o Ps2_to_ASCII_tb linear_pkg.sv keyboard_pkg.sv utilities.sv Linear_to_ASCII.sv Ps2_to_Linear.sv CaeserCipher.sv Ps2_to_ASCII_tb.sv
./Ps2_to_ASCII_tb +dump-vcd=Ps2_to_ASCII_tb.vcd



