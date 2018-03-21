`timescale 1ns / 1ps

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
    
initial begin
    clk <= 1'b0;
    write <= 1'b1;
    RST <= 1'b1;
    
//    INST <=32'b00000000000000000000000000001010;
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

    
    wait_posedge_clk(50);

    $finish;
end


endmodule
