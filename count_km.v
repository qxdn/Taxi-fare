module count_km(
	input key_dri,
	input sys_reset_n,
	
	output reg [15:0] data_km,
	output [3:0] point
);

parameter max_km=16'd9999; 

assign point=4'b0010;

initial 
data_km<=16'b0;

always @(negedge key_dri or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				data_km<=16'b0;
			end
		else if(!key_dri)
			begin
				if(data_km<max_km)
					begin
						data_km<=data_km+1'b1;
					end
				else
					begin
						data_km<=16'd0;
					end
			end
	end

endmodule
