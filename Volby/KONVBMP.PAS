Program Konverzia_palety_bitmap;
{ ----- prepisuje originalny .BMP subor !!!!! ----- }
Uses MainGr,Util386,Speaker;
Type TObrazok=array[0..63999] of byte;
Const MaxZmena=9;
Var a:array[0..63999] of byte absolute $A000:0000;
    f:file;
    i,j,Max:word;
    Stara,Nova,ColMax,RozX,RozY,Pocet:byte;
    s,Nazov,NazovMB,NazovMP:string;
    Paleta:array[0..768] of byte;
    Prechod:array[0..767] of byte;
    P,PB:^TObrazok;
    FP:pointer;
procedure Error;
begin
  ZavriGrafiku;
  Writeln('Nedostatok farieb !!!');
  Halt;
end;
procedure VymenFarbu(St,No:byte);
var pc1:word;
begin
  for pc1:=0 to 63999 do if (p^[pc1]=St) and (pb^[pc1]=0) then begin
    p^[pc1]:=No;
    Mem[$A000:pc1]:=No;
    pb^[pc1]:=1;
  end;
end;
BEGIN
  Writeln('Nazov suboru pre konverziu:');
{  ReadLn(Nazov);}
  Nazov:='SL2.BMP';
  Writeln('Nazov suboru .MB pre pridanie:');
{  ReadLn(NazovMB);}
  NazovMB:='velka.MB';
  Writeln('Nazov suboru .MP pre pridanie:');{prip. s nulovou dlzkou; ale musi existovat}
{  ReadLn(NazovMP);}
  NazovMP:='3Dklav.mp';
  NacitajFont('Hlavny8.MSF',FP);
  GetMem(p,64000);
  GetMem(pb,64000);
  for i:=0 to 63999 do pb^[i]:=0;
  Assign(f,'d:\lubo\pascal\units\Prechody.MP');
  Reset(f,1);
  BlockRead(f,Prechod,768);
  Close(f);
  InicializujGrafiku;
  Assign(f,Nazov);
  Reset(f,1);
  Seek(f,54);
  for i:=0 to 255 do BlockRead(f,Paleta[i*3],4);
  for i:=0 to 767 do Paleta[i]:=Paleta[i] shr 2;
  for i:=0 to 255 do begin
    j:=Paleta[i*3];
    Paleta[i*3]:=Paleta[i*3+2];
    Paleta[i*3+2]:=j;
  end;
  NastavPaletu(@Prechod);
  for i:=197 downto 0 do BlockRead(f,p^[320*i],320);
  Close(f);
  KopirujObrazovku386(Seg(p^),$A000);
  for i:=0 to 63999 do
    case Mem[$A000:i] of
      $3C:Mem[$A000:i]:=16*6+12;
      $17:Mem[$A000:i]:=16*9+12;
      $C4:Mem[$A000:i]:=16*1+8;
      $88:Mem[$A000:i]:=16*3+12;
      else Mem[$A000:i]:=0;
    end;
  for i:=64000-640 to 63999 do a[i]:=0;
  for i:=0 to 199 do a[i*320+319]:=0;
  for i:=0 to 199 do a[i*320+318]:=0;
(*  Nova:=176; {1. volna farba}
  for Stara:=0 to 255 do begin
    Max:=65535;
    for i:=0 to 175 do begin
      j:=Abs(Paleta[3*Stara]-Prechod[3*i])
        +Abs(Paleta[3*Stara+1]-Prechod[3*i+1])
        +Abs(Paleta[3*Stara+2]-Prechod[3*i+2]);
      if j<Max then begin
        Max:=j;
        ColMax:=i;
      end;
    end;
    if Max<MaxZmena then VymenFarbu(Stara,ColMax){v palete Prechod sa nasla vhodna farba}
    else begin
      Prechod[3*Nova]:=Paleta[3*Stara];    {nenasla sa,pridaj ju}
      Prechod[3*Nova+1]:=Paleta[3*Stara+1];
      Prechod[3*Nova+2]:=Paleta[3*Stara+2];
      NastavFarbu(Nova,Paleta[3*Stara],Paleta[3*Stara+1],Paleta[3*Stara+2]);
      VymenFarbu(Stara,Nova);
      Inc(Nova);
      if Nova=0 then Error;
    end;
  end;
  AttentionBeep;*)
  readln;

(*  Assign(f,NazovMP);{ ----- paleta ----- }
  Reset(f,1);
  Seek(f,FileSize(f));
  BlockWrite(f,Prechod,768);
  Close(f);
  KopirujObrazovku386(Seg(p^),$A000);
  NastavPaletu(@Prechod);
  Assign(f,Nazov);
  Reset(f,1);
  Seek(f,54);
  ColMax:=0;
  for i:=0 to 767 do Prechod[i]:=Prechod[i] shl 2;
  for i:=0 to 255 do begin
    BlockWrite(f,Prechod[i*3+2],1);
    BlockWrite(f,Prechod[i*3+1],1);
    BlockWrite(f,Prechod[i*3],1);
    BlockWrite(f,ColMax,1);
  end;
  for i:=199 downto 0 do BlockWrite(f,p^[320*i],320);
  Close(f);*)

  Assign(f,NazovMB); { ----- .MB subor ----- }
  Reset(f,1);
  Seek(f,FileSize(f));
  RozX:=64;{320-256};RozY:=200;
  BlockWrite(f,RozX,1);
  BlockWrite(f,RozY,1);
  BlockWrite(f,a,64000);
  Seek(f,768); {uprav pocet bitmap}
  BlockRead(f,Pocet,1);
  inc(Pocet);
  Seek(f,768);
  BlockWrite(f,Pocet,1);
  Close(f);
END.