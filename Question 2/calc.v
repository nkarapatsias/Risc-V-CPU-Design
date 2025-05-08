`include "calc_enc.v"
`include "alu.v"


module calc ( input wire clk, btnc, btnl, btnu, btnr, btnd, input wire [15:0] sw, output wire [15:0] led );

  reg [15:0] accumulator = 16'b0;
  wire [31:0] result;
  wire [31:0] op1, op2;
  wire [3:0] alu_op;
  wire zero;
  
	
  assign op1 = {{16{accumulator[15]}}, accumulator};
  assign op2 = {{16{sw[15]}}, sw}; 
  assign led = accumulator; //Led is assigned with the accumulators value
  
  
  
  calc_enc my_calc_enc (.btnc(btnc), .btnl(btnl), .btnr(btnr), .alu_op(alu_op));
  
  alu my_alu(.op1(op1), .op2(op2), .alu_op(alu_op), .zero(zero), .result(result));
  
  always @(posedge clk) begin
   	if (btnu) begin
       	accumulator<=16'b0; //Accumulator zeroed synchronously with btnu
			end
  	
		if (btnd) begin
         accumulator <= result[15:0]; //updating accumulator synchronously 
         end							     //with alu result 
         
  end
  
endmodule
