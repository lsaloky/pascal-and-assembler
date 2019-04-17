program Testovanie_ci_je_platna_velka_Fermatova_veta_verzia_2;{cisla 1..4096 za 3.15 min}
const pm=4096; {pocet mocnin,moze byt az po 4096 Zmen aj v assembleri!!!}
var m:array[1..pm+1]of comp;  {tuna su tretie mocniny}
    x,suc:comp;
    c1,c2,vacsie,index:word;
procedure Zhodne;
begin
  writeln('a^3+b^3=c^3 pre ',c1,',',c2,',',vacsie+index);
end;
BEGIN
  for c1:=1 to 24 do writeln;
  x:=1;c1:=1;
  repeat
    m[c1]:=x*x*x;
    x:=x+1;
    c1:=c1+1;
  until x>pm;
  m[pm+1]:=9.2E18;
  for c1:=1 to pm do
    for c2:=c1 to pm do begin
      suc:=m[c1]+m[c2];
      asm
        mov [index],2048   {sem daj pm div 2}
        mov [vacsie],2048   {aj sem}
      end;
      repeat
        asm
          shr word[index],1{index:=index div 2}
          cld
          mov cx,4
          mov si,offset suc
          mov di,offset m
          mov ax,vacsie
          dec ax
          shl ax,3
          add di,ax
     repe cmpsw
          jne @Chyba
          call Zhodne
          @Chyba:
        end;
    {    if m[vacsie]=suc then writeln('a^3+b^3=c^3 pre ',c1,',',c2,',',vacsie+index);}
        if m[vacsie]>suc then begin
          asm
            mov ax,[vacsie]
            sub ax,[index]
            mov [vacsie],ax
         { vacsie:=vacsie-index}
          end;
        end
        else begin
          asm
            mov ax,[vacsie]
            add ax,[index]
            mov [vacsie],ax
         { vacsie:=vacsie+index}
          end;
        end;
      until index<1;
    end;
END.