DATAS SEGMENT
    number dw 0 
    gap dw 0
    account dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX;指令指向DATAS段
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
getnumber:;将输入的ascii转化为十进制数 结果放在number中
     xor dx,dx ;将dx清零
     cmp al,20h ;判断输入是不是换行符 是结束输入
     je getgap
     xor ah,ah;将高位清理 执行16位乘法
     push ax;将输入字符入栈 低位al中
     mov ax,number;实现number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;将输入用bx存储在bl中
     sub bl,30h
     add ax,bx
     mov number,ax
     jmp input  
     
getgap:;将输入的ascii转化为十进制数 结果放在number中
     xor dx,dx ;将dx清零
     cmp al,20h ;判断输入是不是换行符 是结束输入
     je getaccount
     xor ah,ah;将高位清理 执行16位乘法
     push ax;将输入字符入栈 低位al中
     mov ax,gap;实现number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;将输入用bx存储在bl中
     sub bl,30h
     add ax,bx
     mov gap,ax
     jmp input 
 
getaccount:;将输入的ascii转化为十进制数 结果放在number中
     xor dx,dx ;将dx清零
     cmp al,0dh ;判断输入是不是换行符 是结束输入
     je process
     xor ah,ah;将高位清理 执行16位乘法
     push ax;将输入字符入栈 低位al中
     mov ax,account;实现number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;将输入用bx存储在bl中
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
push cx  ;保存cx和si的值
push si
mov al, 0A0h
dec dh 
mul dh  ;dh*al->ax 跳到第八行
				    
mov bx,ax  ;保存位置
				    
mov al,2  ;每次跳字
mul dl    ;dh*al->ax 跳到第三列
sub ax,2  ;  
				    
add bx,ax  ;保存位置
				    
mov ax,0B800h  
mov es, ax  ;段寄存器定位到显存位置
				    
mov di,0   ;偏移地址
				    
 mov al,cl  
				    
    mov ch,0
 s: mov cl,ds:[si]
    jcxz ok
    mov es:[bx+di],cl  ;赋值
    mov es:[bx+di+1],al;赋颜色
				    
    inc si
    add di,2
    jmp short s
				  
 ok:pop si
    pop cx
 				  
    ret    
            

CODES ENDS
    END START













