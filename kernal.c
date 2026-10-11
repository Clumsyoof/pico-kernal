#include <stdint.h>

#define HW_REG(addr) (*(volatile uint32_t *)(addr))

#define RESETS_BASE     0x4000C000
#define IO_BANK0_BASE   0x40014000
#define SIO_BASE        0xD0000000 //Single cycle IO

#define RESETS_RESET (RESETS_BASE + 0x0)
#define RESETS_RESET_DONE (RESETS_BASE + 0x8)

/*RP2040 has atomic regester aliases for bit manipulation. each register has 4 parralell addresses
    
    address offset                   offset mode                what it doin
 
1.  + 0x0000                         normal                     override regester normally
2.  + 0x1000                         XOR                        1 -> 0, 0 -> 0
3.  + 0x2000                         SET                        1 -> HIGH
4.  + 0x3000                         CLEAR                      1 -> LOW
*/

#define RESETS_RESET_CLR (RESETS_BASE + 0x3000 + 0x0)
#define GPIO15_CTRL (IO_BANK0_BASE + 0x07C) //GPIO15 CONTROL 
#define SIO_GPIO_OUT_XOR (SIO_BASE + 0x01C)
#define SIO_GPIO_OE_SET (SIO_BASE + 0x024)

#define LED_PIN              15
#define LED_PIN_MASK         (1u << LED_PIN)

#define RESETS_IO_BANK0_MASK (1u << 5)

void kmain(void) {
    HW_REG(RESETS_RESET_CLR) = RESETS_IO_BANK0_MASK;

    while((HW_REG(RESETS_RESET_DONE) & RESETS_IO_BANK0_MASK) == 0){
        
    }

    HW_REG(GPIO15_CTRL) = 5;
    HW_REG(SIO_GPIO_OE_SET) =LED_PIN_MASK;
    
    while(1){
        HW_REG(SIO_GPIO_OUT_XOR) = LED_PIN_MASK;
    
        for(volatile uint32_t delay=0;delay<1000000;delay++){
        
        }
    }
}
