DATAS SEGMENT
    number dw 0 
    gap dw 0
    account dw 0
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX;ָ��ָ��DATAS��
    mov si,06h
    call main
    
    mov dh,8
    mov dl,3
    mov cl,0CAh
    
    mov si,07h 
    call show_str
    
    MOV AH,4CH
    INT 21H
main proc    
input:
    mov ah,01h
    int 21h
getnumber:;�������asciiת��Ϊʮ������ �������number��
     xor dx,dx ;��dx����
     cmp al,20h ;�ж������ǲ��ǻ��з� �ǽ�������
     je getgap
     xor ah,ah;����λ���� ִ��16λ�˷�
     push ax;�������ַ���ջ ��λal��
     mov ax,number;ʵ��number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;��������bx�洢��bl��
     sub bl,30h
     add ax,bx
     mov number,ax
     jmp input  
     
getgap:;�������asciiת��Ϊʮ������ �������number��
     xor dx,dx ;��dx����
     cmp al,20h ;�ж������ǲ��ǻ��з� �ǽ�������
     je getaccount
     xor ah,ah;����λ���� ִ��16λ�˷�
     push ax;�������ַ���ջ ��λal��
     mov ax,gap;ʵ��number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;��������bx�洢��bl��
     sub bl,30h
     add ax,bx
     mov gap,ax
     jmp input 
 
getaccount:;�������asciiת��Ϊʮ������ �������number��
     xor dx,dx ;��dx����
     cmp al,0dh ;�ж������ǲ��ǻ��з� �ǽ�������
     je process
     xor ah,ah;����λ���� ִ��16λ�˷�
     push ax;�������ַ���ջ ��λal��
     mov ax,account;ʵ��number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;��������bx�洢��bl��
     sub bl,30h
     add ax,bx
     mov account,ax
     jmp input 
     
     mov cx,account
     ;mov bx,si
process:

    mov ax,number
    call dtoc
    inc si
    mov bx,20h
    mov ds:[si],bx
    loop process
main endp   
dtoc:
    push dx
    push cx
    push ax
   ; push si
    push bx
    
    mov bx,0
    
s1: mov cx,10d
    mov dx,0
    
    div cx
    mov cx,ax
    
    jcxz s2
    
    add dx,30h
    push dx
    
    inc bx
    
    jmp short s1
s2: add dx,30h
    push dx
    
    inc bx
    mov cx,bx
    mov si,0
s3: pop ax
    
    mov [si],al
    inc si
    loop s3
    
okay:
    pop bx 
    ;pop si
    pop ax
    pop cx
    pop dx
    
    ret

show_str:
push cx  ;����cx��si��ֵ
push si
mov al, 0A0h
dec dh 
mul dh  ;dh*al->ax �����ڰ���
				    
mov bx,ax  ;����λ��
				    
mov al,2  ;ÿ������
mul dl    ;dh*al->ax ����������
sub ax,2  ;  
				    
add bx,ax  ;����λ��
				    
mov ax,0B800h  
mov es, ax  ;�μĴ�����λ���Դ�λ��
				    
mov di,0   ;ƫ�Ƶ�ַ
				    
 mov al,cl  
				    
    mov ch,0
 s: mov cl,ds:[si]
    jcxz ok
    mov es:[bx+di],cl  ;��ֵ
    mov es:[bx+di+1],al;����ɫ
				    
    inc si
    add di,2
    jmp short s
				  
 ok:pop si
    pop cx
 				  
    ret    
            

CODES ENDS
    END START













