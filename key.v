module key
(
	input                   clk,       //50MHz
	input                reset_n,      //复位低电平有效
	input   	[2:0]           key,       //输入
	output   				change_dis,
	output					add_km,
	output					stop,			//输出
	output    sys_reset_n
);

reg[2:0] D_ff_1;           
reg[2:0] D_ff_2;     
reg[2:0] D_ff_3;   
reg D_ff_1_reset_n;
reg D_ff_2_reset_n;
reg D_ff_3_reset_n;

always@(posedge clk )
begin
	D_ff_1 <= ~key;  
   D_ff_1_reset_n<=~reset_n;	
end

always@(posedge clk )
begin
	D_ff_2 <= D_ff_1;     
	D_ff_2_reset_n<=D_ff_1_reset_n;
end

always@(posedge clk)
begin
	D_ff_3_reset_n<=D_ff_2_reset_n;
	D_ff_3 <= D_ff_2;      
end

assign change_dis = D_ff_1[2]&D_ff_2[2]&D_ff_3[2];
assign add_km	=	D_ff_1[1]&D_ff_2[1]&D_ff_3[1];
assign stop = D_ff_1[0]&D_ff_2[0]&D_ff_3[0];
assign sys_reset_n=~(D_ff_1_reset_n&D_ff_2_reset_n&D_ff_3_reset_n);

endmodule 