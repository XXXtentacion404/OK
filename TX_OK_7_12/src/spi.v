//*****************************************************************
//*  描    述:  SPI通讯模块
//*  开始时间:  2019-07-01
//*  完成时间:  2019-07-01
//*  修改时间:  2019-07-01
//*  版    本:  V3.0
//*  作    者:  凌智电子
//*  说    明:  SPI通讯. 
//*  备    注:  
//*
//*****************************************************************
//* 修改记录--
//*
//*
//*****************************************************************

module spi #(
    parameter  DATA_WIDTH        = 32,
    parameter  CHANNEL_NUMBER    = 16
  )
  (
    input                clk,
    input                rst_n,
    input                spi_sdi,
    input                spi_cs_data,
    input                spi_cs_cmd,
    input                spi_scl,
    output               spi_sdo,
    
    // reg out port
    input        [DATA_WIDTH-1:0]       write_reg_0, 
    input        [DATA_WIDTH-1:0]       write_reg_1, 
    input        [DATA_WIDTH-1:0]       write_reg_2, 
    input        [DATA_WIDTH-1:0]       write_reg_3, 
    input        [DATA_WIDTH-1:0]       write_reg_4, 
    input        [DATA_WIDTH-1:0]       write_reg_5, 
    input        [DATA_WIDTH-1:0]       write_reg_6, 
    input        [DATA_WIDTH-1:0]       write_reg_7, 
    input        [DATA_WIDTH-1:0]       write_reg_8, 
    input        [DATA_WIDTH-1:0]       write_reg_9, 
    input        [DATA_WIDTH-1:0]       write_reg_10, 
    input        [DATA_WIDTH-1:0]       write_reg_11, 
    input        [DATA_WIDTH-1:0]       write_reg_12, 
    input        [DATA_WIDTH-1:0]       write_reg_13, 
    input        [DATA_WIDTH-1:0]       write_reg_14, 
    input        [DATA_WIDTH-1:0]       write_reg_15, 
    
    // reg in port
    output      [DATA_WIDTH-1:0]        read_reg_0, 
    output      [DATA_WIDTH-1:0]        read_reg_1, 
    output      [DATA_WIDTH-1:0]        read_reg_2, 
    output      [DATA_WIDTH-1:0]        read_reg_3, 
    output      [DATA_WIDTH-1:0]        read_reg_4, 
    output      [DATA_WIDTH-1:0]        read_reg_5, 
    output      [DATA_WIDTH-1:0]        read_reg_6, 
    output      [DATA_WIDTH-1:0]        read_reg_7, 
    output      [DATA_WIDTH-1:0]        read_reg_8, 
    output      [DATA_WIDTH-1:0]        read_reg_9, 
    output      [DATA_WIDTH-1:0]        read_reg_10,
    output      [DATA_WIDTH-1:0]        read_reg_11,
    output      [DATA_WIDTH-1:0]        read_reg_12,
    output      [DATA_WIDTH-1:0]        read_reg_13,
    output      [DATA_WIDTH-1:0]        read_reg_14,
    output      [DATA_WIDTH-1:0]        read_reg_15
  );

localparam ADDR_WIDTH = $clog2(CHANNEL_NUMBER);

wire    [DATA_WIDTH-1:0]      spi_din;
wire                          spi_data_done;
wire    [DATA_WIDTH-1:0]      spi_dout;
wire                          spi_cmd_done;
wire    [ADDR_WIDTH-1:0]      spi_reg_addr;

spi_cmd_data u_spi_cmd_data(
    .clk                ( clk           ),	// 时钟信号
    .rst_n              ( rst_n         ),	// 复位
    .spi_sdi            ( spi_sdi       ),	// SPI 输入  MOSI
    .spi_sdo            ( spi_sdo       ),	// SPI 输出  MISO
    .spi_cs_cmd         ( spi_cs_cmd    ),	// 命令片选信号
    .spi_cs_data        ( spi_cs_data   ),	// 数据片选信号
    .spi_scl            ( spi_scl       ),	// SPI 时钟信号 SCLK
    .din                ( spi_din       ),	// FPGA -> STM32 数据
    .cmd                ( spi_reg_addr  ),	// 通道命令输出
    .cmd_valid          ( spi_cmd_done  ),	// 通道命令有效信号
    .dout               ( spi_dout      ),	// 通道数据输出
    .data_valid         ( spi_data_done )		// 通道数据有效信号
  );   

