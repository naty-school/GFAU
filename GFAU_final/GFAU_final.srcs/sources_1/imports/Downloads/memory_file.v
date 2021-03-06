`timescale 1ns / 1ps
module memory(address1, Data);
    input [3:0]address1;
    output [15:0]Data;
    reg [15:0] mem [0:15];
    
    initial 
	begin
		mem[0]  = 16'b0001001100100000;
		mem[1]  = 16'b0110001001100000;
		mem[2]  = 16'b0101001101000000;
		mem[3]  = 16'b1001010001100011;
		mem[4]  = 16'b0001100101010010;
		mem[5]  = 16'b0101011000110010;
		mem[6]  = 16'b0001010101010100;
		mem[7]  = 16'b0111011110000001;
		mem[8]  = 16'b0001000000100010;
		mem[9]  = 16'b0110000010000010;
		mem[10] = 16'b0111001000110111;
		mem[11] = 16'b0011010000100101;
		mem[12] = 16'b0001001000000100;
		mem[13] = 16'b0110010110000110;
		mem[14] = 16'b1001011010011000;
		mem[15] = 16'b0110100001111001;
    end
   
    assign Data = mem[address1][15:0];

endmodule   