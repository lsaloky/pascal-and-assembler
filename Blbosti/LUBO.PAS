Uses crt;
{  procedure VypisChybu(Cislo:byte);
   procedure LuboInit;
    function LuboRataj(NodePtr):real;
   procedure LuboReadln(Dlzka);                   vystup v DataStr
   procedure Tabulka;
   procedure Vypis(a:cellid;os:string);
   procedure Prik_riad;
   procedure Ponuka;
   procedure Sbunka;
   procedure JozoMakaj(Bunka:cellid);
   procedure DoCellChange(s:string);
    function VytvorVyraz(Vyraz:string):NodePtr;
}
const ColsPerCell=10;
      MaxIDLen=10;
      FakeNil=0;
      MinRow='A';
      MaxRow='I';
      MinCol=1;
      MaxCol=7;
      MaxLine=1;
      BASECOL    =1;  {Pozicia x osi.  }
      BASEROW    =5;  {        y osi.  }
      Chyby:array[1..5] of string=(
        'Logaritmus ma zaporny argument',
        'Odmocnina ma zaporny argument',
        'Delenie nulou',
        'Adresa bunky mimo rozsah',
        'Zly prikaz: spravne su L,E,C,X');

type Counter=0..maxint;
     RowIndex=MinRow..MaxRow;
     ColIndex=FakeNil..MaxCol;
     Token=(SINFUNC,COSFUNC,EXPFUNC,LNFUNC,SQRTFUNC,UMINUS,PLUS,MINUS,TIMES,
            DIVIDE,CELLABEL,LEFTPAREN,RIGHTPAREN,NUMBER,NOMORE,UNKNOWN,
            ACELLNAME,BADCELL);
     Commands=(HELP,CHANGECELL,ENTEREXPR,ENTERLABEL,BAD,EXITSPREAD);
     CellID=record
       Name:RowIndex;
       Num:ColIndex;
     end;
     NodePtr=^Node;
     Node=record
       CellName:CellID;
       Op:Token;
       Value:real;
       Left,Right:NodePtr;
     end;
     DependPtr=^Depend;
     Depend=record
       Dependee:CellID;
       Next:DependPtr;
     end;
     Cell=record
       Cellexpr:NodePtr;
       CellLabel:string;
       DependList:DependPtr;
       Value:Real;
     end;
var VCell:array[MinRow..MaxRow,MinCol..MaxCol] of Cell;
    CurCell:CellID;
    LValue:real;
    LZac:NodePtr;
    TempDepend:DependPtr;   {VytvorVyraz}
    Ch:Char;
    VCommand:Commands;
    idc,DataStr:string;
    I:integer;
{ ----- chybove hlasenie ----- }
procedure VypisChybu(Cislo:byte);
begin
  GotoXY(3,24);
  TextBackGround(7);TextColor(Red);
  Write(Chyby[Cislo],'   < Stlac Enter >');
  repeat
    ch:=ReadKey;
  until ch=#13;
  GotoXY(3,24);Writeln('                                                ');
  TextBackGround(4);TextColor(Black);
end;
{ ----- inicializacia pola VCell ----- }
procedure LuboInit;
var lx:char;
    ly,lz:word;
begin
  CurCell.Name:='A';CurCell.Num:=1;
  for lx:=MinRow to MaxRow do        {riadky}
    for ly:=MinCol to MaxCol do      {stlpce}
      with VCell[lx,ly] do begin
        CellExpr:=nil;
        CellLabel:='';
        DependList:=nil;
        Value:=0;
      end;
