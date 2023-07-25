/* Includes ------------------------------------------------------------------*/
#include "MyApplication.h"

/* Private define-------------------------------------------------------------*/

/* Private variables----------------------------------------------------------*/
static void Peripheral_Set(void); 

/* Public variables-----------------------------------------------------------*/
MyInit_t MyInit = 
{
	Peripheral_Set
};

/* Private function prototypes------------------------------------------------*/      


/*
	* @name   Peripheral_Set
	* @brief  Õ‚…Ë…Ë÷√
	* @param  None
	* @retval None      
*/
static void Peripheral_Set()
{
	SPI_Communication_Init();
	led_init();
	key_init();
}

/********************************************************
  End Of File
********************************************************/
