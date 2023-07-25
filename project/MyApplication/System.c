#include "MyApplication.h"

static void Run(void); 
static void Error_Handler(void);
static void Assert_Failed(void);
/* Private define-------------------------------------------------------------*/
//uint8_t flag1=0;
//uint8_t flag2=0;

//u32 rece_date_0;
//u32 rece_date_1;
//u32 rece_date_2;
//u32 rece_date_3;
//	u8 i,j,buf[16];
//	u8 Errors[8];
//	u8 Right[8];

 uint8_t key;
 uint32_t i=0;
//					LED0(0);   
/*
*@名称 System指针结构体
*@作用 通过调用指针代替调用函数
*@参数 Run,运行函数
			Error_Handler,错误提示函数
			Assert_Failed
*/

////定义结构体类型在.h文件里
//typedef struct
//{
//	void (*Run)(void);
//	void (*Error_Handler)(void);
//	void (*Assert_Failed)(void);
//} System_t;


System_t System = //结构体变量，可以看看书是这样用的
{
	Run,
	Error_Handler,
	Assert_Failed
};



/*
*@名称 主体运行函数
*@作用 
*@参数 无
*/


void Run(void)
{


//					SPI_Communication_Send_Cmd_Data(0, 10*30000000);			// 发送数据	SPI_fre		34300=1K hz
						

	key = key_scan(0);                  /* 得到键值 */
        if (key)
        {
            switch (key)
            {
							
								case WKUP_PRES:             /* KEY1第1个灯 */
                   LED1_TOGGLE();          /* LED1状态取反 */
								SPI_Communication_Send_Cmd_Data(0, 1000*34300);			// 发送数据	SPI_fre		34300=1K hz
								delay_ms(10);
                    break;
								
                case KEY0_PRES:             /* KEY2第2个灯*/
                         LED0_TOGGLE();          /* LED1状态取反 */
									 SPI_Communication_Send_Cmd_Data(1,0);			// 发送数据	SPI_fre		34300=1K hz
                    break;
								
                default : break;
             }
					}
				    else
        {
            delay_ms(10);
				}
}
/*
*@名称 Error_Handler
*@作用 
*@参数 无
*/
void Error_Handler(void)
{

}



/*
*@名称 Assert_Failed
*@作用 
*@参数 无
*/	

void Assert_Failed(void)
{

}




void PHA_TEST (void)
{
	u32 PHA_CNT;						// 相位差测量计数值
	u32 FRE_CNT;						// 频率测量计数值
	u32 CYC_CNT;						// 测量周期个数计数值
	u32 ADV_CNT;						// 超前周期计数值
	u32 LAG_CNT;						// 滞后周期计数值
	unsigned char display_buf[16];		// 显示缓存
	uint32_t FREQUENCY;									// 频率值
	uint32_t DUTY_RATIO; 								// 相位差值
	
	// 变量初始化
	PHA_CNT = 0;
	FRE_CNT = 0;
	CYC_CNT = 0;
	ADV_CNT = 0;
	LAG_CNT = 0;
	FREQUENCY  = 0;
	DUTY_RATIO = 0;
	// 获取计数值
	SPI_Communication_Send_Cmd_Data (1, 1);				// 禁止计数值更新
	FRE_CNT = SPI_Communication_Rece_Cmd_Data (2);	// 获取频率计数值
	PHA_CNT = SPI_Communication_Rece_Cmd_Data (3);	// 获取相位差计数值
	CYC_CNT = SPI_Communication_Rece_Cmd_Data (4);	// 获取测量周期个数值
	ADV_CNT = SPI_Communication_Rece_Cmd_Data (5);	// 获取超前周期计数值
	LAG_CNT = SPI_Communication_Rece_Cmd_Data (6);	// 获取滞后周期计数值
	SPI_Communication_Send_Cmd_Data (1, 0);				// 允许计数值更新
	// 频率及相位差计算
	/******************************************************************
	f = 1/t = (c_cnt * 10^8) / (f_cnt * 2)
	t = (f_cnt / c_cnt) * 20 ns = (f_cnt * 20) / (c_cnt * 10^9) s
	******************************************************************/
//	FREQUENCY  = (CYC_CNT * 200000000.00) / FRE_CNT;
//	DUTY_RATIO = PHA_CNT * 360.00 / FRE_CNT;
	FREQUENCY  = (CYC_CNT * 300000000.00 / 1.0000182) / FRE_CNT;
	DUTY_RATIO = PHA_CNT * 360.00 / FRE_CNT;
		printf("%d\n",DUTY_RATIO);
	
	// 超前滞后判读
	if (ADV_CNT <= LAG_CNT)						// 滞后
	{
		DUTY_RATIO = 360 - DUTY_RATIO;	// 调整为超前
	}
	// 显示频率及相位差
	
//	printf("pinglvjishu:%10d\r\n",FRE_CNT);						// 频率测量计数值
//	printf("xiangweijishu:%10d\r\n",PHA_CNT);					// 相位差测量计数值
//	printf("zhouqijishu:%10d\r\n",CYC_CNT);						// 测量周期个数计数值
//	printf("chaoqianjishu:%10d\r\n",ADV_CNT);	      	// 超前周期计数值
//	printf("zhihoujishu:%10d\r\n",LAG_CNT);	    			// 滞后周期计数值
//	printf("pinglvjishu  :%10.3fHZ\r\n",FREQUENCY);			// 频率值
//	printf("xiangweicha:	%10.3f\r\n",DUTY_RATIO);			// 相位差值

	
}








