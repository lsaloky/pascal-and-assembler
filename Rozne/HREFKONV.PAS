program Konverzia_HTML_Reference;
uses Dos;
{$DEFINE DOJEDNEHO}
const Cesta='C:\DOKUME~1\LUBO\HTMLREF\';
var sr:SearchRec;
    fin,fout:text;
    s,t:string;
    i:integer;
BEGIN
{$IFDEF DOJEDNEHO}
  Assign(fout,'htmlref.htm');
  ReWrite(fout);
  WriteLn(fout,'<HTML>'#13#10'<BODY>');
{$ENDIF}
  FindFirst(Cesta+'*.*',AnyFile,sr);
  while DosError=0 do begin
    if sr.name[1]<>'.' then begin
      Assign(fin,Cesta+sr.name);
      Reset(fin);
{ ----- vynechaj 50 riadkov, namiesto nich napis "<HTML>, <BODY> " ----- }
      for i:=1 to 51 do ReadLn(fin,s);
      t:=Copy(s,1,4);
      if t='<H2>' then begin
{$IFNDEF DOJEDNEHO}
        Assign(fout,sr.name);
        ReWrite(fout);
        WriteLn(fout,'<HTML>'#13#10'<BODY>'#13#10+s);
{$ELSE}
        WriteLn(fout,'</P>'#13#10+s);
{$ENDIF}
        while not EOF(fin) do begin { kopiruj }
          ReadLn(fin,s);
          t:=Copy(s,1,20);
          if t<>'<br><center><a href=' then begin { orez na konci dokumentu }
            if (s='<H3>Content Tags</H3>') or
               (s='<H3>Parent Tags</H3>')  then begin { vynechaj 4 riadky }
              ReadLn(fin,s);
              ReadLn(fin,s);
              ReadLn(fin,s);
              ReadLn(fin,s);
            end;
            WriteLn(fout,s);
          end else begin
            ReadLn(fin,s);
            ReadLn(fin,s);
{$IFNDEF DOJEDNEHO}
            WriteLn(fout,'</BODY>');
{$ELSE}
            ReadLn(fin,s);
{$ENDIF}
          end;
        end;
{$IFNDEF DOJEDNEHO}
        Close(fout);
{$ENDIF}
      end;
      Close(fin);
    end;
    FindNext(sr);
  end;
{$IFDEF DOJEDNEHO}
  WriteLn(fout,#13#10'</BODY>'#13#10'</HTML>');
  Close(fout);
{$ENDIF}
END.