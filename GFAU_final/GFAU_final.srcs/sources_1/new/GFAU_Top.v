`timescale 1ns / 1ps

module GFAU_Top(
    input clk, input reset, input[3:0] poly, input[1:0] op, input[2:0] num1, input[2:0] num2, 
    input BTNC, output[6:0] ssd, output[7:0] AN);
    
    wire cout, reset_out, sigC, sigReset;
    Filter #(.wd(16),.n(65535),.bound(64000)) bU(.clk(clk),.data_in(reset), .data_out(reset_out));
    Debouncer dU(.clk(clk),.sigIn(reset_out),.sigOut(sigReset));   
    Filter #(.wd(16),.n(65535),.bound(64000)) bC(.clk(clk),.data_in(BTNC), .data_out(cout));
    Debouncer dC(.clk(clk),.sigIn(cout),.sigOut(sigC));
    
    reg select, enable;
    reg[2:0] address1, address2, result, temp;
    wire[2:0] port1, port2;
    
    GFAU_Gen G3(.clk(clk), .reset(reset), .poly(poly), 
    .addr1(address1), .addr2(address2),.pl_ctrl(select), .access1(port1),
    .access2(port2));
    
    SSD_Ctrl ssd1(.clk(clk),.ssd(ssd), .AN(AN), .poly(poly), .num1(num1), .num2(num2), 
    .result(result));
    
    always@(*) begin  
        case (op)
            0: begin //ADDITION is just a XOR, no lookup. Same for Subtraction
                select = 0;
                result = num1 ^ num2;
                address1 = 0;
                address2 = 0;
            end
            1: begin //multiply
                if(sigC) begin
                    select = 1;
                    address1 = ((port1 + port2) % 7) + 1;
                    address2 = 0;
                    if(num1 == 0 || num2 == 0) begin
                        result = 0;
                    end
                    else
                        result = port1;
                end
                else begin
                    select = 0; //get logarithm values
                    address1 = num1; //port1 = log num1
                    address2 = num2; //port2 = log num2 
                end
            end
            
            2: begin //divide
                if(sigC) begin
                    select = 1;
                    address1 = ((port1 - port2) % 7) + 1;
                    address2 = 0;
                    if(num1 == 0 || num2 == 0) begin
                        result = 0;
                    end
                    else
                        result = port1;
                end
                else begin
                    select = 0; //get logarithm values
                    address1 = num1; //port1 = log num1
                    address2 = num2; //port2 = log num2 
                end
            end
            default: begin //Log Lookup. Only takes 1 number.
                select = 0;
                address1 = num1;
                address2 = 0;
                result = port1;
            end
        endcase
    end
endmodule

//DUAL ACCESS BRAM
module GFAU_Gen(
    input clk,
    input reset,
    input [3:0] poly,
    input [2:0] addr1,
    input [2:0] addr2,
    input pl_ctrl,
    output reg [2:0] access1,
    output reg [2:0] access2
    );
    
    reg [3:0] counter;
    reg enable = 1;
    integer i;
    reg [2:0] primitives [0:7];
    reg [2:0] log [0:7];
    wire [2:0] result;
    
    
    LFSR3 GF8(.clk(clk), .enable(enable), .reset(reset), .poly(poly), .result(result));
    
    initial begin
        counter <= 1;
    end
    
    always@(posedge clk) begin
        if(reset) begin
            primitives[0] <= 0; //set initial value to 0
            log[0] <= 7;
            counter <= 1;
        end

        else begin
            if(counter <= 7) begin
                counter <= counter + 1;
                primitives[counter] <= result;
                log[result] <= (counter - 1);
            end
        end     
    end
    
    always@(posedge clk) begin
        if(pl_ctrl) begin
            access1 <= primitives[addr1];
            access2 <= primitives[addr2];
        end
        else begin
            access1 <= log[addr1];
            access2 <= log[addr2];
        end
    end   
endmodule
