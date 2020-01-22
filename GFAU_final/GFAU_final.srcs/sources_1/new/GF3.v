`timescale 1ns / 1ps

module LFSR3(clk, reset, enable, poly, result);
    parameter LN = 3;
    parameter INIT = {{(LN-1){1'b0}}, 1'b1};
    input clk, reset, enable;
    input[LN:0] poly;
    output reg[LN-1:0] result;
    
    always@(posedge clk) begin
        if(reset)
            result <= 3'b001;
        else if(~enable)
            result <= result;
        else begin
            if(result[LN-1]) begin
                result <= {result[LN-2:0], 1'b0} ^ poly;
            end
            else begin
                result <= {result[LN-2:0], 1'b0};
            end
        end
    end       
endmodule
