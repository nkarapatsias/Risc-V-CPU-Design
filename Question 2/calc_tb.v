`timescale 1ns/1ps //initializing timescaling


	`include "calc.v"

	module calc_tb;

	reg clk, btnc, btnl, btnu, btnr, btnd;
	reg [15:0] sw;
	wire [15:0] led;
	reg [15:0] prev_val; // Creating a helping register to store the previous value of accumulator before it changes in the next clock cycle

	
	//Starting clock
	initial 
		begin 			
			clk = 0; // Initialize clock to 0
			forever #10 clk = ~clk; // Toggle clock every 10 tu
		end

      calc my_calc ( .clk(clk), .btnc(btnc), .btnl(btnl), .btnu(btnu), .btnr(btnr), .btnd(btnd),.sw(sw),.led(led));
	
	
	
	initial 
		begin
			$display("Input(btnl, btnc, btnr)\t\t\tPREVIOUS VALUE(ACC)\t\t\tSWITCHES(INPUT)\t\t\t\t\tRESULT");
			btnu = 1'b1;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnu = 1'b0;
			#20;
			
			sw = 16'h354a;
			btnd = 1'b0;

			
			btnl = 1'b0; btnc = 1'b1; btnr = 1'b0; 
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
		  
			btnd = 1'b0;
			
			sw = 16'h1234;

			btnl = 1'b0; btnc = 1'b1; btnr = 1'b1;
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			sw = 16'h1001;	
			btnl = 1'b0; btnc = 1'b0; btnr = 1'b1;
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			  
			sw = 16'hf0f0;	
			btnl = 1'b0; btnc = 1'b0; btnr = 1'b0; 
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			 sw = 16'h1fa2;		
			btnl = 1'b1; btnc = 1'b1; btnr = 1'b1; 
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			 sw = 16'h6aa2;	
			btnl = 1'b0; btnc = 1'b1; btnr = 1'b0; 
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			 sw = 16'h0004;	
			btnl = 1'b1; btnc = 1'b0; btnr = 1'b1; 
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			 sw = 16'h0001;
			btnl = 1'b1; btnc = 1'b1; btnr = 1'b0;
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;
			
			 sw = 16'h46ff;	
			btnl = 1'b1; btnc = 1'b0; btnr = 1'b0;
			#20;
			btnd = 1'b1;
			prev_val = led;
			#20;
				$display("%b%b%b\t\t\t\t\t    %h\t\t\t\t    %h\t\t\t\t\t %h",btnl, btnc, btnr, prev_val, sw, led);
			btnd = 1'b0;	
			$finish;
		end
  
  endmodule