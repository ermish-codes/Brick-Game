; TEAM: Ermish, Sawaira, Hanzala, Ahmed
; Se-C
; Project: Brick Breakers 
; Iteration 2

.MODEL SMALL
.STACK 100h

.DATA
    char_color   DB         0
    paddle_x     DW         125
    paddle_y     DW         185
    paddle_width DW         70
    paddle_old_x DW         125
    paddle_speed DW         14

    ; Ball variables
    ball_x       DW         155
    ball_y       DW         170
    ball_dx      DW         1
    ball_dy      DW         -1
    ball_speed   DW         6
    ball_launched DB        0

    ; Brick state: 5 rows x 15 cols, 1 = alive 0 = dead
    brick_state  DB         75 DUP(1)

    lives_count DW         3
    score       DW         0

    font_table LABEL BYTE
        DB         00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 00000000b    ; space 0
        DB         00110000b, 01111000b, 11001100b, 11001100b, 11111100b, 11001100b, 11001100b, 00000000b    ; A 1
        DB         11111100b, 11000110b, 11000110b, 11111100b, 11000110b, 11000110b, 11111100b, 00000000b    ; B 2
        DB         01111000b, 11001100b, 11000000b, 11000000b, 11000000b, 11001100b, 01111000b, 00000000b    ; C 3
        DB         11111000b, 11001100b, 11001100b, 11001100b, 11001100b, 11001100b, 11111000b, 00000000b    ; D 4
        DB         11111100b, 11000000b, 11111000b, 11000000b, 11000000b, 11000000b, 11111100b, 00000000b    ; E 5
        DB         11111100b, 11000000b, 11111000b, 11000000b, 11000000b, 11000000b, 11000000b, 00000000b    ; F 6
        DB         01111000b, 11001100b, 11000000b, 11011100b, 11001100b, 11001100b, 01111000b, 00000000b    ; G 7
        DB         11001100b, 11001100b, 11111100b, 11001100b, 11001100b, 11001100b, 11001100b, 00000000b    ; H 8
        DB         11111100b, 00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 11111100b, 00000000b    ; I 9
        DB         00111100b, 00011000b, 00011000b, 00011000b, 11011000b, 11011000b, 01110000b, 00000000b    ; J 10
        DB         11001100b, 11011000b, 11110000b, 11100000b, 11110000b, 11011000b, 11001100b, 00000000b    ; K 11
        DB         11000000b, 11000000b, 11000000b, 11000000b, 11000000b, 11000000b, 11111100b, 00000000b    ; L 12
        DB         11000110b, 11101110b, 11111110b, 11010110b, 11000110b, 11000110b, 11000110b, 00000000b    ; M 13
        DB         11001100b, 11101100b, 11111100b, 11011100b, 11001100b, 11001100b, 11001100b, 00000000b    ; N 14
        DB         01111000b, 11001100b, 11001100b, 11001100b, 11001100b, 11001100b, 01111000b, 00000000b    ; O 15
        DB         11111100b, 11001100b, 11001100b, 11111100b, 11000000b, 11000000b, 11000000b, 00000000b    ; P 16
        DB         01111000b, 11001100b, 11001100b, 11001100b, 11011100b, 11001100b, 01111010b, 00000000b    ; Q 17
        DB         11111100b, 11001100b, 11001100b, 11111100b, 11011000b, 11001100b, 11001100b, 00000000b    ; R 18
        DB         01111000b, 11001100b, 11000000b, 01111000b, 00001100b, 11001100b, 01111000b, 00000000b    ; S 19
        DB         11111100b, 00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00000000b    ; T 20
        DB         11001100b, 11001100b, 11001100b, 11001100b, 11001100b, 11001100b, 01111000b, 00000000b    ; U 21
        DB         11001100b, 11001100b, 11001100b, 11001100b, 11001100b, 01111000b, 00110000b, 00000000b    ; V 22
        DB         11000110b, 11000110b, 11010110b, 11010110b, 11111110b, 11101110b, 11000110b, 00000000b    ; W 23
        DB         11001100b, 11001100b, 01111000b, 00110000b, 01111000b, 11001100b, 11001100b, 00000000b    ; X 24
        DB         11001100b, 11001100b, 11001100b, 01111000b, 00110000b, 00110000b, 00110000b, 00000000b    ; Y 25
        DB         11111100b, 00001100b, 00011000b, 00110000b, 01100000b, 11000000b, 11111100b, 00000000b    ; Z 26
        DB         00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00000000b    ; | 27
        DB         00000000b, 00000000b, 00000000b, 11111100b, 00000000b, 00000000b, 00000000b, 00000000b    ; - 28
        DB         00000000b, 01100000b, 00110000b, 00011000b, 00110000b, 01100000b, 00000000b, 00000000b    ; > 29
        DB         00000000b, 00000000b, 00110000b, 00000000b, 00110000b, 00000000b, 00000000b, 00000000b    ; : 30
        DB         00110000b, 00110000b, 00110000b, 00110000b, 00110000b, 00000000b, 00110000b, 00000000b    ; ! 31
        DB         00110000b, 01110000b, 00110000b, 00110000b, 00110000b, 00110000b, 11111100b, 00000000b    ; 1 32
        DB         01111000b, 11001100b, 00001100b, 00111000b, 01100000b, 11000000b, 11111100b, 00000000b    ; 2 33
        DB         01111000b, 11001100b, 00001100b, 00111000b, 00001100b, 11001100b, 01111000b, 00000000b    ; 3 34
        DB         00011000b, 00111000b, 01011000b, 10011000b, 11111100b, 00011000b, 00011000b, 00000000b    ; 4 35
        DB         11111100b, 11000000b, 11111000b, 00001100b, 00001100b, 11001100b, 01111000b, 00000000b    ; 5 36
        DB         00000000b, 00000110b, 00001100b, 00011000b, 00110000b, 01100000b, 00000000b, 00000000b    ; / 37
        DB         00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 00110000b, 00110000b, 00000000b    ; . 38
        DB         00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 00000000b, 11111100b, 00000000b    ; _ 39
        DB         01111000b, 11001100b, 11011100b, 11101100b, 11001100b, 11001100b, 01111000b, 00000000b    ; 0 40
        DB         00111000b, 01100000b, 11000000b, 11111000b, 11001100b, 11001100b, 01111000b, 00000000b    ; 6 41
        DB         11111100b, 00001100b, 00011000b, 00110000b, 01100000b, 01100000b, 01100000b, 00000000b    ; 7 42
        DB         01111000b, 11001100b, 11001100b, 01111000b, 11001100b, 11001100b, 01111000b, 00000000b    ; 8 43
        DB         01111000b, 11001100b, 11001100b, 01111100b, 00001100b, 00011000b, 01110000b, 00000000b    ; 9 44
        DB         01100110b, 11111111b, 11111111b, 11111111b, 01111110b, 00111100b, 00011000b, 00000000b    ; heart 45
        DB         00000000b, 00010000b, 00111000b, 01111100b, 00111000b, 00010000b, 00000000b, 00000000b    ; diamond 46
        DB         00111100b, 01111110b, 11111111b, 11111111b, 11111111b, 01111110b, 00111100b, 00000000b    ; circle 47

    title_br     DB         'BRICK BREAKERS', 0
    prompt_msg   DB         'press any key to continue', 0
    team_names   DB         ' Ermish  Sawaira  Ahmed  Hanzala | SE-C', 0

    ; name input screen variables
    name_label   DB         'Enter Your Name:', 0
    name_buf     DB         21 DUP(0)
    name_len     DW         0
    instr_msg    DB         'enter to continue | backspace to remove', 0
    name_stored  DB         21 DUP(0)

    ; menu screen variables
    menu_title   DB         'MAIN MENU', 0
    opt1_txt     DB         '1 - START GAME', 0
    opt2_txt     DB         '2 - INSTRUCTIONS', 0
    opt3_txt     DB         '3 - HIGH SCORES', 0
    opt4_txt     DB         '4 - EXIT', 0
    menu_nav     DB         'Use UP/DOWN and ENTER', 0
    selected_opt DW         1
    old_selected DW         1
    ball_mx      DW         286
    ball_my      DW         150
    ball_mdx     DW         0
    ball_mdy     DW         -1

    ; instruction screen variables
    instr_title  DB         'HOW TO PLAY', 0
    page1_txt    DB         '(1/2)', 0
    page2_txt    DB         '(2/2)', 0
    more_txt     DB         'PRESS ENTER FOR MORE >>', 0
    back_txt     DB         'ESC-Back', 0
    esc_p2_txt   DB         'ENTER for page 1 ->', 0
    ctrl_head    DB         'CONTROLS', 0
    obj_head     DB         'OBJECTIVE', 0
    lives_head   DB         'LIVES', 0
    bonus_head   DB         'BONUSES', 0
    key_head     DB         'KEYS', 0
    move_head    DB         'MOVEMENTS', 0
    key_left     DB         '<- / A', 0
    key_right    DB         '-> / D', 0
    key_space    DB         'SPACE', 0
    move_left    DB         'Move Paddle Left', 0
    move_right   DB         'Move Paddle Right', 0
    move_space   DB         'To Bounce the Ball', 0
    obj_l1       DB         'Break all bricks to advance!', 0
    lives_l1     DB         'You start with 3 lives.', 0
    lives_l2     DB         'Losing the ball costs one life.', 0
    bonus_l1     DB         'Catch falling items from bricks:', 0
    color_head   DB         'COLOR', 0
    effect_head  DB         'EFFECT', 0
    b_cyan       DB         'Cyan', 0
    b_red        DB         'Red', 0
    b_green      DB         'Green', 0
    b_yellow     DB         'Yellow', 0
    b_purple     DB         'Purple', 0
    b_cyan_eff   DB         'Slow Ball', 0
    b_red_eff    DB         'Fast Ball', 0
    b_green_eff  DB         '+1 Life', 0
    b_yellow_eff DB         'Wide Pad', 0
    b_purple_eff DB         'Narrow Pad', 0
    bonus_note   DB         'Only one bonus active at a time', 0
    return_msg   DB         'Press any key or ESC to return', 0

    ; high score screen variables
    hs_title     DB         'HIGH SCORES', 0
    hs_hdr       DB         '  NAME          SCORE    RANK', 0
    hs1_name     DB         'AHSAN', 0
    hs1_score    DB         '9800', 0
    hs1_rank     DB         '1', 0
    hs2_name     DB         'ALI', 0
    hs2_score    DB         '8700', 0
    hs2_rank     DB         '2', 0
    hs3_name     DB         'SARIM', 0
    hs3_score    DB         '7500', 0
    hs3_rank     DB         '3', 0
    hs4_name     DB         'HAMZA', 0
    hs4_score    DB         '7500', 0
    hs4_rank     DB         '3', 0
    hs5_name     DB         'SANA', 0
    hs5_score    DB         '6000', 0
    hs5_rank     DB         '5', 0

    ; game screen variables
    gs_scoreDisplayStr     DB         'SCORE: 0000', 0
    gs_livesDisplayStr     DB         'LIVES:', 0
    gs_levelDisplayStr     DB         'LEVEL: 01', 0
    gs_player    DB         'PLAYER:', 0
    gs_name      DB         21 DUP(0)



           ; Game Over screen variables
    go_title_str DB         'G A M E   O V E R', 0
    go_score_lbl DB         'Final Score   : ', 0
    go_level_lbl DB         'Level Reached : ', 0
    go_bricks_lbl DB        'Bricks Left   : ', 0
    go_lives_lbl DB         'Lives Remaining : ', 0
    go_opt1      DB         '[ ENTER ]  Restart Game', 0
    go_opt2      DB         '[ ESC ]    Main Menu', 0
        ; Game state
    game_running DB         0
    temp_str     DB         10 DUP(0)
