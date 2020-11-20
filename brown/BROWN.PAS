PROGRAM Brownsche_Kueste;

USES  crt,graph,Farben;
CONST minx =   1;
      maxx =  60;
      miny =   1;
      maxy =  40;

      grafx  =  30;
      grafy  =  35;
      breite = 600;
      hoehe  = 400;

VAR   feld: array[minx..maxx] of array[miny..maxy] of real;
      m,n,erhebung,wi,relx,rely: real;
      gd,gm,i,z,x,y,x1,y1,x2,y2,anzahl: integer;
      c: char;
      s: string;
      Palette1: Palette;

PROCEDURE Initialize;
begin
  with Palette1 do
    for i:=0 to 7 do begin
      Farbe[i].NeuBenutzen(0,0,i*9);
      Farbe[i+8].NeuBenutzen(i*9,(7-i)*7,0)
    end;
  for i:=1 to 15 do begin
    setfillstyle(solidfill,i);
    bar(20*i+80,10,20*i+95,20);
  end;
  relx:=breite/(maxx-minx);
  rely:=hoehe/(maxy-miny);
  for x:=minx to maxx do
    for y:=miny to maxy do
      feld[x,y]:=8
end;

PROCEDURE Grafik;
begin
  repeat
    x1:=random(maxx-minx)-minx;
    x2:=random(maxx-minx)-minx;
  until x1<>x2;
  y1:=random(maxy-miny)-miny;
  y2:=random(maxy-miny)-miny;
  erhebung:=(random+random)-1;
  m:=(y2-y1)/(x2-x1);
  n:=(x1*y2-x2*y1)/(x1-x2);
  for x:=minx to maxx do
    for y:=miny to maxy do begin
      if y>m*x+n then feld[x,y]:=feld[x,y]+erhebung;
      if feld[x,y]<0 then feld[x,y]:=0;
      if feld[x,y]>15 then feld[x,y]:=15;
      setfillstyle(solidfill,round(feld[x,y]));
      bar(round(grafx+(x-minx)*relx),
          round(grafy+hoehe-(y-miny)*rely),
          round(grafx+(x-minx+1)*relx)-1,
          round(grafy+hoehe-(y-miny-1)*rely)-1);
    end;
end;

BEGIN
  gd:=detect;
  initgraph(gd,gm,'..\..\bgi');
  moveto(0,0);
  setviewport(0,0,639,479,true);
  Palette1.Init;
  Initialize;
  randomize;
  i:=0;
  anzahl:=1;
  repeat
    for z:=1 to anzahl do begin
      inc(i);
      wi:=sqrt(i);
      setfillstyle(solidfill,0);
      Grafik;
    end;
    c:=readkey;
    if c in ['1'..'9'] then val(c,anzahl,anzahl);
    case c of
      '0': anzahl:=10;
      '+': for x:=minx to maxx do
             for y:=miny to maxy do
               feld[x,y]:=feld[x,y]+0.5;
      '-': for x:=minx to maxx do
             for y:=miny to maxy do
               feld[x,y]:=feld[x,y]-0.5
    end
  until c=#27;
  closegraph
END.
