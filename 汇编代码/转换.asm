DATAS SEGMENT
     number dw 0
   newlines db 0dh,0ah,'$';换行符 回车符
   string1 db 'please enter your score:  $'
   string2 db 'a bad input:  $'
   string3 db 'please re-enter your score: $';此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX  ;DS指向datas
    mov ah,09h;功能号09h 输出串
    lea dx,string1
    int 21h
    call main
    mov ah,4ch
    int 21h
main proc
input:mov ah,01h
      mov bx,0
      int 21h
getnumber:;将输入的ascii转化为十进制数 结果放在number中
     xor dx,dx ;将dx清零
     cmp al,0dh ;判断输入是不是换行符 是结束输入
     je compare
     cmp al,'0';判断输入是否为非法输入
     jc errors
     cmp al,'9'
     ja errors
     xor ah,ah ;将高位清理 执行16位乘法
     push ax ;将输入字符入栈 低位al中
     mov ax,number ;实现number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;将输入用bx存储在bl中
     sub bl,30h
     add ax,bx
     mov number,ax
     jmp input  
compare:
     cmp number,100000;输入大于100 输出错误
     ja errors
     cmp number,0;输入小于0 输出错误
     jc errors
     call newline;换行  
output:;功能号int 21h 02h 输出一个字符
     mov ah,02h
     mov dx,number
     int 21h
     jmp exit       

exit:;退出
    ret
errors:;打印错误信息 重新输入
    call newline
    lea dx,string2
    mov ah,09h
    int 21h
    call newline
    mov ah,09h
    lea dx,string3
    int 21h
    mov number,0;重置number
    jmp input
main endp
newline proc;换行
       lea dx,newlines
       mov ah,09h
       int 21h
       ret
newline endp
CODES ENDS
    END START


