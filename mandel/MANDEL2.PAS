PROGRAM Mandelbrot; {$e+,n+}
USES  crt,graph,Farben,speaker;
TYPE  Complex = record
        Re: extended;
        Im: extended
      end;
CONST minx = -2;
      maxx =  1;
      miny = -1;
      maxy =  1;

      step = 0.02;
      maxz = 10;

      grafx  =  30;
      grafy  =  35;
      breite = 600;
      hoehe  = 400;
VAR   x,y,relx,rely: real;
      gd,gm,i:       integer;
      s:             string;
      z0,z1:         Complex;
      Palette1:      Palette;

FUNCTION Mandel: integer;
begin
  z0.Re:=0;
  z0.Im:=0;
  for i:=1 to maxz do begin
    z1.Re:=sqr(z0.Re)-sqr(z0.Im)+x;
    z1.Im:=2*z0.Re*z0.Im+y;
    z0.Re:=z1.Re;
    z0.Im:=z1.Im
  end;
  if (z0.Re=0) and (z0.Im=0) then Mandel:=15 else
  Mandel:=15-round(ln(sqrt(z0.Re*z0.Re+z0.Im*z0.Im))/ln(10))
end;

BEGIN
  gd:=detect;
  initgraph(gd,gm,'..\bgi');
  moveto(0,0);
  setviewport(0,0,639,479,true);
  InitSnd;
  Palette1.Init;
  with Palette1 do
  for i:=0 to 7 do begin
    Farbe[i].NeuBenutzen(i*9,0,0);
    Farbe[i+7].NeuBenutzen(63,i*9,0);
  end;
  for i:=1 to 14 do begin
    setfillstyle(solidfill,i);
    bar(10*i+80,10,10*i+85,20);
  end;
  Palette1.Farbe[14].Benutzen;
  setfillstyle(solidfill,0);
  relx:=breite/(maxx-minx);
  rely:=hoehe/(maxy-miny);
  y:=maxy;
  repeat
    x:=minx;
    str(trunc((maxy-y)*100/(maxy-miny)):2,s);
    outtextxy(30,12,s+' %');
    repeat
      setfillstyle(solidfill,Mandel);
      bar(round(grafx+(x-minx)*relx),round(grafy+hoehe-(y-miny)*rely),
          round(grafx+(x+step-minx)*relx),round(grafy+hoehe-(y-step-miny)*rely)-1);
      x:=x+step
    until x>maxx;
    y:=y-step;
    setfillstyle(solidfill,0);
    bar(30,10,60,20);
  until y<miny;
  playsnd('*---ceg>c');
  repeat until keypressed;
  EndSnd;
  closegraph;
END.
