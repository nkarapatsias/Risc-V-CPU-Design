`include "ram.v"
`include "regfile.v" 
`include "datapath.v" 
`include "alu.v"
`include "rom.v" 


module top_proc #(parameter [31:0] INITIAL_PC = 32'h00400000)
(
input wire clk, rst,
input wire [31:0] instr, dReadData,
output wire [31:0] PC, dAddress, dWriteData,
output reg MemRead, MemWrite, 
output wire [31:0] WriteBackData
);


reg [3:0] ALUCtrl;
reg ALUSrc, RegWrite, MemtoReg, PCSrc, loadPC;
reg [2:0] state; // States of the FSM
wire Zero;


localparam IF  = 3'b000,
ID  = 3'b001,
EX  = 3'b010,
MEM = 3'b011,
WD  = 3'b100;


datapath #(.INITIAL_PC(INITIAL_PC), .DATAWIDTH(32)) my_datapath 
(
.clk(clk), .rst(rst), .instr(instr) , .PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .MemToReg(MemtoReg), .ALUCtrl(ALUCtrl), .loadPC(loadPC), .PC(PC),
.Zero(Zero), .dAddress(dAddress), .dWriteData(dWriteData), .dReadData(dReadData), .WriteBackData(WriteBackData));


initial 
	begin
		ALUSrc <=0;
		RegWrite <=0;
		MemtoReg <=0;
		PCSrc <=0;
		loadPC <=0;
		state <=3'b000;
	end


always @(posedge clk) //AluCtrl
	begin

		if (instr[6:0] == 7'b0100011 || instr[6:0] == 7'b0000011) //S type instruction (SW) or LW
			begin
				ALUCtrl <= 4'b0010; //Decoding of addition
			end
		else if (instr[6:0] == 7'b1100011) //B type of instruction (BEQ)
			begin
				ALUCtrl <= 4'b0110; //Decoding of subtract
			end
		else 
			if (instr[6:0] == 7'b0110011) //R type of instructions
				begin
					case ({instr[31:25], instr[14:12]})
						10'b0000000000: ALUCtrl <= 4'b0010; //ADD
						10'b0100000000: ALUCtrl <= 4'b0110; //SUB
						10'b0000000001: ALUCtrl <= 4'b1001; //SLL
						10'b0000000010: ALUCtrl <= 4'b0100; //SLT
						10'b0000000100: ALUCtrl <= 4'b0101; //XOR
						10'b0000000101: ALUCtrl <= 4'b1000; //SRL
						10'b0100000101: ALUCtrl <= 4'b1010; //SRA
						10'b0000000110: ALUCtrl <= 4'b0001;//OR
						10'b0000000111: ALUCtrl <= 4'b0000;//AND
					endcase
				end
			if (instr[6:0] == 7'b0010011) //I type of instructions
				begin
					case (instr[14:12])
						3'b000: ALUCtrl <= 4'b0010; //ADDI
						3'b010: ALUCtrl <= 4'b0100; //SLTI
						3'b100: ALUCtrl <= 4'b0101; //XORI
						3'b110: ALUCtrl <= 4'b0001; //ORI
						3'b111: ALUCtrl <= 4'b0000; //ANDI
						3'b001: ALUCtrl <= 4'b1001; //SLLI
					endcase
					if ({instr[31:25], instr[14:12]} == 10'b0000000101) //SRLI
						begin
							ALUCtrl <= 4'b1000; 
						end
					if({instr[31:25], instr[14:12]} == 10'b0100000101) //SRAI
						begin
							ALUCtrl <= 4'b1010; 
						end
				end
	end

	
	
	
always @(posedge clk) //ALUSrc
	begin
		if (instr[6:0] == 7'b0000011 || instr[6:0] == 7'b0100011 || instr[6:0] == 7'b0010011)
			begin
				ALUSrc <= 1'b1;
			end
		else 
			begin
				ALUSrc <= 1'b0;
			end
	end



always @(posedge clk) // FSM
	begin 
		if (rst) 
			begin
				state <= IF;
			end 
			  
		else
		begin
			case (state)
				IF:  
					begin
						loadPC <= 0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						PCSrc <= 1'b0;
						MemWrite <= 1'b0;
						if (instr[6:0] == 7'b1100011 && Zero == 1'b1)
							begin
								PCSrc <= 1'b1;
							end
						
						if(instr[6:0] == 7'b0000011)
							begin
								MemtoReg <= 1'b1;
							end				
						
						state <= ID;  
					end
				
				ID:  
					begin
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						PCSrc <= 1'b0;

						if(instr[6:0] == 7'b0000011)
							begin
								MemtoReg <= 1'b1;
							end
						if (instr[6:0] == 7'b1100011 && Zero == 1'b1)
							begin
								PCSrc <= 1'b1;
							end
					
						state <= EX;  
					end
				
				EX:  
					begin
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						PCSrc <= 1'b0;
						MemWrite <= 1'b0;
						if(instr[6:0] == 7'b0000011)
							begin
								MemtoReg <= 1'b1;
							end
								
						if (instr[6:0] == 7'b1100011 && Zero == 1'b1)
							begin
								PCSrc <= 1'b1;
							end
							
						state <= MEM; 
					end	
				
				MEM: 
					begin
						PCSrc <= 1'b0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;

						if(instr[6:0] == 7'b0000011) // LW Instruction
							begin
								MemtoReg <= 1'b1;
								MemRead <= 1'b1;
							end
						
						if(instr[6:0] == 7'b0100011) // SW Instruction
							begin
								MemWrite <= 1'b1;
							end
						
						else
							begin
								MemRead <= 1'b0;
								MemWrite <= 1'b0;
							end
									
						if (instr[6:0] == 7'b1100011 && Zero == 1'b1)
							begin
								PCSrc <= 1'b1;
							end
							
						state <= WD;  
					end
				
				
				WD:  
					begin
						PCSrc <= 1'b0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b1;
						loadPC <= 1;
						MemWrite <= 1'b0;
						
						if(instr[6:0] == 7'b0000011)
							begin
								MemtoReg <= 1'b1;
							end
								
						if (instr[6:0] == 7'b1100011 && Zero == 1'b1)
							begin
								PCSrc <= 1'b1;
							end
								
						state <= IF;  
					end
					
				default: state <= IF;
			endcase
		end

	end




endmodule