.CODE

main PROC
    mov   ax, @data
    mov   ds, ax
    mov   es, ax
    mov   ax, 0013h
    int   10h
    call  HomeScreen
    call  NameInputScreen
    call  MainMenuScreen
    mov   ax, 0003h
    int   10h
    mov   ah, 4Ch
    int   21h
main ENDP

; ============================================================
; HOME SCREEN
; ============================================================
HomeScreen PROC
    mov   al, 00h
    call  FillScreen
    call  DrawBricks
    mov   bx, 104-6
    mov   dx, 80-6
    mov   si, 112+12
    mov   di, 8+12
    mov   al, 03h
    call  DrawRect
    mov   bx, 104-6-2
    mov   dx, 80-6-2
    mov   si, 112+12+4
    mov   di, 8+12+4
    mov   al, 03h
    call  DrawRect
    mov   ch, 0Dh
    mov   bx, 13*8
    mov   dx, 10*8
    mov   si, OFFSET title_br
    call  DrawString
    mov   ch, 05h
    mov   bx, 7*8
    mov   dx, 15*8
    mov   si, OFFSET prompt_msg
    call  DrawString
    mov   bx, 10
    mov   dx, 180
    mov   cx, 300
    mov   al, 08h
    call  DrawHLine
    mov   ch, 08h
    mov   bx, 0
    mov   dx, 23*8
    mov   si, OFFSET team_names
    call  DrawString
    mov   ah, 00h
    int   16h
    ret
HomeScreen ENDP

