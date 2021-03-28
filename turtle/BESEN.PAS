program Besen;

uses graph,turtle,crt;

const MaxLaenge1 = 5;
      MaxLaenge2 = 3;
      MaxLaenge3 = 3;
      MaxLaenge4 = 10;
      Faktor1 = 0.72;
      Faktor2 = 0.68;

var gd,gm: integer;
    Eingabe: char;


procedure Borsten1(l: real);
var MerkX,MerkY: integer;
begin
  MerkX:=TurtleX;
  MerkY:=TurtleY;
  Forwd(l);
  Hideturtle;
  Back(l/4);
  Left(80);
  Forwd(l/4);
  Showturtle;
  if l>MaxLaenge1 then Borsten1(7*l/12);
  Forwd(7*l/12);
  Hideturtle;
  Forwd(l/4);
  Right(40);
  Back(3*l/2);
  Showturtle;
  if l>MaxLaenge1 then Borsten1(7*l/12);
  Forwd(7*l/12);
  Right(40);
  Push(MerkX,MerkY);
end;

procedure Borsten2(l: real);
begin
  Forwd(l);
  Right(30);
  if l>MaxLaenge2 then Borsten2(l*Faktor1)
  else
  begin
    Forwd(l*Faktor1);
    Back(l*Faktor1);
  end;
  Left(30);
  Back(l);
  Left(60);
  if l>MaxLaenge2 then Borsten2(l*Faktor1)
  else
  begin
    Forwd(l*Faktor1);
    Back(l*Faktor1);
  end;
  Right(60);
end;

procedure Borsten3(l: real);
begin
  Forwd(l/2);
  Right(30);
  if l>MaxLaenge3 then Borsten3(l*Faktor2)
  else
  begin
    Forwd(l*Faktor2);
    Back(l*Faktor2)
  end;
  Left(120);
  if l>MaxLaenge3 then Borsten3(l*Faktor2)
  else
  begin
    Forwd(l*Faktor2);
    Back(l*Faktor2)
  end;
  Right(90);
  Back(l/2);
end;

procedure Borsten4(l: real);
begin
  HideTurtle;
  Back(l/2);
  Right(30);
  ShowTurtle;
  if l>3 then Borsten4(l*0.7)
  else begin
    Forwd(l*0.7);
    Back(l*0.7);
  end;
  HideTurtle;
  Left(30);
  Forwd(l/2);
  ShowTurtle;
  Forwd(l);
  HideTurtle;
  Forwd(l/2);
  Left(150);
  ShowTurtle;
  if l>3 then Borsten4(l*0.7)
  else begin
    Forwd(l*0.7);
    Back(l*0.7);
  end;
  HideTurtle;
  Right(150);
  Back(l/2);
  Back(l);
end;

{---- Hauptprogramm ----}
begin
  clrscr;
  writeln('Beispielnummer eingeben (1-4):');
  repeat
    Eingabe:=readkey
  until Eingabe in ['1'..'4',#27];
  if Eingabe=#27 then halt;
  gd:=detect;
  setviewport(0,0,639,479,true);
  initgraph(gd,gm,'..\..\bgi');
  setbkcolor(blue);
  clearviewport;
  case Eingabe of
    '1': begin
           PutTurtle(-70,-50);
           Right(90);
           Borsten1(200);
         end;
    '2': begin
           PutTurtle(-120,-60);
           Right(60);
           Borsten2(150);
         end;
    '3': begin
           PutTurtle(-120,-100);
           Right(60);
           Borsten3(250);
         end;
    '4': begin
           PutTurtle(-90,0);
           Right(90);
           Borsten4(170);
         end
  end;
  readln;
  closegraph
end.
