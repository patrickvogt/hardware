/* @description: Assembler-Programm, um das ACT-LED vom Raspberry Pi zum Blinken zu bringen */

.section .init 
.globl _start 

.set GPIO_BASE, 0x20200000
/* globaler symbolischer Name fuer die Wartezeit zwischen Ein- und Ausschalten des LEDs */
.set LED_ON_OFF_TIME_PERIOD, 5000000

_start:
  ldr r0,=GPIO_BASE 
  
  /* PIN 16 auf Ausgabe einstellen */
  mov r1,#1
  lsl r1,#18
  str r1,[r0,#0x4] 
  
  /* LED einschalten */
led_on: 
  mov r1,#1
  lsl r1,#16
  
  str r1,[r0,#0x28]
  
  /* Ein paar Millionen Zyklen warten (mit LED an) */
  ldr r2,=LED_ON_OFF_TIME_PERIOD
  
wait1$: /* im Prinzip for-Schleife von LED_ON_OFF_TIME_PERIOD bis 0 und Schrittweite -1 */
  sub r2,#1
  cmp r2,#0
  bne wait1$
  
  /* LED hat lange genug geleuchtet -> wieder ausschalten */
  /* Bit 16 in Register GPIO_BASE+0x1C einschalten/setzen */
  str r1,[r0,#0x1C]
  
  /* wieder ein paar Millionen Zyklen warten (mit LED aus) */
  ldr r2,=LED_ON_OFF_TIME_PERIOD
  
wait2$:
  sub r2,#1
  cmp r2,#0
  bne wait2$
  
 /* Ok, hier ist es zu dunkel. Schalten wir das LED wieder ein */
  b led_on
