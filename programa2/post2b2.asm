; post2b2.asm - DAS: resta BCD empaquetada
ORG 100h

section .data
    msgOk  db "DAS OK: $"
    msgErr db "Error en resta BCD$"
    crlf   db 0Dh,0Ah,"$"

section .text
start:
    ; --- CASO 1: 73 BCD - 28 BCD = 45 BCD ---
    mov al, 73h    ; BCD "73"
    sub al, 28h    ; AL = 73h - 28h = 4Bh (No es BCD válido)
    das            ; Ajustar: AL = 45h
    
    ; Verificar si el resultado es 45h
    cmp al, 45h
    jne .error

    ; Imprimir mensaje de éxito
    mov ah, 09h
    mov dx, msgOk
    int 21h

    ; Mostrar el valor ajustado en pantalla (45)
    mov bl, al     ; Guardar resultado en BL
    call print_bcd

    ; --- CASO 2: 20 BCD - 01 BCD = 19 BCD ---
    mov al, 20h
    sub al, 01h    ; AL = 1Fh (No es BCD válido)
    das            ; Ajustar: AL = 19h

    ; Verificar si el resultado es 19h
    cmp al, 19h
    jne .error

    ; Nueva línea e imprimir segundo resultado
    mov ah, 09h
    mov dx, crlf
    int 21h
    
    mov bl, al     ; Guardar resultado en BL
    call print_bcd
    
    jmp .fin

.error:
    mov ah, 09h
    mov dx, msgErr
    int 21h

.fin:
    mov ah, 4Ch
    xor al, al
    int 21h

; --- Subrutina para imprimir AL en formato BCD ---
print_bcd:
    mov al, bl
    shr al, 4      ; Obtener nibble alto (decenas)
    add al, 30h    ; Convertir a ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    mov al, bl
    and al, 0Fh    ; Obtener nibble bajo (unidades)
    add al, 30h    ; Convertir a ASCII
    mov dl, al
    mov ah, 02h
    int 21h
    ret