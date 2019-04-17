program Prevod_a_spajanie;{spajanie MGP,MBP}
uses Crt;
var s1,s3,Prip:string;
    i,j,Cislo:integer;
    Roz:array[1..2] of byte;
    PocetBMP,PocetBMP2:byte;
    f1,f3:file;
    HlavMGP1,HlavMGP3:array[1..16] of byte;
    MedziPamat:array[1..60000] of byte;
BEGIN
  ClrScr;
  write('N zov zdrojov‚ho s£boru: ');
  readln(s1);
  write('N zov s£boru, ku ktor‚mu sa prid va: ');
  readln(s3);
  Prip:=Copy(s1,Pos('.',s1)+1,255);
  for i:=1 to Length(Prip) do Prip[i]:=UpCase(Prip[i]);
  if Prip='MGP' then begin
    Assign(f1,s1);
    Reset(f1,1);
    BlockRead(f1,HlavMGP1,16);
    Assign(f3,s3);
    Reset(f3,1);
    BlockRead(f3,HlavMGP3,16);
    WriteLn('P“v. s£bor m  ',HlavMGP1[2],' procesov.'#13#10'Ktory chces pridat do nov‚ho s£boru?');
    ReadLn(Cislo);
    Inc(HlavMGP3[2]);
    Seek(f3,0);
    BlockWrite(f3,HlavMGP3,16);  {zapis zvyseny pocet procesov}
    For i:=1 to Cislo-1 do begin
      BlockRead(f1,j,2);
      Seek(f1,FilePos(f1)+j);
    end;
    BlockRead(f1,j,2);
    BlockRead(f1,MedziPamat,j);
    Seek(f3,FileSize(f3));
    BlockWrite(f3,j,2);
    BlockWrite(f3,MedziPamat,j);
    Close(f1);
    Close(f3);
  end;
  if Prip='MB' then begin
    Assign(f1,s1);
    Reset(f1,1);
    Seek(f1,768);
    BlockRead(f1,PocetBMP,1);
    Assign(f3,s3);
    Reset(f3,1);
    Seek(f3,768);
    BlockRead(f3,PocetBMP2,1);
    WriteLn('P“v. s£bor m  ',PocetBMP,' bitm p.'#13#10'Ktor£ chces pridat do nov‚ho s£boru?');
    ReadLn(Cislo);
    Inc(PocetBMP2);
    Seek(f3,768);
    BlockWrite(f3,PocetBMP2,1);  {zapis zvyseny pocet bitmap}
    For i:=1 to Cislo-1 do begin
      BlockRead(f1,Roz,2);
      Seek(f1,FilePos(f1)+Roz[1]*Roz[2]);
    end;
    BlockRead(f1,Roz,2);
    BlockRead(f1,MedziPamat,Roz[1]*Roz[2]);
    Seek(f3,FileSize(f3));
    BlockWrite(f3,Roz,2);
    BlockWrite(f3,MedziPamat,Roz[1]*Roz[2]);
    Close(f1);
    Close(f3);
  end;
END.

