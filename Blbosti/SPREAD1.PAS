{$I Lubo.pas}
BEGIN
 LuboInit;
 Tabulka;
 Ponuka;
 Prik_riad;
 TextColor(Black);
 Repeat
  Prik_riad;
  Sbunka;
  ch:=readkey;
  Case ch of
  'c' : VCommand := ChangeCell;
  'e' : VCOmmand := EnterExpr;
  'l' : VCommand := EnterLabel;
  'x' : VCommand := ExitSpread;
   end;
  Case VCommand of
   ChangeCell : Begin
                write('Zadaj novu bunku: ');
                repeat
                  ch:=ReadKey;
                until UpCase(ch) in [MinRow..MaxRow];
                write(ch);idc[1]:=ch;
                repeat
                  ch:=ReadKey;
                until Ord(ch)-48 in [MinCol..MaxCol];
                write(ch);idc[2]:=ch;
                ch:=ReadKey;
                idc[0]:=#2;
                DoCellChange(idc);
                end;
   EnterLabel : Begin
                  write('Zadaj label: ');
                  LuboReadln(30);
                  VCell[CurCell.Name,CurCell.Num].CellLabel:=DataStr;
                  vypis(Curcell,VCell[CurCell.Name,CurCell.Num].CellLabel);
                end;
   Enterexpr  : begin
                 write('Zadaj vyraz: ');
                 LuboReadln(30);
                 for i:=1 to Length(DataStr) do DataStr[i]:=UpCase(DataStr[i]);
                 with VCell[CurCell.Name,CurCell.Num] do begin
                   CellExpr:=VytvorVyraz(DataStr);
                   JozoMakaj(CurCell);
                   Str(VCell[CurCell.Name,CurCell.Num].Value:4:4,DataStr);
                   Vypis(CurCell,DataStr);
                 end;
                end;
   ExitSpread:
   else VypisChybu(5);
  end;
  Until VCommand = ExitSpread;
  TextColor(7);TextBackGround(0);ClrScr;
  writeln('QuickCalc verzia 1.0, 1997');
  writeln('Tvorcovia:'#13#10);
  writeln(' Diko Peter');
  writeln(' Hales Jozef');
  writeln(' Saloky Lubo');
  writeln(' Sedl k Ondrej');
  writeln(' Simkaninov  Lubom¡ra');
end.