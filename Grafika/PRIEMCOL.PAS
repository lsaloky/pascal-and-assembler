program Priemerovanie_farieb_vo_farebnom_mode;
uses Crt;
var VesaInf:array[0..255] of byte;
    RiadokPred,RiadokPo:array[1..960] of byte;{pri priemerovani je tu riadok pred a riadok po aktualnej stranke,
                                               aby nebolo nutne pri kazdom bode swapovat stranku}
    Granul,AktStr:word;
    x,y,z,ZacR:word;
procedure NastavStranku;assembler;
asm
             mov bx,0
             mov ax,4F05h
             int 10h                   {nastav 1.stranku}
end;
BEGIN
  asm
             mov ax,seg VesaInf        {zistenie granularity}
             mov es,ax
             mov di,offset vesainf
             mov ax,4F01h
             mov cx,10Fh
             int 10h
             mov cx,word ptr VesaInf+4
             mov ax,64
             div cl
             mov Granul,ax
             mov ax,4F02h              {nastavenie graf. modu}
             mov bx,10Fh
             int 10h
  end;
  ZacR:=0;AktStr:=0;
  for y:=0 to 199 do begin
    for x:=1 to 960 do RiadokPred[x]:=Random(256);
    asm
            mov dx,y
            shr dx,5
            mov ax,Granul
            mul dx                    {DX=Granul*Riadok/32}
            mov dx,ax
            cmp dx,AktStr
            je @Nenastav
            call NastavStranku
@Nenastav:   mov AktStr,dx
            mov ax,0A000h
            mov es,ax
            lea si,RiadokPred
            mov di,ZacR
            mov cx,480
        rep movsw                     {nakresli riadok}
    end;
    if ZacR=63488 then ZacR:=0
    else ZacR:=ZacR+2048;
  end;
{ ----- priemerovanie farieb, inicializacia ----- }
  repeat
    asm
              mov dx,Granul
              call NastavStranku
    end;
    Move(Mem[$A000:$0000],RiadokPo,960);{1. riadok 1. stranky ( = 33. riadok) do RiadokPred}
    asm
              mov dx,0
              call NastavStranku
    end;
    ZacR:=2048;AktStr:=0;               {od riadka 1}
    for y:=1 to 198 do begin
      if y mod 32=0 then begin
        Move(Mem[$A000:$F800],RiadokPred,960);{posledny riadok terajsej stranky do RiadokPred}
        AktStr:=AktStr+Granul;          {posun na novu stranku}
        asm
              mov dx,AktStr
              add dx,Granul             {nasledujuca}
              call NastavStranku
        end;
        Move(Mem[$A000:$0000],RiadokPo,960);{prvy riadok dalsej stranky do RiadokPo}
        asm
              mov dx,AktStr
              call NastavStranku        {terajsia, cize nova}
        end;
      end;
      asm
              mov ax,0A000h
              mov es,ax
              mov di,ZacR               {do ES:DI sa uklada}
              add di,3
              mov dx,3                  {DX od 3 do 318*3}
 @Cyklus:     cmp ZacR,0
              jne @HoreNormal

              lea bx,RiadokPred         {pouziva sa buffer RIADOKPRED pre predosly riadok}
              mov al,byte[bx+di-3]
              mov ah,0
              add al,byte[bx+di]
              adc ah,0
              add al,byte[bx+di+3]
              adc ah,0
              jmp @Stred

 @HoreNormal: mov al,byte[es:di-2051]   {normalny vypocet z predosleho riadka}
              mov ah,0
              add al,byte[es:di-2048]
              adc ah,0
              add al,byte[es:di-2045]
              adc ah,0

 @Stred:      add al,byte[es:di-3]      {vzdy normalny vypocet aktualneho riadka}
              adc ah,0
              add al,byte[es:di+3]
              adc ah,0

              cmp ZacR,63488
              jne @DoleNormal
              lea bx,RiadokPo         {pouziva sa buffer RIADOKPO pre predosly riadok}
              sub di,63488
              add al,byte[bx+di-3]
              adc ah,0
              add al,byte[bx+di]
              adc ah,0
              add al,byte[bx+di+3]
              adc ah,0
              add di,63488
              jmp @Vypocet

 @DoleNormal: add al,byte[es:di+2045]   {normalny vypocet dolneho riadka}
              adc ah,0
              add al,byte[es:di+2048]
              adc ah,0
              add al,byte[es:di+2051]
              adc ah,0                  {v AX je celkovy sucet}

 @Vypocet:    shr ax,3                  {v AX je priemer}
              adc al,0                  {chyba zaokruhlenia - pripocitaj posledny vyrolovany bit}
              mov byte[es:di],al
              inc di
              inc dx
              cmp dx,319*3
              jl @Cyklus
      end;
      if ZacR=63488 then ZacR:=0
      else ZacR:=ZacR+2048;
    end;
  until KeyPressed;
END.