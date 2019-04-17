unit Farby; {Priamy_pristup_k_palete_VGA a praca s farbami}
interface
  const Dopredu=1;Dozadu=-1;
  procedure NastavFarbu(cislo,r,g,b:byte);
  procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
  procedure ZapniZobrazovanie;
  procedure VypniZobrazovanie;
  procedure RotujPaletu(zac,kon:byte;smer:shortint);
{  procedure StmavObrazovku;}
implementation
  procedure NastavFarbu(cislo,r,g,b:byte);
  begin
    port[$3C8]:=cislo;
    port[$3C9]:=r;
    port[$3C9]:=g;
    port[$3C9]:=b;
  end;
  procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
  var x:byte;
  begin
    port[$3C7]:=cislo;
    r:=port[$3C9];
    g:=port[$3C9];
    b:=port[$3C9];
  end;
  procedure VypniZobrazovanie;
  begin
    port[$3C6]:=$00;
  end;
  procedure ZapniZobrazovanie;
  begin
    port[$3C6]:=$FF;
  end;
  procedure RotujPaletu(zac,kon:byte;smer:shortint);
  var r,g,b,x,r1,g1,b1:byte;
  begin
    case smer of
      1:begin
        port[$3C7]:=kon;
        r1:=port[$3C9];
        g1:=port[$3C9];
        b1:=port[$3C9];
        for x:=kon-1 downto zac do begin
          port[$3C7]:=x;
          r:=port[$3C9];
          g:=port[$3C9];
          b:=port[$3C9];
          port[$3C8]:=x+1;
          port[$3C9]:=r;
          port[$3C9]:=g;
          port[$3C9]:=b;
        end;
        port[$3C8]:=zac;
        port[$3C9]:=r1;
        port[$3C9]:=g1;
        port[$3C9]:=b1;
      end;
    end;
  end;
end.