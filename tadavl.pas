unit tadavl;

{$mode ObjFPC}{$H+}

interface

type
  arbol = ^nodo;
  nodo = record
    info : LongInt;
    de   :   string;
    izq, der : arbol;
    Fe : -1..1;
  end;

  procedure inicializar (var a : arbol);
  function vacio (a : arbol) : boolean;
  // Inserta la provincia descrip con dato e.
  procedure insertar (var a : arbol; e : LongInt; descrip : string; var sw : boolean);
  // Borra la provincia descrip.
  procedure borrar (var a : arbol;e : LongInt; descrip : string; var sw : boolean);
  // Busca el dato más aproximado al dado ; dato : poblacion o extension y descrip es nombre de provincia.
  procedure buscar (a : arbol; c : integer; var encontrado : boolean; var dato : LongInt; var descrip : string;
    var diff : longint);
  // Recorrer y buscar si se le pasa una provincia.
  procedure recorreras (a : arbol; descrip : string; var dato : LongInt);
  procedure recorrerdes (a : arbol; descrip : string; var dato : LongInt);

  procedure sumatoriodato (a : arbol;var suma : longint);
  procedure mayordato (a : arbol; var descrip : string;  var dato : LongInt);
  procedure menordato (a : arbol; var descrip : string;  var dato : LongInt);

