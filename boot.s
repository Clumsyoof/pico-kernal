.syntax unified
.cpu cortex-m0plus
.thumb

.section .vectors, "a"
.align 8
.word __stack_top
.word _start

.section .text
.global _start
.thumb_func
.type _start, %function

_start:
    bl kmain
    cpsid i
hang:
    wfi
    b hang

.size _start, . -_start
