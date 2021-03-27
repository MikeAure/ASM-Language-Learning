assume cs:code, ds:data, ss:stack


data segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

stack segment
    db 20h dup(0)
stack ends

code segment
    start:

        mov ax, stack
        mov ss, ax
        mov sp, 20h
        mov ax, data
        mov ds, ax
        mov si, 0
        call letterc
        mov dl, 3
        mov dh, 8
        mov cl, 2
        call show_str
        mov ax, 4c00h
        int 21h
        

    
    letterc:
        push cx
        push si
    
    ex_letterc:

        mov cl, [si]
        mov ch, 0
        jcxz end_letterc
        cmp cl, 61H
        jnb judge2
        inc si
        jmp ex_letterc

    judge2:

        cmp cl, 7ah
        jna upper
        inc si
        jmp ex_letterc

    upper:

        and byte ptr[si], 11011111b
        inc si
        jmp short ex_letterc

    end_letterc:

        pop si
        pop cx
        ret


    show_str:

        push cx
        push dx
        push bx
        push si
        push es
        push di
        

        mov ax, 0b800h
        mov es, ax
        dec dh
        dec dl

        mov al, 160
        mul dh
        push ax
        mov al, 2
        mul dl
        pop dx
        add ax, dx
        mov di, ax       
        mov ah, cl

    display:

        mov ch, 0
        mov cl, [si]
        jcxz end_show_str
        mov al, [si]
        mov word ptr es:[di], ax
        inc si
        add di, 2
        jmp short display

    end_show_str:

        pop di
        pop es
        pop si
        pop bx
        pop dx
        pop cx
        ret





code ends
end start