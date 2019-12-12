.model small
.stack
.data
    color DW 1010b,"$"  ; variable de color la cual se modifica por cada turno de jugador
    colorp DW 1100b,"$"
    
    Benidos db '<<<BIENVENIDOS A TOPOS>>>','$' 
    soli  db 'Ingrese la cantidad de jugadores: ','$'
    soli1 db 'Introduzca el caracter para el primer jugador: ','$'
    soli2 db 'Introduzca el caracter para el segundo jugador: ','$'
    soli3 db 'Introduzca el caracter para el tercer jugador: ','$'
    soli4 db 'Ingrese el caracter de su topo: ','$'
    matriz1 db ' อออออออออออออออออออ','$'
	matriz2 db 'บ บ บ บ บ บ บ บ บ บ บ','$'
    menu1 db 'L/Rendirse  S/Salir R/Reset J1:    Puntaje:    J2:    Puntaje:  ',13,10,'$'
    menu2 db 'S/Salir R/Reset J1:   Puntaje:   J2:   Puntaje:   J3:   Puntaje:   ',13,10,'$'
    Nivel1 db 'Nivel 1','$'
    Nivel2 db 'Nivel 2','$'
    Nivel3 db 'Nivel 3','$'
    Nivel4 db 'Nivel 4','$'
    Nivel5 db 'Nivel 5','$'
    vacio db '                                                     ','$'
    cantJuga  db 0 
    Y1  db 0             ;Columna a imprimir en la matriz
    X1  db 0             ;Fila a imprimir en la matriz
    Y2  db 0             ;Columna a imprimir en la matriz
    X2  db 0             ;Fila a imprimir en la matriz  
    Y3  db 0             ;Columna a imprimir en la matriz
    X3  db 0             ;Fila a imprimir en la matriz
    Y4  db 0             ;Columna a imprimir en la matriz
    X4  db 0             ;Fila a imprimir en la matriz
    NumRandom  db 0
   NumRandom1  db 0          ;Numero que se genera de manera random
    caracter1  db '0' ,'$'
    Puntaje1   db 0
    Puntaje11  db 0
    caracter2  db '0' ,'$'   ;Los caracters y puntos son los de los jugadores
    Puntaje2   db 0
    Puntaje22  db 0
    caracter3  db '0' ,'$'
    Puntaje3   db 0
    Puntaje33  db 0
    Topo       db '0' ,'$' ;Caracter del topo
    contador   db 0        ;cuenta la cantidad de impresiones en matriz
    limpiar    db ' ' ,'$'
    cursorX    db 0        
    cursorY    db 0
    
    ; ------------
    ;|Prueba data |
    ; ------------
    topos db '=    @    #    *    &   ','$'
    msj_der db 'Click derecho','$'
    msj_izq db 'Clicl izquierdo','$'
    
    pos_click_x dw 0
    pos_click_y dw 0
    pos_texto_x db 0
    pos_texto_y db 0
    caracter    db 0                 ;Me guarda el caracter que preciones con el mouse
    contaMouse  db 0
    cickP       db 'Punto menos','$' ;Prueba
    

.code

    mov ax, @data
    mov ds, ax
    
INICIO:

sonidoBeep macro                 ;Macro del sonido beep
    mov ah,2h
    mov dl,07h
    int 21h 
    ENDm

mouseMov macro                   ;Macro del mouse
    mov ax, 00h                  ;utilizar mouse
    int 33h
    
    mov ax, 02h                  ;mostrar mouse
    int 33h
    
    mov ax, 03h
    int 33h
    
    mov pos_click_x,cx           ;se guarda la posicion x del cursor
    mov pos_click_y,dx           ;se guarda la posicion y del cursor
    
    shl bl, 2                    ;Se corre a la izquierda dos posiciones para obtener los clicks
    
    cmp bl,0100b                 ;click izquierdo
    je click_izq
    
    cmp bl, 1000b                ;click derecho
    je click_der 
    ENDm
    
             ;---------PARTES DE PRUEBA---------
             
             
