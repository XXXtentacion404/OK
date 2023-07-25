module Data_Processing(
	input clk,					// 时钟
	input rst_n,				// 复位
	input [15:0] adc_in,		// ADC输入数据
	input [12:0] WRUSEDW,	// FIFO存储的个数
	input WREMPTY,				// FIFO写空信号
	output FIFO_WR,			// FIFO写使能
	output [15:0] FIFO_IN	// FIFO数据输入
);

reg [15:0] adc_in_reg; 		// ADC输入数据缓存
reg [15:0] FIFO_IN_REG;		// FIFO输入数据
reg FIFO_WR_EN;				// FIFO写使能
reg FIFO_WR_EN_REG;			// FIFO写使能缓存

assign FIFO_IN = FIFO_IN_REG;
assign FIFO_WR = FIFO_WR_EN_REG;

// ADC输入信号缓存
always @(posedge clk)
begin
	adc_in_reg <= adc_in;
end

reg trigger; // 触发
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		trigger <= 1'b0;
	end
	else
	begin
		if((adc_in[15:8] <= 8'd126) || (adc_in[7:0] <= 8'd126))
			trigger <= 1'b0;
		else if((adc_in[15:8] >= 8'd130) || (adc_in[7:0] >= 8'd130))
			trigger <= 1'b1;
		else
			trigger <= trigger;
	end
end

reg trigger_reg;
always @(posedge clk)
begin
	trigger_reg <= trigger;
end

reg [31:0] cnt_reg;
always @(posedge clk)
begin
	if((!trigger_reg) && (trigger) && (cnt_reg > 32'd1024))
		cnt_reg <= 32'd0;
	else
		cnt_reg <= cnt_reg + 1'b1;
end

reg [47:0] cnt;
always @(posedge trigger)
begin
	if(cnt_reg > 32'd1024)
		cnt <= cnt_reg;
end

reg [31:0] cnt_cnt;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		FIFO_WR_EN <= 1'b0;
		cnt_cnt <= 0;
	end
	else
	begin
		if((WREMPTY || (WRUSEDW < 13'd10)) && (cnt_reg == cnt_cnt))
			FIFO_WR_EN <= 1'b1;
		else if((FIFO_WR_EN) && ((cnt_reg >= (cnt_cnt + 1024))) && ((cnt - cnt_cnt) > 1024))
		begin
			FIFO_WR_EN <= 1'b0;
			cnt_cnt <= cnt_cnt + 1024;
		end
		else if((FIFO_WR_EN) && (cnt_reg >= cnt))
		begin
			FIFO_WR_EN <= 1'b0;
			cnt_cnt <= 32'd0;
		end
		else if(cnt_cnt > cnt)
		begin 
			cnt_cnt <= 32'd0;
		end 
		else
			FIFO_WR_EN <= FIFO_WR_EN;
	end
end

// FIFO写使能缓存
always @(posedge clk)
begin
	FIFO_WR_EN_REG <= FIFO_WR_EN;
end

// 更新FIFO写入的数据
always @(posedge clk)
begin
	if(FIFO_WR_EN)
		FIFO_IN_REG <= adc_in_reg;
end 

endmodule 

