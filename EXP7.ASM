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
            div word ptr es:[bx].10[di]
            mov es:[bx].13[di], ax
            add bx, 10h

        loop average
    
    mov ax, 4c00h
    int 21h

    code ends

end start


        
