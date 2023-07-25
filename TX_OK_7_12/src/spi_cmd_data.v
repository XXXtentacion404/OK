//*************************************************************************************
//* 
//*************************************************************************************

module  spi_cmd_data#(
  parameter  DATA_WIDTH  = 32,              // 数据位宽
  parameter  CMD_WIDTH   = 8                // 命令位宽
)
(
  input                       clk,          // 时钟信号
  input                       rst_n,		  // 复位
  input                       spi_sdi,      // SPI 输入  MOSI
  output                      spi_sdo,      // SPI 输出  MISO
  input                       spi_cs_cmd,   // 命令片选信号
  input                       spi_cs_data,  // 数据片选信号
  input                       spi_scl,      // SPI 时钟信号 SCLK

  input   [DATA_WIDTH-1:0]    din,          // FPGA -> STM32 数据

  output  [CMD_WIDTH-1:0]     cmd,          // 通道命令输出
  output                      cmd_valid,    // 通道命令有效信号
  output  [DATA_WIDTH-1:0]    dout,         // 通道数据输出
  output                      data_valid    // 通道数据有效信号
);

spi_core_log u_spi_core_cmd
  (
    .clk            ( clk         ),    // 时钟信号
    .rst_n          ( rst_n       ),	 // 复位
    .spi_sdi        ( spi_sdi     ),    // SPI 输入  MOSI
    .spi_sdo        (             ),    // SPI 输出  MISO
    .spi_cs         ( spi_cs_cmd  ),    // 通道片选信号
    .spi_scl        ( spi_scl     ),    // SPI 时钟信号 SCLK
    .din            ( 8'haa       ),    // FPGA -> STM32 数据
    .dout           ( cmd         ),    // 通道命令输出
    .data_valid     ( cmd_valid   )     // 通道命令有效信号
);
defparam 
  u_spi_core_cmd.DATA_WIDTH = CMD_WIDTH;

spi_core_log u_spi_core_data(
    .clk            ( clk         ),    // 时钟信号
    .rst_n          ( rst_n       ),	 // 复位
    .spi_sdi        ( spi_sdi     ),    // SPI 输入  MOSI
    .spi_sdo        ( spi_sdo     ),    // SPI 输出  MISO
    .spi_cs         ( spi_cs_data ),    // 通道片选信号
    .spi_scl        ( spi_scl     ),    // SPI 时钟信号 SCLK
    .din            ( din         ),    // FPGA -> STM32 数据
    .dout           ( dout        ),    // 通道数据输出
    .data_valid     ( data_valid  )     // 通道数据有效信号
);
defparam 
  u_spi_core_data.DATA_WIDTH = DATA_WIDTH;

endmodule