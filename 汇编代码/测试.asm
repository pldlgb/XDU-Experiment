assume cs:codesg
codesg segment			;��������5��8λ��16������(ÿ����8λ�����ƣ���2λʮ������)���ۼ�������  ��Ϊ16λ
		mov	dx,0			;�������ۼӺ�
		mov cx,5h

s:		mov ah,01h
		mov bx,0
		int 21h			;����
		cmp al,41h
		jb a			;С��41H��������С��'A'��Ϊ���֣���ת��a
		sub al,7h
a:		sub al,30h		;��ascll��������
		add bl,al		;�Ž�bl
		mov ah,01h
		int 21h			;����ڶ���
		cmp al,41h
		jb b			;С��41H��������С��'A'��Ϊ���֣���ת��b
		sub al,7h
b:		sub al,30h		;��ascll��������
		shl bl,1		;����bl���ڳ�λ�ø�����λ�ۼ�
		shl bl,1
		shl bl,1
		shl bl,1
		add bl,al		;�Ž�bl
		add dx,bx		;bx��λbh�������0
		loop s

		mov bx,dx

		MOV AH,02H
		MOV DL,0DH
		INT 21H 		;�س�
		MOV AH,02H
		MOV DL,0AH
		INT 21H 		;����

		MOV  CH,4		;���Bx
ROTATE: MOV  CL,4
        ROL  BX,CL		;��bx�����λѭ�����Ƶ������λ
        MOV  AL,BL		;ȡ��λ�ƺ��bl
        AND  AL,0FH		;ȡ��al����λ�����ϴ�bx�������λ�������Ƿ���������������λ���������λ
        ADD  AL,30H		;����30H ,��ʼת��Ϊascll�룬��ʵ����Ҳ������or AL,30H�����ܸ���
        CMP  AL,3AH		;�Ƚ�AL,��10��ascll��
        JL  PRINTIT		;JLС��ת�ƣ������з������ıȽϣ�AL<3AH ��Ϊ���֣�����ת
        ADD  AL,7H		;�ߵ��˴�˵��Ϊ��ĸ�����7��Ϊ��ĸ��ascll
PRINTIT:MOV  DL,AL		;���������ascll�����DL
        MOV  AH,2		;2�Ź���,�ַ����
        INT  21H		;2�Ź���,�ַ����,���DL��ascll��
        DEC  CH			;ch --
        JNZ  ROTATE		;��������־λ ZF!=0 ��ת��
		mov ax,4c00h
		int 21h
codesg ends
end
