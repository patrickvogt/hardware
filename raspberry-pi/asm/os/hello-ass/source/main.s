/* @description: Assembler-Programm, um das ACT-LED vom Raspberry Pi einzuschalten */

/* Alle nachfolgenden Befehle sollen beim Kompilieren in den Bereich 'init' abgelegt werden. Der Bereich 'init' ist in der LD-Datei definiert und liegt am Anfang des generierten Binaerkompilats an der Adresse 0x0000 */
.section .init 
/* globales Label mit dem Bezeichner '_start' deklarieren */
.globl _start 

/* globaler symbolischer Bezeichner fuer die Basisadresse des GPIO-Controllers deklarieren */
.set GPIO_BASE, 0x20200000

/* Hier beginnt der eigentliche Code */
_start:
  /* Speichere die Zahl 0x20200000_16 ins GP-Register R0 ab. Dies ist die physische Basisadresse des GPIO-Controllers vom BCM2835 (siehe S.90 im 'SoC-Periphals.pdf' -> Achtung: Dort wird eine Bus-Adresse 0x7E200000 als Basisadresse vom GPIO-Controller angegeben, die erst in eine physische Adresse uebersetzt werden muss (mithilfe der MMU). Dazu muss bei den IO Periphals-Adressen einfach der Praefix 0xE7...... durch 0x20...... ausgetauscht werden (siehe S. 5 u. 6 im 'SoC-Periphals.pdf'). */
  /* Das = steht hier fuer einen Pseudo-Befehl ldr=. Dieser Befehl sorgt dafuer, dass der ldr-Befehl in einen mov-Befehl uebersetzt wird, sofern dies der zweite Operand zulaesst. Das sorgt dafuer, dass das Programm ein wenig schneller ist und die Basisadresse nicht aus dem (langsamen) Speicher in das Register geladen werden muss */
  ldr r0,=GPIO_BASE 
  
  /*
  _FRAGE_: Wo steht genau, dass ein PIN gecleared werden muss, damit die LED leuchtet. Wo ist also diese invertierte Logik spezifiziert?
  */
  
  /* Als naechstes muss der 16. PIN angesprochen werden, da dieser mit dem ACT-LED verknuepft ist (siehe http://www.raspberrypi.org/wp-content/uploads/2012/10/Raspberry-Pi-R2.0-Schematics-Issue2.2_027.pdf). Die 54 PINs des GPIO sind jeweils in 10er Paeckchen aufgeteilt, die mit jeweils 4 Byte (=32 Bit) beginnend bei der Basisadresse GPIO_BASE angesprochen werden koennen. Der 16. PIN muss auf eine bestimmte Funktion eingestellt werden, deshalb werden diese 10er-Paeckchen auch als 'Function Select' bezeichnet (siehe S. 90 im 'SoC-Periphals.pdf'). */
  
  /* Daraus ergibt sich folgende Tabelle: */
  
  /*
     GPIO-Register | Offset | physische Adresse | Name                   | zugehoerige PINs
                 0 |      0 |        0x20200000 | GPIO Function Select 0 |  0 -  9 
                 1 |      4 |        0x20200004 | GPIO Function Select 1 | 10 - 19 
                 2 |      8 |        0x20200008 | GPIO Function Select 2 | 20 - 29 
                 3 |     12 |        0x20200012 | GPIO Function Select 3 | 30 - 39 
                 4 |     16 |        0x20200016 | GPIO Function Select 4 | 40 - 49
                 5 |     20 |        0x20200020 | GPIO Function Select 5 | 50 - 54 
  */
  
  /* PIN 16 liegt also in dem zweiten 10er-Paekchen und deshalb muessen wir einen Wert an die physische Adresse GPIO_BASE+0x4 schreiben */
  /* Zuerst muessen wir jedoch den Wert, den wir an diese Adresse schreiben wollen, vorbereiten, also in ein zweites GP-Register R1 laden */
  
  /* Das GPIO Function Select 1-Register (0x20200004) ist wie folgt aufgebaut (wobei die anderen GPIO Function Select Register analog aufgebaut sind) (siehe S. 92 im 'SoC-Periphals.pdf') */
  /* Jeweils 3 Bit (innerhalb der 32 Bit eines GPIO Select-Registers) stehen fuer einen PIN, im Falle vom GPIO Function Select 1-Register sind dies: */
  
  /*
   0 -  2 | PIN 10
   3 -  5 | PIN 11
   6 -  8 | PIN 12
   9 - 11 | PIN 13
  12 - 14 | PIN 14
  15 - 17 | PIN 15
  18 - 20 | PIN 16
  21 - 23 | PIN 17
  24 - 26 | PIN 18
  27 - 29 | PIN 19
  30 - 32 | unbenutzt (nur lesbar)
  */
  
  /* Wir muessen also einen Wert generieren, in dem die Bits 18-20 irgendwie eingeschaltet oder ausgeschaltet sind. Die anderen Bits (0-17 und 21-32) sind fuer uns unwichtig und muessen nicht beachtet werden */
  /* Damit das Lichtlein brennen kann, muss der 16. PIN auf Ausgabe (engl. Output) gestellt werden. Dafuer muessen die Bits 20-18 auf folgenden Wert gesetzt werden: 001 (20=0, 19=0, 18=1) */
  
  /* Um dieses 18. Bit vom GPIO Function Select 1-Register zu setzen machen wir Folgendes: */
  
  /* lade den Wert 1 in GP-Register R1, also ist das 0. Bit von Register R1 gesetzt */
  mov r1,#1
  /* verschiebe das 0. Bit nun um 18 Stellen (logisch) nach links. Dann ist das 18. Bit gesetzt und wir koennen diesen Wert zum Schreiben an Adresse GPIO_BASE+0x4 benutzen. */
  lsl r1,#18
  
  /* Analog - binaere Zahl 2^18 laden: mov r1, #0b1000000000000000000 */
  
  /* Dieser Wert muss jetzt an die physische Adresse GPIO_BASE+0x4 geschrieben werden, damit nicht PIN6, sondern PIN16 auf Ausgabe gestellt wird */
  /* in GP-Register R0 steht die Basisadresse vom GPIO-Controller und #0x4 ist der Offset, der zu dieser Basisadresse hinzuaddiert wird. */
  str r1,[r0,#0x4] 
  
  /* PIN 16 ist also jetzt auf Ausgabe eingestellt  - jetzt muss nur noch die Ausgabe veranlasst werden */
  
  /* Jetzt muessen wir noch den PIN 16 _ausschalten_, damit das Lichtlein auch tatsaechlich brennt */
  
  /* Dafuer muessen wir das 16. Bit im GPIO Register GPIO Pin Output Clear 0 an der physischen Adresse GPIO_BASE+0x28 setzen, damit der entsprechende PIN gecleared wird. (siehe S. 95 im 'SoC-Periphals.pdf') */
  
  /* Wir muessen wieder zuerst einen Wert generieren, wo das 16. Bit gesetzt ist. Dazu machen wir analog zu vorher: Wir laden eine 1 und verschieben diese um 16 Positionen nach links */
  
  mov r1,#1
  lsl r1,#16
  
  /* Analog - binaere Zahl 2^16 laden: mov r1, #0b10000000000000000 */
  
  /* Dieser Wert soll nun an die physische Adresse GPIO_BASE+0x28 geschrieben werden, damit der 16. PIN auch tatsaechlich ausgeschaltet/gecleared wird */
  str r1,[r0,#0x28]
  
/* Als letztes muessen wir noch eine Endlosschleife implementieren, damit der Prozessor nicht abstuerzt. */
loop$: 
  b loop$
  