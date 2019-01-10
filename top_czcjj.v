module top_czcjj(
	input sys_clk,
	input reset_n,
	input   [2:0]    key,       //3个按键输入
	
	output [3:0] seg_sel,  //位选
	output [7:0] seg_led   //段选
);

wire sys_reset_n;
wire [7:0] data_s;
wire [7:0] data_m;
wire [4:0] second_point;
wire [15:0] dis_data;
wire [4:0] dis_point;
wire change_dis;
wire add_km;
wire [15:0] data_km;
wire [3:0]	point_km;
wire [15:0]	data_price;
wire [3:0] point_price;
wire stop_key;
wire en_time;
wire en_km;

key u_key(
	.clk          			(sys_clk),
	.reset_n    		   (reset_n),
	.key 			         (key),
	
	.change_dis      		(change_dis),
	.add_km					(add_km),
	.stop						(stop_key),
	.sys_reset_n  			(sys_reset_n)
);

count_1s u_count_1(
	.clk						(sys_clk),
	.sys_reset_n			(sys_reset_n),
	.EN                  (en_time),
	
	.data_s					(data_s),
	.data_m					(data_m),
	.point               (second_point)
);

seg u_seg(
	.clk						(sys_clk),
	.sys_reset				(sys_reset_n),
	.data						(dis_data),
	.point					(dis_point),
	
	.seg_sel					(seg_sel),
	.seg_led					(seg_led)
);
mux u_mux(
	.key_dri					(change_dis),
	.sys_reset_n 			(sys_reset_n),
	.data_1_kilometer		(data_km),
	.data_1_point			(point_km),
	.data_2_time			(data_m*100+data_s),
	.data_2_point			(second_point),
	.data_3_price			(data_price),
	.data_3_point			(point_price),
	
	.dis_data				(dis_data),
	.dis_point				(dis_point)
);
count_km u_count_km(
	.key_dri					(add_km),
	.sys_reset_n			(sys_reset_n),
	.EN						(en_km),
	
	.data_km					(data_km),
	.point					(point_km)
);
count_money u_price(
	.data_m					(data_m),
	.data_km					(data_km),
	.sys_reset_n			(sys_reset_n),
	.clk						(sys_clk),
	
	.data_price				(data_price),
	.point					(point_price)
);
stop_car u_stop(
	.stop_key				(stop_key),
	.sys_reset_n			(sys_reset_n),

	.en_time					(en_time),
	.en_km					(en_km)
);
endmodule
