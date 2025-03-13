.MODEL medium 

.STACK 100H
.DATA
    x DB 7
    y DW ?
.CODE

MAIN PROC FAR
    MOV AX,@DATA 
    MOV DS,AX
    
    mov ax,0
    mov al,x
    
    mov bx,ax
    mul bx
    mov cx,ax
    
    mul bx
    mov bx,ax
    
    mov ax,cx
    mov cx, -3
    imul cx
    
    add bx,ax
    add bx,7
    mov y,bx
    
    
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

