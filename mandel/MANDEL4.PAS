PROGRAM Mandelbrot; {$e+,n+}
USES  crt,graph,Farben,speaker;
TYPE  Complex = record
        Re: extended;
        Im: extended
      end;

CONST MorJ: integer = 0;          { 0 = Mandelbrotmenge
                                    1 = Juliamenge }
      minx: extended = -1.5;
      maxx: extended =  1.5;
      miny: extended = -1.0;
      maxy: extended =  1.0;
      step: extended =    0.1;

      konst: Complex = ( Re: 0.31;
                         Im: 0.04);

      konvrg =   0.001; {h”chstens 1}
      maxz   =  45;     {m”glichst Vielfaches von 15}

      grafx  =  30;
      grafy  =  35;
      breite = 600;
      hoehe  = 400;

VAR   x,y,relx,rely: extended;
      gd,gm,i,divis: integer;
      k:             char;
      s:             string;
      z0,z1,c:       Complex;
      betrag:        extended;
      Palette1:      Palette;


FUNCTION Mandel: integer;
begin
  if MorJ=0 then begin
    z0.Re:=konst.Re;
    z0.Im:=konst.Im;
    c.Re:=x;
    c.Im:=y
  end
  else begin
    z0.Re:=x;
    z0.Im:=y;
    c.Re:=konst.Re;
    c.Im:=konst.Im
  end;
  Mandel:=0;
  for i:=1 to maxz do begin
    z1.Re:=sqr(z0.Re)-sqr(z0.Im)+c.Re;
    z1.Im:=2*z0.Re*z0.Im+c.Im;
    z0.Re:=z1.Re;
    z0.Im:=z1.Im;
    betrag:=sqrt(sqr(z0.Re)+sqr(z0.Im));
    if betrag>1000 then begin
      Mandel:=i div divis;
      i:=maxz
    end
    else if betrag<=konvrg then i:=maxz
  end
end;

PROCEDURE Aufraeumen;
begin
  setfillstyle(solidfill,1);
  bar(grafx-1,grafy-1,grafx+breite-1,grafy+hoehe-1);
  for i:=1 to 15 do begin
    setfillstyle(solidfill,i);
    bar(20*i+80,10,20*i+95,20);
  end;
end;

PROCEDURE Option(c: char);
VAR difx,dify: extended;

  PROCEDURE SetBorder(mix,max,miy,may: extended);
  begin  minx:=mix; maxx:=max; miny:=miy; maxy:=may  end;

begin
  difx:=(maxx-minx)/3;
  dify:=(maxy-miny)/3;
  if c in ['1'..'9'] then step:=step/3;
  case c of
    '1': SetBorder(minx,minx+difx,miny,miny+dify);
    '2': SetBorder(minx+difx,maxx-difx,miny,miny+dify);
    '3': SetBorder(maxx-difx,maxx,miny,miny+dify);
    '4': SetBorder(minx,minx+difx,miny+dify,maxy-dify);
    '5': SetBorder(minx+difx,maxx-difx,miny+dify,maxy-dify);
    '6': SetBorder(maxx-difx,maxx,miny+dify,maxy-dify);
    '7': SetBorder(minx,minx+difx,maxy-dify,maxy);
    '8': SetBorder(minx+difx,maxx-difx,maxy-dify,maxy);
    '9': SetBorder(maxx-difx,maxx,maxy-dify,maxy);
    '+': step:=step/2;
    '-': step:=step*2;
    ' ': MorJ:=1-MorJ;
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
  divis:=maxz div maxcolors;
  repeat
    relx:=breite/(maxx-minx);
    rely:=hoehe/(maxy-miny);
    cleardevice;
    Aufraeumen;
    y:=maxy;
    repeat
      x:=minx;
      setcolor(white);
      str(trunc((maxy-y)*100/(maxy-miny)):2,s);
      outtextxy(30,12,s+' %');
      setfillstyle(solidfill,14);
      repeat
        setfillstyle(solidfill,Mandel);
        bar(round(grafx+(x-minx)*relx),round(grafy+hoehe-(y-miny)*rely),
            round(grafx+(x+step-minx)*relx)-2,round(grafy+hoehe-(y-step-miny)*rely)-2);
        x:=x+step
      until x>=maxx;
      y:=y-step;
      setfillstyle(solidfill,black);
      bar(30,10,60,20);
      if keypressed then begin
        x:=maxx; y:=miny; i:=maxz
      end
    until y<=miny;
    playsnd('*---ceg>c');
    repeat k:=readkey until k in ['1'..'9','+','-',' ',#27];
    Option(k)
  until k=#27;
  EndSnd;
  closegraph;
END.
