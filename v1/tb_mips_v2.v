`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2018 03:26:11 PM
// Design Name: 
// Module Name: tb_mips_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mips_v2();
// CLK
reg clk;
reg RST;

// REG
reg write;

// for INST
reg [31:0] INST;

// monitor
wire flag;
wire [31:0] out, reg_out, ina, inb, ALUA, ALUB;
wire [31:0] DOUT0;
wire [4:0] addr;

// top circuit
top_module_mips_v2 t0(
    .CLK(clk), .write(write), .flag(flag), .out(out),
    .ina(ina), .inb(inb),.ALUA(ALUA),.ALUB(ALUB), .INST(INST), .addr(addr), .RST(RST)
);





//    input [31:0] INST,
//    output [31:0] out,
//    output flag,
    
//    input CLK,
//    input write,
//    output [31:0] ina, inb, ALUA, ALUB
    
initial begin
    clk <= 1'b0;
    write <= 1'b1;
    RST <= 1'b1;
    
    INST <=32'b00000000000000000000000000001010;
end


always #5 begin
    clk <= ~clk;
end


task wait_posedge_clk;
    input   n;
    integer n;

    begin
        for(n=n; n>0; n=n-1) begin
            @(posedge clk)
                ;
        end
    end
endtask

initial begin

    wait_posedge_clk(1);
    RST <= 1'b0;
    // write reg8 = 1
    wait_posedge_clk(2);
    INST <=32'b00000000000000000000000000001010;
    
    wait_posedge_clk(2);
    INST <=32'b00000100000010000000000000000001;
    wait_posedge_clk(2);
    INST <=32'b00000000000010000100100000000000;
    wait_posedge_clk(2);
    INST <=32'b00000101000010000000000000000001;
    wait_posedge_clk(2);
    INST <=32'b00000001000010010100100000000000;
    wait_posedge_clk(2);
    INST <=32'b00000101000010000000000000000001;
    
    wait_posedge_clk(10);

    $finish;
end


endmodule