obt_pos_texto macro pos_click,pos_texto
        
    mov ax,pos_click
    mov bl,8
    div bl
    mov pos_texto,al
        
    endm
    
    
    leer_caracter macro caracter
        mov ah,08h
        mov bh,0
        int 10h
        
        mov caracter,al 
        
    endm
    
;----------------------------FIN DE MACROS PRUEBA--------------------------    

  randin macro variable           ;De aqui saco el numero random
     mov ah,2Ch                         
     int 21h
     mov variable , dl                               
     mov al, variable
     ENDm

  n macro fila, Nfila, restaFila, sumaFila ; posiciones x de la matriz
     cmp al, 26
     ja restaFila
     cmp al, 6
     jb sumaFila
     cmp al,8
     je fila
     cmp al,10
     je fila
     cmp al,12
     je fila
     cmp al,14
     je fila
     cmp al,16
     je fila
     cmp al,18
     je fila
     cmp al,20
     je fila
     cmp al,22
     je fila
     cmp al,24
     je fila
     cmp al,26
     je fila
     dec al                                 ;Por si el numero era impar le resto un uno
     jmp Nfila 
     ENDm 
;--------------------------------------------------------------------------------------      
  
  p macro columna,Ncolumna,restaColum,suma  ;Posiciones y de la matriz
      cmp al, 20
     ja restaColum
     cmp al, 1                              ;Si es mayor o igual a 21 que vaya a resta
     jb suma 
     cmp al,2                               ;Se hacen comparaciones a las pociones de el eje y
     je columna
     cmp al,4
     je columna
     cmp al,6
     je columna
     cmp al,8
     je columna
     cmp al,10
     je columna
     cmp al,12
     je columna
     cmp al,14
     je columna
     cmp al,16
     je columna
     cmp al,18
     je columna
     cmp al,20
     je columna
     dec al                                ;Por si el numero era impar le resto un uno
     jmp Ncolumna
  ENDm


  colores macro C, V, X, Y                 ;Imprime el caracter de color  
     mov ah, 02h
     mov bh, 00d
     mov dh, Y   ;Y
     mov dl, X   ;X
     int 10h
     
     mov bx, C 
     mov cx, 01h  
     mov al, V 
     mov ah, 09h
     int 10h
     ENDm
        
  mesj macro M                              ;Imprime un mensaje directamente
     lea dx, M   
     mov ah, 09
     int 21h
     ENDm 
        
  PrintPosition macro M,Y,X                 ;Esta macro es para imprimir en diferenstes posiciones
     mov ah, 02h
     mov bh, 00d
     mov dh, Y
     mov dl, X 
     int 10h
            
     mov ah, 9
     lea dx, M
     int 21h
     ENDm
       
PrintNumPosi macro Y,X,Unidades,Decenas   ;Esta macro es para imprimir numeros en diferentes posiciones
     mov ah, 02h
     mov bh, 00d
     mov dh, Y
     mov dl, X 
     int 10h
            
     mov ah,02h ; funcion para imprimir un caracter
     mov dl,Unidades ; muevo las centenas a DL para poder imprimir
     add dl,30h ; sumo 30h a DL para imprimir el numero real y no otro caracter
     int 21h ; imprime 1

     mov dl,Decenas
     add dl,30h
     int 21h 
     ENDm

;______________________________TOPO1__________________________________       
Topo1 Macro                                 ;posiciones para limpiar topos
    
PrintPosition limpiar, Y1, X1               ;Aqui estoy borrando las posiciones de los topos
PrintPosition limpiar, Y2, X2
PrintPosition limpiar, Y4, X4
PrintPosition limpiar, Y3, X3            
    
    randin NumRandom                        ;llamo a la macro de # random
    
Nfila:  
      n fila, Nfila, restaFila, sumaFila    ;llamo a la macro de comparacion de grados
           
restaFila:
    sub al,19                               ;Si el numero encontrado es mayor a 28 que le reste 19
    jmp Nfila
    
sumaFila:
    add al,7                                ;Si el numero random encontrado es menor a 8 que sume 7
    jmp Nfila

