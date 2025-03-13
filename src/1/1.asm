.MODEL medium 
.STACK 100H 
.DATA 

    len DB 20
    number DB len DUP(?)
    negative db ?

.CODE 
MAIN PROC FAR 
    MOV AX,@DATA 
    MOV DS,AX
    MOV AH, 01H
    INT 21H
    
    mov CX, 0
    mov cl, len
    
    cmp AL, '-'
    jne first_digit  
    mov negative, 1
    jmp intput_loop
    first_digit:
        mov SI,CX             
        mov number[SI], AL
        dec cx
            
    intput_loop:
        MOV AH, 01H               ;single character input
        INT 21H
        
        CMP AL, '0'
        JB done_input               ; If below '0', stop
        CMP AL, '9'
        JA done_input
        mov SI,CX                ;take input
        mov number[SI], AL
        loop intput_loop
    
    done_input:
    MOV AH, 02H       
    MOV DL, 0DH       
    INT 21H           
    MOV DL, 0AH       
    INT 21H           
    
    mov Dl, negative
    cmp Dl, 1
    jne reverse    
        mov dx, 45
        MOV AH, 02H
        INT 21H
            
    reverse: 
    mov dl, len
    sub dx, cx 
    mov cx, dx
    mov Ax, 0
    
    print_loop:
        mov DL,number[SI]
        MOV AH, 02H
        INT 21H
        inc SI
        loop print_loop
    
    
    ;interrupt to exit
    MOV AH,4CH 
    INT 21H 
    
MAIN ENDP

END MAIN 