; ============================================================
; NAME INPUT SCREEN
; ============================================================
NameInputScreen PROC
    mov   al, 00h
    call  FillScreen
    call  DrawBricks
    mov   bx, 0
    mov   dx, 50
    mov   cx, 320
    mov   al, 05h
    call  DrawHLine
    mov   ch, 0Dh
    mov   bx, 13*8
    mov   dx, 8*8
    mov   si, OFFSET title_br
    call  DrawString
    mov   bx, 0
    mov   dx, 80
    mov   cx, 320
    mov   al, 01h
    call  DrawHLine
    mov   ch, 0Dh
    mov   bx, 10*10
    mov   dx, 13*8
    mov   si, OFFSET name_label
    call  DrawString
    mov   bx, 80
    mov   dx, 118
    mov   si, 160
    mov   di, 14
    mov   al, 05h
    call  DrawRect
    mov   bx, 81
    mov   dx, 119
    mov   si, 158
    mov   di, 12
    mov   al, 00h
    call  FillRect
    mov   bx, 0
    mov   dx, 175
    mov   cx, 320
    mov   al, 08h
    call  DrawHLine
    mov   ch, 08h
    mov   bx, 4
    mov   dx, 184
    mov   si, OFFSET instr_msg
    call  DrawString
    mov   name_len, 0
    mov   cx, 21
    mov   si, OFFSET name_buf

    nis_clear:
        mov   BYTE PTR [si], 0
        inc   si
        loop  nis_clear
        call  UpdateInputDisplay

    nis_loop:
        mov   ah, 00h
        int   16h
        cmp   al, 13
        je    nis_done
        cmp   al, 8
        je    nis_back
        cmp   name_len, 20
        jae   nis_loop
        mov   si, name_len
        mov   name_buf[si], al
        inc   name_len
        call  UpdateInputDisplay
        jmp   nis_loop
    nis_back:
        cmp   name_len, 0
        je    nis_loop
        dec   name_len
        mov   si, name_len
        mov   name_buf[si], 0
        call  UpdateInputDisplay
        jmp   nis_loop
    nis_done:
   
        cmp   name_len, 0      ; Check if name is empty
        je    nis_loop         ; If empty, go back to input loop
        
        mov   cx, name_len
        cmp   cx, 0
        je    nis_empty
     
    
        mov   si, OFFSET name_buf
        mov   di, OFFSET name_stored
    nis_copy:
        mov   al, [si]
        mov   [di], al
        inc   si
        inc   di
        loop  nis_copy
        mov   BYTE PTR [di], 0
        jmp   nis_copy_g
    nis_empty:
        mov   BYTE PTR [name_stored], 0
    nis_copy_g:
        mov   cx, name_len
        cmp   cx, 0
        je    nis_empty_g
        mov   si, OFFSET name_buf
        mov   di, OFFSET gs_name
    nis_copy2:
        mov   al, [si]
        mov   [di], al
        inc   si
        inc   di
        loop  nis_copy2
        mov   BYTE PTR [di], 0
        jmp   nis_ret
    nis_empty_g:
        mov   BYTE PTR [gs_name], 0
    nis_ret:
        ret
NameInputScreen ENDP

; ============================================================
; UPDATE INPUT DISPLAY
; ============================================================
UpdateInputDisplay PROC
    mov   bx, 81
    mov   dx, 119
    mov   si, 158
    mov   di, 12
    mov   al, 00h
    call  FillRect
    mov   ch, 0Fh
    mov   bx, 11*8
    mov   dx, 15*8
    mov   si, OFFSET name_buf
    call  DrawString
    ret
UpdateInputDisplay ENDP

; ============================================================
; MAIN MENU SCREEN
; ============================================================
MainMenuScreen PROC
    mov   ball_mx, 286
    mov   ball_my, 150
    mov   ball_mdx, 0
    mov   ball_mdy, -1
    mov   selected_opt, 1
    mov   old_selected, 1
    call  DrawMainMenuStatic
    menu_loop:
        call  AnimateMenuBall
        mov   ah, 01h
        int   16h
        jz    menu_loop
        mov   ah, 00h
        int   16h
        cmp   ah, 48h
        je    menu_up
        cmp   ah, 50h
        je    menu_down
        cmp   al, 13
        je    menu_select
        cmp   al, 27
        je    menu_exit
        jmp   menu_loop
    menu_up:
        cmp   selected_opt, 1
        je    menu_loop
        mov   ax, selected_opt
        mov   old_selected, ax
        dec   selected_opt
        call  RedrawMenuHighlight
        jmp   menu_loop
    menu_down:
        cmp   selected_opt, 4
        je    menu_loop
        mov   ax, selected_opt
        mov   old_selected, ax
        inc   selected_opt
        call  RedrawMenuHighlight
        jmp   menu_loop
    menu_select:
        cmp   selected_opt, 1
        je    ms_game
        cmp   selected_opt, 2
        je    ms_instr
        cmp   selected_opt, 3
        je    ms_hs
        cmp   selected_opt, 4
        je    menu_exit
        jmp   menu_loop
    ms_game:
        call  GameScreenLayout
        call  DrawMainMenuStatic
        jmp   menu_loop
    ms_instr:
        call  InstructionsScreen
        call  DrawMainMenuStatic
        jmp   menu_loop
    ms_hs:
        call  HighScoreScreen
        call  DrawMainMenuStatic
        jmp   menu_loop
    menu_exit:
        ret
MainMenuScreen ENDP

; ============================================================
; DRAW MAIN MENU STATIC
; ============================================================
DrawMainMenuStatic PROC
    mov   al, 00h
    call  FillScreen
    call  DrawNeonFrame
    mov   ch, 0Dh
    mov   bx, 14*8
    mov   dx, 3*8
    mov   si, OFFSET menu_title
    call  DrawString
    mov   bx, 12*8
    mov   dx, 4*8+6
    mov   cx, 96
    mov   al, 05h
    call  DrawHLine
    mov   old_selected, 0
    call  DrawAllMenuOpts
    mov   ch, 05h
    mov   bx, 8*8
    mov   dx, 22*8
    mov   si, OFFSET menu_nav
    call  DrawString
    mov   bx, 262
    mov   dx, 174
    mov   si, 38
    mov   di, 6
    mov   al, 0Fh
    call  FillRect
    ret
DrawMainMenuStatic ENDP

; ============================================================
; DRAW ALL MENU OPTIONS
; ============================================================
DrawAllMenuOpts PROC
        mov   bx, 10*8
        mov   dx, 7*8
        mov   si, OFFSET opt1_txt
        cmp   selected_opt, 1
        jne   dao1
        mov   ch, 0Dh
        jmp   dao1d
    dao1:
        mov   ch, 0Fh
    dao1d:
        call  DrawString
        mov   bx, 10*8
        mov   dx, 9*8
        mov   si, OFFSET opt2_txt
        cmp   selected_opt, 2
        jne   dao2
        mov   ch, 0Dh
        jmp   dao2d
    dao2:
        mov   ch, 0Fh
    dao2d:
        call  DrawString
        mov   bx, 10*8
        mov   dx, 11*8
        mov   si, OFFSET opt3_txt
        cmp   selected_opt, 3
        jne   dao3
        mov   ch, 0Dh
        jmp   dao3d
    dao3:
        mov   ch, 0Fh
    dao3d:
        call  DrawString
        mov   bx, 10*8
        mov   dx, 13*8
        mov   si, OFFSET opt4_txt
        cmp   selected_opt, 4
        jne   dao4
        mov   ch, 0Dh
        jmp   dao4d
    dao4:
        mov   ch, 0Fh
    dao4d:
        call  DrawString
        ret
DrawAllMenuOpts ENDP

; ============================================================
; REDRAW MENU HIGHLIGHT
; ============================================================
RedrawMenuHighlight PROC
        mov   bx, 10*8
        mov   ax, old_selected
        cmp   ax, 1
        je    rmh_y1
        cmp   ax, 2
        je    rmh_y2
        cmp   ax, 3
        je    rmh_y3
        mov   dx, 13*8
        mov   si, OFFSET opt4_txt
        jmp   rmh_clear
    rmh_y1:
        mov   dx, 7*8
        mov   si, OFFSET opt1_txt
        jmp   rmh_clear
    rmh_y2:
        mov   dx, 9*8
        mov   si, OFFSET opt2_txt
        jmp   rmh_clear
    rmh_y3:
        mov   dx, 11*8
        mov   si, OFFSET opt3_txt
    rmh_clear:
        mov   ch, 0Fh
        call  DrawMenuTextAt
        mov   bx, 10*8
        mov   ax, selected_opt
        cmp   ax, 1
        je    rmh_n1
        cmp   ax, 2
        je    rmh_n2
        cmp   ax, 3
        je    rmh_n3
        mov   dx, 13*8
        mov   si, OFFSET opt4_txt
        jmp   rmh_draw
    rmh_n1:
        mov   dx, 7*8
        mov   si, OFFSET opt1_txt
        jmp   rmh_draw
    rmh_n2:
        mov   dx, 9*8
        mov   si, OFFSET opt2_txt
        jmp   rmh_draw
    rmh_n3:
        mov   dx, 11*8
        mov   si, OFFSET opt3_txt
    rmh_draw:
        mov   ch, 0Dh
        call  DrawMenuTextAt
        ret
