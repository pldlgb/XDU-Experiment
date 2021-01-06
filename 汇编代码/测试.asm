assume cs:codesg
codesg segment			;键盘输入5个8位的16进制数(每个数8位二进制，即2位十六进制)，累加求和输出  和为16位
		mov	dx,0			;这里存放累加和
		mov cx,5h

s:		mov ah,01h
		mov bx,0
		int 21h			;输入
		cmp al,41h
		jb a			;小于41H的数，即小于'A'，为数字，跳转到a
		sub al,7h
a:		sub al,30h		;从ascll码变成数字
		add bl,al		;放进bl
		mov ah,01h
		int 21h			;输入第二次
		cmp al,41h
		jb b			;小于41H的数，即小于'A'，为数字，跳转到b
		sub al,7h
b:		sub al,30h		;从ascll码变成数字
		shl bl,1		;左移bl，腾出位置给输入位累加
		shl bl,1
		shl bl,1
		shl bl,1
		add bl,al		;放进bl
		add dx,bx		;bx高位bh本身就是0
		loop s

		mov bx,dx

		MOV AH,02H
		MOV DL,0DH
		INT 21H 		;回车
		MOV AH,02H
		MOV DL,0AH
		INT 21H 		;换行

		MOV  CH,4		;输出Bx
ROTATE: MOV  CL,4
        ROL  BX,CL		;把bx最高四位循环左移到最低四位
        MOV  AL,BL		;取出位移后的bl
        AND  AL,0FH		;取出al低四位，即上次bx的最高四位，这里是反向输出，先输出高位，再输出低位
        ADD  AL,30H		;加上30H ,开始转变为ascll码，其实这里也可以用or AL,30H，还能更快
        CMP  AL,3AH		;比较AL,和10的ascll码
        JL  PRINTIT		;JL小于转移，用于有符号数的比较，AL<3AH （为数字）则跳转
        ADD  AL,7H		;走到此处说明为字母，则加7变为字母的ascll
PRINTIT:MOV  DL,AL		;将待输出的ascll码放入DL
        MOV  AH,2		;2号功能,字符输出
        INT  21H		;2号功能,字符输出,输出DL的ascll码
        DEC  CH			;ch --
        JNZ  ROTATE		;运算结果标志位 ZF!=0 则转移
		mov ax,4c00h
		int 21h
codesg ends
end
