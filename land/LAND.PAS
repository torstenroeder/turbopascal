program landgenerator;
uses    crt,graph,mathe;
const   maxx=100;
        maxy=100;
        landfaktor: real=4.2;
        schwingung: real=0.45;
        staedte: integer=40;
        ende: boolean=false;
        farbe: array[1..6] of integer
               =(1,9,10,2,6,14);
var     feld:  array[0..maxx+1] of array[0..maxy+1] of integer;
        wk: real;
        gd,gm,x,y,grafx,grafy: integer;
        c: char;
        s: string;
        i: integer;


procedure land;
begin
  wk:=(feld[x,y-1]+feld[x+1,y]+feld[x,y+1]+feld[x-1,y])
      /(sgn(feld[x,y-1])+sgn(feld[x+1,y])
      +sgn(feld[x,y+1])+sgn(feld[x-1,y]));
  wk:=wk+(random*landfaktor-1)*schwingung;
  if wk<1 then wk:=1;
  if wk>6 then wk:=6;
  feld[x,y]:=trunc(wk);
  putpixel(x*3+grafx,y*3+grafy,farbe[feld[x,y]])
end;


begin
  gd:=detect;
  initgraph(gd,gm,'..\BGI');
  moveto(0,0);
  setviewport(0,0,639,479,true);
  randomize;
  grafx:=(640-3*maxx) div 2;
  grafy:=(480-3*maxy) div 2;
  c:='3';
  for x:=0 to maxx+1 do begin
    feld[x,0]:=1;
    putpixel(x*3+grafx,grafy,farbe[feld[x,0]]);
    feld[x,maxy+1]:=1;
    putpixel(x*3+grafx,(maxy+1)*3+grafy,farbe[feld[x,maxy+1]])
  end;
  for y:=0 to maxy+1 do begin
    feld[0,y]:=1;
    putpixel(grafx,y*3+grafy,farbe[feld[0,y]]);
    feld[maxx+1,y]:=1;
    putpixel((maxx+1)*3+grafx,y*3+grafy,farbe[feld[maxx+1,y]])
  end;
  repeat
    for x:=1 to maxx do
      for y:=1 to maxy do
        feld[x,y]:=0;
    setfillstyle(1,black);
    bar(grafx+1,grafy+1,grafx+maxx*3+2,grafy+maxy*3+2);
    case c of
    '1': for y:=1 to maxx do
           for x:=1 to maxy do
             land;
    '2': for y:=1 to maxx do begin
           for x:=1 to maxy do
             land;
           y:=y+1;
           for x:=maxy downto 1 do
             land
         end;
    '3': begin
           y:=1;
           for i:=1 to (maxx div 2) do begin
             for x:=i to maxx-i+1 do land;
             for y:=i+1 to maxy-i+1 do land;
             for x:=maxx-i downto i do land;
             for y:=maxy-i downto i+1 do land
           end
         end;
    '4': begin
           i:=0;
           repeat
             x:=random(maxx+1);
             y:=random(maxy+1);
             if (feld[x,y]=0)
               and ((feld[x+1,y]>0) or (feld[x,y+1]>0)
                  or (feld[x-1,y]>0) or (feld[x,y-1]>0))
             then begin
               land;
               i:=i+1
             end
           until i=(maxx)*(maxy)
         end;
    '5': begin
           i:=0;
           repeat
             x:=random(maxx+1);
             y:=random(maxy+1);
             if feld[x,y]=0 then i:=i+1;
             feld[x,y]:=1;
             putpixel(x*3+grafx,y*3+grafy,farbe[feld[x,y]])
           until i=20;
           repeat
             x:=random(maxx+1);
             y:=random(maxy+1);
             if (feld[x,y]=0)
                and ((feld[x+1,y]>0) or (feld[x,y+1]>0)
                  or (feld[x-1,y]>0) or (feld[x,y-1]>0))
             then begin
               land;
               i:=i+1
             end
           until i=(maxx)*(maxy)
         end;
    '6': begin
           i:=0;
           repeat
             x:=random(maxx+1);
             y:=random(maxy+1);
             if feld[x,y]=0 then i:=i+1;
             feld[x,y]:=1;
             putpixel(x*3+grafx,y*3+grafy,farbe[feld[x,y]])
           until i=20;
           repeat
             x:=random(maxx+1);
             y:=random(maxy+1);
             if (feld[x+1,y]>0) or (feld[x,y+1]>0)
                or (feld[x-1,y]>0) or (feld[x,y-1]>0)
             then begin
               if feld[x,y]=0 then i:=i+1;
               land
             end
           until i=(maxx)*(maxy)
         end
    end;
    setcolor(red);
    for i:=1 to staedte do begin
      repeat
        x:=succ(random(maxx));
        y:=succ(random(maxy))
      until feld[x,y]>2;
      circle(x*3+grafx,y*3+grafy,2)
    end;
    setcolor(white);
    repeat
      bar(100,10,140,60);
      str(landfaktor:3:2,s);
      outtextxy(10,10,'Landfaktor: '+s);
      str(schwingung:3:2,s);
      outtextxy(10,25,'Schwingung: '+s);
      str(staedte,s);
      outtextxy(10,40,'St„dte:     '+s);
      c:=readkey;
      case c of
        #59: landfaktor:=landfaktor-0.2;
        #60: landfaktor:=landfaktor-0.02;
        #61: landfaktor:=landfaktor+0.02;
        #62: landfaktor:=landfaktor+0.2;
        #63: schwingung:=schwingung-0.1;
        #64: schwingung:=schwingung-0.01;
        #65: schwingung:=schwingung+0.01;
        #66: schwingung:=schwingung+0.1;
        #67: staedte:=staedte-1;
        #68: staedte:=staedte+1;
        #27: ende:=true
      end
    until ende or (c in ['1'..'6'])
  until ende;
  closegraph
end.
