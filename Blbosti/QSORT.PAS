program mojQSort;            {trapne pomaly}
{$R-,S-}
var Data:array[1..20002] of integer;
    x,y:integer;
begin
data[20001]:=0;
data[20002]:=0;
for x:=1 to 20000 do data[x]:=random(29999);
for x:=1 to 20000 do begin
  if Data[x+1]<Data[x] then begin
    y:=data[x+1];
    Move(data[1],data[2],2*x);
    data[1]:=y;
  end;
end;
end.

{    Origin l triediaca rutina od Borlandu - nehor zne rychla}
{program QSort}
const Max = 20000;
type List = array[1..Max] of Integer;
var Data: List;
    I: Integer;
procedure QuickSort(var A: List; Lo, Hi: Integer);
procedure Sort(l, r: Integer);
var i, j, x, y: integer;
begin
  i := l;    {index zaciatku pola}
  j := r;    {index posledn‚ho prvku pola}
  x := a[(l+r) DIV 2]; {prostredny prvok pola}
  repeat
    while a[i] < x do i := i + 1;  {hlad  1. c¡slo - vacsie ako x od zaciatku}
    while x < a[j] do j := j - 1;  {hlad  2. c¡slo - vacsie ako x od konca}
    if i <= j then
    begin
      y := a[i]; a[i] := a[j]; a[j] := y;  {vymen¡ 1. a 2. c¡slo}
      i := i + 1; j := j - 1;              {zmen¡ indexy a ide dalej}
    end;
  until i > j;                             {opakuje, az kym nedojde do stredu}
  if l < j then Sort(l, j);                {ak dojde az na druhy koniec pola, zavol  proced£ru rekurz¡vne}
  if i < r then Sort(i, r);
end;

begin {QuickSort};
  Sort(Lo,Hi);
end;

begin {QSort - hlavny program}
  Randomize;
  for i := 1 to Max do Data[i] := Random(30000);
  QuickSort(Data, 1, Max);
end.
