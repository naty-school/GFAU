module LFSR3_tb();
    //wire[2:0] result;
    reg[2:0] address1;
    reg reset, clk, control;
    reg [5:0] poly; 
    reg enable; 
    wire[4:0] lfsrOut;
    
    //GFAU_Gen G1(.clk(clk), .reset(reset), .poly(poly), .pl_ctrl(control), .addr1(address1), .access1(result));
    LFSR3 #(.LN(5)) test(.clk(clk), .reset(reset), .poly(poly), .result(lfsrOut), .enable(enable));
    
    initial
    begin
    //Initialize input values to 0 and reset to 0. This provides a 1 to the LSB in the module
        clk = 0;
        reset = 1;
        poly = 5;
        control = 1;
        
        #2 reset = 0; 
        enable = 1;
        #10 control = 1;
        address1 = 1;        
        #2 address1 = 2;     
        #2 address1 = 3;
        #2 address1 = 4;     
        #2 address1 = 5;
        #2 address1 = 6;     
        #2 address1 = 7;
        
        #2 control = 0;
        address1 = 1;        
        #2 address1 = 2;     
        #2 address1 = 3;
        #2 address1 = 4;     
        #2 address1 = 5;
        #2 address1 = 6;     
        #2 address1 = 7;
        #2 address1 = 0;
        
        #2 $finish;
    end
    
    always
    begin
        #1 clk <= ~clk;
    end
endmodule