fila:
    mov X1, al                              ;Guardo la variable random

;------------------------Saco la posicion de y manera random----------------                     
    
randin NumRandom1                                        ;llamo a la macro de # random
 
Ncolumna:
    p columna, Ncolumna, restaColum, sumaColum           ;llamo a la macro de comparacion de grados

restaColum:
    sub al, 20                                           ;resto al random si es muy grande
    jmp Ncolumna

sumaColum:
    add al,7                                             ;le sumo al random si es menor a 8
    jmp Ncolumna           
         
Columna:
    mov Y1,al                                            ;guardo el radom en una variable
 
    colores 04h, topo, X1, Y1                           ;Imprimo el topo en las cordenadas
    
  ENDm
  
;_________________________TOPO2 AZULES____________________________

TOPO2 MACRO                                              ;segunda macro de topos azules    
 
randin NumRandom                                         ;llamo a la macro de # random
    
Afila:  
      n fila1, Afila, restaFila1, sumaFila1              ;llamo a la macro de comparacion de grados
           
restaFila1:                                              ;Si el ramdon es muy grande le resta
    sub al,19
    jmp Afila
    
sumaFila1:                                               ;Sumo al random si el numero es menor a 8
    add al,7
    jmp Afila

fila1:
    mov X2, al

;------------------------Saco la posicion de y manera random----------------                     
    
randin NumRandom1                                      ;llamo a la macro de # random
 
Acolumna:
    p Columna1, Acolumna, restaColum1, sumaColum1      ;llamo a la macro de comparacion de grados

restaColum1:
    sub al, 20                                         ;Resto al random si es muy grande 
    jmp Acolumna                                       
    
sumaColum1:
    add al,7                                           ;Sumo al random si el numero es menor a 8
    jmp Acolumna
         
Columna1:
    mov Y2,al                                          ;guardo el radom en una variable
 
    colores 01h, topo, X2, Y2                          ;Imprimo el topo en las cordenadas guardadas en la variable
    
ENDm

;___________________________TOPO3 ROJOS____________________________

TOPO3 MACRO 

randin NumRandom                                       ;llamo a la macro de # random
    
NNfila:  
      n fila2, NNfila, restaFila2, sumaFila2           ;llamo a la macro de comparacion de grados
           
restaFila2:                                            ;Resto al random si es muy grande
    sub al,19
    jmp NNfila
    
sumaFila2:                                             ;Sumo al random si es muy pequeno
    add al,7
    jmp NNfila

fila2:
    mov X4, al                                         ;

;------------------------Saco la posicion de y manera random----------------                     
    
randin NumRandom1                                       ;llamo a la macro de # random
 
NNcolumna:
    p columna2, NNcolumna, restaColum2, sumaColumna2    ;llamo a la macro de comparacion de grados

restaColum2:
    sub al, 20                                          ;resto al random si es muy grande
    jmp NNcolumna
    
sumaColumna2:                                           ;Sumo si el random es menor a 7
    add al,7
    jmp NNcolumna           
         
Columna2:
    mov Y4,al                                           ;guardo el random en una variable
 
    colores 04h, topo, X4, Y4                          ;Imprimo los topos en loas variables guardadas

ENDm

;___________________________TOPO4________________________________________

TOPO4 MACRO
randin NumRandom                                        ;llamo a la macro de # random
    
AAfila:  
      n fila11, AAfila, restaFila11, sumaFila11         ;llamo a la macro de comparacion de grados
           
restaFila11:                                            ;Si el ramdon es muy grande le resto
    sub al,19
    jmp AAfila
    
sumaFila11:                                             ;Si el random es menor a 8 le sumo 7
    add al,7
    jmp AAfila

fila11:
    mov X3, al                                          ;Guardo en una variable el resultado del random

;------------------------Saco la posicion de y manera random----------------                     
    
randin NumRandom1                                       ;llamo a la macro de # random
 
AAcolumna:
    p Columna11, AAcolumna, restaColum11, sumaColum11   ;llamo a la macro de comparacion de grados

