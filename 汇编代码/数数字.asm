DATA	 	SEGMENT	
NUMBER		DB	'No.:17130120116 ',0AH,0DH,'NAME:liyunshui',0AH,0DH,'$'
ERROR		DB   0AH,0DH,'ERROR! PLEASE TRY AGAIN!',0AH,0DH,'$'
INP			DB 0AH,0DH,'Please input a number,you can exit by inputing "q" or "Q"',0AH,0DH,'$'
XP          DB 0AH,0DH,'$'
DATA		ENDS

CODE		SEGMENT	
			ASSUME	CS:CODE,DS:DATA
start:		MOV 	AX,DATA
			MOV		DS,AX
			MOV 	DX,OFFSET NUMBER 	;打印学号姓名
			MOV 	AH,09H
			INT 	21H
			MOV		BX,0H
			MOV		DX,OFFSET INP
			MOV		AH,09H              ;提示输入字符
			INT		21H
			mov dx,0
input:		
            MOV     AH,01H			
			INT     21H
			
			CMP 	AL,0DH            	;数字输入完毕   
			JE		change
			
			
			CMP 	AL,030h				;非数字
			jl		input
			cmp		AL,039h
			jg		input
			
			add   dx,1  				;1+0
            jmp input
			
change:	
			MOV 	CL,16       ;16次循环，打出16个
loops:        
			CMP		DX,0AH			;是否是A以上的数
			JL		C2		
			ADD		DX,07H		    
C2:			ADD		DX,30H		
									;show chArActer 
			MOV		AH,02H
			INT		21H
            
	
EXIT:		
			MOV		AX,4C00H	
			INT		21H

CODE		ENDS
END	START