RedrawMenuHighlight ENDP

; ============================================================
; DRAW MENU TEXT AT
; ============================================================
DrawMenuTextAt PROC
        push  bx
        sub   bx, 12
        cmp   ch, 0Dh
        jne   dmt_noarr
        mov   al, '>'
        call  DrawChar
        jmp   dmt_arrow_done
    dmt_noarr:
        push  ax
        push  si
        push  di
        mov   al, 00h
        mov   si, 8
        mov   di, 8
        call  FillRect
        pop   di
        pop   si
        pop   ax
    dmt_arrow_done:
        pop   bx
        call  DrawString
        ret
DrawMenuTextAt ENDP

; ============================================================
; ANIMATE MENU BALL
; ============================================================
AnimateMenuBall PROC
        mov   bx, ball_mx
        mov   dx, ball_my
        mov   si, 6
        mov   di, 6
        mov   al, 00h
        call  FillRect
        mov   ax, ball_mdy
        add   ball_my, ax
        cmp   ball_my, 12
        jg    amb_y1
        neg   ball_mdy
        mov   ball_my, 12
    amb_y1:
        cmp   ball_my, 166
        jl    amb_y2
        neg   ball_mdy
        mov   ball_my, 166
    amb_y2:
        mov   bx, ball_mx
        mov   dx, ball_my
        mov   si, 6
        mov   di, 6
        mov   al, 05h
        call  FillRect
        call  MediumDelay
        ret
AnimateMenuBall ENDP

; ============================================================
; INSTRUCTIONS SCREEN
; ============================================================
InstructionsScreen PROC
    ins_page1:
        mov   al, 00h
        call  FillScreen
        call  DrawNeonFrame
        mov   ch, 0Dh
        mov   bx, 13*8
        mov   dx, 2*8
        mov   si, OFFSET instr_title
        call  DrawString
        mov   ch, 07h
        mov   bx, 33*8
        mov   dx, 2*8
        mov   si, OFFSET page1_txt
        call  DrawString
        mov   bx, 10*8
        mov   dx, 3*8+4
        mov   cx, 128
        mov   al, 05h
        call  DrawHLine
        mov   ch, 0Dh
        mov   bx, 16*8
        mov   dx, 5*8
        mov   si, OFFSET ctrl_head
        call  DrawString
        mov   bx, 28
        mov   dx, 50
        mov   cx, 264
        mov   al, 05h
        call  DrawHLine
        mov   bx, 28
        mov   dx, 98
        mov   cx, 264
        mov   al, 05h
        call  DrawHLine
        mov   bx, 140
        mov   dx, 50
        mov   cx, 48
        mov   al, 05h
        call  DrawVLine
        mov   bx, 28
        mov   dx, 62
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Dh
        mov   bx, 6*8
        mov   dx, 53
        mov   si, OFFSET key_head
        call  DrawString
        mov   ch, 0Dh
        mov   bx, 21*8
        mov   dx, 53
        mov   si, OFFSET move_head
        call  DrawString
        mov   bx, 28
        mov   dx, 74
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Fh
        mov   bx, 6*8
        mov   dx, 65
        mov   si, OFFSET key_left
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 21*8
        mov   dx, 65
        mov   si, OFFSET move_left
        call  DrawString
        mov   bx, 28
        mov   dx, 86
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Fh
        mov   bx, 6*8
        mov   dx, 77
        mov   si, OFFSET key_right
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 21*8
        mov   dx, 77
        mov   si, OFFSET move_right
        call  DrawString
        mov   bx, 28
        mov   dx, 98
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Fh
        mov   bx, 6*8
        mov   dx, 89
        mov   si, OFFSET key_space
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 21*8
        mov   dx, 89
        mov   si, OFFSET move_space
        call  DrawString
        mov   ch, 0Dh
        mov   bx, 16*8
        mov   dx, 13*8+4
        mov   si, OFFSET obj_head
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 4*8
        mov   dx, 14*8+6
        mov   si, OFFSET obj_l1
        call  DrawString
        mov   ch, 0Dh
        mov   bx, 17*8
        mov   dx, 16*8+4
        mov   si, OFFSET lives_head
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 4*8
        mov   dx, 17*8+6
        mov   si, OFFSET lives_l1
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 4*8
        mov   dx, 18*8+6
        mov   si, OFFSET lives_l2
        call  DrawString
        mov   bx, 7
        mov   dx, 182
        mov   cx, 306
        mov   al, 05h
        call  DrawHLine
        mov   bx, 7
        mov   dx, 183
        mov   si, 306
        mov   di, 9
        mov   al, 05h
        call  FillRect
        mov   ch, 07h
        mov   bx, 3*8
        mov   dx, 184
        mov   si, OFFSET back_txt
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 16*8
        mov   dx, 184
        mov   si, OFFSET more_txt
        call  DrawString
    ins_p1_wait:
        mov   ah, 00h
        int   16h
        cmp   al, 13
        je    ins_page2
        cmp   al, 27
        je    ins_exit
        jmp   ins_p1_wait
    ins_page2:
        mov   al, 00h
        call  FillScreen
        call  DrawNeonFrame
        mov   ch, 0Dh
        mov   bx, 13*8
        mov   dx, 2*8
        mov   si, OFFSET instr_title
        call  DrawString
        mov   ch, 07h
        mov   bx, 33*8
        mov   dx, 2*8
        mov   si, OFFSET page2_txt
        call  DrawString
        mov   bx, 10*8
        mov   dx, 3*8+4
        mov   cx, 128
        mov   al, 05h
        call  DrawHLine
        mov   ch, 0Dh
        mov   bx, 16*8
        mov   dx, 5*8
        mov   si, OFFSET bonus_head
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 4*8
        mov   dx, 6*8+4
        mov   si, OFFSET bonus_l1
        call  DrawString
        mov   bx, 28
        mov   dx, 64
        mov   cx, 264
        mov   al, 05h
        call  DrawHLine
        mov   bx, 28
        mov   dx, 136
        mov   cx, 264
        mov   al, 05h
        call  DrawHLine
        mov   bx, 130
        mov   dx, 64
        mov   cx, 72
        mov   al, 05h
        call  DrawVLine
        mov   bx, 28
        mov   dx, 76
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Dh
        mov   bx, 6*8
        mov   dx, 67
        mov   si, OFFSET color_head
        call  DrawString
        mov   ch, 0Dh
        mov   bx, 20*8
        mov   dx, 67
        mov   si, OFFSET effect_head
        call  DrawString
        mov   bx, 28
        mov   dx, 88
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Bh
        mov   bx, 6*8
        mov   dx, 79
        mov   si, OFFSET b_cyan
        call  DrawString
        mov   ch, 0Bh
        mov   bx, 20*8
        mov   dx, 79
        mov   si, OFFSET b_cyan_eff
        call  DrawString
        mov   bx, 28
        mov   dx, 100
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Ch
        mov   bx, 6*8
        mov   dx, 91
        mov   si, OFFSET b_red
        call  DrawString
        mov   ch, 0Ch
        mov   bx, 20*8
        mov   dx, 91
        mov   si, OFFSET b_red_eff
        call  DrawString
        mov   bx, 28
        mov   dx, 112
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Ah
        mov   bx, 6*8
        mov   dx, 103
        mov   si, OFFSET b_green
        call  DrawString
        mov   ch, 0Ah
        mov   bx, 20*8
        mov   dx, 103
        mov   si, OFFSET b_green_eff
        call  DrawString
        mov   bx, 28
        mov   dx, 124
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Eh
        mov   bx, 6*8
        mov   dx, 115
        mov   si, OFFSET b_yellow
        call  DrawString
        mov   ch, 0Eh
        mov   bx, 20*8
        mov   dx, 115
        mov   si, OFFSET b_yellow_eff
        call  DrawString
        mov   bx, 28
        mov   dx, 136
        mov   cx, 264
        mov   al, 01h
        call  DrawHLine
        mov   ch, 0Dh
        mov   bx, 6*8
        mov   dx, 127
        mov   si, OFFSET b_purple
        call  DrawString
        mov   ch, 0Dh
        mov   bx, 20*8
        mov   dx, 127
        mov   si, OFFSET b_purple_eff
        call  DrawString
        mov   ch, 05h
        mov   bx, 4*8
        mov   dx, 148
        mov   si, OFFSET bonus_note
        call  DrawString
        mov   bx, 7
        mov   dx, 182
        mov   cx, 306
        mov   al, 05h
        call  DrawHLine
        mov   bx, 7
        mov   dx, 183
        mov   si, 306
        mov   di, 9
        mov   al, 05h
        call  FillRect
        mov   ch, 07h
        mov   bx, 3*8
        mov   dx, 184
        mov   si, OFFSET back_txt
        call  DrawString
        mov   ch, 0Fh
        mov   bx, 18*8
        mov   dx, 184
        mov   si, OFFSET esc_p2_txt
        call  DrawString
    ins_p2_wait:
        mov   ah, 00h
        int   16h
        cmp   al, 27
        je    ins_exit
        cmp   al, 13
        je    ins_page1
        jmp   ins_p2_wait
    ins_exit:
        ret
