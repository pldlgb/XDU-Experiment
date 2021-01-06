;FUNCTION CODE
IO_port_addre			EQU 0CF8H					;32λ���õ�ַ�˿�
IO_port_data			EQU	0CFCH					;32λ�������ݶ˿�
IO_PLX_ID				EQU	200810B5H				;PCI���豸������ID
BADR0					=	10H						;����ַ�Ĵ���0
BADR1					=	14H						;����ַ�Ĵ���1
BADR2					=	18H						;����ַ�Ĵ���2
BADR3					=	1CH						;����ַ�Ĵ���3

MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS

MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI��9054оƬI/O����ַ�ݴ�ռ�
IO_base_address     DB 4 DUP(0)						;PCI��I/O����ַ�ݴ�ռ�
pcicardnotfind		DB 0DH,0AH,'pci card not find or address/interrupt error !!!',0DH,0AH,'$'
GOOD				DB 0DH,0AH,'The Program is Executing !',0DH,0AH,'$'
P8255_A    	DW  	0000H  	
P8255_B    	DW  	0001H
P8255_C    	DW  	0002H
P8255_MODE 	DW  	0003H
DELAY_SET	EQU	 	0FFFH							;��ʱ����
MES4		DB	10,13,'The data error !Please enter again !' ,10,13,'$'
MES3		DB	10,13,'Please enter 0~9 to Play !' ,10,13
			DB 	'ENTER CR TO RETURN  !',0DH,0AH,'$'
MES2		DB '	PCI CONFIG READ ERROR!		$'

DDATA		DB		?
MY_DATA 	ENDs

MY_CODE 	SEGMENT PARA 'CODE'

MY_PROC		PROC	FAR		
			ASSUME 	CS:MY_CODE,	DS:MY_DATA,	SS:MY_STACK
			
START:		
.386	;386ģʽ����
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
st1:		MOV 	DX,offset good							;��ʾ��ʼִ�г�����Ϣ
			MOV 	AH,09H
			INT 	21H
			
			
			CALL	FINDPCI						;����PCI����Դ����ʾ
			MOV		CX,word ptr IO_base_address		
			ADD		P8255_A,CX
        	ADD		P8255_B,CX
        	ADD		P8255_C,CX
        	ADD		P8255_MODE,CX
			
SSS: 		
			MOV 	DX,P8255_MODE
       		MOV 	AL,08BH						;д8255������A��B�����C����
       		OUT 	DX,AL 
       		mov		al,00fh
        	MOV     DX,P8255_C
			IN      AL,DX
qq:			MOV     DX,P8255_B
			IN      AL,DX
			AND     AL,80H
			JNZ      qqq
  			MOV		DX,P8255_A
       		mov	al,0EDH
       		OUT DX,AL
       		MOV CX,01FH
qqd:      	call DELAY
       		loop qqd
       		MOV AL,0bbH
       		OUT DX,AL
       		call DELAY
       		CALL DELAY
       		call DELAY
       		mov	al,0DEH
       		OUT DX,AL
       	    MOV CX,01FH
qqdd:       call DELAY
       		loop qqdd
       	
       		jmp		qq
qqq:		MOV     DX,P8255_B
			IN      AL,DX
			and     al,80h
			JZ      qq
  			mov     DX,P8255_C
  			IN      AL,DX
  			AND     AL,01110111b
  			MOV		DX,P8255_A
      		OUT     DX,AL
       		jmp		qqq
       		
START1:		MOV		DX,OFFSET MES3	
			MOV		AH,09H
			INT 	21H      		
			
ERROR:		MOV		DX,OFFSET MES2				;��ʾ��������Ϣ
			MOV		AH,09H
			INT		21H
EXIT:		MOV		AX,4C00H
			INT		21H	   		
MY_PROC		ENDp	

		
			
DELAY20		PROC  	NEAR						;��ʱ����
			PUSHF
			PUSH	AX
			PUSH	DX
			PUSH	CX
			MOV		AH,86H			
			MOV		CX,00
			MOV		DX,20
			INT		15H
       		POP		CX
       		POP		DX
       		POP		AX
       		POPF
       		RET
DELAY20  	ENDp


DELAY500	PROC  	NEAR						;��ʱ����
			PUSHF
			PUSH	AX
			PUSH	DX
			PUSH	CX
			MOV		AH,86H			
			MOV		CX,07h
			MOV		DX,0d0H
			INT		15H
       		POP		CX
       		POP		DX
       		POP		AX
       		POPF
       		RET
DELAY500	ENDp
DELAY		PROC	NEAR;��ʱ����
PUSHF
		PUSH	DX
		PUSH	CX
		MOV	DX,DELAY_SET
D1:
		MOV	CX,-1
D2:		DEC	CX
		JNZ	D2
		DEC	DX
		JNZ	D1
		POP	CX
		POP	DX
POPF
RET
DELAY		ENDp;			

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
			
MY_CODE		ENDS

			END		START 		
