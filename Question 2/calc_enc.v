module calc_enc (
input wire btnc, btnl, btnr,
output wire [3:0] alu_op);



wire n1_result_0, a1_result_0, a2_result_0, result_0; //result declarations for alu_op[0] gates
wire n1_result_1, n2_result_1, a1_result_1, a2_result_1, result_1; //result declarations for alu_op[1] gates
wire n1_result_2, n2_result_2, a1_result_2, a2_result_2, a3_result_2, result_2; //result declarations for alu_op[2] gates
wire n1_result_3, n2_result_3, a1_result_3, a2_result_3, a3_result_3, a4_result_3, result_3; //result declarations for alu_op[3] gates	


assign alu_op[0] = result_0;
assign alu_op[1] = result_1;
assign alu_op[2] = result_2;
assign alu_op[3] = result_3;


// alu_op[0]


not n1_0 (n1_result_0, btnc);
and a1_0 (a1_result_0, n1_result_0, btnr);
and a2_0 (a2_result_0, btnr, btnl);
or o1_0 (result_0, a1_result_0, a2_result_0);


// alu_op[1]

not n1_1 (n1_result_1, btnl);
and a1_1 (a1_result_1, n1_result_1, btnc);
not n2_1 (n2_result_1, btnr);
and a2_1 (a2_result_1, n2_result_1, btnc);
or o1_1 (result_1, a1_result_1, a2_result_1);



// alu_op[2]

and a1_2 (a1_result_2, btnc, btnr);
not n1_2 (n1_result_2, btnc);
and a2_2 (a2_result_2, n1_result_2, btnl);
not n2_2 (n2_result_2, btnr);
and a3_2 (a3_result_2, n2_result_2, a2_result_2);
or o1_2 (result_2, a1_result_2, a3_result_2);


// alu_op[3]
not n1_3 (n1_result_3 ,btnc);
and a1_3 (a1_result_3, n1_result_3, btnl);
and a2_3 (a2_result_3, a1_result_3, btnr);
and a3_3 (a3_result_3, btnc, btnl);
not n2_3 (n2_result_3, 	btnr);
and a4_3 (a4_result_3, a3_result_3, n2_result_3);
or o1_3	(result_3, a2_result_3, a4_result_3);






endmodule
