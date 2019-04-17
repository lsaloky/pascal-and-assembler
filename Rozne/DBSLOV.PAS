program Databaza_slov;
const Sprac='bezpecno.htm';
      Neplatne=[':',';','.',',','?','/','"',#37,'[',']','{','}','\','|','+',
                '=','_','!','@','%','*','(',')',#48..#57];
var f:file;
    vstup,vystup:text;
    KodTab:array[0..255] of char;
    s:string;
    i,j:integer;
BEGIN
{ ----- inicializacia kodovej tabulky ----- }
  Assign(f,'CP1250.tbl');
  Reset(f,1);
  Seek(f,FileSize(f)-256);
  BlockRead(f,KodTab,256);
  Close(f);
{ ----- konverzia HTML dokumentu na normalny text ----- }
  s:=Sprac;
  Delete(s,Length(s)-3,4);
  Assign(vystup,s+'.txt');
  ReWrite(vystup);
  Assign(vstup,Sprac);
  Reset(vstup);

  while not EOF(vstup) do begin
    ReadLn(vstup,s);
                   { odstranovanie riadiacich kodov v zatvorkach }
    i:=Pos('<',s);
    j:=Pos('>',s);
    if (i>j) or ((i=0) and (j>0)) then Delete(s,1,j); {prikaz je pokracovanim z predchadzajuceho riadka}
    while i>0 do begin
      if j=0 then j:=Length(s);  {prikaz pokracuje na dalsom riadku}
      Delete(s,i,j-i+1);
      i:=Pos('<',s);
      j:=Pos('>',s);
    end;
                   { mazanie medzier }
    while (s[1]=' ') and (s<>'') do Delete(s,1,1);
    while (s[Length(s)]=' ') and (s<>'') do Delete(s,Length(s),1);
                   { mazanie &xxx; }
    i:=Pos('&',s);
    j:=Pos(';',s);
    while i>0 do begin
      Delete(s,i,j-i+1);
      i:=Pos('&',s);
      j:=Pos(';',s);
    end;
                   { dalsie upravy }
    for i:=1 to Length(s) do begin
      if s[i] in Neplatne then Delete(s,i,1);
      if s[i] in ['A'..'Z'] then s[i]:=Chr(Ord(s[i])+32);
    end;
                   { prekodovanie do Latin 2 }
    for i:=1 to Length(s) do if s[i]>#128 then s[i]:=Kodtab[Ord(s[i])];
                   { zapis }
    if s<>'' then WriteLn(vystup,s);
  end;
  Close(vstup);
  Close(vystup);
END.