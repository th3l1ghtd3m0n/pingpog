    org 0x7c00
%define WIDTH 320 
%define HEIGHT 200

%define COLOR_BLACK 0
%define COLOR_BLUE 1
%define COLOR_GREEN 2
%define COLOR_CYAN 3
%define COLOR_RED 4
%define COLOR_MAGENTA 5
%define COLOR_BROWN 6
%define COLOR_LIGHTGRAY 7
%define COLOR_DARKGRAY 8
%define COLOR_LIGHTBLUE 9
%define COLOR_LIGHTGREEN 10
%define COLOR_LIGHTCYAN 11
%define COLOR_LIGHTRED 12
%define COLOR_LIGHTMAGENTA 13
%define COLOR_YELLOW 14
%define COLOR_WHITE 15

%define BACKGROUND_COLOR COLOR_BLACK
%define BALL_WIDTH 10
%define BALL_HEIGHT 10


    mov ah, 0x00
    mov al, 0x13
    int 0x10

    mov ch, BACKGROUND_COLOR
    call fill_screen

    xor ax, ax
    mov es, ax
    mov word [es:0x0070], draw_frame
    mov word [es:0x0072], 0x00

    jmp $

draw_frame:
    pusha

    mov ax, 0x0000
    mov ds, ax

    mov ax, 0xA000
    mov es, ax

    mov ch, BACKGROUND_COLOR
    call draw_ball

    cmp word [ball_x], 0
    jle .neg_dx

    cmp word [ball_x], WIDTH - BALL_WIDTH
    jge .neg_dx

    jmp .horcol_end
.neg_dx:
    neg word [ball_dx]
.horcol_end:

    cmp word [ball_y], 0
    jle .neg_dy

    cmp word [ball_y], HEIGHT - BALL_HEIGHT
    jge .neg_dy

    jmp .vercol_end
.neg_dy:
    neg word [ball_dy]
.vercol_end:

    mov ax, [ball_x]
    add ax, [ball_dx]
    mov [ball_x], ax

    mov ax, [ball_y]
    add ax, [ball_dy]
    mov [ball_y], ax

    mov ch, 0x0D
    call draw_ball

    popa
    iret

fill_screen:
    pusha

    mov ax, 0xA000
    mov es, ax

    xor bx, bx
.loop
    mov BYTE [es:bx], ch
    inc bx
    cmp bx, WIDTH * HEIGHT
    jb .loop

    popa
    ret

draw_ball:

    mov ax, 0x0000
    mov ds, ax

    mov word [y], 0
.y:
    mov word [x], 0
.x:
    mov ax, WIDTH
    mov bx, [y]
    add bx, [ball_y]
    mul bx
    mov bx, ax
    add bx, [x]
    add bx, [ball_x]
    mov BYTE [es: bx], ch

    inc word [x]
    cmp word [x], BALL_WIDTH
    jb .x

    inc word [y]
    cmp word [y], BALL_HEIGHT
    jb .y

    ret 

x: dw 0xcccc
y: dw 0xcccc

ball_x: dw 30
ball_y: dw 30
ball_dx: dw 2
ball_dy: dw (-2)

    times 510 - ($-$$) db 0
    dw 0xaa55
