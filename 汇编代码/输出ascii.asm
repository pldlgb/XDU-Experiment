DATAS SEGMENT
    ;�˴��������ݶδ���
    buf db "please print the ascii of string:",0AH,0DH,'$'
    
      
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV DX,OFFSET buf
	MOV AH,09H
	INT 21H 
	MOV SI,OFFSET buf
	
	B1:
	    MOV AL,DS:[SI]          ;����al�õ�����ֵ
		CMP AL,'$'
		JZ EXIT
		AND AL,0F0H              ;��ȡ����λ
		MOV CL,04H              
		SHR AL,CL                ;������λ
		CMP AL,0AH              
		JB B2                    ;С��A�Ļ�������B2
		ADD AL,07H             ;��С�ڼ�7h
	B2:
		ADD AL,30H        ;ת��ascii��
		MOV DL,AL          
		MOV AH,02H
		INT 21H           ;������ڵ�al
		MOV AL,DS:[SI]    
		AND AL,0FH        ; ��ȡ����λ
		CMP AL,0AH
		JB B3
		ADD AL,07H
	B3:
		ADD AL,30H
		MOV DL,AL
		MOV AH,02H
		INT 21H           ;��ʾ��λ
		mov al,0AH
		;mov dl,al
		;MOV AH,02H
		;INT 21H 
		inc si
		LOOP B1
	  
    
    ;�˴��������δ���
 EXIT:
		MOV AH,4CH
		INT 21H	
CODES ENDS
    END START

