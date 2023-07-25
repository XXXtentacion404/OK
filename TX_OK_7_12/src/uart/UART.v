module UART(
	input clk,					// 时钟
	input clk_50m,				// 50MHz时钟
	input rst_n,				// 复位
	input key,					// 按键，按下按键开始串口传输
	input WREMPTY,				// FIFO写空信号
	input [15:0] FIFO_OUT,	// FIFO数据输出
	input RX,					// 串口读
	output TX,					// 串口写
	output reg FIFO_RD_CLK	// FIFO读时钟
);

reg WR_EN;						// 串口写使能
reg [3:0] i;					// 数组arry的下标
reg [7:0] arry [15:0];		// 串口发送的数据
wire TX_BUSY;					// 串口发送忙信号

// 串口发送一个ADC数据的格式：A:+数据+换行符
initial 
begin 
	arry[0]  <= "0";
	arry[1]  <= "0";
	arry[2]  <= "0";
	arry[3]  <= "1";
	arry[4]  <= "2";
	arry[5]  <= "8";
	arry[6]  <= 8'h0D;
	arry[7]  <= 8'h0A;
	arry[8]  <= "0";
	arry[9]  <= "0";
	arry[10] <= "0";
	arry[11] <= "1";
	arry[12] <= "2";
	arry[13] <= "8";
	arry[14] <= 8'h0D;
	arry[15] <= 8'h0A;
end
  
// 更新串口发送的数据
always @(posedge clk) 
begin
	if(i == 3'd1)	// 当数组arry的下标为1时，读取FIFO中的数据
		FIFO_RD_CLK <= 1'b1;
	else
		FIFO_RD_CLK <= 1'b0;
end

// 将传输的数据转换成ASCII值
always @(posedge clk)
begin
	if(!FIFO_RD_CLK)
	begin
//		arry[2]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd1000 % 12'd10);
//		arry[3]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd100 % 12'd10);
//		arry[4]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd10 % 12'd10);
//		arry[5]  <= 8'd48 + (FIFO_OUT[15:8] % 12'd10);
//		
//		arry[10] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd1000 % 12'd10);
//		arry[11] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd100 % 12'd10);
//		arry[12] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd10 % 12'd10);
//		arry[13] <= 8'd48 + (FIFO_OUT[7 :0] % 12'd10);
		
		arry[10]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd1000 % 12'd10);
		arry[11]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd100 % 12'd10);
		arry[12]  <= 8'd48 + (FIFO_OUT[15:8] / 12'd10 % 12'd10);
		arry[13]  <= 8'd48 + (FIFO_OUT[15:8] % 12'd10);
		
		arry[2] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd1000 % 12'd10);
		arry[3] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd100 % 12'd10);
		arry[4] <= 8'd48 + (FIFO_OUT[7 :0] / 12'd10 % 12'd10);
		arry[5] <= 8'd48 + (FIFO_OUT[7 :0] % 12'd10);
	end
end

// 数组arry的下标
always @(posedge TX_BUSY or negedge rst_n)
begin
	if(!rst_n)
	begin
		i <= 4'd0;
	end
	else
	begin
		i <= i + 1'b1;
	end
end


always @(posedge clk or negedge rst_n) 
begin
	if(!rst_n)
		WR_EN <= 1'b0;
	else
	begin
		if(~key)	// 当按键按下，串口开始发送数据
			WR_EN <= 1'b1;
		else if(WREMPTY)	// 当FIFO为空时，串口停止发送数据
			WR_EN <= 1'b0;
	end
end

// 串口通信
UART_DATA UART_DATA_TEXT(
	.din(arry[i]),			// 发送的数据
	.wr_en(WR_EN),			// 写使能
	.clk_50m(clk_50m),	// 时钟
	.tx(TX),					// 写
	.tx_busy(TX_BUSY),	// 写忙信号
	.rx(RX),					// 读
	.rdy(),					// 读完成
	.rdy_clr(),				// 清除
	.dout()					// 读取的数据
);

endmodule 