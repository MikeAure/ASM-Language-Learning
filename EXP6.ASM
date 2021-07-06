assume cs:code, ds:data, ss:stack

stack segment
    dw 0,0,0,0,0,0,0,0
stack ends

data segment
  db '1. display      '
  db '2. brows        '
  db '3. replace      '
  db '4. modify       '
data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 10h

    mov bx, 0h
    mov cx, 4h

    row:
        push cx
        mov si, 3h
        mov cx, 4
        col:
            mov al, [bx+si]
            and al, 11011111b
            mov [bx+si], al
            inc si
        loop col
        pop cx
        add bx, 10h
    loop row

    mov ax, 4c00h
    int 21h
code ends

end start
