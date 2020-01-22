`timescale 1ns / 1ps

module LFSR3(clk, reset, enable, poly, result);
    parameter LN = 3;
    parameter INIT = {{(LN-1){1'b0}}, 1'b1};
    input clk, reset, enable;
    input[LN:0] poly;
    output reg[LN-1:0] result;
    
    always@(posedge clk) begin
        if(reset)
            result <= INIT;
        else if(~enable)
            result <= result;
        else begin
            if(result[LN-1]) begin
                result <= result ^ poly;
                result[0] <= poly[0];
                result[1] <= (poly[1] & result[2]) ^ result[0];
                result[2] <= (poly[2] & result[2]) ^ result[1];
            end
            else begin
            end
        end
    end       
endmodule
