program Lupeznici;{uloha c. 49}
const pv=5;{pocet veci}
      v:array[1..pv] of byte=(1,4,6,7,8);
var cs,p,x:byte;{ciastkova suma,priemer}
    a:array[1..pv] of byte;
BEGIN
  p:=0;
  for x:=1 to pv do p:=p+v[x];
  p:=p div 2;
