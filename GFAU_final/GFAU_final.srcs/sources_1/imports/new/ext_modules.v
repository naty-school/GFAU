`timescale 1ns / 1ps
//1kHz clkDivider

module SSD_Ctrl(
    input clk,
    input[2:0] num1,
    input[2:0] num2,
    input[2:0] result,
    input[3:0] poly,
    output reg [6:0] ssd,
    output reg [7:0] AN);
    
    reg[1:0] select;
    reg[3:0] digit;
    wire out_1kHz;
    clkDivider CD1kHz(.clk(clk), .out_1kHz(out_1kHz));
    
        //1 kHz SSD Toggle
    always@(posedge out_1kHz)
    begin
        select <= select + 1;
    end
    
    //SSD Multiplexing. Switch between SSDSs and digit values @ 1kHz clock toggle in select
    always@(*)
    case(select)
    3'b00:
        begin
        digit <= {1'b0, num1};
        AN <= 8'b11011111;
    end
    
    3'b01:
    begin
        digit <= {1'b0, num2};
        AN <= 8'b11101111;
    end
    
    3'b10:
    begin
        digit <= {result};
        AN <= 8'b11111110;
    end
    
    3'b11:
    begin
        digit <= poly;
        AN <= 8'b01111111;
    end
    
    default:
    begin
        digit <= 0;
        AN <= 8'b11111111;
    end
    endcase
    
    //Segment Decoding
    always @(*)
    case (digit)
      4'b0000: ssd <= 7'b0000001;
      4'b0001: ssd <= 7'b1001111;
      4'b0010: ssd <= 7'b0010010;
      4'b0011: ssd <= 7'b0000110;
      4'b0100: ssd <= 7'b1001100;
      4'b0101: ssd <= 7'b0100100;
      4'b0110: ssd <= 7'b0100000;
      4'b0111: ssd <= 7'b0001111;
      4'b1000: ssd <= 7'b0000000;
      4'b1001: ssd <= 7'b0000100;
      4'b1010: ssd <= 7'b0001000;
      4'b1011: ssd <= 7'b1100000;
      4'b1100: ssd <= 7'b0110001;
      4'b1101: ssd <= 7'b1000010;
      4'b1110: ssd <= 7'b0110000;
      4'b1111: ssd <= 7'b0111000;
endcase   

endmodule
    
module clkDivider(
    input clk,
    output reg out_1kHz
    );
        //1 khz clock divider 
    reg [16:0] count_reg = 0;
    always @(posedge clk) begin
     begin
        if (count_reg < 100000) 
        begin
            count_reg <= count_reg + 1;
        end 
        else begin
            count_reg <= 0;
            out_1kHz <= ~out_1kHz;
            end	
        end
    end
endmodule

//1 Hz clk Divider
module clkDivider2(
    input clk,
    output reg outSig
    );
        //1 khz clock divider 
    reg [27:0] count_reg = 0;
    always @(posedge clk) begin
     begin
        if (count_reg < 50000000) 
        begin
            count_reg <= count_reg + 1;
        end 
        else begin
            count_reg <= 0;
            outSig <= ~outSig;
            end	
        end
    end
endmodule

module Debouncer(
    input clk, sigIn,
    output sigOut
);
    wire q;
    dff_resetless r1(.clk(clk), .data(sigIn), .q(q));
    assign sigOut = sigIn & !q;
endmodule

module dff_resetless(
    input clk,
    input data, 
    output reg q
);
    always@(posedge clk)
    begin
        q <= data;
    end
endmodule