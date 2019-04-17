var n,m,x,i,j,k,l,il,jl,kl,ll:word;
BEGIN
  writeln('Napis koncove body intervalu');
  readln(n,m);
  for x:=n to m do begin
    for i:=0 to x do
      for j:=i to x do
        for k:=j to x do
          for l:=k to x do
            if i*i+j*j+k*k+l*l=x then begin
              il:=i;jl:=j;kl:=k;ll:=l;
            end;
    writeln(x,': ',il,',',jl,',',kl,',',ll);
  end;
END.