end;
{ ----- vypocet hodnoty aritmetickeho vyrazu ----- }
function LuboRataj(LPZac:NodePtr):real;
begin
  with LPZac^ do begin
    case Op of
      SINFUNC:LuboRataj:=Sin(LuboRataj(Right));
      COSFUNC:LuboRataj:=Cos(LuboRataj(Right));
      EXPFUNC:LuboRataj:=Exp(LuboRataj(Right));
      LNFUNC:begin
        LValue:=LuboRataj(Right);
        if LValue>0 then LuboRataj:=Ln(LValue)
                    else begin
                      LuboRataj:=0;
                      VypisChybu(1);
                    end;
      end;
      SQRTFUNC:begin
        LValue:=LuboRataj(Right);
        if LValue>=0 then LuboRataj:=Sqrt(LValue)
                    else begin
                      LuboRataj:=0;
                      VypisChybu(2);
                    end;
      end;
      UMINUS:LuboRataj:=-LuboRataj(Right);
      PLUS:LuboRataj:=LuboRataj(Left)+LuboRataj(Right);
      MINUS:LuboRataj:=LuboRataj(Left)-LuboRataj(Right);
      TIMES:LuboRataj:=LuboRataj(Left)*LuboRataj(Right);
      DIVIDE:begin
        LValue:=LuboRataj(Right);
        if LValue<>0 then LuboRataj:=LuboRataj(Left)/LuboRataj(Right)
                    else begin
                      LuboRataj:=0;
                      VypisChybu(3);
                    end;
      end;
      NUMBER:LuboRataj:=Value;
      ACELLNAME:LuboRataj:=VCell[CellName.Name,CellName.Num].Value;
    end;
  end;
end;
{ ----- nova rutina pre ReadLn ----- }
procedure LuboReadln(Dlzka:byte);{vystup je v retazci DataStr}
begin
  DataStr[0]:=Chr(Dlzka);
  asm
    mov ah,0Ah
    lea dx,DataStr
    int 21h
  end;
  Move(DataStr[1],DataStr[0],255);
end;
{ ----- vypisanie tabulky ----- }
Procedure tabulka;
  var oz,ox,oy:word;
 begin
  textbackground(7); clrscr;
  textcolor(14{yellow});
  gotoxy(basecol,baserow-1);
  for ox:=1 to maxcol*colspercell do
    begin
      if ox mod colspercell=(colspercell div 2)+1 then
        begin
          textcolor(4);
          gotoxy(basecol+ox+(ox div colspercell),baserow-1);
          write(chr(49+ox div colspercell));
          textcolor(14);
        end;
    end;
  GotoXY(BaseCol,BaseRow);
  Write(' É');
  for ox:=1 to MaxCol do
    begin
      for oy:=1 to COLSPERCELL do write('Í');
      if maxcol<>ox then write('Ñ');
    end;
  writeln('»');
  for oz:=1 to ord(maxrow)-ord('A')+1 do
    begin
      textcolor(4);
      gotoxy(basecol,baserow+2*oz-1);
      write(chr(64+oz));
      textcolor(14);
      write('º');
      for ox:=1 to maxcol do
        begin
          if maxcol<>ox then
            begin gotoxy(basecol+ox*colspercell+ox+1,baserow+2*oz-1); write('³');end;
        end;
      gotoxy(basecol+colspercell*maxcol+maxcol+1,baserow+2*oz-1);
      writeln('º');
      gotoxy(basecol,baserow+2*oz);
      if oz<>ord(maxrow)-ord('A')+1 then
        begin
          write(' Ç');
          for ox:=1 to maxcol do
            begin
              for oy:=1 to colspercell do write('Ä');
              if maxcol<>ox then write('Å');
            end;
          writeln('¶');
        end;
    end;
  gotoxy(basecol,baserow+2*oz);
  write(' È');
  for ox:=1 to maxcol do
    begin
      for oy:=1 to colspercell do write('Í');
      if ox<>maxcol then write('Ï');
    end;
  write('¼');
 end;
{ ----- vypis retazca do tabulky ----- }
procedure vypis(a:cellid;os:string);
  var ox,oy:integer;
      oss:string[10];
      oi:integer;
 begin
  textcolor(1);textbackground(7);
  window(1,1,80,25);
  oy:=(ord(a.name)-ord('A'))*2+baserow+1;
  ox:=ord(a.num-1)*colspercell+ord(a.num)+1+basecol;
  oss:=os;
  gotoxy(ox,oy);
  for oi:=1 to colspercell do write(' ');
  gotoxy(ox,oy);
  write(oss);
  gotoxy(2,3);
  textcolor(black);
 end;
{ ----- vypisanie prikazoveho riadka ----- }
procedure prik_riad;
var i:integer;
 begin
  gotoxy(2,3);
  textbackground(4);
  for i:=1 to 50 do write(' ');
  textcolor(0);
  gotoxy(2,3);
 end;
{ ----- vypisanie dolnej ponuky ----- }
procedure ponuka;
    var zv,nor:integer;
  begin
   nor:=7;
   zv:=15;
   gotoxy(2,25);
   textbackground(1);
   textcolor(nor);
   write(' enter ');textcolor(zv);write('L');textcolor(nor);write('abel ');
   gotoxy(16,25);
   textcolor(zv);write(' C');textcolor(nor);write('hange cell ');
   gotoxy(30,25);
   write(' enter ');textcolor(zv);write('E');textcolor(nor);write('xpresion ');
   gotoxy(48,25);
   write(' e');textcolor(zv);write('X');textcolor(nor);write('it spreadsheet ');
  end;
{ ----- vypisanie aktualnej bunky ----- }
procedure sbunka;
 begin
  textbackground(1);
  textcolor(7);
  gotoxy(61,3);
  write(' Aktualna bunka:',curcell.name,curcell.num,' ');
  gotoxy(2,3);
  TextBackGround(4);TextColor(0);
 end;
{ ----- prechod grafom zavislosti ----- }
procedure JozoMakaj(Bunka:cellid);
var Dalsia,Pom1:CellID;
    PomPtr:DependPtr;
