//*************************************************************************************
//* 
//*************************************************************************************

module spi_reg_buf #(
	parameter  DATA_WIDTH        = 32,
   parameter  CHANNEL_NUMBER    = 16
  )
  (
	input                                     clk, 
	input                                     rst_n, 
	// spi port
	input                                     data_flag,
	input                                     cmd_flag,
	input       [$clog2(CHANNEL_NUMBER)-1:0]  dcmd,
	input       [DATA_WIDTH-1:0]              din,
	output  reg [DATA_WIDTH-1:0]              dout,
	
	// reg out port
	input      [DATA_WIDTH-1:0]              write_reg_0,	// FPGA -> STM32 通道0
	input      [DATA_WIDTH-1:0]              write_reg_1,   // FPGA -> STM32 通道1
	input      [DATA_WIDTH-1:0]              write_reg_2,   // FPGA -> STM32 通道2
	input      [DATA_WIDTH-1:0]              write_reg_3,   // FPGA -> STM32 通道3
	input      [DATA_WIDTH-1:0]              write_reg_4,   // FPGA -> STM32 通道4
	input      [DATA_WIDTH-1:0]              write_reg_5,   // FPGA -> STM32 通道5
	input      [DATA_WIDTH-1:0]              write_reg_6,   // FPGA -> STM32 通道6
	input      [DATA_WIDTH-1:0]              write_reg_7,   // FPGA -> STM32 通道7
	input      [DATA_WIDTH-1:0]              write_reg_8,   // FPGA -> STM32 通道8
	input      [DATA_WIDTH-1:0]              write_reg_9,   // FPGA -> STM32 通道9
	input      [DATA_WIDTH-1:0]              write_reg_10,  // FPGA -> STM32 通道10
	input      [DATA_WIDTH-1:0]              write_reg_11,  // FPGA -> STM32 通道11
	input      [DATA_WIDTH-1:0]              write_reg_12,  // FPGA -> STM32 通道12
	input      [DATA_WIDTH-1:0]              write_reg_13,  // FPGA -> STM32 通道13
	input      [DATA_WIDTH-1:0]              write_reg_14,  // FPGA -> STM32 通道14
	input      [DATA_WIDTH-1:0]              write_reg_15,  // FPGA -> STM32 通道15
	
	// reg in port
	output     [DATA_WIDTH-1:0]              read_reg_0,	  // STM32 -> FPGA 通道0
	output     [DATA_WIDTH-1:0]              read_reg_1,    // STM32 -> FPGA 通道1
	output     [DATA_WIDTH-1:0]              read_reg_2,    // STM32 -> FPGA 通道2
	output     [DATA_WIDTH-1:0]              read_reg_3,    // STM32 -> FPGA 通道3
	output     [DATA_WIDTH-1:0]              read_reg_4,    // STM32 -> FPGA 通道4
	output     [DATA_WIDTH-1:0]              read_reg_5,    // STM32 -> FPGA 通道5
	output     [DATA_WIDTH-1:0]              read_reg_6,    // STM32 -> FPGA 通道6
	output     [DATA_WIDTH-1:0]              read_reg_7,    // STM32 -> FPGA 通道7
	output     [DATA_WIDTH-1:0]              read_reg_8,    // STM32 -> FPGA 通道8
	output     [DATA_WIDTH-1:0]              read_reg_9,    // STM32 -> FPGA 通道9
	output     [DATA_WIDTH-1:0]              read_reg_10,   // STM32 -> FPGA 通道10
	output     [DATA_WIDTH-1:0]              read_reg_11,   // STM32 -> FPGA 通道11
	output     [DATA_WIDTH-1:0]              read_reg_12,   // STM32 -> FPGA 通道12
	output     [DATA_WIDTH-1:0]              read_reg_13,   // STM32 -> FPGA 通道13
	output     [DATA_WIDTH-1:0]              read_reg_14,   // STM32 -> FPGA 通道14
	output     [DATA_WIDTH-1:0]              read_reg_15    // STM32 -> FPGA 通道15
  );

localparam SEL_WIDTH = $clog2(CHANNEL_NUMBER);

reg  [DATA_WIDTH - 1:0] spi_reg_in  [CHANNEL_NUMBER - 1:0];
wire [DATA_WIDTH - 1:0] spi_reg_out [CHANNEL_NUMBER - 1:0];
  
reg    [SEL_WIDTH-1:0]      addr_reg;

  // 
assign  spi_reg_out[0]    = write_reg_0 ;
assign  spi_reg_out[1]    = write_reg_1 ;
assign  spi_reg_out[2]    = write_reg_2 ;
assign  spi_reg_out[3]    = write_reg_3 ;
assign  spi_reg_out[4]    = write_reg_4 ;
assign  spi_reg_out[5]    = write_reg_5 ;
assign  spi_reg_out[6]    = write_reg_6 ;
assign  spi_reg_out[7]    = write_reg_7 ;
assign  spi_reg_out[8]    = write_reg_8 ;
assign  spi_reg_out[9]    = write_reg_9 ;
assign  spi_reg_out[10]   = write_reg_10;
assign  spi_reg_out[11]   = write_reg_11;
assign  spi_reg_out[12]   = write_reg_12;
assign  spi_reg_out[13]   = write_reg_13;
assign  spi_reg_out[14]   = write_reg_14;
assign  spi_reg_out[15]   = write_reg_15;
  
assign  read_reg_0        = spi_reg_in[0];
assign  read_reg_1        = spi_reg_in[1];
assign  read_reg_2        = spi_reg_in[2];
assign  read_reg_3        = spi_reg_in[3];
assign  read_reg_4        = spi_reg_in[4];
assign  read_reg_5        = spi_reg_in[5];
assign  read_reg_6        = spi_reg_in[6];
assign  read_reg_7        = spi_reg_in[7];
assign  read_reg_8        = spi_reg_in[8];
assign  read_reg_9        = spi_reg_in[9];
assign  read_reg_10       = spi_reg_in[10];
assign  read_reg_11       = spi_reg_in[11];
assign  read_reg_12       = spi_reg_in[12];
assign  read_reg_13       = spi_reg_in[13];
assign  read_reg_14       = spi_reg_in[14];
assign  read_reg_15       = spi_reg_in[15];


// 命令(地址)锁存
always @(posedge clk) 
begin
  if (cmd_flag) 
  begin
    addr_reg <= dcmd;
  end 
end 

// 读数据
always @(posedge clk) 
begin
  if (data_flag) 
  begin 
    spi_reg_in[addr_reg] <= din;
  end 
end 

// 写数据
always @(posedge clk) 
begin  
  dout <= spi_reg_out[addr_reg];
end 
 
endmodule 