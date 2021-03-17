assume ds:data, ss:stack, cs:code

data segment
    dw 0124h,0184h,0193h,0444h
data ends

stack segment
    dw 0,0,0,0,0,0,0
stack ends

code segment

start:

    mov ax, data
    mov ds, ax
    mov cx, 4
    mov bx, 0
    mov ax, stack
    mov ss, ax
    mov sp, 16
    
s:  push [bx]
    add bx,2
    loop s

    mov bx, 0
    mov cx, 8

s0: pop [bx]
    add bx, 2
    loop s0

    mov ax, 4c00h
    int 21h

code ends
end start