InstructionsScreen ENDP

; ============================================================
; HIGH SCORE SCREEN
; ============================================================
HighScoreScreen PROC
    mov   al, 00h
    call  FillScreen
    call  DrawNeonFrame
    mov   ch, 0Dh
    mov   bx, 13*8
    mov   dx, 2*8
    mov   si, OFFSET hs_title
    call  DrawString
    mov   bx, 8*8
    mov   dx, 3*8+6
    mov   cx, 192
    mov   al, 05h
    call  DrawHLine
    mov   ch, 03h
    mov   bx, 4*8
    mov   dx, 5*8
    mov   si, OFFSET hs_hdr
    call  DrawString
    mov   bx, 4*8
    mov   dx, 6*8+2
    mov   cx, 240
    mov   al, 01h
    call  DrawHLine
    mov   ch, 0Eh
    mov   bx, 4*8
    mov   dx, 8*8
    mov   si, OFFSET hs1_name
    call  DrawString
    mov   ch, 0Eh
    mov   bx, 18*8
    mov   dx, 8*8
    mov   si, OFFSET hs1_score
    call  DrawString
    mov   ch, 0Eh
    mov   bx, 30*8
    mov   dx, 8*8
    mov   si, OFFSET hs1_rank
    call  DrawString
    mov   ch, 07h
    mov   bx, 4*8
    mov   dx, 10*8
    mov   si, OFFSET hs2_name
    call  DrawString
    mov   ch, 07h
    mov   bx, 18*8
    mov   dx, 10*8
    mov   si, OFFSET hs2_score
    call  DrawString
    mov   ch, 07h
    mov   bx, 30*8
    mov   dx, 10*8
    mov   si, OFFSET hs2_rank
    call  DrawString
    mov   ch, 06h
    mov   bx, 4*8
    mov   dx, 12*8
    mov   si, OFFSET hs3_name
    call  DrawString
    mov   ch, 06h
    mov   bx, 18*8
    mov   dx, 12*8
    mov   si, OFFSET hs3_score
    call  DrawString
    mov   ch, 06h
    mov   bx, 30*8
    mov   dx, 12*8
    mov   si, OFFSET hs3_rank
    call  DrawString
    mov   ch, 06h
    mov   bx, 4*8
    mov   dx, 14*8
    mov   si, OFFSET hs4_name
    call  DrawString
    mov   ch, 06h
    mov   bx, 18*8
    mov   dx, 14*8
    mov   si, OFFSET hs4_score
    call  DrawString
    mov   ch, 06h
    mov   bx, 30*8
    mov   dx, 14*8
    mov   si, OFFSET hs4_rank
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 4*8
    mov   dx, 16*8
    mov   si, OFFSET hs5_name
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 18*8
    mov   dx, 16*8
    mov   si, OFFSET hs5_score
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 30*8
    mov   dx, 16*8
    mov   si, OFFSET hs5_rank
    call  DrawString
    mov   ch, 07h
    mov   bx, 6*8
    mov   dx, 22*8
    mov   si, OFFSET return_msg
    call  DrawString
    hs_wait:
        mov   ah, 00h
        int   16h
        ret
HighScoreScreen ENDP