restaColum11:
    sub al, 20
    jmp AAcolumna                                       ;Resto al random si es muy grande
    
sumaColum11:
    add al,7                                            ;Sumo si el random es menor a 8
    jmp AAcolumna
         
Columna11:
    mov Y3,al                                           ;guardo el radom en una variable
 
    colores 01h, topo, X3, Y3                                            
                                                        ;Imprimo el topo en las variables que guarda el random
    
    ENDm
       
;-------------------------------------Solicito datos--------------------------------   
     
PrintPosition Benidos,0,2     ;Imprime msj bienvenida
PrintPosition soli,3,2        ;mjs solicita cantidad de jugadores
        
        
mov ah, 1                     ;Solicito el caracter por teclado
int 21h
        
sub al, 30h                   ;Hace la comparacion con la parte alta que se almaseno para convertir el num  
        
cmp al, 2
JE  JUGADOR2
                              ;Compara cuanta es la cantidad de jugadores
cmp al, 3
JE  JUGADOR3
           
JMP INICIO
     
    
JUGADOR2:
    ;Jugador 1
    PrintPosition soli1,5,2         ;msj solicita
    
    mov ah, 1                       ;Solicito el caracter por teclado Jugador 1
    int 21h
    
    mov caracter1, al               ;Guardo el caracter en una variable
    
    ;Jugador 2
    PrintPosition soli2,7,2         ;msj solicita
    mov ah, 01                      ;Solicito el caracter por teclado Jugador 2
    int 21h
    
    mov caracter2, al               ;Guardo el caracter en una variable
    
    PrintPosition menu1,23,0
    PrintPosition vacio,0,0
    PrintPosition vacio,3,0         ;Limpio pantalla
    PrintPosition vacio,5,0
    PrintPosition vacio,7,0
   
    colores color, caracter1, 32,23   ;Imprimo el caracter y puntos del primer jugador
    PrintNumPosi 23,43,Puntaje1,Puntaje11
   
            
    colores color, caracter2, 51,23  ;Imprimo el caracter y puntos del segundo jugador
    PrintNumPosi 23,63,Puntaje2,Puntaje22
    jmp matrix                      ;Salta a la matriz
            
JUGADOR3:
 
    ;Jugador 1
    PrintPosition soli1,5,2         
    
    mov ah, 1                       ;Solicito el caracter por teclado Jugador 1
    int 21h
    
    mov caracter1, al               ;Guardo el cacter en una variable
   
    
    ;Jugador 2
    PrintPosition soli2,7,2
    
    mov ah, 1                       ;Solicito el caracter por teclado Jugador 2
    int 21h
    
    mov caracter2, al               ;Guardo el caracter en una variable

    ;Jugador 3
    PrintPosition soli3,9,2
    mov ah, 1                       ;Solicito el caracter por teclado Jugador 3
    int 21h
    
    mov caracter3, al               ;Guardo el caracter en una variable
     
    PrintPosition menu2,23,0        ;Imprimo el menu para 3 jugadores
    PrintPosition vacio,0,0
    PrintPosition vacio,3,0 
    PrintPosition vacio,5,0         ;Limpio de la pantalla las solicitudes
    PrintPosition vacio,7,0
    PrintPosition vacio,9,0  

    colores color, caracter1, 20, 23 ;Imprime puntaje y caracter del primer jugador
    PrintNumPosi 23,29,Puntaje1,Puntaje11
               
    colores color, caracter2, 36, 23 ;Imprime puntaje y caracter del segundo jugador
    PrintNumPosi 23,46,Puntaje1,Puntaje11
               
    colores color, caracter3, 53, 23 ;Imprime puntaje y caracter del tercer jugador
    PrintNumPosi 23,64,Puntaje1,Puntaje11
            
;--------------------------Creando la matriz--------------------------------- 

