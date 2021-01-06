;FUNCTION CODE
IO_port_addre			EQU 0CF8H					;32位配置地址端口
IO_port_data			EQU	0CFCH					;32位配置数据端口
IO_PLX_ID				EQU	200810B5H				;PCI卡设备及厂商ID
BADR0					=	10H						;基地址寄存器0
BADR1					=	14H						;基地址寄存器1
BADR2					=	18H						;基地址寄存器2
BADR3					=	1CH						;基地址寄存器3

MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS

MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI卡9054芯片I/O基地址暂存空间
IO_base_address     DB 4 DUP(0)						;PCI卡I/O基地址暂存空间
pcicardnotfind		DB 0DH,0AH,'pci card not find or address/interrupt error !!!',0DH,0AH,'$'
GOOD				DB 0DH,0AH,'The Program is Executing !',0DH,0AH,'$'
P8255_A    	DW  	0000H  	
P8255_B    	DW  	0001H
P8255_C    	DW  	0002H
P8255_MODE 	DW  	0003H
DELAY_SET	EQU	 	0FFFH							;延时常数
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
.386	;386模式编译
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
st1:		MOV 	DX,offset good							;显示开始执行程序信息
			MOV 	AH,09H
			INT 	21H
			
			
			CALL	FINDPCI						;查找PCI卡资源并显示
			MOV		CX,word ptr IO_base_address		
			ADD		P8255_A,CX
        	ADD		P8255_B,CX
        	ADD		P8255_C,CX
        	ADD		P8255_MODE,CX
			
SSS: 		
			MOV 	DX,P8255_MODE
       		MOV 	AL,08BH						;写8255控制字A、B输出，C输入
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
			
ERROR:		MOV		DX,OFFSET MES2				;显示读错误信息
			MOV		AH,09H
			INT		21H
EXIT:		MOV		AX,4C00H
			INT		21H	   		
MY_PROC		ENDp	

		
			
DELAY20		PROC  	NEAR						;延时程序
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


DELAY500	PROC  	NEAR						;延时程序
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
DELAY		PROC	NEAR;延时程序
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

FINDPCI 	PROC	NEAR						;查找PCI卡资源并显示
			PUSHAD
			PUSHFD
			MOV		EBX,080000000H
FINDPCI_next:
			ADD		EBX,100H
			CMP 	EBX,081000000H
			JNZ 	findpci_continue
			MOV 	DX,offset pcicardnotfind	;显示未找到PCI卡提示信息
			MOV 	AH,09H
			INT 	21H
			MOV 	AH,4CH
			INT 	21H							;退出
findpci_continue:
			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			OUT 	DX,EAX						;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX						;读数据口
			CMP 	EAX,IO_PLX_ID
			JNZ 	findpci_next				;检查是否发现PCI卡

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
       		ADD 	EAX,BADR1
			OUT 	DX,EAX									;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;读数据口
			MOV 	dword ptr IO_9054base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;检查是否为i/o基址信息
       		MOV 	EAX,dword ptr IO_9054base_address
			AND 	EAX,0fffffffeh
        	MOV 	dword ptr IO_9054base_address,EAX		;去除i/o指示位并保存

			MOV 	DX,IO_port_addre
			MOV 	EAX,EBX
			ADD 	EAX,BADR2
			OUT 	DX,EAX									;写地址口
			MOV 	DX,IO_port_data
			IN  	EAX,DX									;读数据口
			MOV 	dword ptr IO_base_address,EAX
			AND 	EAX,1
			JZ 		findPCI_next							;检查是否为i/o基址信息
			MOV 	EAX,dword ptr IO_base_address
			AND 	EAX,0fffffffeh
			MOV 	dword ptr IO_base_address,EAX			;去除i/o指示位并保存
			MOV 	DX,offset good							;显示开始执行程序信息
			MOV 	AH,09H
			INT 	21H
			POPfd
			POPad
			RET
findPCI		ENDP
			
MY_CODE		ENDS

			END		START 		
