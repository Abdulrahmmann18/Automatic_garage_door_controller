module Garage_Door_Controller_tb();

	parameter CLOCK_PERIOD = 20;
	// signals declaration
	reg  CLK_tb;
	reg  RST_tb;
	reg  UP_Max_tb;
	reg  DN_Max_tb;
	reg  Activate_tb;
	wire UP_M_tb;
	wire DN_M_tb;
	
	// clock generation block
	initial begin
		CLK_tb = 0;
		forever #(CLOCK_PERIOD/2) CLK_tb = ~CLK_tb;
	end

	// DUT Instantiation
	Garage_Door_Controller DUT 
	(
		.CLK(CLK_tb), .RST(RST_tb),
		.UP_Max(UP_Max_tb), .DN_Max(DN_Max_tb),
		.Activate(Activate_tb), .UP_M(UP_M_tb) , .DN_M(DN_M_tb)
	);

	// Initial block
	initial begin
		Initialize();
		RST_TASK();
		operation(5'b10010, 5'b11000, 5'b00011);
		#(CLOCK_PERIOD)
		$stop;
	end

	/******************************************************************************************************************/
	// tasks
	task Initialize;
		begin
			UP_Max_tb = 1'b0;
			DN_Max_tb = 1'b0;
			Activate_tb = 1'b0;
		end
	endtask

	task RST_TASK;
		begin
			RST_tb = 1'b0;
			#(2*CLOCK_PERIOD)
			RST_tb = 1'b1;
		end
	endtask

	// next state and output logic
	integer j;
	task operation;
		input [4:0] activate_value;
		input [4:0] up_sensor;
		input [4:0] down_sensor;
		begin
			for (j=0; j<5; j=j+1) begin
				@(negedge CLK_tb)
				Activate_tb = activate_value[j];
				UP_Max_tb = up_sensor[j];
				DN_Max_tb = down_sensor[j];	
			end
		end

	endtask


endmodule