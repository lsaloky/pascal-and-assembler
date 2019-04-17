program EditorGrafickychProcesov;{verzia 1.3 s OOP}
uses MainGr,PomGr,Mys;

{ ----- globalne konstanty a staticke premenne mimo objektov ----- }

const PocetEMB=9;PocetEMGP=15;
      Adresar='d:\lubo\pascal\editory\';
var EMBP:array[1..PocetEMB]of pointer;       {Editor, .MB, pointer}
    EMGPP:array[1..PocetEMGP]of pointer;     {Editor, .MGP, pointer}
    EFP,EPalP:pointer;                       {Editor, Font, pointer; Editor, Paleta, pointer;}
    f:file;
    i,j:integer;

{ ----- deklaracia objektov ----- }

type TEditor=object
       public
         constructor Init;
         procedure Zobraz;
       private
         Udalost:word;
     end;

     PEditorBitmap=^TEditorBitmap;
     TEditorBitmap=object(TEditor)
       public
         constructor Init(p1,p2,p3,p4,p5,p6:word);
         procedure Zobraz;
         procedure ObsluzUdalost;
       private
         MiniX,MiniY,EditX,EditY,Farba,Mierka:word;
     end;

     PEditorMGP=^TEditorMGP;
     TEditorMGP=object(TEditor)
       public
         constructor Init;
         procedure Zobraz;
         procedure ObsluzUdalost;
       private
     end;
{ ----- objekt TEditor ----- }

constructor TEditor.Init;
begin
end;
procedure TEditor.Zobraz;
begin
end;

{ ----- objekt TEditorBitmap ----- }

constructor TEditorBitmap.Init(p1,p2,p3,p4,p5,p6:word);
begin
  Inherited Init;
  MiniX:=p1;MiniY:=p2;
  EditX:=p3;EditY:=p4;
  Mierka:=p5;Farba:=p6;
end;
procedure TEditorBitmap.Zobraz;
begin
end;
procedure TEditorBitmap.ObsluzUdalost;
begin
end;

{ ----- objekt TEditorMGP ----- }

constructor TEditorMGP.Init;
begin
  NacitajFont('Hlavny8.MSF',EFP);
  AttrCitaj.Font:=EFP;
  NacitajPaletu('Prechody.MP',EPalP);
  Assign(f,Adresar+'Mgp12.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetEMB do NacitajBMP(f,EMBP[i]);
  Close(f);
  Assign(f,Adresar+'Mgp12.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetEMGP do NacitajMGP(f,EMGPP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(EPalP);
end;
procedure TEditorMGP.Zobraz;
begin
end;
procedure TEditorMGP.ObsluzUdalost;
begin
end;
{ ----- hlavny program ----- }

var EditorBitmap:PEditorBitmap;
    EditorMGP:PEditorMGP;
BEGIN
  New(EditorMGP,Init);
  New(EditorBitmap,Init(100,0,110,30,5,5));
END.