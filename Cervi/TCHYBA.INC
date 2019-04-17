procedure TChyba.Cislo(Ktore:word);
begin
  case Ktore of
    1:begin
      WriteLn('Druhy pocitac prerusil spojenie.');
      Hmyz.Done;
      Halt(Ktore);
    end;
  end;
end;