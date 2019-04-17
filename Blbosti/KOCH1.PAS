program Koch_1; {prvy pokus s Kochom}
uses MainGr;
var PalP:pointer;
procedure Koch(XZac,YZac,XKon,YKon:integer);
var XTret,YTret,XDveTret,YDveTret,XMimo,YMimo:integer;
begin
  if Abs(XZac-XKon)+Abs(YZac-YKon)<40 then
    PolozBod(XZac,YZac,15)
  else begin
    Ciara(XZac,YZac,XKon,YKon);
    XTret:=XZac+Round((XKon-XZac)/3);
    YTret:=YZac+Round((YKon-YZac)/3);
    XDveTret:=XKon-Round((XKon-XZac)/3);
    YDveTret:=YKon-Round((YKon-YZac)/3);
    XMimo:=XZac+Round((XKon-XZac)/2+(YKon-YZac)/1.73);
    YMimo:=YZac+Round((XKon-XZac)/1.73-(YKon-YZac)/2);
    Koch(XZac,YZac,XTret,YTret);
    Koch(XTret,YTret,XMimo,YMimo);
    Koch(XMimo,YMimo,XDveTret,YDveTret);
    Koch(XDveTret,YDveTret,XKon,YKon);
  end;
end;
BEGIN
  NacitajPaletu('Prechody.MP',PalP);
  InicializujGrafiku;
  NastavPaletu(PalP);
  Color:=15;
  Koch(100,100,200,100);
  CitajZnak;
END.