DATAS SEGMENT
    ;此处输入数据段代码
    buf db "please print the ascii of string:",0AH,0DH,'$'
    
      
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
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
	    MOV AL,DS:[SI]          ;重新al拿到输入值
		CMP AL,'$'
		JZ EXIT
		AND AL,0F0H              ;获取高四位
		MOV CL,04H              
		SHR AL,CL                ;右移四位
		CMP AL,0AH              
		JB B2                    ;小于A的话，跳到B2
		ADD AL,07H             ;不小于加7h
	B2:
		ADD AL,30H        ;转化ascii码
		MOV DL,AL          
		MOV AH,02H
		INT 21H           ;输出现在的al
		MOV AL,DS:[SI]    
		AND AL,0FH        ; 获取低四位
		CMP AL,0AH
		JB B3
		ADD AL,07H
	B3:
		ADD AL,30H
		MOV DL,AL
		MOV AH,02H
		INT 21H           ;显示低位
		mov al,0AH
		;mov dl,al
		;MOV AH,02H
		;INT 21H 
		inc si
		LOOP B1
	  
    
    ;此处输入代码段代码
 EXIT:
		MOV AH,4CH
		INT 21H	
CODES ENDS
    END START