; ============================================================
; GAME SCREEN LAYOUT
; ============================================================
GameScreenLayout PROC
    mov   paddle_x, 125
    mov   paddle_old_x, 125
    mov   score, 0
    mov   lives_count, 3

    mov   al, 00h
    call  FillScreen

    mov   bx, 0
    mov   dx, 0
    mov   si, 320
    mov   di, 28
    mov   al, 05h
    call  FillRect

    mov   ch, 0Fh
    mov   bx, 1*8
    mov   dx, 4
    mov   si, OFFSET gs_scoreDisplayStr
    call  DrawString
    call  UpdateScoreString
    call  RefreshScoreHUD

    mov   ch, 0Fh
    mov   bx, 14*8
    mov   dx, 4
    mov   si, OFFSET gs_livesDisplayStr
    call  DrawString
    call  UpdateLivesDisplay

    mov   ch, 0Fh
    mov   bx, 25*8
    mov   dx, 4
    mov   si, OFFSET gs_levelDisplayStr
    call  DrawString

    mov   ch, 0Fh
    mov   bx, 20*8
    mov   dx, 17
    mov   si, OFFSET gs_player
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 28*8
    mov   dx, 17
    mov   si, OFFSET gs_name
    call  DrawString

    ; Draw bricks
    mov   dx, 48
    mov   ch, 0
    gs_rows:
        mov   bx, 10
        mov   cl, 0
    gs_cols:
        mov   al, ch
        add   al, cl
        and   al, 03h
        cmp   al, 0
        je    gsc_mag
        cmp   al, 1
        je    gsc_dblue
        cmp   al, 2
        je    gsc_dmag
        mov   al, 03h
        jmp   gsc_draw
    gsc_mag:
        mov   al, 0Dh
        jmp   gsc_draw
    gsc_dblue:
        mov   al, 01h
        jmp   gsc_draw
    gsc_dmag:
        mov   al, 05h
    gsc_draw:
        mov   si, 18
        mov   di, 8
        call  FillRect
        add   bx, 20
        inc   cl
        cmp   cl, 15
        jl    gs_cols
        add   dx, 11
        inc   ch
        cmp   ch, 5
        jl    gs_rows

        mov   cx, 75
        mov   si, OFFSET brick_state
    gs_brick_reset:
        mov   BYTE PTR [si], 1
        inc   si
        loop  gs_brick_reset

        mov   ax, paddle_x
        add   ax, 32
        mov   ball_x, ax
        mov   ball_y, 170
        mov   ball_dx, 1
        mov   ball_dy, -1
        mov   ball_launched, 0

        mov   bx, ball_x
        mov   dx, ball_y
        mov   si, 6
        mov   di, 6
        mov   al, 0Fh
        call  FillRect
        call  DrawPaddle

    gs_game_loop:
        in    al, 60h
        test  al, 80h
        jnz   gs_key_up

        cmp   al, 01h
        je    gs_exit
        cmp   al, 39h
        je    gs_space
        cmp   al, 4Bh
        je    gs_do_left
        cmp   al, 1Eh
        je    gs_do_left
        cmp   al, 4Dh
        je    gs_do_right
        cmp   al, 20h
        je    gs_do_right
        jmp   gs_no_move

    gs_key_up:
        jmp   gs_no_move

    gs_space:
        cmp   ball_launched, 0
        jne   gs_no_move
        mov   ball_launched, 1
        jmp   gs_no_move

    gs_do_left:
        mov   bx, paddle_x
        sub   bx, paddle_speed
        cmp   bx, 2
        jge   gs_apply_move
        mov   bx, 2
        jmp   gs_apply_move

    gs_do_right:
        mov   bx, paddle_x
        add   bx, paddle_speed
        mov   ax, 318
        sub   ax, paddle_width
        cmp   bx, ax
        jle   gs_apply_move
        mov   bx, ax

    gs_apply_move:
        cmp   bx, paddle_x
        je    gs_no_move
        call  ClearPaddle
        cmp   ball_launched, 0
        jne   gs_move_paddle_only
        push  bx
        mov   bx, ball_x
        mov   dx, ball_y
        mov   si, 6
        mov   di, 6
        mov   al, 00h
        call  FillRect
        pop   bx
        mov   ax, bx
        add   ax, 32
        mov   ball_x, ax
    gs_move_paddle_only:
        mov   paddle_x, bx
        call  DrawPaddle
        cmp   ball_launched, 0
        jne   gs_no_move
        mov   bx, ball_x
        mov   dx, ball_y
        mov   si, 6
        mov   di, 6
        mov   al, 0Fh
        call  FillRect

    gs_no_move:
        cmp   ball_launched, 0
        je    gs_delay
        call  MoveBall

    gs_delay:
        mov   cx, ball_speed
    gs_delay_lp:
        push  cx
        mov   cx, 10000
    gs_delay_in:
        loop  gs_delay_in
        pop   cx
        loop  gs_delay_lp
        jmp   gs_game_loop

    gs_exit:
        ret
GameScreenLayout ENDP

