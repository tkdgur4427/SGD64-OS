[ORG 0x00]  ; set the starting code address as 0x00
[BITS 16]   ; set the code below as 16 bits

SECTION .text   ; define text SECTION (segment)

START:
    mov ax, 0x07C0  ; set boot loader starting address as 0x07C0
    mov ds, ax      ; set DS segment reg by ax
    mov ax, 0xB800  ; set video memory starting address as 0xB800
    mov es, ax      ; put ax to es (segment reg)

    mov si, 0       ; initialize src index (char src index register) as 0

.SCREENCLEARLOOP:   ; clearing screen
    mov byte[es:si], 0      ; set character located in video memory es:si as null(0)
    mov byte[es:si+1], 0x0A ; set property value
    add si, 2               ; move next desc of video memory

    cmp si, 4000            ; total screen size = 80(char) * 25(lines)

    jl .SCREENCLEARLOOP     ; if si is less than 4000, then continue to loop

    mov si, 0   ; reset si and di (dest index)
    mov di, 0

.MESSAGELOOP:   ; print message
    mov cl, byte [si + MESSAGE1]    ; from MESSAGE1 address, copy the value of [si + MESSAGE1] to cl (general reg)
                                    ; cl is 1 byte of cx
    cmp cl, 0       ; if cl is null
    je .MESSAGEEND  ; break the loop

    mov byte[es:di], cl             ; put the value(cl) to [es:di]

    add si, 1
    add di, 2       ; move next video memory desc (2 bytes)

    jmp .MESSAGELOOP                ; looping again
.MESSAGEEND:

MESSAGE1: db 'SGD64 OS Boot Loader Start~!!', 0 ; define printed message
                                                ; set last char as 0(null) to process in .MESSAGELOOP

jmp $           ; from this point, start infinite loop

times 510 - ($ - $$) db 0x00    ; $: current line address
                                ; $$: current section (.text) starting address
                                ; $ - $$: offset based on current section
                                ; 510 - ($ - $$): from current to address 510
                                ; db 0x00: declaring 1 byte as 0x00
                                ; time: repeating exec
                                ; from current location to address 510, fill 0x00

db 0x55 ; declare 1 byte as 0x55
db 0xAA ; declare 1 byte as 0xAA
        ; address 511, 512 as 0x55 and 0xAA, indicate boot sector