module mux(
	input             key_dri,              //按键输入
	input 				sys_reset_n,			 //计数器清零信号
	input [15:0] 		data_1_kilometer,     //路程的输入
	input [3:0]			data_1_point,    		 //千米的小数点
	input [15:0] 		data_2_time, 			 //时间的输入
	input [3:0] 		data_2_point,			 //时间的小数点
	input [15:0] 		data_3_price,   		 //价格的输入
	input  [3:0]			data_3_point,			 //价格的小数点
	
	output reg [15:0]	   dis_data,				 //显示的数据
	output reg [3:0]		dis_point				 //显示的小数点
);

reg [1:0] cnt;

//计数选择
always @(posedge key_dri or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				cnt<=0;
			end
		else if(cnt < 2'd2)
			begin
				cnt<=cnt +1'b1;
			end
		else
			begin
				cnt <= 0;
			end
	end
	
always @(cnt,data_1_kilometer,data_1_point,data_2_time,data_2_point,data_3_price,data_3_point)
	begin
		case(cnt)
			2'd0: 
				begin
					dis_data <= data_1_kilometer;
					dis_point <= data_1_point;
				end
			2'd1:
				begin
					dis_data <= data_2_time;
					dis_point <= data_2_point;
				end
			2'd2:
				begin
					dis_data <= data_3_price;
					dis_point <= data_3_point;
				end
		endcase
	end
endmodule
