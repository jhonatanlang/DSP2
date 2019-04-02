//
// T1_DSP2.asm 
//
// Created: 12/08/2018 20:08:04 
// Author : Jhonatan 
// 
// --------------------------------------------------------------
// INClude definition files 
// --------------------------------------------------------------
.include "m328pdef.INC" 
// --------------------------------------------------------------
// Register definitions 
// --------------------------------------------------------------
 
.def N = R16 
.def Xk = R17 
.def Yk = R18 
.def W = R19 
.def auxreg = R20 
 
.equ OutputPort = PORTB 
.equ OutputDdr = DDRB 
.equ OutputPin = PB0 
 
// 
.equ tap = 2   
 
main: 
    // Configurando a saida  
    LDI auxReg, 0xff  
    OUT OutputDdr, auxReg  
    LDI auxReg, 0x00  
    OUT OutputPort, auxReg 
 
    //definir endereco dos vetores X e Y  
    .EQU XCELL = 0x0100  
    LDI XH, HIGH(XCELL)  
    LDI XL, LOW(XCELL) 
 
    .EQU YCELL = 0x0140  
    LDI YH, HIGH(YCELL)  
    LDI YL, LOW(YCELL)    
    
   // definir endereco de Z resultado  
    .EQU ZCELL = 0x0180  
    LDI ZH, HIGH(ZCELL)  
    LDI ZL, LOW(ZCELL) 
 
// Preenche vetores (X com 2 e Y com 3)   
setup_vector:  
    LDI N, tap  
    LDI Xk,  2  
    LDI Yk,  3 
 
setup_vector_loop: 
    ST X+, Xk  
    ST Y+, Yk 
 
    DEC  N  
    BRNE setup_vector_loop   
//    ----------------------------------------------------------
 
    CLR R0  
    CLR W  
    LDI N, tap    
    
    SBI OutputPort, OutputPin 
 
    //ADD N, W   
    //BREQ end // if N == 0, jump to end 
loop: 
 
    LD Xk, -X //2 ciclos  
    LD Yk, -Y //2 ciclos 
 
    MUL Xk, Yk //2 ciclos // mul salva o resultado em R1:R0,   
    ADD W, R0 //1 ciclo 
 
    DEC N  //1 ciclo  
    BRNE loop //2 ciclos/1 ciclo // se N == 0, jump to end 
 
end: 
 
    ST Z, W //2 ciclos // salva na memoria 
 
     // ciclos(N) =  N*(2+2+2+1+1+2) - 1 + 2 == N*10 + 1  
     // ciclos/tap(2) = 21/2 = 10,5   
     // ciclos/tap(4) = 41/4 = 10,25   
     // ciclos/tap(8) = 81/8 = 10,125   
     // ciclos/tap(16) = 161/16 = 10,0625   
     // ciclos/tap(32) = 321/32 = 10,03125 // 321c/16MHz ~= 20us 
     // ciclos/tap(64) = 641/64 = 10,015625 
 
    CBI OutputPort, OutputPin 
 
    // Delay  
 /*     
    LDI  R21, 5     
    LDI  R22, 1 
L1:   
    DEC  R22     
    BRNE L1     
    DEC  R21     
    BRNE L1  
*/  
    jmp main 
 