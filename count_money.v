module count_money(
	input [7:0] data_m,
	input [15:0] data_km,
	input sys_reset_n,
	input clk,
	
	output reg [15:0] data_price,
	output [3:0] point
);

assign point=4'b0010;

reg [15:0] price_km;
reg [15:0] price_time;

initial
	begin
		price_km<=16'd30;
		price_time<=16'd0;
	end
	
//里程计价
always @(posedge clk or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				price_km<=16'd30;
			end
		else if(data_km < 16'd10)
			price_km<=16'd30;
		else if(data_km < 16'd15)
			price_km<=16'd40;
		else if(data_km < 16'd20)
			price_km<=16'd50;
		else if(data_km < 16'd25)
			price_km<=16'd60;
		else if(data_km < 16'd30)
			price_km<=16'd70;
		else
			begin
			price_km<=16'd80+((data_km-16'd30)/5)*4'd7;
			end			
	end
//计时价格
always @(posedge clk or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				price_time<=16'd0;
			end
		else
			begin
				price_time<=(data_m/3)*4'd7;
			end
	end

always @(posedge clk)
	begin
		data_price<=price_km+price_time;
	end
endmodule