matrix:
    PrintPosition soli4,3,2         ;Solicito el caracter del topo
    mov ah, 01  
    int 21h
    
    mov topo,  al                   ;Guardo el topo en una variable
    
    PrintPosition vacio,3,2         ;Limpio la solicitud del topo
    
    PrintPosition matriz1,1,7       ;Aqui empiezo la matriz
    PrintPosition matriz2,2,7
    
    PrintPosition matriz1,3,7
    PrintPosition matriz2,4,7
                            
    PrintPosition matriz1,5,7
    PrintPosition matriz2,6,7
    
    PrintPosition matriz1,7,7
    PrintPosition matriz2,8,7
    
    PrintPosition matriz1,9,7
    PrintPosition matriz2,10,7
    
    PrintPosition matriz1,11,7
    PrintPosition matriz2,12,7
    
    PrintPosition matriz1,13,7
    PrintPosition matriz2,14,7
    
    PrintPosition matriz1,15,7
    PrintPosition matriz2,16,7
    
    PrintPosition matriz1,17,7
    PrintPosition matriz2,18,7
    
    PrintPosition matriz1,19,7
    PrintPosition matriz2,20,7
    PrintPosition matriz1,21,7       ;Aqui termino la matriz
            
;Azul 01h  , Rojo 04h   x, y
  
ToposMatrix:
       
    TOPO1    
    TOPO2     
    TOPO3
    TOPO4
        
    mov contaMouse, 20       ;Ciclo de mouse para que este activo
    PrintPosition nivel1,0,7 ;Imprimo el nivel
    
mouseLevel1:
    mouseMov                 ;Estoy llamando la macro del mouse
    dec contaMouse
    cmp contaMouse, 0  
    je ToposMatrix           ;Si es igual a 0 que se salga del ciclo
    jmp mouseLevel1
    
    
    mov al,contador
    inc al
    cmp al,5
    je SALIR
    mov contador, al 

    mov ah, 1
    int 16h
    
    jz ToposMatrix

    mov ah, 0
    int 16h

    cmp al,076    ;L
    je rendir

    cmp al,081  ; Q
    je SALIR

                         ; variables para reset, salir, rendir
    cmp al,108    ; l
    je rendir
    
    cmp al,113   ;  q
    je salir

    ;jne beep
    
    
click_izq:
    
    obt_pos_texto pos_click_x,pos_texto_x
    obt_pos_texto pos_click_y,pos_texto_y
    leer_caracter caracter 
    
    cmp pos_texto_y, 21                          ;Si preciono el mouse y esta fuera del rango del eje y que suene el beep
    ja BEEPfuera
    
    cmp pos_texto_x, 27                          ;Si preciona el mouse fuera del ran de eje x en la matriz suena el beep
    ja BEEPfuera
    
    mov al, pos_texto_y
    cmp al, Y2
    JE P3
    
    mov al, pos_texto_y
    cmp al, Y3
    JE P4
    
    cmp Puntaje11, 0
    je  doce                   
    dec Puntaje11
    jmp Beep
    
    doce:
    cmp puntaje1,1
    jae DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,9                       ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP
    
P3: 
    mov al, pos_texto_x
    cmp al, X2
    JE TopoAzul1
    
    dec Puntaje11
                            
    cmp Puntaje11, 0                     
    jae beep
    
    cmp puntaje1,1
    ja DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,0                      ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP

P4: 
    mov al, pos_texto_x
    cmp al, X3
    JE TopoAzul2 
    
    dec Puntaje11
                            
    cmp Puntaje11, 0                     
    jae beep
    
    cmp puntaje1,1
    ja DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,0                      ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP

click_der:

    obt_pos_texto pos_click_x,pos_texto_x
    obt_pos_texto pos_click_y,pos_texto_y
    leer_caracter caracter
        
    cmp pos_texto_y, 21                  ;Si preciono el mouse y esta fuera del rango del eje y que suene el beep
    ja BEEPfuera
    
    cmp pos_texto_x, 27                  ;Si preciona el mouse fuera del ran de eje x en la matriz suena el beep
    ja BEEPfuera
    
    mov al, pos_texto_y
    cmp al, Y1                           ;Comparo la cordenada eje x con el click derecho
    JE P1
    
    mov al, pos_texto_y
    cmp al, Y4                           ;Comparo la cordenada eje x con el click derecho
    JE P2    
    
    cmp Puntaje11, 0
    je  doce1                   
    dec Puntaje11
    jmp Beep
    
    doce1:
    cmp puntaje1,1
    jae DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,9                       ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP
    

