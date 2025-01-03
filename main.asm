#define GPIO_BASE_ADDR $5000
#define GPIOE_OFFS $14
#define GPIOC_OFFS $A
#define ODR $0
#define DDR $2
#define CR1 $3

#include "mapping.inc"

segment 'rom'
main.l

; === Initialize Stack and Clear RAM ===
ldw X, #stack_end
ldw SP, X

; === Configure GPIO Pins ===
; LED3 - GPIOE Pin 7
mov { GPIO_BASE_ADDR + GPIOE_OFFS + DDR }, #%10000000 ; Set as output
mov { GPIO_BASE_ADDR + GPIOE_OFFS + CR1 }, #%10000000 ; Push-pull mode
; LED4 - GPIOC Pin 7
mov { GPIO_BASE_ADDR + GPIOC_OFFS + DDR }, #%10000000 ; Set as output
mov { GPIO_BASE_ADDR + GPIOC_OFFS + CR1 }, #%10000000 ; Push-pull mode

; === Main Loop ===
main:
    call task1    ;  Keep LED3 and LED4 permanently on
    call task2    ;  Blink LED3 and LED4 together
    call task3    ;  Blink LEDs alternately
    jra main      ; Repeat the loop

; === : Turn LED3 and LED4 Permanently On ===
task1:
    mov { GPIO_BASE_ADDR + GPIOE_OFFS + ODR }, #%10000000 ; Turn on LED3
    mov { GPIO_BASE_ADDR + GPIOC_OFFS + ODR }, #%10000000 ; Turn on LED4
    ret

; ===  Blink LED3 and LED4 Simultaneously ===
task2:
    ; Turn LEDs On
    mov { GPIO_BASE_ADDR + GPIOE_OFFS + ODR }, #%10000000 ; LED3 on
    mov { GPIO_BASE_ADDR + GPIOC_OFFS + ODR }, #%10000000 ; LED4 on
    call delay_long

    ; Turn LEDs Off
    mov { GPIO_BASE_ADDR + GPIOE_OFFS + ODR }, #%00000000 ; LED3 off
    mov { GPIO_BASE_ADDR + GPIOC_OFFS + ODR }, #%00000000 ; LED4 off
    call delay_long
    ret

; ===  Blink LEDs Alternately ===
task3:
    ; Turn LED3 On, LED4 Off
    bset { GPIO_BASE_ADDR + GPIOE_OFFS + ODR }, #7 ; LED3 on
    bres { GPIO_BASE_ADDR + GPIOC_OFFS + ODR }, #7 ; LED4 off
    call delay_short

    ; Turn LED3 Off, LED4 On
    bres { GPIO_BASE_ADDR + GPIOE_OFFS + ODR }, #7 ; LED3 off
    bset { GPIO_BASE_ADDR + GPIOC_OFFS + ODR }, #7 ; LED4 on
    call delay_short
    ret

; === Short Delay Subroutine ===
delay_short:
    ldw X, #$4000
delay_loop_short:
    nop
    decw X
    jrne delay_loop_short
    ret

; === Long Delay Subroutine ===
delay_long:
    ldw X, #$FFFF
delay_loop_long:
    nop
    decw X
    jrne delay_loop_long
    ret

; === Infinite Loop (Optional) ===
infinite_loop.l
    jra infinite_loop

; === Interrupt Placeholder ===
interrupt NonHandledInterrupt
    NonHandledInterrupt.l
    iret

segment 'vectit'
; === Reset Vector ===
dc.l {$82000000+main}              ; Reset vector (entry point)

; === Trap Vector ===
dc.l {$82000000+NonHandledInterrupt} ; Trap

; === IRQ Vectors ===
dc.l {$82000000+NonHandledInterrupt} ; IRQ0
dc.l {$82000000+NonHandledInterrupt} ; IRQ1
dc.l {$82000000+NonHandledInterrupt} ; IRQ2
dc.l {$82000000+NonHandledInterrupt} ; IRQ3
dc.l {$82000000+NonHandledInterrupt} ; IRQ4
dc.l {$82000000+NonHandledInterrupt} ; IRQ5
dc.l {$82000000+NonHandledInterrupt} ; IRQ6
dc.l {$82000000+NonHandledInterrupt} ; IRQ7
dc.l {$82000000+NonHandledInterrupt} ; IRQ8
dc.l {$82000000+NonHandledInterrupt} ; IRQ9
dc.l {$82000000+NonHandledInterrupt} ; IRQ10
dc.l {$82000000+NonHandledInterrupt} ; IRQ11
dc.l {$82000000+NonHandledInterrupt} ; IRQ12
dc.l {$82000000+NonHandledInterrupt} ; IRQ13
dc.l {$82000000+NonHandledInterrupt} ; IRQ14
dc.l {$82000000+NonHandledInterrupt} ; IRQ15
dc.l {$82000000+NonHandledInterrupt} ; IRQ16
dc.l {$82000000+NonHandledInterrupt} ; IRQ17
dc.l {$82000000+NonHandledInterrupt} ; IRQ18
dc.l {$82000000+NonHandledInterrupt} ; IRQ19
dc.l {$82000000+NonHandledInterrupt} ; IRQ20
dc.l {$82000000+NonHandledInterrupt} ; IRQ21
dc.l {$82000000+NonHandledInterrupt} ; IRQ22
dc.l {$82000000+NonHandledInterrupt} ; IRQ23
dc.l {$82000000+NonHandledInterrupt} ; IRQ24
dc.l {$82000000+NonHandledInterrupt} ; IRQ25
dc.l {$82000000+NonHandledInterrupt} ; IRQ26
dc.l {$82000000+NonHandledInterrupt} ; IRQ27
dc.l {$82000000+NonHandledInterrupt} ; IRQ28
dc.l {$82000000+NonHandledInterrupt} ; IRQ29
dc.l {$82000000+NonHandledInterrupt} ; IRQ30
dc.l {$82000000+NonHandledInterrupt} ; IRQ31

; Additional vectors can be added here if needed

end