begin
  with vcell[bunka.name,bunka.num] do begin
    if CellExpr<>nil then Value:=LuboRataj(CellExpr);
    if vcell[bunka.name,bunka.num].dependlist<>nil then begin
      pom1:=vcell[bunka.name,bunka.num].dependlist^.dependee;
      JozoMakaj(pom1);
      pomptr:=vcell[bunka.name,bunka.num].dependlist^.next;
      while pomptr<>nil do begin
        pom1.name:=pomptr^.dependee.name;
        pom1.num:=pomptr^.dependee.num;
        JozoMakaj(pom1);
        pomptr:=pomptr^.next;
      end;
    end;
  end;
end;
{ ----- zmena aktualnej bunky ----- }
Procedure DoCellChange(s:string);
var pom:byte;
Begin
  s[1]:=UpCase(s[1]);
  pom:=Ord(s[2])-48;
  if (s[1]>=MinRow) and (s[1]<=MaxRow) and (pom>MinCol) and (pom<=MaxCol) then begin
    CurCell.Name := s[1];
    CurCell.Num := pom;
  end;
  GotoXY((ord(CurCell.Name)-ord(MinRow))*2+BaseRow+1,Ord(CurCell.Num-1)*ColsPerCell+Ord(CurCell.Num)+1+BaseCol);
end;
{ ----- vytvorenie struktury aritmetickeho vyrazu ----- }
function VytvorVyraz(Vyraz:string):NodePtr;
var Zatvorky    : Integer;
    i           : Integer;
    TatoBunka   : NodePtr;
