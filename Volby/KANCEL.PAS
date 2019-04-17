procedure InitKancelaria;
begin
  PoslKauza:=0;
  Datum.Den:='26';
  Datum.Mesiac:='7';
  Datum.Rok:='1998';
end;
{ ----- KANCELARIA / KORESPONDENCIA ----- }

const AktivPosta:array[1..5,1..4] of word=(
        (13,152,93,168),(106,152,186,168),(63,174,143,190),(240,184,319,199),
        (400,0,0,0));
      KlavPosta:array[1..5] of char=('p','d','r','n',#255);

procedure Korespondencia;
begin
  repeat
    VykresliMGP(MGPPomP[5],@MBP,@MSFP);
    Udalost:=ObsluzUdalost(@AktivPosta,@KlavPosta);
    CakajNaPustenie;
    case Udalost of
      1:begin
      end;
    end;
  until (Udalost=4) or (Udalost=0);
end;

{ -------------------------------------------------------------------------- }

{ -------------------------------------------------------------------------- }


{ -------------------------------------------------------------------------- }

{ ----- KANCELARIA ----- }

const AktivKan:array[1..9,1..4] of word=(
        (0,22,60,88),(65,76,175,128),(0,170,180,195),(182,21,302,51),
        (182,62,302,92),(220,103,310,148),(220,169,319,198),(311,1,312,2),
        (400,0,0,0));
      KlavKan:array[1..9] of char=('v','k','p','e','l','n','t','~',#255);

procedure Kancelaria;
begin
  repeat
    VykresliMGP(MGPPomP[4],@MBP,@MSFP);
    Udalost:=ObsluzUdalost(@AktivKan,@KlavKan);
    CakajNaPustenie;
    if (Udalost>0) and (Udalost<>7) then begin
      case Udalost of
        1:VolebnyProgram;
        2:Korespondencia;
        4:Telefon;
        5:TajnaLinka;
        8:if DebugMode then begin
          ZobrazInformacie;
          CakajNaUdalost;
        end;
      end;
      Udalost:=1;  {aby hned neukoncil kancelariu}
    end;
  until (Udalost=7) or (Udalost=0);
end;
