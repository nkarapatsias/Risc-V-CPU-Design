`timescale 1ns / 1ps

module top_proc_tb; 
	
	reg clk, rst;
	reg [8:0] addr;
	wire [31:0] instr; 
	wire [31:0] PC;
	wire [31:0] dAddress, dWriteData, WriteBackData;
	wire MemWrite, MemRead;
	wire [31:0] dReadData;
	
	
	top_proc my_top_proc
(
.clk(clk), .rst(rst),
.instr(instr), .dReadData(dReadData),
.PC(PC), .dAddress(dAddress), .dWriteData(dWriteData),
.MemRead(MemRead), .MemWrite(MemWrite), 
.WriteBackData(WriteBackData)
);
	
	
	INSTRUCTION_MEMORY my_rom (
	  .clk(clk),
	  .addr(PC[8:0]),
	  .dout(instr) 
	);
	DATA_MEMORY my_ram(
		.clk(clk),
		.we(MemWrite),
		.addr(dAddress[8:0]),
		.din(dWriteData),
		.dout(dReadData)
		);


	// Clock generation
	initial 
	begin
      $dumpfile("dump.vcd"); $dumpvars; //For visualization on Eda playground environment
	   rst = 1;
		#20;
	   clk = 0;
	  forever #10 clk = ~clk; 
    end
	 
	 
	// Zeroing reset here cause we after forever we cant execute anything
	initial 
		begin
		
			rst = 0;

		end
	


	
	
	initial 
	begin
	
		#2850;
		
		$finish;
			      
    end
  
endmodule