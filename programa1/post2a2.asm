; post2a2.asm - SBB: resta de 32 bits
ORG 100h

section .data
    ; A = 0x00030000
    aLo dw 0000h
    aHi dw 0003h
    ; B = 0x00010001
    bLo dw 0001h
    bHi dw 0001h
    
    resLo dw 0
    resHi dw 0
    
    msg db "Resta OK: 0001:FFFFh$"
    msgErr db "Error en resta.$"

section .text

start:
    ; Cargar valores en registros
    mov ax, [aLo]   ; AX = 0000h
    mov dx, [aHi]   ; DX = 0003h
    mov bx, [bLo]   ; BX = 0001h
    mov cx, [bHi]   ; CX = 0001h

    ; --- Operación de Resta de 32 bits ---
    sub ax, bx      ; 0000h - 0001h = FFFFh. Se activa Carry Flag (CF=1) como préstamo.
    sbb dx, cx      ; 0003h - 0001h - CF(1) = 0001h.
    
    ; Guardar resultados
    mov [resLo], ax
    mov [resHi], dx
    
    ; --- Verificación del resultado esperado (0x0001FFFF) ---
    cmp ax, 0FFFFh  ; ¿Parte baja es FFFFh?
    jne .error
    cmp dx, 0001h   ; ¿Parte alta es 0001h?
    jne .error

    ; Si todo es correcto, imprimir mensaje de éxito
    mov ah, 09h
    mov dx, msg
    int 21h
    jmp .fin

.error:
    mov ah, 09h
    mov dx, msgErr
    int 21h

.fin:
    ; Terminar programa
    mov ah, 4Ch
    xor al, al
    int 21h