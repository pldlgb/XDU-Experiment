

DATAS SEGMENT
 db "Kyrie  Irving ",0;�˴��������ݶδ���  

 
DATAS ENDS

STACKS SEGMENT
 ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS 
	MOV DS,AX  ;DSָ������
	mov si ,0  ;SIָ��0��ַ
				    
	mov dh ,8   ;����ʾ���зŵ�dh
	mov dl ,8   ;�зŵ�dl
	mov cl ,1   ;��ɫ
				    
call show_str
				    
	MOV AH,4CH
	INT 21H
				    
show_str :
	push cx  ;����cx��si��ֵ
	push si
	mov al, 0A0h
	;dec dh 
	mul dh  ;dh*al->ax �����ڰ���
				    
	mov bx,ax  ;����λ��
				    
	mov al,2  ;ÿ������
	mul dl    ;dh*al->ax �����ڰ���
	sub ax,2  ;  
				    
	add bx,ax  ;����λ��
				    
	mov ax,0B800h  
	mov es, ax  ;�μĴ�����λ���Դ�λ��
				    
	mov di,0   ;ƫ�Ƶ�ַ
				    
	mov al,cl  
				    
	mov ch,0
s: 
    mov cl,ds:[si]
    jcxz ok
    mov es:[bx+di],cl  ;��ֵ
    mov es:[bx+di+1],al;����ɫ
				    
    inc si
    add di,2
    jmp short s
				  
ok:
   pop si
   pop cx
				  
ret
CODES ENDS
 END START




