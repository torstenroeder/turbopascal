PROGRAM Mandelbrot; {$e+,n+}
USES  crt,graph,Farben,speaker;
TYPE  Complex = record
        Re: extended;
        Im: extended
      end;
CONST minx = -1.5;
      maxx =  1.5;
      miny = -1;
      maxy =  1;

      step   = 0.02;
      maxz   = 100;
      konvrg = 0.01;
      divis  = 2;
      border = 1;

      grafx  =  30;
      grafy  =  35;
      breite = 600;
      hoehe  = 400;
VAR   x,y,relx,rely: real;
      betrag:        extended;
      gd,gm,i:       integer;
      s:             string;
      z0,z1,c:       Complex;
      Palette1:      Palette;


FUNCTION Mandel: integer;
begin
  z0.Re:=x;
  z0.Im:=y;
  c.Re:=-1;
  c.Im:=0;
  Mandel:=0;
  for i:=1 to maxz do begin
    z1.Re:=sqr(z0.Re)-sqr(z0.Im)+c.Re;
    z1.Im:=2*z0.Re*z0.Im+c.Im;
    z0.Re:=z1.Re;
    z0.Im:=z1.Im;
    betrag:=sqrt(sqr(z0.Re)+sqr(z0.Im));
    if betrag<=konvrg then begin
      Mandel:=15-(i div divis);
      i:=maxz
    end
    else if betrag>1000 then i:=maxz
  end;
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
    Farbe[i+8].NeuBenutzen(63,i*9,0);
  end;
  Palette1.Farbe[0].Zeichnen;
  for i:=1 to 15 do begin
    setfillstyle(solidfill,i);
    bar(20*i+80,10,20*i+95,20);
  end;
  Palette1.Farbe[15].Zeichnen;
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
      bar(round(grafx+(x-minx)*relx),
          round(grafy+hoehe-(y-miny)*rely),
          round(grafx+(x+step-minx)*relx)-border,
          round(grafy+hoehe-(y-step-miny)*rely)-border);
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
