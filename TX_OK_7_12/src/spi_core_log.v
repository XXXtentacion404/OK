//*****************************************************************
//*  描    述:  SPI核心模块
//*  开始时间:  2019-07-01
//*  完成时间:  2019-07-01
//*  修改时间:  2019-07-01
//*  版    本:  V2.1
//*  作    者:  凌智电子
//*****************************************************************
module  spi_core_log #(
parameter  DATA_WIDTH  = 8                // 数据宽度
)
(
  input                       clk,        // 时钟信号
  input                       rst_n,      // 时钟信号
  input                       spi_sdi,    // SPI 输入  MOSI
  output                      spi_sdo,    // SPI 输出  MISO
  input                       spi_cs,     // 通道片选信号
  input                       spi_scl,    // SPI 时钟信号 SCLK
  input   [DATA_WIDTH-1:0]    din,        // FPGA -> STM32 数据
  output  [DATA_WIDTH-1:0]    dout,       // 通道数据输出
  output                      data_valid  // 通道数据有效信号, 高电平有效
);

// 输入移位寄存器, 初始化为0
reg   [DATA_WIDTH-1:0]   Shift_Reg_Din  = {DATA_WIDTH{1'b0}};
// 输出移位寄存器, 初始化为0
reg   [DATA_WIDTH-1:0]   Shift_Reg_DOUT = {DATA_WIDTH{1'b0}};
// 通道数据有效信号寄存器，初始化为0
reg                      data_done_reg  = 1'b0;
// 通道数据输出寄存器，初始化为0
reg   [DATA_WIDTH-1:0]   dout_reg = {DATA_WIDTH{1'b0}};

reg   [2:0]   spi_cs_reg = 3'b000;	// spi_cs寄存器
// spi_cs寄存
always @(posedge clk) 
begin 
  spi_cs_reg <= {spi_cs_reg[1:0], spi_cs};
end 

// spi_cs上升沿标志位
reg   done_reg=1'b0;	
// spi_cs上升沿：done_reg=1；否则等于0；
always @(posedge clk) 
begin 
  if (spi_cs_reg[2:0] == 3'b011) 
  begin 
    done_reg <= 1'b1;
  end 
  else 
  begin 
    done_reg <= 1'b0;
  end 
end 

// 输入移位寄存器
always @(posedge spi_scl) 
begin 
  if (!spi_cs) 
  begin 
    Shift_Reg_Din <= {Shift_Reg_Din[DATA_WIDTH-2:0], spi_sdi};
  end 
end 

// 移位寄存器的值送出到通道数据输出寄存器
always @(posedge spi_cs) 
begin 
  dout_reg <= Shift_Reg_Din;
end 
assign dout = dout_reg;  // 通道数据输出寄存器送出到端口


always @(posedge spi_cs or posedge done_reg) 
begin 
  if (done_reg) 
  begin 
   data_done_reg <= 1'b0;    
  end 
  else 
  begin 
   data_done_reg <= 1'b1;    
  end 
end 
assign data_valid = data_done_reg;    // 指示数据有效


// 输出移位寄存器
always @(negedge spi_scl or posedge spi_cs) 
begin 
  if (spi_cs) 
  begin 
    Shift_Reg_DOUT <= din;
  end 
  else 
  begin 
    Shift_Reg_DOUT <= {Shift_Reg_DOUT[DATA_WIDTH-2:0], 1'b0};
  end 
end 

assign spi_sdo = (!spi_cs) ? Shift_Reg_DOUT[DATA_WIDTH-1] : 1'bz;  // 最高位输出

endmodule