; ============================================================
; MOVE BALL
; ============================================================
MoveBall PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di

    mov   bx, ball_x
    mov   dx, ball_y
    mov   si, 6
    mov   di, 6
    mov   al, 00h
    call  FillRect

    mov   ax, ball_x
    add   ax, ball_dx
    mov   bx, ax
    mov   ax, ball_y
    add   ax, ball_dy
    mov   dx, ax

    cmp   bx, 2
    jge   mb_rightCollision
    neg   ball_dx
    mov   bx, 2

    mb_rightCollision:
        mov   ax, bx
        add   ax, 5
        cmp   ax, 317
        jle   mb_topCollision
        neg   ball_dx
        mov   bx, 311

    mb_topCollision:
        cmp   dx, 48
        jge mbh_no_topWallCollision
        jmp    mb_topWallCollision_lbl
    mbh_no_topWallCollision:
        cmp   dx, 103
        jl mb_no_paddleCollision
        jmp   mb_paddleCollision

    mb_no_paddleCollision:
        mov   ax, dx
        sub   ax, 48
        mov   cl, 11
        div   cl
        mov   ch, al
        mov   ax, bx
        sub   ax, 10
        jb    mb_paddleCollision
    mbh_no_paddleCollision:
        mov   cl, 20
        div   cl
        mov   cl, al
        cmp   cl, 15
        jl mb_no_paddleCollision2
        jmp   mb_paddleCollision
    mb_no_paddleCollision2:
        mov   al, ch
        mov   ah, 15
        mul   ah
        add   al, cl
        mov   si, ax
        cmp   brick_state[si], 1
        jne   mb_paddleCollision
        mov   brick_state[si], 0
        push  bx
        push  dx
        push  cx
        xor   ax, ax
        mov   al, cl
        mov   ah, 0
        mov   bx, 20
        mul   bx
        add   ax, 10
        mov   bx, ax
        xor   ax, ax
        mov   al, ch
        mov   ah, 0
        mov   cx, 11
        mul   cx
        add   ax, 48
        mov   dx, ax
        mov   si, 18
        mov   di, 8
        mov   al, 00h
        call  FillRect
        pop   cx
        pop   dx
        pop   bx
        add   score, 5
        call  UpdateScoreString
        call  RefreshScoreHUD
        neg   ball_dy
        jmp   mb_draw

    mb_topWallCollision_lbl:
        cmp   dx, 30
        jge   mb_paddleCollision
        neg   ball_dy
        mov   dx, 30

    mb_paddleCollision:
        cmp   ball_dy, 0
        jl    mb_bottomCollision
        mov   ax, dx
        add   ax, 5
        cmp   ax, paddle_y
        jl    mb_bottomCollision
        cmp   dx, paddle_y
        jg    mb_bottomCollision
        mov   cx, paddle_x
        cmp   bx, cx
        jl    mb_bottomCollision
        add   cx, paddle_width
        cmp   bx, cx
        jge   mb_bottomCollision
        neg   ball_dy
        mov   dx, paddle_y
        sub   dx, 6
        jmp   mb_draw

    mb_bottomCollision:
        mov   ax, dx
        add   ax, 5
        cmp   ax, 199
        jle   mb_draw

        dec lives_count
        call UpdateLivesDisplay
        cmp lives_count, 0
        jg mb_skip_exit
        call GameOverScreen
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret

    mb_skip_exit:
        mov   ball_launched, 0
        mov   ax, paddle_x
        add   ax, 32
        mov   ball_x, ax
        mov   ball_y, 170
        mov   ball_dx, 1
        mov   ball_dy, -1
        mov   bx, ball_x
        mov   dx, ball_y
        mov   si, 6
        mov   di, 6
        mov   al, 0Fh
        call  FillRect
        jmp   mb_done

    mb_draw:
        mov   ball_x, bx
        mov   ball_y, dx
        mov   bx, ball_x
        mov   dx, ball_y
        mov   si, 6
        mov   di, 6
        mov   al, 0Fh
        call  FillRect

    mb_done:
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
MoveBall ENDP
; ============================================================
; GAME OVER SCREEN 
; ============================================================
GameOverScreen PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di

    ; ---- Clear EVERYTHING first ----
    mov   al, 00h
    call  FillScreen

    ; ---- Outer frame ----
    mov   bx, 6
    mov   dx, 6
    mov   si, 308
    mov   di, 186
    mov   al, 05h
    call  DrawRect

    ; ---- Inner frame ----
    mov   bx, 9
    mov   dx, 9
    mov   si, 302
    mov   di, 180
    mov   al, 01h
    call  DrawRect

    ; ---- GAME OVER text (Red, centered) ----
    mov   ch, 0Ch
    mov   bx, 14*8
    mov   dx, 5*8
    mov   al, 'G'
    call  DrawChar
    add   bx, 10
    mov   al, 'A'
    call  DrawChar
    add   bx, 10
    mov   al, 'M'
    call  DrawChar
    add   bx, 10
    mov   al, 'E'
    call  DrawChar
    add   bx, 16
    mov   al, 'O'
    call  DrawChar
    add   bx, 10
    mov   al, 'V'
    call  DrawChar
    add   bx, 10
    mov   al, 'E'
    call  DrawChar
    add   bx, 10
    mov   al, 'R'
    call  DrawChar

    ; ---- Stats box outer ----
    mov   bx, 36
    mov   dx, 56
    mov   si, 248
    mov   di, 78
    mov   al, 05h
    call  DrawRect

    ; ---- Stats box inner ----
    mov   bx, 38
    mov   dx, 58
    mov   si, 244
    mov   di, 74
    mov   al, 00h
    call  FillRect

    ; ---- Final Score ----
    mov   ch, 0Fh
    mov   bx, 7*8
    mov   dx, 9*8
    mov   si, OFFSET go_score_lbl
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 26*8
    mov   dx, 9*8
    mov   si, OFFSET gs_scoreDisplayStr
    add   si, 7
    call  DrawString

    ; ---- Level Reached ----
    mov   ch, 0Fh
    mov   bx, 7*8
    mov   dx, 11*8
    mov   si, OFFSET go_level_lbl
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 26*8
    mov   dx, 11*8
    mov   BYTE PTR [temp_str], '0'
    mov   BYTE PTR [temp_str+1], '1'
    mov   BYTE PTR [temp_str+2], 0
    mov   si, OFFSET temp_str
    call  DrawString

    ; ---- Bricks Left ----
    mov   ch, 0Fh
    mov   bx, 7*8
    mov   dx, 13*8
    mov   si, OFFSET go_bricks_lbl
    call  DrawString

    push  cx
    push  si
    mov   cx, 75
    mov   si, OFFSET brick_state
    mov   bx, 0
    go_count:
        cmp   BYTE PTR [si], 1
        jne   go_nc
        inc   bx
    go_nc:
        inc   si
        loop  go_count
    mov   ax, bx
    pop   si
    pop   cx

    push  ax
    mov   cx, 0
    mov   bx, 10
    go_cvt:
        xor   dx, dx
        div   bx
        push  dx
        inc   cx
        cmp   ax, 0
        jne   go_cvt
    mov   di, OFFSET temp_str
    go_store:
        pop   dx
        add   dl, '0'
        mov   [di], dl
        inc   di
        loop  go_store
    mov   BYTE PTR [di], 0
    pop   ax

    mov   ch, 0Fh
    mov   bx, 26*8
    mov   dx, 13*8
    mov   si, OFFSET temp_str
    call  DrawString

    ; ---- Lives Remaining ----
    mov   ch, 0Fh
    mov   bx, 7*8
    mov   dx, 15*8
    mov   si, OFFSET go_lives_lbl
    call  DrawString
    mov   ch, 0Fh
    mov   bx, 26*8
    mov   dx, 15*8
    mov   al, BYTE PTR [lives_count]
    add   al, '0'
    mov   BYTE PTR [temp_str], al
    mov   BYTE PTR [temp_str+1], 0
    mov   si, OFFSET temp_str
    call  DrawString

    ; ---- Options ----
    mov   ch, 05h
    mov   bx, 8*8
    mov   dx, 19*8
    mov   si, OFFSET go_opt1
    call  DrawString

    mov   ch, 05h
    mov   bx, 8*8
    mov   dx, 21*8
    mov   si, OFFSET go_opt2
    call  DrawString

        go_wait:
        mov   ah, 00h
        int   16h
        cmp   al, 27          ; ESC - exit to menu
        je    go_exit
        cmp   al, 13          ; ENTER - restart game
        je    go_restart
        jmp   go_wait

    go_restart:
        mov   score, 0
        mov   lives_count, 3
        mov   cx, 75
        mov   si, OFFSET brick_state
    go_reset_bricks:
        mov   BYTE PTR [si], 1
        inc   si
        loop  go_reset_bricks
        call  UpdateScoreString
        
        ; Don't return to caller - jump back to start game fresh
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        
        ; Instead of ret, call GameScreenLayout fresh
        call  GameScreenLayout
        ret

    go_exit:
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
GameOverScreen ENDP
; ============================================================
; DRAW PADDLE
; ============================================================
DrawPaddle PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   bx, paddle_x
    mov   dx, paddle_y
    mov   si, paddle_width
    mov   di, 8
    mov   al, 0Fh
    call  FillRect
    pop   di
    pop   si
    pop   dx
    pop   cx
    pop   bx
    pop   ax
    ret
DrawPaddle ENDP

; ============================================================
; CLEAR PADDLE
; ============================================================
ClearPaddle PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   bx, paddle_x
    mov   dx, paddle_y
    mov   si, paddle_width
    mov   di, 8
    mov   al, 00h
    call  FillRect
    pop   di
    pop   si
    pop   dx
    pop   cx
    pop   bx
    pop   ax
    ret
ClearPaddle ENDP

; ============================================================
; DRAWING UTILITIES
; ============================================================
FillScreen PROC
    push  ax
    push  cx
    push  di
    push  es
    mov   cx, 0A000h
    mov   es, cx
    xor   di, di
    mov   cx, 320*200
    rep   stosb
    pop   es
    pop   di
    pop   cx
    pop   ax
    ret
FillScreen ENDP

DrawHLine PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  di
    push  es
    mov   di, 0A000h
    mov   es, di
    push  ax
    mov   ax, dx
    mov   di, 320
    mul   di
    add   ax, bx
    mov   di, ax
    pop   ax
    rep   stosb
    pop   es
    pop   di
    pop   dx
    pop   cx
    pop   bx
    pop   ax
    ret
DrawHLine ENDP

FillRect PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   cx, si
    fr_loop:
        push  dx
        call  DrawHLine
        pop   dx
        inc   dx
        dec   di
        jnz   fr_loop
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
FillRect ENDP

DrawRect PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   cx, si
    call  DrawHLine
    push  dx
    add   dx, di
    dec   dx
    call  DrawHLine
    pop   dx
    push  dx
    push  si
    mov   cx, 1
    dr_vert:
        call  DrawHLine
        push  bx
        add   bx, si
        dec   bx
        call  DrawHLine
        pop   bx
        inc   dx
        dec   di
        jnz   dr_vert
        pop   si
        pop   dx
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
DrawRect ENDP

DrawNeonFrame PROC
    push  ax
    push  bx
    push  dx
    push  si
    push  di
    mov   bx, 4
    mov   dx, 4
    mov   si, 312
    mov   di, 190
    mov   al, 05h
    call  DrawRect
    mov   bx, 7
    mov   dx, 7
    mov   si, 306
    mov   di, 184
    mov   al, 01h
    call  DrawRect
    pop   di
    pop   si
    pop   dx
    pop   bx
    pop   ax
    ret
DrawNeonFrame ENDP

DrawVLine PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  di
    push  es
    mov   di, 0A000h
    mov   es, di
    push  ax
    mov   ax, dx
    mov   di, 320
    mul   di
    add   ax, bx
    mov   di, ax
    pop   ax
    dvl_loop:
        mov   es:[di], al
        add   di, 320
        dec   cx
        jnz   dvl_loop
        pop   es
        pop   di
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
DrawVLine ENDP

