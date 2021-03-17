assume cs:code, ds:data
data segment
    db 'welcome to masm!'
data ends

code segment
    start:
        mov ax, data
        mov ds, ax
        mov cx, 10h
        mov ax, 0b800h
        mov es, ax
        mov bx, 0
        mov di, 0a0h    ;将段的偏移地址设置为0a0h，作为显示屏上的第一行
                        ;不知为什么设置为0无法正常显示第一行

    loop1:

        mov al, [bx]    ;将data[bx]字节内容移动至al中
        mov ah, 00000010b   ;将字符样式设置码放入ah中
        mov word ptr es:[di], ax
        inc bx
        add di, 2

    loop loop1

    mov di, 0
    mov bx, 0
    mov cx, 10h
    mov di, 140h

    loop2:
        
        mov al, [bx]    ;将data[bx]字节内容移动至al中
        mov ah, 00100100b   ;将字符样式设置码放入ah中
        mov word ptr es:[di], ax
        inc bx
        add di, 2

    loop loop2

    mov di, 0 
    mov bx, 0
    mov cx, 10h
    mov di, 1e0h

    loop3:

        mov al, [bx]    ;将data[bx]字节内容移动至al中
        mov ah, 01110001b   ;将字符样式设置码放入ah中
        mov word ptr es:[di], ax
        inc bx
        add di, 2

    loop loop3

    mov ax, 4c00h
    int 21h

code ends
end start