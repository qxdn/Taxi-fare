module top_czcjj(
	input sys_clk,
	input reset_n,
	input   [2:0]    key,       //3个按键输入
	
	output [1:0] test_led,  //2个测试LED
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

key u_key(
	.clk          			(sys_clk),
	.reset_n    		   (reset_n),
	.key 			         (key),
	
	.control      			({change_dis,test_led}),
	.sys_reset_n  			(sys_reset_n)
);

count_1s u_count_1(
	.clk						(sys_clk),
	.sys_reset_n			(sys_reset_n),
	.EN                  (1'b1),
	
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
	.data_1_kilometer		(16'b1111_1110_1101),
	.data_1_point			(4'b0010),
	.data_2_time			(data_m*100+data_s),
	.data_2_point			(second_point),
	.data_3_price			(8'b1111_1011),
	.data_3_point			(4'b0010),
	
	.dis_data				(dis_data),
	.dis_point				(dis_point)
);

endmodule
