MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS

MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI��9054оƬI/O����ַ�ݴ�ռ�
IO_base_address     DB 4 DUP(0)						;PCI��I/O����ַ�ݴ�ռ�
pcicardnotfind		DB 0DH,0AH,'pci card not find or address/interrupt error !!!',0DH,0AH,'$'
GOOD				DB 0DH,0AH,'The Program is Executing !',0DH,0AH,'$'
LS244    	DW  	00000H  		
LS273    	DW  	00020H
;
;
DELAY_SET	EQU		0FFFH							;��ʱ����

MY_DATA 	ENDs

MY_CODE 	SEGMENT PARA 'CODE'

MY_PROC		PROC	FAR		
			ASSUME 	CS:MY_CODE,	DS:MY_DATA,	SS:MY_STACK			
MAIN:		
.386	;386ģʽ����
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
			CALL	FINDPCI					;�Զ�����PCI����Դ��IO�ڻ�ַ
			MOV		CX,word ptr IO_base_address	
;			MOV		CX,0E800H				;ֱ�Ӽ���(E800:����PCI��IO�ڻ�ַ)
			
	ADD		LS244,CX				;PCI��IO��ַ+ƫ��
	ADD		LS273,CX

; ���빦��ʵ�ִ���
START:
			MOV DX, LS244
			IN  AL, DX
			CMP AL, 11111111B
			JE HIGH
			CMP AL, 00H
			JE LOW	
			CMP AL,11110000B
			JZ LUNLIU
			CMP AL,00001111B
			JZ JIAOTI
			MOV DX, LS273
			OUT DX, AL
			call DELAY
			JMP START

LOW:
			MOV CX, 8
			MOV AL, 7FH
			MOV DX, LS273
	ROUND1:		
			OUT DX, AL
			RCL AL,1
			CALL DELAY
			LOOP ROUND1
			MOV AL,00FFH
			OUT DX,AL
			CALL DELAY
			OUT DX,AL
			CALL DELAY
		
			JMP START
HIGH:
			MOV CX, 8
			MOV AL, 7FH
			MOV DX, LS273
	ROUND2:		
			OUT DX, AL
			RCR AL,1
			CALL DELAY
			LOOP ROUND2
			MOV AL,00FFH
			OUT DX,AL
			CALL DELAY
			OUT DX,AL
			CALL DELAY
		
			JMP START
			
LUNLIU:		
			MOV CX, 8
			MOV AL, 7FH
			MOV DX, LS273
	ROUND3:		
			OUT DX, AL
			RCL AL,1
			CALL DELAY
			LOOP ROUND3
			MOV AL,00FFH
			OUT DX,AL
			CALL DELAY
			OUT DX,AL
			CALL DELAY
			
			MOV CX, 8
			MOV AL, 7FH
			MOV DX, LS273
	ROUND4:		
			OUT DX, AL
			RCR AL,1
			CALL DELAY
			LOOP ROUND4
			MOV AL,00FFH
			OUT DX,AL
			CALL DELAY
			OUT DX,AL
			CALL DELAY
			JMP START
			
JIAOTI:
			MOV CX,3
			MOV AL,00H
			MOV DX,LS273
	ROUND5:
			MOV AL,11111100B
			OUT DX,AL
			CALL DELAY
			CALL DELAY
			CALL DELAY
			MOV AL,00111111B
			OUT DX,AL
			CALL DELAY
			CALL DELAY
			CALL DELAY
			LOOP ROUND5
			JMP START
			
										
MY_PROC  ENDp




;*****************************************************************************
;			/*��ʱ����*/
;*****************************************************************************	
;
DELAY 		PROC  	NEAR					;��ʱ����
			PUSHF
			PUSH	DX
			PUSH	CX
			MOV 	DX,DELAY_SET
D1: 		MOV 	CX,-1
D2:    		DEC 	CX
		JNZ 	D2
		DEC		DX
		JNZ		D1
		POP		CX
		POP		DX
		POPF
		RET
DELAY  		ENDp
;
;*****************************************************************************
;		/* �ҿ��ӳ��� */
;*****************************************************************************			
;
;FUNCTION CODE
IO_port_addre		EQU 0CF8H					;32λ���õ�ַ�˿�
IO_port_data		EQU	0CFCH					;32λ�������ݶ˿�
IO_PLX_ID			EQU	200810B5H				;PCI���豸������ID
BADR0				=	10H						;����ַ�Ĵ���0
BADR1				=	14H						;����ַ�Ĵ���1
BADR2				=	18H						;����ַ�Ĵ���2
BADR3				=	1CH						;����ַ�Ĵ���3

FINDPCI 	PROC	NEAR						;����PCI����Դ����ʾ
			PUSHAD
			PUSHFD
			MOV		EBX,080000000H
FINDPCI_next:
			ADD		EBX,100H
			CMP 	EBX,081000000H
			JNZ 	findpci_continue
			MOV 	DX,offset pcicardnotfind	;��ʾδ�ҵ�PCI����ʾ��Ϣ
			MOV 	AH,09H
			INT 	21H
			MOV 	AH,4CH
			INT 	21H							;�˳�
findpci_continue:
			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			OUT 	DX,EAX						;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX						;�����ݿ�
			CMP 	EAX,IO_PLX_ID
			JNZ 	findpci_next				;����Ƿ���PCI��

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
		ADD 	EAX,BADR1
			OUT 	DX,EAX									;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;�����ݿ�
			MOV 	dword ptr IO_9054base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;����Ƿ�Ϊi/o��ַ��Ϣ
		MOV 	EAX,dword ptr IO_9054base_address
			AND 	EAX,0fffffffeh
	MOV 	dword ptr IO_9054base_address,EAX		;ȥ��i/oָʾλ������

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			ADD 	EAX,BADR2
			OUT 	DX,EAX									;д��ַ��
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;�����ݿ�
			MOV 	dword ptr IO_base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;����Ƿ�Ϊi/o��ַ��Ϣ
			MOV 	EAX,dword ptr IO_base_address
			AND 	EAX,0fffffffeh
			MOV 	dword ptr IO_base_address,EAX			;ȥ��i/oָʾλ������
			MOV 	DX,offset good							;��ʾ��ʼִ�г�����Ϣ
			MOV 	AH,09H
			INT 	21H
			POPfd
			POPad
			RET
findPCI		ENDP

MY_CODE   	ENDS

			END    	MAIN	