begin
 Tatobunka:=NIL;
 Zatvorky:=0;
 for i:=1 to Length(Vyraz) do begin     { hlada + musi mat prednost pred - }
  if Vyraz[i]='(' then Inc(Zatvorky);
  if Vyraz[i]=')' then Dec(Zatvorky);
  if ((Zatvorky=0) and (Vyraz[i]='+')) then begin
   New(TatoBunka);
   TatoBunka^.Op:=PLUS;
   TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
   TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
   break;
  end;
 end;
 if (TatoBunka=NIL) then
  for i:=1 to Length(Vyraz) do begin     { hlada - }
   if Vyraz[i]='(' then Inc(Zatvorky);
   if Vyraz[i]=')' then Dec(Zatvorky);
   if ((Zatvorky=0) and (Vyraz[i]='-')) then begin
    New(TatoBunka);
    TatoBunka^.Op:=MINUS;
    if (i-1)=0 then begin
     New(TatoBunka^.Left);
     TatoBunka^.Left^.Op:=NUMBER;
     TatoBunka^.Left^.Value:=0;
     TatoBunka^.Left^.Left:=NIL;
     TatoBunka^.Left^.Right:=NIL;
    end else begin
     TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
    end;
    TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
    break;
   end;
  end;
 if (TatoBunka=NIL) then
  for i:=1 to Length(Vyraz) do begin     { hlada * alebo / }
   if Vyraz[i]='(' then Inc(Zatvorky);
   if Vyraz[i]=')' then Dec(Zatvorky);
   if (Zatvorky=0) then
    if (Vyraz[i]='*') or (Vyraz[i]='/') then begin
     New(TatoBunka);
     if (Vyraz[i]='*') then TatoBunka^.Op:=TIMES
                       else TatoBunka^.Op:=DIVIDE;
     TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
     TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
     break;
    end;
  end;
 if (TatoBunka=NIL) then          { pozera, ci nebola velka zatvorka }
  if (Vyraz[1]='(') and (Vyraz[Length(Vyraz)]=')') then
   TatoBunka:=VytvorVyraz(copy(Vyraz,2,Length(Vyraz)-2));
 if (TatoBunka=NIL) then begin   { nemoze to byt operacia }
  { moze byt funkcia, acellname, cislo }
  if ((Vyraz[1]>='0') and (Vyraz[1]<='9')) or (Vyraz[1]='.') then begin { ma cislo }
   New(TatoBunka);
   Tatobunka^.Op:=NUMBER;
   Val(Vyraz,TatoBunka^.Value,i);
   TatoBunka^.Left:=NIL;
   TatoBunka^.Right:=NIL;
  end else begin      { na acellname or funckiu }
   if ((Vyraz[2]>='0') and (Vyraz[2]<='9')) then begin { ma acellname }
    New(TatoBunka);
    Tatobunka^.Op:=ACELLNAME;
    Tatobunka^.CellName.Name:=Vyraz[1];
    Tatobunka^.CellName.Num:=Ord(Vyraz[2])-48;
    TatoBunka^.Left:=NIL;
    TatoBunka^.Right:=NIL;
    TempDepend:=VCell[CurCell.Name,CurCell.Num].DependList; { prehladava sa dependlist }
    while (TempDepend<>NIL) do begin
     if (TempDepend^.Dependee.Name=Tatobunka^.CellName.Name) and
        (TempDepend^.Dependee.Num=Tatobunka^.CellName.Num)   then break;
     TempDepend:=TempDepend^.Next;
    end;                             { ak ma NIL, tak nenasiel tuto }
    if (TempDepend=NIL) then begin
     New(TempDepend);
     TempDepend^.Dependee:=Tatobunka^.CellName;
     TempDepend^.Next:=VCell[CurCell.Name,CurCell.Num].DependList;
     VCell[CurCell.Name,CurCell.Num].DependList:=TempDepend;
    end;
   end else begin                                      { ma funckciu }
    New(TatoBunka);
    TatoBunka^.Left:=NIL;
    case Vyraz[1] of
    'S':begin { 'SIN'  alebo 'SQRT' }
         if Vyraz[2]='I' then begin { SIN }
          Tatobunka^.Op:=SINFUNC;
          TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
         end else begin  { SQRT }
          Tatobunka^.Op:=SQRTFUNC;
          TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,6,Length(Vyraz)-6));
         end;
        end;
    'C':begin { 'COS' }
         Tatobunka^.Op:=COSFUNC;
         TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
        end;
    'E':begin { 'EXP' }
         Tatobunka^.Op:=EXPFUNC;
         TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
        end;
    'L':begin { 'LN' }
         Tatobunka^.Op:=LNFUNC;
         TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,4,Length(Vyraz)-4));
        end;
     else begin
      Tatobunka^.Op:=UNKNOWN;
      TatoBunka^.Right:=NIL;
     end;
    end;
   end;
  end;
 end;
 VytvorVyraz:=TatoBunka;
end;
