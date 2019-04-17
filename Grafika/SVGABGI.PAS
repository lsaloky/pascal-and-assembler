program Mody_SVGA_pristupne_cez_BGI;
uses Graph;
var gd,gm:integer;
    maxx,maxy,maxcol:word;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=4;
  InitGraph(gd,gm,'d:\bp\bgi');
  SetColor(100);
  Line(100,100,200,200);
  maxx:=GetMaxx;
  maxy:=GetMAxy;
  maxcol:=GetMaxColor;
  readln;
  CloseGraph;
  writeln('Rozlisenie: ',maxx+1,' * ',maxy+1,' v ',maxcol+1,' farbach');
  readln;
end.
{driver             mod               rozlisenie       pocet farieb}
{egavga             0                 640 x 200        16          }
{                   1                 640 x 350        16          }
{                   2                 640 x 480        16          }
{vesa16             0                 800 x 600        16          }
{                   1                 1024 x 768       16          }
{                   2 (nejde)         1280 x 1024      16          }
{svga256            0                 320 x 200        256         }
{                   2 (s UNIVESA.EXE) 640 x 480        256         }
{                   3 (s UNIVESA.EXE) 800 x 600        256         }
{                   4 (s UNIVESA.EXE) 1024 x 768       256         }