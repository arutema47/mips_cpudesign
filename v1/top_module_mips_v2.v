`timescale 1ns / 1ps

// Instruction set + ALU + REG + PC

module top_module_mips_v2(
    output [31:0] INST,
    output [31:0] out,
    output flag,
    input RST,
    
    input [4:0] addr,
    input CLK,
    input write,
    output [31:0] ina, inb, ALUA, ALUB
    );
    
    // decode INST
    reg [4:0] read1, wadd;
    reg ALUsrc;
    wire [5:0] opcode = INST[31:26];
    wire [5:0] funct = INST[5:0];    
    wire [4:0] read0 = INST[25:21]; //rs
    
    always @(*) begin
        if(INST[31:26]==0) begin // INST=R
            read1 = INST[20:16]; //rt
            wadd = INST[15:11];
            ALUsrc = 0;
        end
        else begin
            wadd = INST[20:16]; //rt
            ALUsrc = 1;
        end
    end
            
    // REGISTER
    GPR REG(
    .REGNUM0(read0),.REGNUM1(read1),.REGNUM2(wadd),
    .DIN0(out),
    .DOUT0(ina),.DOUT1(inb),
    .CLK(CLK),
    .WE0(write)
    );
    
    // PC
    PC PC(
    .CLK(CLK), .RST(RST), .INST(INST));
    
    // ALU
    ALU ALU(
    .ina(ina),.inb(inb),.out(out),.flag(flag),.ALUA(ALUA),.ALUB(ALUB), .INST(INST), .opcode(opcode), .funct(funct), .ALUsrc(ALUsrc)
    );
    
endmodule

module PC(
    input CLK,
    input RST,
    output [31:0] INST
    );
    
    wire write = 1'b0; // dont write..
    wire [31:0] data_in = 32'b0;
    wire [31:0] data_out;
    
    assign INST = data_out;
    wire [4:0] addr;
    
    // call program counter
    COUNTER5B COUNTER(
        .CLK(CLK), .addr(addr), .RST(RST)
    );
    // call program memory   
    CPU_REG PMEM(
        .addr(addr), .data_in(data_in), .data_out(data_out), .write(write));      
        
endmodule

module COUNTER5B(
    input CLK,
    input RST,
    output [4:0] addr);
    
    // 2^5 (32-state) counter
    reg [4:0] count; 
    assign addr = count;
    
    always @(posedge CLK) begin
        if(RST == 1) begin
            count = 5'b0;
        end
        else begin
            count = count + 1;
        end
    end
     
endmodule
    
module ALU(
    input [5:0] opcode,
    input [31:0] ina,
    input [31:0] inb,
    input ALUsrc,
    input [5:0] funct,
    input [31:0] INST,
    
    output [31:0] out, ALUA, ALUB,
    output flag
    
    );
    
    reg [32:0] tout;
    reg [31:0] ALUB2;
    wire [31:0] imm_i;
    
    assign ALUA = ina;
    assign ALUB = ALUB2;
    assign imm_i[15:0] = INST[15:0];
    assign imm_i[31:16] = 16'b0;
    
    
    always @(*) begin
        if(ALUsrc) begin
            ALUB2 = imm_i;
            end
        else begin
            ALUB2 = inb;
        end
    end
    
    assign flag = tout[32]; //Overflow
    assign out = tout[31:0];    
    
    // ALU function
    always@(*) begin
        if(opcode==6'd0) begin
            case(funct)
                6'd0: // add
                tout = ALUA + ALUB;
                6'd2: // sub
                tout = ALUA - ALUB;
                
                6'd10: // XOR
                tout = ALUA ^ ALUB;
                
                default:
                tout = ALUA + ALUB;
            endcase
        end
        else begin
                tout = ALUA + ALUB;
        end
    end
endmodule