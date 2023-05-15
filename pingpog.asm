    org 0x7c00

%define ROW 50
%define WIDTH 320 
%define HEIGHT 200

%define BALL_WIDTH 10
%define BALL_HEIGHT 10

    mov ah, 0x00
    mov al, 0x13
    int 0x10

    mov ax, 0xA000
    mov es, ax

    mov word [ball_x], 0
    mov word [ball_y], 0
    mov word [ball_dx], 1
    mov word [ball_dy], 1

main_loop:
    mov ch, 0x00
    call draw_ball

    mov ax, [ball_x]
    add ax, [ball_dx]
    mov [ball_x], ax

    mov ax, [ball_y]
    add ax, [ball_dy]
    mov [ball_y], ax

    mov ch, 0x0D
    call draw_ball

    jmp main_loop

draw_ball:

    mov word [i], 0
draw_ball_i:                  ;row
    mov word [j], 0
draw_ball_j:                  ;col

    mov ax, WIDTH
    mov bx, [i]
    add bx, [ball_x]
    mul bx
    mov bx, ax
    add bx, [j]
    add bx, [ball_y]
    mov BYTE [es: bx], ch

    inc word [j]
    cmp word [j], BALL_WIDTH
    jb draw_ball_j

    inc word [i]
    cmp word [i], BALL_HEIGHT
    jb draw_ball_i

    ret 

i: dw 0
j: dw 0

ball_x: dw 0
ball_y: dw 0
ball_dx: dw 0
ball_dy: dw 0

    times 510 - ($-$$) db 0
    dw 0xaa55
