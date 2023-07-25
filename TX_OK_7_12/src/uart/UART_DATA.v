//--------------------------------------------------------------
// 程序描述:
//     串口通讯
// 作    者: 凌智电子
// 开始日期: 2018-08-24
// 完成日期: 2018-08-24
// 修改日期:
// 版    本: V1.0: 
// 调试工具: 
// 说    明:
//     
//--------------------------------------------------------------
module UART_DATA(
	input wire [7:0] din,	//传输的数据
	input wire wr_en,			//传输使能
	input wire clk_50m,		//系统时钟
	output wire tx,			//传输数据线
	output wire tx_busy,		//传输忙
	input wire rx,				//接收数据线
	output wire rdy,			//接收结束
	input wire rdy_clr,		
	output wire [7:0] dout	//接收的数据
);

wire rxclk_en, txclk_en;
reg rdy_r;
reg rdy_clr_r;
reg wr_en_r;
reg [7:0] din_r;

always @(posedge clk_50m)
begin 
	rdy_clr_r = rdy;
	rdy_r <= rdy;
end 

always @(posedge clk_50m)
begin 
	wr_en_r = wr_en;
end 

always @(posedge clk_50m)
begin
	if(wr_en)
		din_r <= din;
	if(rdy)
		din_r <= dout;
end

//波特率
Baud_Rate UART_Baud_Rate(
	.clk_50m(clk_50m),
	.rxclk_en(rxclk_en),
	.txclk_en(txclk_en)
);
//数据传输
UART_TX UART_TX_DATA(
	.din(din_r),
	.wr_en(rdy_r | wr_en_r),
	.clk_50m(clk_50m),
	.clken(txclk_en),
	.tx(tx),
	.tx_busy(tx_busy)
);
//数据接收
UART_RX UART_RX_DATA(
	.rx(rx),
	.rdy(rdy),
	.rdy_clr(rdy_clr_r & (tx_busy)),
	.clk_50m(clk_50m),
	.clken(rxclk_en),
	.data(dout)
);

endmodule 