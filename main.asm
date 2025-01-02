stm8/

    #include "mapping.inc"

    segment 'ram0'          
result_add DS.B 1           
result_sub DS.B 1           
result_and DS.B 1           
result_or DS.B 1            
result_xor DS.B 1           
result_xnor DS.B 1
result_mul DS.B 1
result_div DS.B 1         

    segment 'rom'
main.l
    ; initialize SP
    ldw X,#stack_end
    ldw SP,X

    ; Addition
    LD A, #$10              
    ADD A, #$20             
    LD result_add, A         

    ; Subtraction
    LD A, #$30              
    SUB A, #$10             
    LD result_sub, A        

    ; AND Operation
    LD A, #$F0              
    AND A, #$0F             
    LD result_and, A        

    ; OR Operation
    LD A, #$F0            
    OR A, #$0F              
    LD result_or, A         

    ; XOR Operation
    LD A, #$AA           
    XOR A, #$55             
    LD result_xor, A       

    ; XNOR Operation
    LD A, #$AA          ;170 (10101010)   
    XOR A, #$55         ;85 (01010101)    
    CPL A                   
    LD result_xnor, A   ;Result  11111111 but we have to reverse it which is 00000000    

    ; Multiplication by 2 (using shifting left)
    LD A, #$03              
    SLA A               
    LD result_mul, A        

    ; Division by 2 (using shifting right)
    LD A, #$10              
    SRL A                   
    LD result_div, A        

    #ifdef RAM0    
    ; clear RAM0
ram0_start.b EQU $ram0_segment_start
ram0_end.b EQU $ram0_segment_end
    ldw X,#ram0_start
clear_ram0.l
    clr (X)
    incw X
    cpw X,#ram0_end    
    jrule clear_ram0
    #endif

    #ifdef RAM1
    ; clear RAM1
ram1_start.w EQU $ram1_segment_start
ram1_end.w EQU $ram1_segment_end    
    ldw X,#ram1_start
clear_ram1.l
    clr (X)
    incw X
    cpw X,#ram1_end    
    jrule clear_ram1
    #endif

    ; clear stack
stack_start.w EQU $stack_segment_start
stack_end.w EQU $stack_segment_end
    ldw X,#stack_start
clear_stack.l
    clr (X)
    incw X
    cpw X,#stack_end    
    jrule clear_stack

    ; Infinite loop
infinite_loop.l
    jra infinite_loop

    interrupt NonHandledInterrupt
NonHandledInterrupt.l
    iret

    segment 'vectit'
    dc.l {$82000000+main}                                   
    dc.l {$82000000+NonHandledInterrupt}    ; trap
    dc.l {$82000000+NonHandledInterrupt}    ; irq0
    dc.l {$82000000+NonHandledInterrupt}    ; irq1
    dc.l {$82000000+NonHandledInterrupt}    ; irq2
    dc.l {$82000000+NonHandledInterrupt}    ; irq3
    dc.l {$82000000+NonHandledInterrupt}    ; irq4
    dc.l {$82000000+NonHandledInterrupt}    ; irq5
    dc.l {$82000000+NonHandledInterrupt}    ; irq6
    dc.l {$82000000+NonHandledInterrupt}    ; irq7
    dc.l {$82000000+NonHandledInterrupt}    ; irq8
    dc.l {$82000000+NonHandledInterrupt}    ; irq9
    dc.l {$82000000+NonHandledInterrupt}    ; irq10
    dc.l {$82000000+NonHandledInterrupt}    ; irq11
    dc.l {$82000000+NonHandledInterrupt}    ; irq12
    dc.l {$82000000+NonHandledInterrupt}    ; irq13
    dc.l {$82000000+NonHandledInterrupt}    ; irq14
    dc.l {$82000000+NonHandledInterrupt}    ; irq15
    dc.l {$82000000+NonHandledInterrupt}    ; irq16
    dc.l {$82000000+NonHandledInterrupt}    ; irq17
    dc.l {$82000000+NonHandledInterrupt}    ; irq18
    dc.l {$82000000+NonHandledInterrupt}    ; irq19
    dc.l {$82000000+NonHandledInterrupt}    ; irq20
    dc.l {$82000000+NonHandledInterrupt}    ; irq21
    dc.l {$82000000+NonHandledInterrupt}    ; irq22
    dc.l {$82000000+NonHandledInterrupt}    ; irq23
    dc.l {$82000000+NonHandledInterrupt}    ; irq24
    dc.l {$82000000+NonHandledInterrupt}    ; irq25
    dc.l {$82000000+NonHandledInterrupt}    ; irq26
    dc.l {$82000000+NonHandledInterrupt}    ; irq27
    dc.l {$82000000+NonHandledInterrupt}    ; irq28
    dc.l {$82000000+NonHandledInterrupt}    ; irq29

    end
