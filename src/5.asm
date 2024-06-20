.MODEL SMALL  
.STACK 100H  
.DATA  
  
;The string to be printed  
STRING DB 'I rather flip bits by a magnetic needle',13,10,'than to ever write any program in this language', '$'
  
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