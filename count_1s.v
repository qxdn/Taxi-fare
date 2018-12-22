//计时模块
module count_1s
(
	input clk,   //系统时钟
	input sys_reset_n, //复位信号
	input EN, //使能  保持
	
	output reg [7:0] data_s,  //秒计时器
	output reg [7:0] data_m,	//分钟计时器
	output [3:0] point   //点
);

parameter time_60=8'd60;
parameter MAX_NUM=28'd24_999_999;

reg [27:0] cnt; //1s计数器
reg   clk_1s;  //1s脉冲
reg   flag_1m;  //1m计时

assign point=4'b0100;
//1s计时
always @(posedge clk or negedge sys_reset_n)
	begin
		if(!sys_reset_n)
			begin
				cnt<=1'b0;
				clk_1s<=1'b0;
		end
		else if(!EN)
			begin
				cnt<=cnt;   //保持
				clk_1s<=clk_1s;
			end
		else if(cnt<MAX_NUM)
			begin
				cnt<=cnt+1'b1;
			end
		else
			begin
				cnt<=0;
				clk_1s<=~clk_1s;  //翻转
			end
	end
//	秒加1
always @(negedge clk_1s or negedge sys_reset_n)	
	begin
		if(!sys_reset_n)
			begin
				data_s<=0;
				flag_1m<=0;
			end
		else if(!EN)
			begin
				data_s<=data_s;   //保持
				flag_1m<=flag_1m;
			end
		else if(data_s < time_60-1)
			begin
				data_s<=data_s+1'b1;		
				flag_1m<=0;					
			end
		else
			begin
				data_s<=0;
				flag_1m<=1;					
			end			
	end
//分钟加一
always @(posedge flag_1m or negedge sys_reset_n)	
	begin
		if(!sys_reset_n)
			begin
				data_m<=0;
			end
		else if(!EN)
			begin
				data_m<=data_m;   //保持
			end
		else  
			begin
				if(data_m<time_60-1)
					begin
						data_m<=data_m+1'b1;
					end
				else
					begin
						data_m<=0;
					end
					
			end
	end

endmodule
