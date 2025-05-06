.model small
.stack 100h

.data
    prompt db 'Enter a string (max 256 chars): $'
    originalMsg db 10, 13, 'Original string: $'
    reversedMsg db 10, 13, 'Reversed string: $'
    buffer db 256 dup(?)       ; Buffer to store input
    reversed db 256 dup('$')   ; Buffer to store reversed string
    newline db 10, 13, '$'     ; For new line

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax                 ; Set ES to data segment for string operations

    ; Display prompt
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Read string from user
    mov di, offset buffer       ; DI points to buffer start
    mov cx, 256                ; Maximum characters to read
    xor bx, bx                 ; Counter for actual characters read

read_loop:
    mov ah, 01h                ; Read character function
    int 21h                    ; Character stored in AL
    
    cmp al, 13                 ; Check for Enter key (carriage return)
    je done_reading            ; If Enter, stop reading
    
    mov [di], al               ; Store character in buffer
    inc di                     ; Move to next buffer position
    inc bx                     ; Increment character count
    loop read_loop             ; Continue until CX=0 or Enter pressed

done_reading:
    mov byte ptr [di], '$'     ; Null-terminate the string

    ; Display original string message
    mov ah, 09h
    lea dx, originalMsg
    int 21h
    
    ; Display the original string
    lea dx, buffer
    int 21h

    ; Reverse the string
    mov si, offset buffer      ; SI points to start of original string
    mov di, offset reversed    ; DI points to start of reversed buffer
    add si, bx                 ; SI now points to end of original string
    dec si                     ; Adjust for 0-based index

reverse_loop:
    cmp bx, 0                  ; Check if we've processed all characters
    je done_reversing
    
    mov al, [si]               ; Get character from end of original
    mov [di], al               ; Store at beginning of reversed
    dec si                     ; Move SI backward
    inc di                     ; Move DI forward
    dec bx                     ; Decrement character counter
    jmp reverse_loop

done_reversing:
    mov byte ptr [di], '$'     ; Null-terminate the reversed string

    ; Display reversed string message
    mov ah, 09h
    lea dx, reversedMsg
    int 21h
    
    ; Display the reversed string
    lea dx, reversed
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp
end main