DrawBricks PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   dx, 6
    mov   ch, 0
    db_row:
        mov   bx, 4
        mov   cl, 0
    db_col:
        mov   al, ch
        xor   al, cl
        and   al, 03h
        cmp   al, 0
        je    db_mag
        cmp   al, 1
        je    db_dblue
        cmp   al, 2
        je    db_dmag
        mov   al, 03h
        jmp   db_draw
    db_mag:
        mov   al, 0Dh
        jmp   db_draw
    db_dblue:
        mov   al, 01h
        jmp   db_draw
    db_dmag:
        mov   al, 05h
    db_draw:
        mov   si, 18
        mov   di, 7
        call  FillRect
        add   bx, 20
        inc   cl
        cmp   cl, 16
        jl    db_col
        add   dx, 9
        inc   ch
        cmp   ch, 4
        jl    db_row
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
DrawBricks ENDP

CharToIndex PROC
    cmp   al, 3
    jg   cti_not_ctrl
    jl   cti_not_ctrl
    jmp    cti_heart
    cti_not_ctrl:
    cmp   al, 4
    je    cti_diamond
    cmp   al, ' '
    je    cti_space
    cmp   al, '|'
    je    cti_pipe
    cmp   al, '-'
    je    cti_dash
    cmp   al, '>'
    je    cti_gt
    cmp   al, ':'
    je    cti_colon
    cmp   al, '!'
    je    cti_excl
    cmp   al, '.'
    je    cti_dot
    cmp   al, '/'
    je    cti_slash
    cmp   al, '1'
    je    cti_1
    cmp   al, '2'
    je    cti_2
    cmp   al, '3'
    je    cti_3
    cmp   al, '4'
    je    cti_4
    cmp   al, '5'
    je    cti_5
    cmp   al, '_'
    je    cti_uscore
    cmp   al, '0'
    je    cti_0
    cmp   al, '6'
    je    cti_6
    cmp   al, '7'
    je    cti_7
    cmp   al, '8'
    je    cti_8
    cmp   al, '9'
    je    cti_9
    cmp   al, 'A'
    jb    cti_unknown
    cmp   al, 'Z'
    jbe   cti_upper
    cmp   al, 'a'
    jb    cti_unknown
    cmp   al, 'z'
    ja    cti_unknown
    sub   al, 'a'-'A'
    jmp   cti_upper
    cti_unknown:
        xor   ax, ax
        ret
    cti_upper:
        sub   al, 'A'
        mov   ah, 0
        inc   ax
        ret
    cti_space:
        xor   ax, ax
        ret
    cti_pipe:
        mov   ax, 27
        ret
    cti_dash:
        mov   ax, 28
        ret
    cti_gt:
        mov   ax, 29
        ret
    cti_colon:
        mov   ax, 30
        ret
    cti_excl:
        mov   ax, 31
        ret
    cti_1:
        mov   ax, 32
        ret
    cti_2:
        mov   ax, 33
        ret
    cti_3:
        mov   ax, 34
        ret
    cti_4:
        mov   ax, 35
        ret
    cti_5:
        mov   ax, 36
        ret
    cti_slash:
        mov   ax, 37
        ret
    cti_dot:
        mov   ax, 38
        ret
    cti_uscore:
        mov   ax, 39
        ret
    cti_0:
        mov   ax, 40
        ret
    cti_6:
        mov   ax, 41
        ret
    cti_7:
        mov   ax, 42
        ret
    cti_8:
        mov   ax, 43
        ret
    cti_9:
        mov   ax, 44
        ret
    cti_heart:
        mov   ax, 45
        ret
    cti_diamond:
        mov   ax, 46
        ret
CharToIndex ENDP

DrawChar PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  si
    push  di
    mov   [char_color], ch
    call  CharToIndex
    shl   ax, 1
    shl   ax, 1
    shl   ax, 1
    mov   si, OFFSET font_table
    add   si, ax
    mov   ax, 0A000h
    mov   es, ax
    push  bx
    mov   ax, dx
    mov   bx, 320
    mul   bx
    pop   bx
    add   ax, bx
    mov   di, ax
    mov   cx, 8
    dc_row:
        mov   al, [si]
        push  di
        push  cx
        mov   cx, 8
    dc_pix:
        shl   al, 1
        jnc   dc_skip
        mov   bl, [char_color]
        mov   es:[di], bl
    dc_skip:
        inc   di
        loop  dc_pix
        pop   cx
        pop   di
        add   di, 320
        inc   si
        loop  dc_row
        pop   di
        pop   si
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
DrawChar ENDP

DrawString PROC
    push  ax
    ds_next:
        lodsb
        cmp   al, 0
        je    ds_done
        call  DrawChar
        add   bx, 8
        jmp   ds_next
    ds_done:
        pop   ax
        ret
DrawString ENDP

MediumDelay PROC
    push  cx
    mov   cx, 12000
    md_loop:
        loop  md_loop
        pop   cx
        ret
MediumDelay ENDP

SmallDelay PROC
        push  cx
        mov   cx, 8000
    sd_loop:
        loop  sd_loop
        pop   cx
        ret
SmallDelay ENDP

UpdateLivesDisplay PROC
    push  ax
    push  bx
    push  cx
    push  dx
    mov   bx, 20*8
    mov   dx, 4
    mov   si, 40
    mov   di, 8
    mov   al, 05h
    call  FillRect
    mov   cx, lives_count
    cmp   cx, 0
    jle   uld_done
    cmp   cx, 5
    jle   uld_ok
    mov   cx, 5
    uld_ok:
    mov   bx, 20*8
    mov   dx, 4
    uld_loop:
        push  cx
        mov   al, 3
        mov   ch, 0Ch
        call  DrawChar
        pop   cx
        add   bx, 8
        loop  uld_loop
    uld_done:
        pop   dx
        pop   cx
        pop   bx
        pop   ax
        ret
UpdateLivesDisplay ENDP

UpdateScoreString PROC
    push  ax
    push  bx
    push  cx
    push  dx
    push  di
    mov   ax, score
    mov   di, OFFSET gs_scoreDisplayStr
    add   di, 7
    mov   bx, 10
    xor   dx, dx
    mov   cx, 1000
    div   cx
    add   al, '0'
    mov   [di], al
    inc   di
    mov   ax, dx
    xor   dx, dx
    mov   cx, 100
    div   cx
    add   al, '0'
    mov   [di], al
    inc   di
    mov   ax, dx
    xor   dx, dx
    mov   cx, 10
    div   cx
    add   al, '0'
    mov   [di], al
    inc   di
    add   dl, '0'
    mov   [di], dl
    pop   di
    pop   dx
    pop   cx
    pop   bx
    pop   ax
    ret
UpdateScoreString ENDP

RefreshScoreHUD PROC
    push ax
    push bx
    push cx
    push dx
    push  es
    push  ds
    mov   ax, @data
    mov   ds, ax
    mov   ch, 05h
    mov   bx, 1*8
    mov   dx, 4
    mov   si, 88
    mov   di, 8
    mov   al, 05h
    call  FillRect
    mov   ch, 0Fh
    mov   bx, 1*8
    mov   dx, 4
    mov   si, OFFSET gs_scoreDisplayStr
    call  DrawString
    pop   ds
    pop   es
    pop   dx
    pop   cx
    pop   bx
    pop   ax
    ret
RefreshScoreHUD ENDP

END main