spi_reg_buf u_spi_reg_buf(
    .clk              	( clk           ), 	// 时钟信号	
    .rst_n            	( rst_n         ), 	// 复位
    .data_flag        	( spi_data_done ),	// 通道数据有效信号
    .cmd_flag         	( spi_cmd_done  ),	// 通道命令有效信号
    .dcmd             	( spi_reg_addr  ),	// 通道命令
    .din              	( spi_dout      ),	// 通道数据
    .dout             	( spi_din       ),	// FPGA -> STM32 数据
    
    // reg out port
    .write_reg_0      	( write_reg_0   ),	// FPGA -> STM32 通道0
    .write_reg_1      	( write_reg_1   ),   // FPGA -> STM32 通道1
    .write_reg_2      	( write_reg_2   ),   // FPGA -> STM32 通道2
    .write_reg_3      	( write_reg_3   ),   // FPGA -> STM32 通道3
    .write_reg_4      	( write_reg_4   ),   // FPGA -> STM32 通道4
    .write_reg_5      	( write_reg_5   ),   // FPGA -> STM32 通道5
    .write_reg_6      	( write_reg_6   ),   // FPGA -> STM32 通道6
    .write_reg_7      	( write_reg_7   ),   // FPGA -> STM32 通道7
    .write_reg_8      	( write_reg_8   ),   // FPGA -> STM32 通道8
    .write_reg_9      	( write_reg_9   ),   // FPGA -> STM32 通道9
    .write_reg_10     	( write_reg_10  ),   // FPGA -> STM32 通道10
    .write_reg_11     	( write_reg_11  ),   // FPGA -> STM32 通道11
    .write_reg_12     	( write_reg_12  ),   // FPGA -> STM32 通道12
    .write_reg_13     	( write_reg_13  ),   // FPGA -> STM32 通道13
    .write_reg_14     	( write_reg_14  ),   // FPGA -> STM32 通道14
    .write_reg_15     	( write_reg_15  ),   // FPGA -> STM32 通道15
	 
	 // reg in port
    .read_reg_0       	( read_reg_0    ),	// STM32 -> FPGA 通道0
    .read_reg_1       	( read_reg_1    ),	// STM32 -> FPGA 通道1
    .read_reg_2       	( read_reg_2    ),	// STM32 -> FPGA 通道2
    .read_reg_3       	( read_reg_3    ),	// STM32 -> FPGA 通道3
    .read_reg_4       	( read_reg_4    ),	// STM32 -> FPGA 通道4
    .read_reg_5       	( read_reg_5    ),	// STM32 -> FPGA 通道5
    .read_reg_6       	( read_reg_6    ),	// STM32 -> FPGA 通道6
    .read_reg_7       	( read_reg_7    ),	// STM32 -> FPGA 通道7
    .read_reg_8       	( read_reg_8    ),	// STM32 -> FPGA 通道8
    .read_reg_9       	( read_reg_9    ),	// STM32 -> FPGA 通道9
    .read_reg_10      	( read_reg_10   ),	// STM32 -> FPGA 通道10
    .read_reg_11      	( read_reg_11   ),	// STM32 -> FPGA 通道11
    .read_reg_12      	( read_reg_12   ),	// STM32 -> FPGA 通道12
    .read_reg_13      	( read_reg_13   ),	// STM32 -> FPGA 通道13
    .read_reg_14      	( read_reg_14   ),	// STM32 -> FPGA 通道14
    .read_reg_15      	( read_reg_15   ),	// STM32 -> FPGA 通道15
);
defparam
  u_spi_reg_buf.DATA_WIDTH      = DATA_WIDTH,
  u_spi_reg_buf.CHANNEL_NUMBER  = CHANNEL_NUMBER;


endmodule


