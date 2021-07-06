assume cs:code
code segment
mov ax, 0
push ax
popf ;将PSW置0(本章所学习的标志位都为0)
mov ax, 0fff0h
add ax, 0010h ;修改相关标志位
pushf
pop ax ;(将PSW保存至ax)
and al, 11000101B
and ah, 00001000B ;只考虑CF,PF,ZF,SF,OF五个标志位
mov ax, 4c00h
int 21h
code ends

end