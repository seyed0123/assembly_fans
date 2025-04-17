STACK SEGMENT PARA STACK
	DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'
	
	WINDOW_WIDTH DW 140h                 
	WINDOW_HEIGHT DW 0C8h                
	WINDOW_BOUNDS DW 10h                   
	
	TIME_AUX DB 0                        
	GAME_ACTIVE DB 1                     
	EXITING_GAME DB 0
	WINNER_INDEX DB 0                   
	CURRENT_SCENE DB 0                   
	
	TEXT_PLAYER_POINTS DB '00','$'    
	TEXT_GAME_OVER_TITLE DB 'GAME OVER','$'  
	TEXT_GAME_OVER_PLAY_AGAIN DB 'Press R to play again','$' 
	TEXT_GAME_OVER_MAIN_MENU DB 'Press E to exit to main menu','$' 
	TEXT_MAIN_MENU_TITLE DB 'MAIN MENU','$' 
	TEXT_MAIN_MENU_PLAY DB 'START PLAY - S KEY','$' 
	TEXT_MAIN_MENU_EXIT DB 'EXIT GAME - E KEY','$' 
	
	BALL_ORIGINAL_X DW 0A0h              
	BALL_ORIGINAL_Y DW 64h              
	BALL_X DW 0A0h                       
	BALL_Y DW 64h                      
	BALL_SIZE DW 06h                     
	BALL_VELOCITY_X DW 05h               
	BALL_VELOCITY_Y DW 02h              
	
	PADDLE_X DW 20h                 
	PADDLE_Y DW 55h                 
	PLAYER_POINTS DB 0             
	
	PADDLE_WIDTH DW 06h                  
	PADDLE_HEIGHT DW 25h               
	PADDLE_VELOCITY DW 0Fh               
	RANDOM_VAR DB 0
	
	MAP_COLOR DB 0FH

DATA ENDS

