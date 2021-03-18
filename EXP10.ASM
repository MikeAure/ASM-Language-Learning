assume cs:code, ds:data, ss:stack

data segment
    db 'word',0
    db 'unix',0
    db 'wind',0
    db 'good',0
data ends

stack segment
    db 16 dup(0)
code segment

    start:
        
        mov ax, data
        mov ds, ax
        mov bx, 0

        mov cx, 4

        mov ax, stack
        mov ss, ax
        mov sp, 10h
    s:

        mov si, bx
        call capital
        add bx, 5
    loop s

        mov cx, 4
        mov dh, 8
        mov dl, 3
        mov bx, 0        

    print:

        mov si, 0
        call show_str
        inc dh
        add bx, 5
    loop print

    mov ax, 4c00h
    int 21h



    capital:

        push cx
        push si
    
    change:
        
        mov ch, 0
        mov cl, [si]
        jcxz ok
        and byte ptr [si], 11011111b
        inc si
        jmp short change

    ok:

        pop si
        pop cx
        ret



    show_str:                   ;逐行显示字符串
    
        mov ax, 0b800h  
        mov es, ax              ;保存显示区域的首地址
        push cx                 ;保存cx，便于退出函数后恢复外层循环状态
        ;push si                ;保存si
        push dx                 ;保存行号列号
        sub dh, 1               ;行号列号减一便于接下来计算显示区域的偏移量
        sub dl, 1

        mov al, 0a0h            ;计算行偏移量
        mul dh
        push ax                 ;保存行偏移量
        mov al, 2h              ;计算列偏移量
        mul dl
        pop dx                  ;恢复行偏移量，并与列偏移量累加
        add ax, dx              
        mov di, ax              ;将显示区域的总偏移量保存至变址寄存器di

    display:

        mov ch, 0               ;ch寄存器用于判断何时退出循环
        mov cl, [bx+si]         ;高8位为0，低8位为当前字符，遇0停止
        jcxz ok2
        mov al, data:[bx+si]    ;用ax准备当前要放到显示区域内存的内容
        mov ah, 00000010b       ;设置字符格式


        mov word ptr es:[di], ax    ;移至显示区域内存
        inc si                      ;指向数据区下一个字节
        add di, 2                   ;指向显示区下两个字节
        jmp short display           ;循环


    ok2:

        pop dx              ;数据恢复工作
        ;pop si
        pop cx
        ret
code ends

end start