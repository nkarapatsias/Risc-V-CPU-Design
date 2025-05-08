module datapath #(parameter [31:0] INITIAL_PC = 32'h00400000, parameter DATAWIDTH = 32)
(
input wire clk, rst,
input wire [31:0] instr,
input wire PCSrc, ALUSrc, RegWrite, MemToReg, 
input wire [3:0] ALUCtrl,
input wire loadPC,		
output reg [31:0] PC,
output wire Zero,
output reg [31:0] dAddress, dWriteData, WriteBackData,
input wire [31:0] dReadData
);



reg [31:0] imm, op2_reg, op1_reg;
wire [31:0] alu_result, readData1, readData2;


reg [4:0] readReg1, readReg2, writeReg;



regfile my_regfile ( .clk(clk) , .write(RegWrite), .readReg1(readReg1), .readReg2(readReg2), 
	.writeReg(writeReg), .writeData(WriteBackData), 
	.readData1(readData1) ,.readData2(readData2)); //Register File	
	

alu my_alu (.op1(op1_reg), .op2(op2_reg), .alu_op(ALUCtrl)	, .zero(Zero), .result(alu_result));	

initial
begin
	PC <= INITIAL_PC; 
end


always @(posedge clk) // Register File
begin
	readReg1 = instr[19:15];
	readReg2 = instr[24:20];
	writeReg = instr[11:7];
	
end

always @(posedge clk) //Program Counter (PC),  Branch Target
begin
	if (rst)
		begin
			PC <= INITIAL_PC; 
		end

	else 
		if (loadPC)
			begin
				if(PCSrc)
					begin
						PC = PC + {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]}; //PC + branch_offset (we know that is B type of insrt and so the imm)
					end
				else
					begin
						PC = PC+4; //PC+4
					end
			end	
	end

always @(posedge clk) // Immediate Generation-ALU
begin
	if (instr[6:0] == 7'b0010011) // I type of instructions
	   begin
			imm <= {{20{instr[31]}},instr[31:20]};	 													 
		end
		
	if (instr[6:0] == 7'b0000011) // LW type of instructions
	   begin
			imm <= {{20{instr[31]}},instr[31:20]};	 													 
		end
	if (instr[6:0] == 7'b0100011) // S type of instructions	
		begin
			imm <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
		end

	if (instr[6:0] == 7'b1100011) // B type of instructions	
		begin
			imm <= {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]};
		end
	
	
      op1_reg<= readData1; //ALU
	dWriteData <= readData2;
	dAddress = alu_result;
	if(ALUSrc == 0)
		begin
			op2_reg <= readData2;
		end
	else if (ALUSrc == 1)
		begin
			op2_reg <= imm;
		end
end

always @(posedge clk) //  Write Back
begin
	if(MemToReg == 0)
		begin
			WriteBackData <= alu_result;
		end
	else if (MemToReg == 1)
		begin
			WriteBackData <= dReadData;
		end
end


endmodule