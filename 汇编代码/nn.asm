;0DH:�ص�����
;0AH:�Ƶ���һ��
MySTACK SEGMENT STACK
	DW 100 DUP(?)
MySTACK ENDS

DATA SEGMENT PARA 'DATA'
	welcome DB "hello!one",0AH,0DH,'$'
	AskNum DB "please enter your Student ID:$"
	FeedBAckNum DB 0AH,0DH,"you're Student ID is $"
	AskName DB 0AH,0DH,"please enter your name:$"
	FeedBackName DB 0AH,0DH,"hello $"
	FeedBackName2 DB " !$"
	Ask DB 0AH,0DH,"please enter a character:$"
	FeedBack DB 'H$'
	num DB 20,?,20 DUP(?)
	mname DB 20,?,20 DUP(?) 
	mascii DB ?,?
	buff3 DB 0AH,0DH,'PLEASE INPUT(q/Q quit!):$'
	buff4 DB 0AH,0DH,'THE ASCII:Ox$'
	buff5 DB 0AH,0DH,'STUDENT NUM:$'
	CRLF DB 0AH,0DH,'$'
	sd Db ?
DATA ENDS

CODE  SEGMENT PARA 'CODE'
      ASSUME CS:CODE,DS:DATA,SS:MySTACK
START:
	  ;��ʼ���μĴ���
	  MOV AX,DATA
	  MOV DS,AX
	  MOV ES,AX
	  
	  ;��ʾ�ַ���
	  MOV DX,offset welcome;
	  MOV AH,09H;
	  INT 21H;
	  LEA DX,AskNum
	  INT 21H
	  
	  ;��ȡѧ��
	  LEA DX,num
	  MOV AH,0AH
	  INT 21H
	  
	  ;��ʾѧ��
	  LEA DX,FeedBackNum
	  MOV AH,09H
	  INT 21H
	  
	  LEA BX,num
	  MOV CL,[BX+1]	;ѧ�Ÿ���
	  MOV CH,0
	  ADD BX,2		;ָ���һ������
	  MOV AH,02H
   L1:
	  MOV DL,[BX]
	  INC BX
	  INT 21H
	  LOOP L1
	  
	  ;ѯ������
	  LEA DX,AskName
	  MOV AH,09H
	  INT 21H
	  
	  ;��ȡ����
	  LEA DX,mname
	  MOV AH,0AH
	  INT 21H
	  
	  ;��ʾ����
	  LEA DX,FeedBackName
	  MOV AH,09H
	  INT 21H
	  
	  LEA BX,mname
	  MOV CL,[BX+1]
	  MOV CH,0
	  ADD BX,2
	  MOV AH,02H
	L2:
	  MOV DL,[BX]
	  INC BX
	  INT 21H
	  LOOP L2
	  
	  LEA DX,FeedBackName2
	  MOV AH,09H
	  INT 21H
	  
	  ;��ȡ�ַ�����ʾASCII��
B1:
		MOV DX,OFFSET buff3
		MOV AH,09H
		INT 21H           ;print "PLEASE INPUT(q/Q quit!):"
		MOV AH,01H
		INT 21H            ;����һ���ַ�
		CMP AL,'q'
		JZ EXIT
		CMP AL,'Q'
		JZ EXIT             ;Q/qʱ�˳�
		MOV sd,AL          ;�����븳��sd
		MOV DX,OFFSET buff4
		MOV AH,09H
		INT 21H            ;print ��THE ASCII:$��
		MOV SI,OFFSET sd    ;��si��λ��sdλ��
		MOV AL,DS:[SI]          ;����al�õ�����ֵ
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
		INT 21H           ;��ʾ�Ͱ�λ
		LOOP B1
	EXIT:
		MOV AH,4CH
		INT 21H	  
CODE  ENDS
END START



