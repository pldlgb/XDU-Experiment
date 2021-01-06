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
			MOV 	DX,OFFSET NUMBER 	;��ӡѧ������
			MOV 	AH,09H
			INT 	21H
			MOV		BX,0H
			MOV		DX,OFFSET INP
			MOV		AH,09H              ;��ʾ�����ַ�
			INT		21H
input:		
            MOV     AH,01H			
			INT     21H
			
			CMP 	AL,0DH            	;�����������   
			JE		change
			
			CMP     AL,'Q'				;�˳�
			JE	 	EXIT
			CMP     AL,'q'
			JE	    EXIT
			
			CMP 	AL,030h				;������
			jl		errors
			cmp		AL,039h
			jg		errors
			
			SUB		AL,30H				;����
			push 	AX                  ;��AX��ֵѹ��ջ��
			mov		AX,BX               
			mov		DX,0000AH           
			mul		DX                  ;AX*10,0*10
			mov		BX,AX               ;BX=AX
			pop		AX					;
			add		BL,AL				;1+0
			
			CMP     BX,00H              ;�ж��ǲ���0
			JZ      ZERO
			jmp		input
			
errors:		MOV		DX,OFFSET ERROR
			MOV		AH,09H
			INT		21H
			MOV		BX,0H               ;bx����
			jmp     input               ;������������
			
ZERO:     	MOV 	CL,4
           	JMP   LOOPS        ;���4��0
change:	
            CMP     BX,00H
            JZ      ERRORS
			MOV 	CL,4       ;�Ĵ�ѭ��������ĸ�
loops:
			MOV 	DX,BX          
			AND 	DX,0F000H
			
			push cx
			mov     cl,0CH      
			SHR		DX,cl           ;����12λ
			pop cx
			CMP		DX,0AH			;�Ƿ���A���ϵ���
			JL		C2		
			ADD		DX,07H		    
C2:			ADD		DX,30H		
									;show chArActer 
			MOV		AH,02H
			INT		21H
            
            push cx
            mov     cl,04H
			SHL		BX,cl           ;������λ 
			pop  cx
			LOOP    loops         ;ѭ����ص�����
			MOV 	DX,OFFSET XP	
			MOV 	AH,09H
			INT 	21H
			JMP     INPUT
	
EXIT:		
			MOV		AX,4C00H	
			INT		21H

CODE		ENDS
END	START