CODE SEGMENT PARA 'CODE'

	MAIN PROC FAR
	ASSUME CS:CODE,DS:DATA,SS:STACK      
	PUSH DS                              
	SUB AX,AX                            
	PUSH AX                              
	MOV AX,DATA                          
	MOV DS,AX                            
	POP AX                              
	POP AX                               
		
		CALL CLEAR_SCREEN               
		
		CHECK_TIME:                      
			
			CMP EXITING_GAME,01h
			JE START_EXIT_PROCESS
			
			CMP CURRENT_SCENE,00h
			JE SHOW_MAIN_MENU
			
			CMP GAME_ACTIVE,00h
			JE SHOW_GAME_OVER
			
			MOV AH,2Ch 					 
			INT 21h    					 
			
			CMP DL,TIME_AUX  			
			JE CHECK_TIME    		     
			

  
			MOV TIME_AUX,DL              
			
			CALL CLEAR_SCREEN            
			
			CALL MOVE_BALL               
			CALL DRAW_BALL               
			
			CALL MOVE_PADDLES          
			CALL DRAW_PADDLES            
			
			CALL DRAW_UI               
			
			JMP CHECK_TIME               
			
			SHOW_GAME_OVER:
				CALL DRAW_GAME_OVER_MENU
				JMP CHECK_TIME
				
			SHOW_MAIN_MENU:
				CALL DRAW_MAIN_MENU
				JMP CHECK_TIME
				
			START_EXIT_PROCESS:
				CALL CONCLUDE_EXIT_GAME
				
		RET		
	MAIN ENDP
	
	MOVE_BALL PROC NEAR          
	    
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX                   
		
		
		MOV AX,PADDLE_X
		CMP BALL_X,AX                    
		JL GAME_OVER     
		
		MOV AX,WINDOW_WIDTH
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_X,AX	                
		JG INC_PLAYER_SCORE_MID     
		JMP MOVE_BALL_VERTICALLY
			
		GAME_OVER:                      
			MOV PLAYER_POINTS,00h   
			CALL UPDATE_TEXT_PLAYER_POINTS
			MOV GAME_ACTIVE,00h            
			RET	

		
		MOVE_BALL_VERTICALLY:		
			MOV AX,BALL_VELOCITY_Y
			ADD BALL_Y,AX             
		


		MOV AX,WINDOW_BOUNDS
		CMP BALL_Y,AX                   
		JL NEG_VELOCITY_Y                


		MOV AX,WINDOW_HEIGHT	
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_Y,AX                
		JG NEG_VELOCITY_Y		         


		JMP CON_CHECK
		
		
		INC_PLAYER_SCORE_MID:
		JMP INC_PLAYER_SCORE
		
		
		CON_CHECK:
		MOV AX,BALL_X
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_X
		JNG EXIT_COLLISION_CHECK  
		
		MOV AX,PADDLE_X
		ADD AX,PADDLE_WIDTH
		CMP BALL_X,AX
		JNL EXIT_COLLISION_CHECK  
		
		MOV AX,BALL_Y
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_Y
		JNG EXIT_COLLISION_CHECK  
		
		MOV AX,PADDLE_Y
		ADD AX,PADDLE_HEIGHT
		CMP BALL_Y,AX
		JNL EXIT_COLLISION_CHECK  
		
	

		JMP NEG_VELOCITY_X
		
		
    		
		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y   
			CALL RANDOM_NUM
		    MOV AL,RANDOM_VAR
		    CMP AL,6
			JG INCRESE_X
			
			SUB BALL_VELOCITY_X,3
			RET
			INCRESE_X:
			ADD BALL_VELOCITY_X,4
			RET
		INC_PLAYER_SCORE:
		    CALL RANDOM_NUM
		    MOV AL,RANDOM_VAR
		    MOV AH,0
    		MOV MAP_COLOR,AL
    		 
    		
		    INC PLAYER_POINTS

		    CALL UPDATE_TEXT_PLAYER_POINTS
		NEG_VELOCITY_X:
			NEG BALL_VELOCITY_X            
			
			RET                              
			
		EXIT_COLLISION_CHECK:
			RET
	MOVE_BALL ENDP
	
	MOVE_PADDLES PROC NEAR              
		

		
		
		MOV AH,01h
		INT 16h
		JZ EXIT_PADDLE_MOVEMENT 
		
		
		MOV AH,00h
		INT 16h
		
		
		CMP AL,77h 
		JE MOVE_PADDLE_UP
		CMP AL,57h 
		JE MOVE_PADDLE_UP
		
		
		CMP AL,73h 
		JE MOVE_PADDLE_DOWN
		CMP AL,53h 
		JE MOVE_PADDLE_DOWN
		JMP EXIT_PADDLE_MOVEMENT
		
		MOVE_PADDLE_UP:
			MOV AX,PADDLE_VELOCITY
			SUB PADDLE_Y,AX
			
			MOV AX,WINDOW_BOUNDS
			CMP PADDLE_Y,AX
			JL FIX_PADDLE_TOP_POSITION
			JMP EXIT_PADDLE_MOVEMENT
			
			FIX_PADDLE_TOP_POSITION:
				MOV PADDLE_Y,AX
				JMP EXIT_PADDLE_MOVEMENT
			
		MOVE_PADDLE_DOWN:
			MOV AX,PADDLE_VELOCITY
			ADD PADDLE_Y,AX
			MOV AX,WINDOW_HEIGHT
			SUB AX,WINDOW_BOUNDS
			SUB AX,PADDLE_HEIGHT
			CMP PADDLE_Y,AX
			JG FIX_PADDLE_BOTTOM_POSITION
			JMP EXIT_PADDLE_MOVEMENT
			
			FIX_PADDLE_BOTTOM_POSITION:
				MOV PADDLE_Y,AX
				JMP EXIT_PADDLE_MOVEMENT
		
		EXIT_PADDLE_MOVEMENT:
		
			RET
		
	MOVE_PADDLES ENDP
	
	DRAW_BALL PROC NEAR                  
		
		MOV CX,BALL_X                  
		MOV DX,BALL_Y                   
		
		DRAW_BALL_HORIZONTAL:
			MOV AH,0Ch                 
			MOV AL,MAP_COLOR 					
			MOV BH,00h 					
			INT 10h    					 
			
			INC CX     					
			MOV AX,CX          	  		
			SUB AX,BALL_X
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,BALL_X 				 
			INC DX       				 
			
			MOV AX,DX             		
			SUB AX,BALL_Y
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
		
		RET
	DRAW_BALL ENDP
	
	DRAW_PADDLES PROC NEAR
		
		MOV CX,PADDLE_X 			 
		MOV DX,PADDLE_Y 			
		
		DRAW_PADDLE_HORIZONTAL:
			MOV AH,0Ch 					
			MOV AL,MAP_COLOR 					 
			MOV BH,00h 					 
			INT 10h    					
			
			INC CX     				 	 
			MOV AX,CX         			 
			SUB AX,PADDLE_X
			CMP AX,PADDLE_WIDTH
			JNG DRAW_PADDLE_HORIZONTAL
			
			MOV CX,PADDLE_X 		 
			INC DX       				
			
			MOV AX,DX            	     
			SUB AX,PADDLE_Y
			CMP AX,PADDLE_HEIGHT
			JNG DRAW_PADDLE_HORIZONTAL
			
			
		RET
	DRAW_PADDLES ENDP
	
	DRAW_UI PROC NEAR
		
		MOV AH,02h                     
		MOV BH,00h                 
		MOV DH,02h                      
		MOV DL,010h						
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_PLAYER_POINTS   
		INT 21h
		
		MOV CX,WINDOW_BOUNDS 			
		MOV DX,WINDOW_BOUNDS
		DEC DX
		DEC DX
		DEC DX
		                          
		DRAW_WALL_HORIZONTAL_UP:
	    	MOV AH,0Ch                   
			MOV AL,MAP_COLOR 					 
			MOV BH,00h 					 
			INT 10h                      
			INC CX
			MOV AX,WINDOW_WIDTH
			SUB AX,WINDOW_BOUNDS
			CMP CX,AX
			JLE  DRAW_WALL_HORIZONTAL_UP
			
		MOV CX,WINDOW_BOUNDS 		
		MOV DX,WINDOW_HEIGHT
		SUB DX,WINDOW_BOUNDS
		INC DX
		INC DX
		INC DX	
		DRAW_WALL_HORIZONTAL_DOWN:
	    	MOV AH,0Ch                   
			MOV AL,MAP_COLOR 					 
			MOV BH,00h 					 
			INT 10h                      
			INC CX
			MOV AX,WINDOW_WIDTH
			SUB AX,WINDOW_BOUNDS
			CMP CX,AX
			JLE  DRAW_WALL_HORIZONTAL_DOWN
			
		MOV CX,WINDOW_WIDTH
		SUB CX,WINDOW_BOUNDS
		INC CX
		INC CX
		MOV DX,WINDOW_BOUNDS
		DRAW_WALL_VERTICAL:
		    MOV AH,0Ch                   
			MOV AL,MAP_COLOR 					
			MOV BH,00h 					
			INT 10h
			INC DX
			MOV AX,WINDOW_HEIGHT
			SUB AX,WINDOW_BOUNDS
			CMP DX,AX
			JLE DRAW_WALL_VERTICAL                         
		                          
		
		RET
	DRAW_UI ENDP
	
	UPDATE_TEXT_PLAYER_POINTS PROC NEAR
		
		XOR AX, AX
        MOV AL, PLAYER_POINTS  
    

        MOV AH, 0             
        MOV BL, 10            
        DIV BL               
    

        ADD AL, '0'           
        MOV [TEXT_PLAYER_POINTS], AL  
    

        ADD AH, '0'           
        MOV [TEXT_PLAYER_POINTS + 1], AH  
    
        MOV [TEXT_PLAYER_POINTS + 2], '$'
    
        RET
		
	UPDATE_TEXT_PLAYER_POINTS ENDP
	
	DRAW_GAME_OVER_MENU PROC NEAR        
		
		CALL CLEAR_SCREEN                


		MOV AH,02h                       
		MOV BH,00h                     
		MOV DH,04h                     
		MOV DL,04h						
		INT 10h							 
		
		MOV AH,09h                      
		LEA DX,TEXT_GAME_OVER_TITLE      
		INT 21h                          
		

		MOV AH,02h                     
		MOV BH,00h                     
		MOV DH,08h                    
		MOV DL,04h						
		INT 10h							 

		MOV AH,09h                       
		LEA DX,TEXT_GAME_OVER_PLAY_AGAIN      
		INT 21h                          
		

		MOV AH,02h                       
		MOV BH,00h                      
		MOV DH,0Ah                       
		MOV DL,04h						
		INT 10h							 

		MOV AH,09h                       
		LEA DX,TEXT_GAME_OVER_MAIN_MENU     
		INT 21h                          
		

		MOV AH,00h
		INT 16h

		
		CMP AL,'R'
		JE RESTART_GAME
		CMP AL,'r'
		JE RESTART_GAME

		CMP AL,'E'
		JE EXIT_TO_MAIN_MENU
		CMP AL,'e'
		JE EXIT_TO_MAIN_MENU
		RET
		
		RESTART_GAME:
			MOV GAME_ACTIVE,01h
			CALL RESET_BALL_POSITION
			RET
		
		EXIT_TO_MAIN_MENU:
			MOV GAME_ACTIVE,00h
			MOV CURRENT_SCENE,00h
			RET
			
	DRAW_GAME_OVER_MENU ENDP
	
	DRAW_MAIN_MENU PROC NEAR
		
		CALL CLEAR_SCREEN
		

		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,04h                      
		MOV DL,04h						
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_MAIN_MENU_TITLE      
		INT 21h                         
		

		MOV AH,02h                     
		MOV BH,00h                       
		MOV DH,06h                   
		MOV DL,04h						
		INT 10h							 
		
		MOV AH,09h                      
		LEA DX,TEXT_MAIN_MENU_PLAY    
		INT 21h                          
		
		

		MOV AH,02h                       
		MOV BH,00h                 
		MOV DH,0Ah                       
		MOV DL,04h						 
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_MAIN_MENU_EXIT      
		INT 21h                         
		
		MAIN_MENU_WAIT_FOR_KEY:

			MOV AH,00h
			INT 16h
		

			CMP AL,'S'
			JE START_PLAY
			CMP AL,'s'
			JE START_PLAY
			CMP AL,'E'
			JE EXIT_GAME
			CMP AL,'e'
			JE EXIT_GAME
			JMP MAIN_MENU_WAIT_FOR_KEY
			
		START_PLAY:
			MOV CURRENT_SCENE,01h
			MOV GAME_ACTIVE,01h
			RET
		
		EXIT_GAME:
			MOV EXITING_GAME,01h
			RET

	DRAW_MAIN_MENU ENDP
	
	CLEAR_SCREEN PROC NEAR             
	
			MOV AH,00h                 
			MOV AL,13h                   
			INT 10h    					
		
			MOV AH,0Bh 				
			MOV BH,00h 					
			MOV BL,00h 				
			INT 10h    					
			
			RET
			
	CLEAR_SCREEN ENDP
	
	CONCLUDE_EXIT_GAME PROC NEAR        
		
		MOV AH,00h                   
		MOV AL,02h                 
		INT 10h    					
		
		MOV AH,4Ch                   
		INT 21h

	CONCLUDE_EXIT_GAME ENDP
	
	RESET_BALL_POSITION PROC NEAR        
		
		MOV AX,BALL_ORIGINAL_X
		MOV BALL_X,AX
		
		MOV AX,BALL_ORIGINAL_Y
		MOV BALL_Y,AX
		
		MOV BALL_VELOCITY_X,05H
		
		NEG BALL_VELOCITY_X
		NEG BALL_VELOCITY_Y
		
		RET
	RESET_BALL_POSITION ENDP
	
	RANDOM_NUM PROC NEAR
        MOV AH, 00h      
        INT 1Ah          
        MOV AX, DX       
        XOR DX, DX      
        MOV BX, 15     
        DIV BX          
        INC DL
        MOV RANDOM_VAR, DL 
        RET
    RANDOM_NUM ENDP

CODE ENDS
END