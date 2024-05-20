module Garage_Door_Controller
(
	input wire CLK,
	input wire RST,
	input wire UP_Max,
	input wire DN_Max,
	input wire Activate,
	output reg UP_M,
	output reg DN_M
);
	
	localparam IDLE = 2'b00,
			   Mv_Dn = 2'b01,
			   Mv_Up = 2'b10;

	reg [1:0] cu_s, nx_s;

	// current state f_F
	always @(posedge CLK or negedge RST) begin
		if (~RST) 
			cu_s <= IDLE;
		else 
			cu_s <= nx_s;		
	end

	// next state and output logic
	always @(*) begin
		// default values
		nx_s = IDLE; 
		UP_M = 1'b0;
		DN_M = 1'b0;
		case (cu_s)
			IDLE :
			begin
				UP_M = 1'b0;
				DN_M = 1'b0;
				if (~Activate)
					nx_s = IDLE;
				else if (UP_Max && ~DN_Max)
					nx_s = Mv_Dn;
				else if (~UP_Max && DN_Max)
					nx_s = Mv_Up; 
			end
			Mv_Dn :
			begin
				UP_M = 1'b0;
				DN_M = 1'b1;
				if (DN_Max)
					nx_s = IDLE;
				else
					nx_s = Mv_Dn; 
			end
			Mv_Up :
			begin
				UP_M = 1'b1;
				DN_M = 1'b0;
				if (UP_Max)
					nx_s = IDLE;
				else
					nx_s = Mv_Up; 
			end
			default :
			begin
				nx_s = IDLE; 
				UP_M = 1'b0;
				DN_M = 1'b0;
			end

		endcase
	end

endmodule