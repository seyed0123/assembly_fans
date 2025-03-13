.MODEL medium 

.STACK 100H
.DATA
    number1 dw 0
    number2 dw 0
    mul_num dw 0
    gcd dw 0
    lcd dw 0
.CODE

MAIN PROC FAR
    MOV AX,@DATA 
    MOV DS,AX

    CALL GET_NUMBER

    
    POP AX            
    mov number1,ax
    
    CALL GET_NUMBER
    pop ax
    mov number2,ax
    
    mov bx,number1
    mul bx
    mov mul_num,ax 
    
    euclidean:
    mov ax,number1
    mov bx,number2
    
    cmp ax,bx
    jae number1_bigger
    
    mov cx,ax
    mov ax,bx
    mov bx,cx                  
    
    number1_bigger:
    cmp ax,bx
    je done
    sub ax,bx
    mov number1,ax
    mov number2,bx
    
    jmp euclidean 
    
    
    done:
    mov gcd,bx
    mov ax,mul_num
    div bx
    mov lcd,ax
    
    push ax
    call PRINT_NUMBER
    
    mov ax,gcd
    push ax
    call PRINT_NUMBER
                      
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP


GET_NUMBER PROC
    MOV bx, 0
input_loop:            
    MOV AH, 01H            
    INT 21H
    
    CMP AL, '0'
    JB done_input               
    CMP AL, '9'
    JA done_input
    SUB AL, 30H
    mov ah,0
    ADD Bx, Ax
    MOV AX, BX     
    MOV CX, 10      
    MUL CX         
    MOV BX, AX         
    JMP input_loop   
    
done_input:
    MOV AX, BX
    MOV DX, 0
    DIV CX
    pop cx           
    PUSH AX        
    push cx
    
    MOV AH, 02H       
    MOV DL, 0DH       
    INT 21H           
    MOV DL, 0AH       
    INT 21H
    
    RET              
GET_NUMBER ENDP

PRINT_NUMBER proc
    pop cx
    pop ax
    push cx
    mov cx,';'
    push cx
    mov bx,10
    mov cx,ax
    devide_loop:
        mov ax,cx
        mov dx,0
 
        cmp ax,0
        je devide_done
        
        cmp ax, 10
        jb another_digit
        
        div bx
        mov cx,ax
        add dx,30h
        push dx
        
        jmp devide_loop
    
    another_digit:
        mov dx,ax 
        add dx,30h
        push dx
     
    devide_done:
    
    print_loop:
        pop dx
        cmp dx,';'
        je done_print
        
        mov ah, 02H
        int 21H
        jmp print_loop
        
    done_print:
        MOV AH, 02H       
        MOV DL, 0DH       
        INT 21H           
        MOV DL, 0AH       
        INT 21H
        ret
PRINT_NUMBER ENDP

END MAIN
