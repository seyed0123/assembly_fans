.MODEL SMALL
.STACK 100H
.DATA

;The string to be printed
STRING DB "It's when I wrote assembly that I began appreciating C...", '$'

.CODE
MAIN PROC FAR
 MOV AX,@DATA
 MOV DS,AX

 ; load address of the string
 LEA DX,STRING

 ;output the string
 ;loaded in dx
 MOV AH,09H
 INT 21H

 ;interrupt to exit
 MOV AH,4CH
 INT 21H

MAIN ENDP
END MAIN
