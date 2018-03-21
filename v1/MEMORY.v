`timescale 1ns / 1ps


module CPU_REG(
    input [4:0] addr, //32-words MIPS like
    input [31:0] data_in,
    output [31:0] data_out,
    
    input CLK,
    input write
    );
    
    reg [31:0] PROGRAM[31:0];
    
    initial $readmemb("/adress/to/sample1.bin", PROGRAM);
    
    assign data_out = PROGRAM[addr];
    always @(posedge CLK) if(write) PROGRAM[addr] <= data_in;

endmodule

module GPR(
    input CLK,
    input [4:0] REGNUM0, REGNUM1, REGNUM2,
    input [31:0] DIN0,
    input WE0,
    output [31:0] DOUT0, DOUT1
  );
    reg [31:0] r[15:0];
    
    assign DOUT0 = (REGNUM0==0) ? 0 : r[REGNUM0];
    assign DOUT1 = (REGNUM1==0) ? 0 : r[REGNUM1];
    always @(posedge CLK) if (WE0) r[REGNUM2] <= DIN0;
    
endmodule
