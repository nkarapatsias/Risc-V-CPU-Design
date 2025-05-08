module regfile #(parameter DATAWIDTH = 32)
( input wire clk , write, 
  input wire [4:0] readReg1, readReg2, writeReg, 
  input wire [DATAWIDTH-1:0] writeData,
  output reg [DATAWIDTH-1:0] readData1,readData2
);
	
	integer i;
	reg [DATAWIDTH-1:0] registers [31:0];
	
	initial begin
		for(i=0; i<32; i=i+1)
			begin
				registers[i] = 32'b0;
			end
	end
	


	
	always @(posedge clk) begin
		if (write)
			begin
				if (writeReg == readReg1) //Giving priority to writing data
					begin
					registers[writeReg] = writeData; // Asychronous write as the lecturer noted
					readData1 <= registers[readReg1];
					readData2 <= registers[readReg2];
					end
				else if (writeReg == readReg2) //Giving priority to writing data
					begin
					registers[writeReg] = writeData;
					readData1 <= registers[readReg1];
					readData2 <= registers[readReg2];
					end
				else					
					begin
					registers[writeReg] <= writeData;
					readData1 <= registers[readReg1];
					readData2 <= registers[readReg2];
					end

			end
		else 
			begin
				readData1 <= registers[readReg1];
				readData2 <= registers[readReg2];
			end
			
	end

	
	
	
endmodule