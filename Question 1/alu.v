module alu (
	input wire [31:0] op1, op2,   // Input number 1 and 2
	input wire [3:0] alu_op,   // alu operation
	output reg zero,				//output zero	
	output reg [31:0] result// Output result
);

	parameter [3:0] ALUOP_AND=4'b0000, ALUOP_OR=4'b0001, ALUOP_ADD=4'b0010, ALUOP_SUB=4'b0110, ALUOP_LESS_THAN=4'b0100, 
	ALUOP_SLIDE_R=4'b1000, ALUOP_SLIDE_L=4'b1001, ALUOP_ASLIDE=4'b1010, ALUOP_XOR=4'b0101;
	always @(*) begin
		result <= 32'b0;
      zero <= 1'b0;
		case(alu_op)
			ALUOP_AND: result <= (op1&op2); //AND
			ALUOP_OR: result <= (op1|op2); //OR
			ALUOP_ADD: result <= (op1+op2); //ADDITION
			ALUOP_SUB: result <= (op1-op2); //SUBTRACT
			ALUOP_LESS_THAN: result <= (op1 < op2) ? 32'b1 : 32'b0; //OP1<OP2
			ALUOP_SLIDE_R: result <= (op1>>op2[4:0]); // op1>>op2[4:0]
			ALUOP_SLIDE_L: result <= (op1<<op2[4:0]); //op1<<op2[4:0]
			ALUOP_ASLIDE: result <= ($unsigned($signed(op1)>>>op2[4:0])); //op1>>>op2[4:0]
			ALUOP_XOR:	result <= (op1^op2); //op1^op2	
			default: result <= 32'b0;
		endcase
		zero <= (result == 32'b0) ? 1'b1 : 1'b0;
		
	end
		
	
	
	
	
	endmodule

