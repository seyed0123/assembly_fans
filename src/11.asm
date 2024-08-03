.MODEL SMALL  
.STACK 100H  
.DATA  
  
;The string to be printed  
STRING DB 'Writing in Assembly: like trying to communicate with an alien using smoke signals�frustrating, confusing, and likely to end in tears.', '$'
  
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