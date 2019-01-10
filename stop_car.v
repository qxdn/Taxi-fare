module stop_car(
	input  stop_key,
	input  sys_reset_n,
	
	output reg  en_time,
	output reg 	en_km
);

initial
	begin
		en_time<=1'b0;
		en_km<=1'b1;
	end

always @(posedge stop_key or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				en_time<=1'b0;
				en_km<=1'b1;
			end
		else
			begin
				en_time<=~en_time;
				en_km<=~en_km;
			end
	end
endmodule
