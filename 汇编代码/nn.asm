;0DH:回到首行
;0AH:移到下一行
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
	  ;初始化段寄存器
	  MOV AX,DATA
	  MOV DS,AX
	  MOV ES,AX
	  
	  ;显示字符串
	  MOV DX,offset welcome;
	  MOV AH,09H;
	  INT 21H;
	  LEA DX,AskNum
	  INT 21H
	  
	  ;获取学号
	  LEA DX,num
	  MOV AH,0AH
	  INT 21H
	  
	  ;显示学号
	  LEA DX,FeedBackNum
	  MOV AH,09H
	  INT 21H
	  
	  LEA BX,num
	  MOV CL,[BX+1]	;学号个数
	  MOV CH,0
	  ADD BX,2		;指向第一个数字
	  MOV AH,02H
   L1:
	  MOV DL,[BX]
	  INC BX
	  INT 21H
	  LOOP L1
	  
	  ;询问姓名
	  LEA DX,AskName
	  MOV AH,09H
	  INT 21H
	  
	  ;获取姓名
	  LEA DX,mname
	  MOV AH,0AH
	  INT 21H
	  
	  ;显示姓名
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
	  
	  ;获取字符并显示ASCII码
B1:
		MOV DX,OFFSET buff3
		MOV AH,09H
		INT 21H           ;print "PLEASE INPUT(q/Q quit!):"
		MOV AH,01H
		INT 21H            ;输入一个字符
		CMP AL,'q'
		JZ EXIT
		CMP AL,'Q'
		JZ EXIT             ;Q/q时退出
		MOV sd,AL          ;将输入赋给sd
		MOV DX,OFFSET buff4
		MOV AH,09H
		INT 21H            ;print “THE ASCII:$”
		MOV SI,OFFSET sd    ;将si定位到sd位置
		MOV AL,DS:[SI]          ;重新al拿到输入值
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
		INT 21H           ;显示低八位
		LOOP B1
	EXIT:
		MOV AH,4CH
		INT 21H	  
CODE  ENDS
END START



