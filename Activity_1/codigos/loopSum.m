loop: 
    LD Xk, -X //2 cycle 
    LD Yk, -Y //2 cycle 
    MUL Xk, Yk //2 cycle // mul save the result in R1:R0, 
    ADD W, R0 //1 cycle 
    DEC N //1 cycle 
    BRNE loop //2 cycles // 1 cycle if N == 0, jump to end 
end:
    ST Z, W //2 cycles // save in memory