P2: 
    mov al, pos_texto_x
    cmp al, X4                           ;Comparo la cordenada eje x con el click derecho
    JE TopoRojo1
    dec Puntaje11
                            
    cmp Puntaje11, 0                     
    jae beep
    
    cmp puntaje1,1
    ja DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,0                      ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP
    
P1: 
    mov al, pos_texto_x                  ;Comparo la cordenada eje x con el click derecho
    cmp al, X1
    JE TopoRojo2
    dec Puntaje11
    
    cmp Puntaje11, 0                     
    jae beep
    
    cmp puntaje1,1
    ja DrecreDecenas:                    ;Si las docenas son mayores a uno que me le decremente
    
    mov puntaje1,0
    mov puntaje11,0                      ;Sino que me mueva un 0 a las unidades y decenas
    
    jmp BEEP
    
;#############################################################################################    

TopoRojo1:
    
    inc puntaje11                        ;Le incremento un punto
    cmp puntaje11, 10
    je  IncreDecenas1
    vol1:
    PrintPosition limpiar, Y4, X4        ;Elimino el topo
    PrintNumPosi 23,43,Puntaje1,Puntaje11
    jmp MouseLevel1                      ;Vuelve al mouse


TopoRojo2:
    inc puntaje11                        ;Le incremento un punto
    cmp puntaje11, 10
    je  IncreDecenas2                    ;Le incremento un punto
    vol2:
    PrintPosition limpiar, Y1, X1        ;Elimino el topo
    PrintNumPosi 23,43,Puntaje1,Puntaje11;actualizo los datos en pantalla
    jmp MouseLevel1                      ;Vuelve al mouse

TopoAzul1:
    inc puntaje11                        ;Le incremento un punto
    cmp puntaje11, 10
    je  IncreDecenas3
    vol3:                    
    PrintPosition limpiar, Y2, X2        ;Elimino el topo
    PrintNumPosi 23,43,Puntaje1,Puntaje11;actualizo los datos en pantalla
    jmp MouseLevel1                      ;Vuelve al mouse

TopoAzul2:
    inc puntaje11                        ;Le incremento un punto
    cmp puntaje11, 10
    je  IncreDecenas4
    vol4:                    
    PrintPosition limpiar, Y3, X3        ;Elimino el topo
    PrintNumPosi 23,43,Puntaje1,Puntaje11;actualizo los datos en pantalla
    jmp MouseLevel1
    
IncreDecenas1:
    inc puntaje1
    mov puntaje11, 0
    jmp vol1                       ;Si la unidad es mayor a 9 incremento las decenas
    
IncreDecenas2:
    inc puntaje1
    mov puntaje11, 0               ;Si la unidad es mayor a 9 incremento las decenas
    jmp vol2
    
IncreDecenas3:
    inc puntaje1
    mov puntaje11, 0               ;Si la unidad es mayor a 9 incremento las decenas
    jmp vol3
    
IncreDecenas4:
    inc puntaje1
    mov puntaje11, 0               ;Si la unidad es mayor a 9 incremento las decenas
    jmp vol4   
    
DrecreDecenas:
mov puntaje1, 0                   ;Le muevo un 9 a las unidades
mov puntaje11, 9                       ;Si la decena es mayor a una la decremento
jmp Beep

RENDIR:
    PrintPosition soli3,9,28
    jmp salir

BEEP:
    PrintNumPosi 23,43,Puntaje1,Puntaje11
    
    sonidoBeep                    ;Aqui llamo la macro del sonido 
    
    jmp MOUSELEVEL1
    
BEEPfuera:

    sonidoBeep                    ;Aqui llamo la macro del sonido
    
    jmp MOUSELEVEL1
    
PUNTO:

    jmp ToposMatrix


SALIR:

.EXIT
                 