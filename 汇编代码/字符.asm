

DATAS SEGMENT
 db "Kyrie  Irving ",0;此处输入数据段代码  

 
DATAS ENDS

STACKS SEGMENT
 ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS 
	MOV DS,AX  ;DS指向代码段
	mov si ,0  ;SI指向0地址
				    
	mov dh ,8   ;把显示的行放到dh
	mov dl ,8   ;列放到dl
	mov cl ,1   ;颜色
				    
call show_str
				    
	MOV AH,4CH
	INT 21H
				    
show_str :
	push cx  ;保存cx和si的值
	push si
	mov al, 0A0h
	;dec dh 
	mul dh  ;dh*al->ax 跳到第八行
				    
	mov bx,ax  ;保存位置
				    
	mov al,2  ;每次跳字
	mul dl    ;dh*al->ax 跳到第八列
	sub ax,2  ;  
				    
	add bx,ax  ;保存位置
				    
	mov ax,0B800h  
	mov es, ax  ;段寄存器定位到显存位置
				    
	mov di,0   ;偏移地址
				    
	mov al,cl  
				    
	mov ch,0
s: 
    mov cl,ds:[si]
    jcxz ok
    mov es:[bx+di],cl  ;赋值
    mov es:[bx+di+1],al;赋颜色
				    
    inc si
    add di,2
    jmp short s
				  
ok:
   pop si
   pop cx
				  
ret
CODES ENDS
 END START




