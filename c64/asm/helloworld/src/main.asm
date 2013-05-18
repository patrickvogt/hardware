.SEGMENT "CODE"

.ADDR start

start:  ldy #0
loop:   lda hello,y
        beq done
        jsr $FFD2
        iny
        jmp loop
done:   rts

hello:	.byte "HALLO WELT",0