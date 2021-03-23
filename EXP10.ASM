assume cs:code, ds:data, ss:stack

data segment
    db 10 dup(0)
data ends

stack segment
    db 20h dup(0)
stack ends

code segment

    start:

        mov ax, stack
        mov ss, ax
        mov sp, 20h

        mov ax, 4f40h
        mov dx, 2
        mov cx, 10
        ;mov ds, bx
        mov si,0
        call dwtoc
        
        mov dh, 8
        mov dl, 3
        mov cl, 2
        call show_str

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



    show_str:

         push dx                 ;保存行号列号
         push ax
         push es
         push bx
         push si
         push di
         push cx
        
                         ;逐行显示字符串
    
        mov ax, 0b800h  
        mov es, ax              ;保存显示区域的首地址

        sub dh, 1               ;行号列号减一便于接下来计算显示区域q的偏移量
        sub dl, 1

        mov al, 0a0h            ;计算行偏移量
        mul dh
        push ax                 ;保存行偏移量
        mov al, 2h              ;计算列偏移量
        mul dl
        pop dx                  ;恢复行偏移量，并与列偏移量累加
        add ax, dx              
        mov di, ax              ;将显示区域的总偏移量保存至变址寄存器di
        mov ah, cl              ;将字符串格式参数保存至bl

    display:

        mov ch, 0               ;ch寄存器用于判断何时退出循环
        mov cl, [si]         ;高8位为0，低8位为当前字符，遇0停止
        jcxz ok2
        mov al, data:[si]   
        mov word ptr es:[di], ax    ;移至显示区域内存
        inc si                      ;指向数据区下一个字节
        add di, 2                   ;指向显示区下两个字节
        jmp short display           ;循环

    ok2:

        pop cx
        pop di
        pop si
        pop bx
        pop es
        pop ax
        pop dx                    ;恢复dx值，清空栈
        ret


    divdw:

        push ax
        mov ax, dx
        mov dx, 0
        div cx
        mov bx, ax
        pop ax
        div cx
        mov cx, dx                  ;存储计算结果的余数
        mov dx,bx
        ret


    dtoc:

        push si
        push ax
        push dx
        push cx
        push di
        push bx

        
        mov bx, 10

    loopl:

        mov dx, 0
        div bx
        mov cx, ax
        jcxz last
        add dx, 30h
        push dx
        inc si
        jmp short loopl

    last:

        add dx, 30h
        push dx
        inc si

        mov cx, si
        mov si, 0

    sl:
        pop ds:[si]
        inc si
        loop sl

    exit_dtoc:

        pop bx
        pop di
        pop cx
        pop dx
        pop ax
        pop si
        ret


    dwtoc:
        push bx
        push cx
        push ax
        push si

    ok4:

        mov cx, 10
        call divdw
        add cx, 30h
        push cx
        inc si
        cmp dx, 0       ;此处用cmp，实在知道怎么用jcxz
        je cmp_ax
        jmp ok4

    cmp_ax:

        cmp ax, 0
        je last2
        jmp ok4
    last2:

        ;add cx, 30h    ;用cmp就不必像dtoc那样再保存一遍
        ;push cx
        ; inc si

        mov cx, si
        mov si, 0

    sk:

        pop ds:[si]
        inc si
        loop sk

    exit_dwtoc:

        pop si
        pop ax
        pop cx
        pop bx
        ret

        
        
code ends

end start