# Assembly fans
<img src="shots/photo12104283647.jpg" width = "60%">

This repository is for those very interested in assembly and who want to show their devotion and close relationship with it by writing a few sentences about it.

## collaboration:
To participate in this action, it is enough to fork the repo, place your desired text in the specified part of the code (line 5), put the asm file in the `src` directory, and the photo of the output of your program in the `shots` directory then put it in the [readme](README.md) file.
```assembly
.MODEL SMALL  
.STACK 100H  
.DATA  
  
; The string to be printed  
STRING DB 'Put your text here', '$'
  
.CODE  
MAIN PROC FAR  
 MOV AX,@DATA  
 MOV DS,AX  
  
 ; load address of the string  
 LEA DX,STRING  
  
 ; output the string 
 ; loaded in dx  
 MOV AH,09H 
 INT 21H  
  
 ; interrupt to exit
 MOV AH,4CH 
 INT 21H  
  
MAIN ENDP  
END MAIN
```



## Shots:
![](shots/1.png)
<br>

![](shots/2.png)
<br>

![](shots/3.png)
<br>

![](shots/4.png)
<br>

![](shots/5.png)
<br>

![](shots/6.png)
<br>

![](shots/7.bmp)
<br>

![](shots/8.png)
<br>

![](shots/9.png)
<br>

![](shots/10.jpeg)
<br>

![](shots/11.JPG)
<br>

![](shots/12.png)
<br>





