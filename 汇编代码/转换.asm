DATAS SEGMENT
     number dw 0
   newlines db 0dh,0ah,'$';���з� �س���
   string1 db 'please enter your score:  $'
   string2 db 'a bad input:  $'
   string3 db 'please re-enter your score: $';�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX  ;DSָ��datas
    mov ah,09h;���ܺ�09h �����
    lea dx,string1
    int 21h
    call main
    mov ah,4ch
    int 21h
main proc
input:mov ah,01h
      mov bx,0
      int 21h
getnumber:;�������asciiת��Ϊʮ������ �������number��
     xor dx,dx ;��dx����
     cmp al,0dh ;�ж������ǲ��ǻ��з� �ǽ�������
     je compare
     cmp al,'0';�ж������Ƿ�Ϊ�Ƿ�����
     jc errors
     cmp al,'9'
     ja errors
     xor ah,ah ;����λ���� ִ��16λ�˷�
     push ax ;�������ַ���ջ ��λal��
     mov ax,number ;ʵ��number*10 + (al-30h) 
     mov bx,10
     mul bx
     pop bx ;��������bx�洢��bl��
     sub bl,30h
     add ax,bx
     mov number,ax
     jmp input  
compare:
     cmp number,100000;�������100 �������
     ja errors
     cmp number,0;����С��0 �������
     jc errors
     call newline;����  
output:;���ܺ�int 21h 02h ���һ���ַ�
     mov ah,02h
     mov dx,number
     int 21h
     jmp exit       

exit:;�˳�
    ret
errors:;��ӡ������Ϣ ��������
    call newline
    lea dx,string2
    mov ah,09h
    int 21h
    call newline
    mov ah,09h
    lea dx,string3
    int 21h
    mov number,0;����number
    jmp input
main endp
newline proc;����
       lea dx,newlines
       mov ah,09h
       int 21h
       ret
newline endp
CODES ENDS
    END START


