program proarbolesequilibrados;

uses sysutils,tadavl;

var
  arbol_prov_pob : arbol;
  sw_uso_pob  : boolean;
  encontrado : boolean;
  dato : longint;
  descripcion : string;
  dato_s : string;
  diff_max : longint;

  arbol_prov_extension : arbol;
  sw_uso_exten : boolean;

  sumatorio : LongInt;

begin

  // Poblacion
  vacio(arbol_prov_pob);
  insertar (arbol_prov_pob,1000,'madrid',sw_uso_pob);
  insertar (arbol_prov_pob,2000,'barcelona',sw_uso_pob);
  insertar (arbol_prov_pob,1700,'c1',sw_uso_pob);
  insertar (arbol_prov_pob,2100,'c2',sw_uso_pob);
  insertar (arbol_prov_pob,1500,'c3',sw_uso_pob);
  insertar (arbol_prov_pob,2070,'c4',sw_uso_pob);

  diff_max:=MaxLongInt;
  buscar (arbol_prov_pob,2030,encontrado,dato,descripcion,diff_max);
  dato_s := IntToStr(dato);
  Writeln ('Ciudad : ' + descripcion + ' Pob. ' + IntToStr(dato));
  Writeln('Ascendente : ');
  recorreras(arbol_prov_pob,'c3',dato);
  Writeln (' Pob. : ' + IntToStr(dato));
  Writeln('Descendente : ');
  recorrerdes(arbol_prov_pob,'barcelona',dato);
  Writeln (' Pob. : ' + IntToStr(dato));

  // Extension
  vacio(arbol_prov_pob);
  insertar (arbol_prov_extension,50,'madrid',sw_uso_exten);
  insertar (arbol_prov_extension,35,'barcelona',sw_uso_exten);
  insertar (arbol_prov_extension,78,'c1',sw_uso_exten);
  insertar (arbol_prov_extension,100,'c2',sw_uso_exten);
  insertar (arbol_prov_extension,103,'c3',sw_uso_exten);
  insertar (arbol_prov_extension,90,'c4',sw_uso_exten);

  diff_max:=MaxLongInt;
  buscar (arbol_prov_extension,80,encontrado,dato,descripcion,diff_max);
  dato_s := IntToStr(dato);
  Writeln ('Ciudad : ' + descripcion + ' extension. ' + IntToStr(dato));
  Writeln('Ascendente : ');
  recorreras(arbol_prov_extension,'c3',dato);
  Writeln (' extension. : ' + IntToStr(dato));
  Writeln('Descendente : ');
  recorrerdes(arbol_prov_extension,'barcelona',dato);
  Writeln (' extension. : ' + IntToStr(dato));

  sumatoriodato(arbol_prov_extension,sumatorio);
  Writeln('Sumatorio : '  + IntToStr(sumatorio));

  dato:=0;
  mayordato(arbol_prov_extension,descripcion,dato);
  Writeln ('Mayor dato : ' + descripcion + ' . : ' + IntToStr(dato));

  dato:=0;
  menordato(arbol_prov_extension,descripcion,dato);
  Writeln ('Mayor dato : ' + descripcion + ' . : ' + IntToStr(dato));


end.

