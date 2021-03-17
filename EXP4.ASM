assume cs:code

code segment

    mov ax, 0
    mov ds, ax
    mov bx, 200h
    
    mov dx, 0
    mov cx, 40h

    s:  mov [bx], dl
        inc dl
        inc bx
        loop s
    
    mov ax, 4c00h
    int 21h

code ends

end