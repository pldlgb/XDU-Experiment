DATAS SEGMENT
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    db 0;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,12666
    
    MOV BX,DATAS
    mov ds,bx
    mov si,0
    
    call dtoc
    
    mov dh,8
    mov dl,3
    mov cl,0CAh
    
    call show_str
    
    MOV AH,4CH
    INT 21H
    
dtoc:
    push dx
    push cx
    push ax
    push si
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
    pop si
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





