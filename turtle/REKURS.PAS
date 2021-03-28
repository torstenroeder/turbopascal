PROGRAM rekursionen;
USES crt,graph,turtle;
VAR  gd,gm,i: integer;
     l:       real;
     a:       char;

PROCEDURE peano;
  procedure p(n,s,w: real);
  begin
    if (n>0) then begin
      Left(w);
      p(n-1,s,-w);
      Forwd(s);
      Right(w);
      p(n-1,s,w);
      Forwd(s);
      p(n-1,s,w);
      Right(w);
      Forwd(s);
      p(n-1,s,-w);
      Left(w);
    end;
  end;
begin
  PutTurtle(180,-180);
  p(6,6,90);
end;

PROCEDURE westwindbaum;
  procedure baum(l: real);
  begin
    Forwd(l);
    Left(30);
    if l>5 then baum(l*(3/4))
      else circle(xcor,ycor,3);
    Right(90);
    if l>5 then baum(l*(2/3)) else
      circle(xcor,ycor,3);
    Left(60);
    Back(l)
  end;
begin
  PutTurtle(0,-180);
  baum(100)
end;

PROCEDURE kocheck;
  procedure linie(l:real);
  begin
    if l<4 then Forwd(l) else linie(l/3); Left(60);
    if l<4 then Forwd(l) else linie(l/3); Right(120);
    if l<4 then Forwd(l) else linie(l/3); Left(60);
    if l<4 then Forwd(l) else linie(l/3)
  end;
begin
  PutTurtle(-120,-120);
  for i:=1 to 3 do
  begin
    linie(100);
    Right(120)
  end
end;

PROCEDURE pyramide;
  procedure spirale(l: real);
  begin
    Forwd(l);
    Right(89);
    if l>1 then spirale(l*0.99)
  end;
begin
  setlinestyle(1,0,0);
  PutTurtle(-180,-180);
  spirale(380)
end;

PROCEDURE sommer;
  procedure linie(l:integer);
  var i: integer;
  begin
    for i:=1 to 6 do
      begin
        Forwd(l);
        if l>5 then linie(l div 3);
        Back(l);
        Right(60)
      end
  end;
begin
  setlinestyle(0,0,0);
  PutTurtle(0,20);
  linie(108)
end;

PROCEDURE dreieck;
  procedure seite(l:real);
  var i:integer;
  begin
    for i:=1 to 3 do
    begin
      Forwd(l);
      Right(120);
      if l>6 then seite(l/2)
    end;
  end;
begin
  PutTurtle(-140,-120);
  Right(30);
  seite(320)
end;

PROCEDURE hallo;
  procedure linie(l: real);
  begin
    if l<25 then Forwd(l/2) else linie(l/2);
    Left(90);
    if l<25 then Forwd(l/4) else linie(l/4);
    Right(180);
    if l<25 then Forwd(l/2) else linie(l/2);
    Left(180);
    if l<25 then Forwd(l/4) else linie(l/4);
    Right(90);
    if l<25 then Forwd(l/2) else linie(l/2);
  end;
begin
  PutTurtle(-120,120);
  Right(90);
  for i:=1 to 3 do
  begin
    linie(240);
    Right(120);
  end
end;

BEGIN
  gd:=detect;
  setviewport (0,0,639,479,true);
  repeat
    clrscr;
    gotoxy(1,5);
    writeln('ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»');
    writeln('º                    Menu                        º');
    writeln('ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶');
    writeln('º            A.....Peano                         º');
    writeln('º            B.....Westwindbaum                  º');
    writeln('º            C.....Kochsche Kurve                º');
    writeln('º            D.....Pyramide                      º');
    writeln('º            E.....Sommer                        º');
    writeln('º            F.....Dreieck                       º');
    writeln('º            esc...beenden                       º');
    writeln('ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶');
    writeln('º              Deine Wahl:                       º');
    writeln('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
    gotoxy(30,16);
    a:=readkey;
    if a in ['a'..'g'] then
    begin
      initgraph(gd,gm,'..\..\bgi');
      cleardevice;
      case a of
        'a': peano;
        'b': westwindbaum;
        'c': kocheck;
        'd': pyramide;
        'e': sommer;
        'f': dreieck;
        'g': hallo;
      end;
      repeat until readkey<>'';
      closegraph
    end;
  until a=chr(27)
END.
