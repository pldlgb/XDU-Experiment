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
input:		
            MOV     AH,01H			
			INT     21H
			
			CMP 	AL,0DH            	;数字输入完毕   
			JE		change
			
			CMP     AL,'Q'				;退出
			JE	 	EXIT
			CMP     AL,'q'
			JE	    EXIT
			
			CMP 	AL,030h				;非数字
			jl		errors
			cmp		AL,039h
			jg		errors
			
			SUB		AL,30H				;运算
			push 	AX                  ;将AX的值压入栈中
			mov		AX,BX               
			mov		DX,0000AH           
			mul		DX                  ;AX*10,0*10
			mov		BX,AX               ;BX=AX
			pop		AX					;
			add		BL,AL				;1+0
			
			CMP     BX,00H              ;判断是不是0
			JZ      ZERO
			jmp		input
			
errors:		MOV		DX,OFFSET ERROR
			MOV		AH,09H
			INT		21H
			MOV		BX,0H               ;bx清零
			jmp     input               ;错误重新输入
			
ZERO:     	MOV 	CL,4
           	JMP   LOOPS        ;打出4个0
change:	
            CMP     BX,00H
            JZ      ERRORS
			MOV 	CL,4       ;四次循环，打出四个
loops:
			MOV 	DX,BX          
			AND 	DX,0F000H
			
			push cx
			mov     cl,0CH      
			SHR		DX,cl           ;右移12位
			pop cx
			CMP		DX,0AH			;是否是A以上的数
			JL		C2		
			ADD		DX,07H		    
C2:			ADD		DX,30H		
									;show chArActer 
			MOV		AH,02H
			INT		21H
            
            push cx
            mov     cl,04H
			SHL		BX,cl           ;左移四位 
			pop  cx
			LOOP    loops         ;循环后回到这里
			MOV 	DX,OFFSET XP	
			MOV 	AH,09H
			INT 	21H
			JMP     INPUT
	
EXIT:		
			MOV		AX,4C00H	
			INT		21H

CODE		ENDS
END	START