implementation

  procedure inicializar(var a: arbol);
  begin
    a:=nil;
  end;

  function vacio (a : arbol) : boolean;
  begin
    vacio:=a = nil;
  end;

  procedure buscar (a : arbol; c : integer; var encontrado : boolean; var dato : LongInt; var descrip : string;
    var diff : longint);
  begin
    if vacio(a) then
      exit
    else
      // Actualiza el encontrar el más parecido.
      if (Abs(c-a^.info)<diff) then
      begin
        encontrado:=true;
        dato:=a^.info;
        descrip:=a^.de;
        diff:=Abs(c-a^.info)
      end;
      // Seleccionamos el lado de arbol.
      if (a^.info > c) then
        buscar (a^.izq,c,encontrado,dato,descrip,diff)
      else
        buscar (a^.der,c,encontrado,dato,descrip,diff)
  end;

  function construir (a : arbol; e : integer; descrip : string; b: arbol) : arbol;
  var
    nuevo : arbol;
  begin
    new (nuevo); nuevo^.info:=e; nuevo^.de:=descrip;
    nuevo^.izq :=a; nuevo^.der:=b;
    construir:=nuevo;
  end;

  // ROTACIONES.
  procedure rotacioniisimple (var a: arbol);
  var
    p : arbol;
  begin
    p:=a^.izq; a^.izq:=p^.der; p^.der:=a;
    p^.Fe := 0; a^.Fe:=0;
    a:=p;
  end;

  procedure rotacionddsimple (var a: arbol);
  var
    p : arbol;
  begin
    p:=a^.der; a^.der:=p^.izq; p^.izq:=a;
    p^.Fe:=0; a^.Fe:=0;
    a:=p;
  end;

  procedure rotacionddoble (var a : arbol);
  var
    p1,p2 : arbol;
  begin
    p1:=a^.izq; p2:=p1^.der; p1^.der:=p2^.izq;
    p2^.izq:=p1; a^.izq:=p2^.der; p2^.der:=a;
    if p2^.Fe = 1 then
       p1^.Fe:=-1
    else
      p1^.Fe:=0;
    if p2^.Fe = -1 then
       a^.Fe:=1
    else
      a^.Fe:=0;
    p2^.Fe:=0;
    a := p2;
  end;

  procedure rotaciondidoble (var a:arbol);
  var
    p1,p2 : arbol;
  begin
    p1:=a^.der; p2:=p1^.izq; p1^.izq:=p2^.der;
    p2^.der:=p1; a^.der:=p2^.izq; p2^.izq:=a;
    if p2^.Fe = 1 then
      a^.Fe:=-1
    else
      a^.Fe:=0;
    if p2^.Fe = -1 then
      p1^.Fe:=1
    else
      p1^.Fe:=0;
    p2^.Fe:=0;
    a:=p2
  end;

  procedure actualizarizq (var a : arbol; var sw :  boolean);
  begin
    case a^.Fe of
         1 :   begin
                    a^.Fe:=0;
                    sw:=false
               end;
         0 :   a^.Fe:=-1;
         -1 :  begin
                    if a^.izq^.Fe = -1 then
                      rotacioniisimple(a)
                    else
                      rotacionddoble(a);
                    sw := false;
               end;
    end;
  end;

  procedure actualizarder (var a : arbol; var sw :  boolean);
  begin
    case a^.Fe of
         -1 :   begin
                    a^.Fe:=0;
                    sw:=false
               end;
         0 :   a^.Fe:=1;
         1 :  begin
                    if a^.der^.Fe = 1 then
                      rotacionddsimple(a)
                    else
                      rotaciondidoble(a);
                    sw := false;
               end;
    end;
  end;

  procedure insertar (var a : arbol; e : LongInt; descrip : string; var sw : boolean);
  begin
    if vacio(a) then
      begin
        a:=construir(nil,e,descrip,nil);
        a^.Fe := 0;
        sw := true;
      end
    else
    begin
       if a^.info > e then
         begin
           insertar(a^.izq,e,descrip,sw);
           if sw then actualizarizq (a,sw)
         end
       else
         if a^.info < e then
           begin
             insertar(a^.der,e,descrip,sw);
             if sw then actualizarder (a,sw)
           end
       else
         sw:=false
    end;
  end;

  procedure rotacionii2 (var a: arbol);
  var
    p : arbol;
  begin
    p:= a^.izq; a^.izq:=p^.der; p^.der:=a;
    p^.Fe:=1; a^.Fe:=-1;
    a:=p;
  end;

  procedure rotaciondd2 (var a : arbol);
  var
    p : arbol;
  begin
    p:=a^.der; a^.der:=p^.izq; p^.izq:=a;
    p^.Fe:=-1; a^.Fe:=1;
    a:=p;
  end;

  procedure menor (a : arbol; var e : integer;var descrip : string);
  begin
    if a^.izq = nil then
    begin
      e:=a^.info; descrip:=a^.de;
    end
    else
      menor (a^.izq,e,descrip);
  end;

  procedure actualizarbi (var a : arbol; var sw : boolean);
  begin
    case a^.Fe of
         -1 : a^.Fe:=0;
         0  : begin
                a^.Fe:=1;
                sw:=false;
              end;
         1  : case a^.der^.Fe of
                1  :   rotacionddsimple(a);
                -1 : rotaciondidoble(a);
                0  : begin
                       rotaciondd2(a);
                       sw:=false
                     end;
         end;
    end;
  end;

  procedure actualizarbd (var a : arbol; var sw : boolean);
  begin
    case a^.Fe of
         1 : a^.Fe:=0;
         0  : begin
                a^.Fe:=-1;
                sw:=false;
              end;
         -1  : case a^.izq^.Fe of
                -1  :   rotacioniisimple(a);
                1 : rotacionddoble(a);
                0  : begin
                       rotacionii2(a);
                       sw:=false
                     end;
         end;
    end;
  end;

  procedure eliminar(var a:arbol; var sw : boolean);
  var
    auxi : arbol;
    e : integer;
    descrip : string;
  begin
    if a^.izq = nil then
      begin
        auxi := a; a:=a^.der;
        dispose(auxi);
        sw:=true
      end
    else
      if a^.der = nil then
        begin
          auxi:=a; a:=a^.izq;
          dispose(auxi);
          sw:=true
        end
    else
      begin
         menor (a^.der,e,descrip);
         a^.info:=e;
         a^.de:=descrip;
         borrar(a^.der,e,descrip,sw);
         if sw then actualizarder(a,sw);
      end;
  end;

  procedure borrar (var a : arbol;e : longint;descrip : string; var sw : boolean);
  var
    c : LongInt;
  begin
    if vacio(a) then
      sw:=false
    else
      if a^.de = descrip then
        eliminar(a,sw)
      else
        begin
          c:=a^.info;
          if a^.info > e then
            begin
              borrar (a^.izq,e,descrip,sw);
              if sw then actualizarbi(a,sw);
            end
            else
              begin
                borrar(a^.der,e,descrip,sw);
                if sw then actualizarbd(a,sw);
            end;

        end;
  end;

  procedure recorreras (a : arbol; descrip : string; var dato : LongInt);
  begin
    if not vacio(a) then
      begin
        recorreras (a^.izq,descrip,dato);
        write (a^.de) ; write (' : '); writeln(a^.info);
        if a^.de=descrip then
          dato := a^.info;
        recorreras (a^.der,descrip,dato);
      end;
  end;

  procedure recorrerdes (a : arbol; descrip : string; var dato : LongInt);
  begin
    if not vacio(a) then
      begin
        recorrerdes (a^.der,descrip,dato);
        write (a^.de) ; write (' : '); writeln(a^.info);
        if a^.de=descrip then
          dato := a^.info;
        recorrerdes (a^.izq,descrip,dato);
      end;
  end;

  procedure sumatoriodato (a : arbol;var suma : LongInt);
  begin
    if not vacio(a) then
      begin
        sumatoriodato (a^.der,suma);
        suma:=suma + a^.info;
        sumatoriodato (a^.izq,suma);
      end;
  end;

  procedure mayordato (a : arbol; var descrip : string;  var dato : LongInt);
  begin
    if not vacio(a) then
      begin
        mayordato (a^.der,descrip,dato);
        if (a^.info>dato) then
          begin
            descrip:=a^.de;
            dato:=a^.info;
          end;
        mayordato (a^.izq,descrip,dato);
      end;
  end;

  procedure menordato (a : arbol; var descrip : string;  var dato : LongInt);
  begin
    if not vacio(a) then
      begin
        menordato (a^.der,descrip,dato);
        if (a^.info<dato) or (dato=0) then
          begin
            descrip:=a^.de;
            dato:=a^.info;
          end;
        menordato (a^.izq,descrip,dato);
      end;
  end;


end.


