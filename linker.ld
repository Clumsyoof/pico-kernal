ENTRY(_start)

MEMORY
{
    FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2058K /*2mb QSPI flash */
    RAM(rwx) : ORIGIN = 0x20000000, LENGTH = 264K /*264kb internal sram*/
}

SECTIONS
{
    /*bootloader in first 256bytes of flash*/
    .boot2 :
    {
        __boot2_start__ = .;
        KEEP(*(.boot2))
        __boot2_end__ = .;
    } > FLASH

    /*vector table at x10000100*/
    .vectors : ALIGN(256)
    {
        __vectors_start__ = .;
        KEEP(*(.vectors))
        __vectors_end__ = .;
    } > FLASH 

    /*text is executable, rodata is read only , bss is uninitalised memory*/
    .text : ALIGN(4)
    {
        *(.text .text.*)
    } > FLASH
    

    .rodata : ALIGN(4)
    {
        *(.rodata .rodata.*)
    } > FLASH
    
    .data : ALIGN(4)
    {
        __data_start__ = .;
        *(.data .data.*)
        . = ALIGN(4);
        __data_end__ = .;
    } > RAM AT > FLASH
    
    __data_load__ = LOADADDR(.data); 

    .bss : ALIGN(4)
    {
        __bss_start__ = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > RAM

    /*main stack pointer at top of sram at 0x20042000*/
    __stack_top =ORIGIN(RAM) + LENGTH(RAM);
}
