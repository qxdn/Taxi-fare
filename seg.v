
//动态显示
module seg
(
	input clk, // 系统时钟50MHz
	input sys_reset, //复位按键
	input  [15:0] data, //0~9999
	input 	[3:0] point,  //4位小数点
	output reg [3:0] seg_sel,  //位选
	output reg [7:0] seg_led   //段选
);

localparam  CLK_DIVIDE = 4'd10     ;        // 时钟分频系数
localparam  MAX_NUM    = 13'd5000  ;        // 对数码管驱动时钟(5MHz)计数1ms所需的计数值

reg [3:0] clk_cnt;  //分频计数器
reg  dri_clk;      //驱动时钟 避免过快
reg [15:0] num;    //4个8421BCD
reg [12:0]       cnt0;        // 数码管驱动时钟计数器
reg               flag;        // 标志信号（标志着cnt0计数达1ms）
reg [4:0] num_disp;    //当前显示的值
reg  point_disp;  //显示小数点
reg [1:0]    cnt_sel; //4个位选

wire [3:0] data0;   //个位
wire [3:0] data1;   //十位
wire [3:0] data2;   //百位
wire [3:0] data3;   //千位

assign  data0 = data % 4'd10;  //个位
assign  data1 = data /4'd10 % 4'd10; //十位
assign  data2 = data /7'd100%4'd10; //百位
assign  data3 = data /10'd1000%4'd10; //千位

//对系统时钟10分频，得到的频率为5MHz的数码管驱动时钟dri_clk
always @(posedge clk or negedge sys_reset) 
	begin
   if(!sys_reset) 
		begin
       clk_cnt <= 4'd0;
       dri_clk <= 1'b1;
		end
   else if(clk_cnt == CLK_DIVIDE/2 - 1'd1) 
		begin
       clk_cnt <= 4'd0;
       dri_clk <= ~dri_clk;
		end
   else 
		begin
       clk_cnt <= clk_cnt + 1'b1;
       dri_clk <= dri_clk;
		end
end

//将16为二进制转换成8421BCD
always @(posedge dri_clk or negedge sys_reset)
	begin
		if(!sys_reset)
		begin
			num<=16'd0;
		end
		else
		begin
		num[15:12]<=data3;
		num[11:8]<=data2;
		num[7:4]<=data1;
		num[3:0]<=data0;
		end
	end
//计时1ms
always @(posedge dri_clk or negedge sys_reset)
	begin
		if(!sys_reset)
			begin
			cnt0<=13'b0;
			flag<=1'b0;
			end
		else if (cnt0 < MAX_NUM - 1'b1) 
			begin
        cnt0 <= cnt0 + 1'b1;
        flag <= 1'b0;
			end
		else 
		begin
        cnt0 <= 13'b0;
        flag <= 1'b1;
		end
	end
//位选切换
always @(posedge dri_clk or negedge sys_reset)
	begin
		if(!sys_reset)
			begin
			 cnt_sel<=2'b0;
			end 
		else	if(flag)
			begin
				if(cnt_sel==2'b11)
					begin
						cnt_sel<=2'b00;
					end
				else
					begin
						cnt_sel<=cnt_sel+1'b1;
					end
			end
		else
			begin
				cnt_sel<=cnt_sel;
			end
	end
//位选信号
always @(posedge dri_clk or negedge sys_reset)
	begin
		if(!sys_reset)
			begin
			 seg_sel=4'b1111;   //低电平有效
			 num_disp<=4'b0000;  //显示0
			 point_disp<=1'b1;
			end 
		else
			begin
				case (cnt_sel)
					2'd0:
					begin
						seg_sel  <= 4'b1110;  //显示数码管最低位
						num_disp <= num[3:0];  //显示的数据
						point_disp <= ~point[0];  //显示的小数点
					end
					2'd1:
					begin
						seg_sel  <= 4'b1101;  //显示数码管1位
						num_disp <= num[7:4];  //显示的数据
						point_disp <= ~point[1];  //显示的小数点
					end
					2'd2:
					begin
						seg_sel  <= 4'b1011;  //显示数码管百位
						num_disp <= num[11:8] ;  //显示的数据
						point_disp <= ~point[2];  //显示的小数点
					end
					2'd3:
					begin
						seg_sel  <= 4'b0111;  //显示数码管千位
						num_disp <= num[15:12] ;  //显示的数据
						point_disp <= ~point[3];  //显示的小数点
					end
				endcase
		end
	end
//段选控制
always @(posedge dri_clk or negedge sys_reset)
	begin
		if(!sys_reset)
			begin
				seg_led <= 8'b1111_1111;
			end
		else
			begin
				case (num_disp)
					4'd0 : seg_led <= {point_disp,7'b1000000}; //显示数字 0
					4'd1 : seg_led <= {point_disp,7'b1111001}; //显示数字 1
					4'd2 : seg_led <= {point_disp,7'b0100100}; //显示数字 2
					4'd3 : seg_led <= {point_disp,7'b0110000}; //显示数字 3
					4'd4 : seg_led <= {point_disp,7'b0011001}; //显示数字 4
					4'd5 : seg_led <= {point_disp,7'b0010010}; //显示数字 5
					4'd6 : seg_led <= {point_disp,7'b0000010}; //显示数字 6
					4'd7 : seg_led <= {point_disp,7'b1111000}; //显示数字 7
					4'd8 : seg_led <= {point_disp,7'b0000000}; //显示数字 8
					4'd9 : seg_led <= {point_disp,7'b0010000}; //显示数字 9
				endcase
			end
	end
endmodule
