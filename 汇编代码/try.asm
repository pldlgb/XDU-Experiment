DATAS SEGMENT
    db "I Love You",$;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov dx,0
    mov ah,9
    int 21h
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

