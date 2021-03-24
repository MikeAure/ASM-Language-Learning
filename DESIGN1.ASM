assume cs:code, ds:data, ss:stack

data segment
  db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
  db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
  db '1993','1994','1995'
  ;以上是表示21年的21个字符串

  dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140317,197514
  dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
  ;以上表示21年公司总收入的21个dword型数据

  dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
  dw 11542,14430,15257,17800
  ;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
  db 21 dup ('year summ ne ?? ')
table ends

stack segment
    db 16 dup(0)
stack ends

code segment

    start:  mov ax, data
            mov ds, ax
            mov bx, 0h
            mov ax, stack 
            mov ss, ax
            mov sp, 10h
            mov cx, 15h
            mov si, 0   ;数据数组指针
            mov ax, table
            mov es, ax  ;es为table表指针

        year:             ;将年份循环输入表中
            push cx
            mov cx, 4h  ;内层循环四次，逐字节向表公司成员所在的内存复制内容
            mov di, 0h  ;指向表中公司成员特定字节
            loop1:  
                mov al, [si]
                mov es:[bx].0[di], al
                inc si
                inc di        
            loop loop1

            pop cx
            
            add bx,10h
        loop year

        mov cx, 15h
        mov bx, 0h

        ;mov di, 0
        income:

            push cx
            mov cx, 4h  ;内层循环四次，逐字节向表公司成员所在的内存复制内容
            mov di, 0h
            loop2:

                mov al, [si]
                mov es:[bx].5[di], al
                inc si
                inc di

            loop loop2
            pop cx
            add bx, 10h

        loop income

        mov cx, 15h
        mov bx, 0h

        people:


            push cx
            mov cx, 2h  ;内层循环两次
            mov di, 0h
            loop3:

                mov al, [si]
                mov es:[bx].10[di], al
                inc si
                inc di

            loop loop3

            pop cx
            add bx, 10h
        
        loop people

        mov bx, 0h
        mov cx, 15h

        average:

            ;push cx
            ;mov cx, 40h
            mov di, 0h

            mov ax, word ptr es:[bx].5[di]
            mov dx, word ptr es:[bx].5[di+2]
            push cx
            mov cx, es:[bx].10[di]
            call divdw
            mov es:[bx].13[di], ax
            pop cx
            add bx, 10h

        loop average

        mov cx, 21
        mov bx, 0
        dispre:

            mov byte ptr es:[bx].4, 0
            mov byte ptr es:[bx].9, 0
            mov byte ptr es:[bx].12, 0
            add bx, 10h

        loop dispre
            
        mov bx, 0
        mov ax, es
        mov ds, ax
        mov cx, 21

        mov dh, 5
        mov dl, 5
        mov si, 0

        dis_year:

            push cx



            mov cx, 2

            call show_str
            inc dh
            add si, 10h

            pop cx
        
        loop dis_year

        mov bx, 0
        mov ax, data
        mov ds, ax
        mov si, 0
        mov ax, table
        mov es, ax
        mov dh, 5
        mov dl, 15
        mov cx, 21

        dis_income:

            push cx
            push dx
            mov ax, word ptr es:[bx].5
            mov dx, word ptr es:[bx].7
            call dwtoc

            pop dx
            mov cx,2
            call show_str
            inc dh
            add bx, 10h
            pop cx
        loop dis_income

        mov bx, 0
        mov ax, data
        mov ds, ax
        mov si, 0
        mov ax, table
        mov es, ax
        mov dh, 5
        mov dl, 25
        mov cx, 21

        
        dis_employee:

            push cx
            push dx
            mov ax, word ptr es:[bx].10
            mov dx, 0
            call dwtoc

            pop dx
            mov cx,2
            call show_str
            inc dh
            add bx, 10h
            pop cx
        loop dis_employee

        mov bx, 0
        mov ax, data
        mov ds, ax
        mov si, 0
        mov ax, table
        mov es, ax
        mov dh, 5
        mov dl, 35
        mov cx, 21

        
        dis_aver:

            push cx
            push dx
            mov ax, word ptr es:[bx].13
            mov dx, 0
            call dwtoc

            pop dx
            mov cx,2
            call show_str
            inc dh
            add bx, 10h
            pop cx
        loop dis_aver

    mov ax, 4c00h
    int 21h

    divdw:

        push bx
        push ax
        mov ax, dx
        mov dx, 0
        div cx
        mov bx, ax
        pop ax
        div cx
        mov cx, dx                  ;存储计算结果的余数
        mov dx,bx
        pop bx
        ret

    show_str:

        push dx                 ;保存行号列号
        push ax
        push es
        push bx
        push si
        push di
        push cx
        
    
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

    dwtoc:
        push bx
        push cx
        push ax
        push si
        push di
        mov di, 0

    ok4:

        mov cx, 10
        call divdw
        add cx, 30h
        push cx
        inc di
        cmp dx, 0       ;此处用cmp，实在不知道怎么用jcxz🤦‍
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

        mov cx, di

    sk:

        pop ds:[si]
        inc si
        loop sk

    exit_dwtoc:

        pop di
        pop si
        pop ax
        pop cx
        pop bx
        ret

    code ends

end start


        
