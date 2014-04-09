#include <avr/io.h>
#include <stdint.h>
#include <avr/pgmspace.h>

/* => 1 MHz */
#define F_CPU 1000000

#include <util/delay.h>

#include "pong.h"

/* Ausgabepins: aufsteigend von LSB nach MSB */
uint8_t out_pins[] = 
{ 
    PC5, PC4, PC3, PC2,
    PB4, PB3, PB2, PB1 
};

/* EIngabepins: absteigend von MSB nach LSB */
uint8_t in_pins[] = 
{ 
    PB0, PD7, PD6, PD5, 
    PB7, PB6, PD4, PD3, 
    PD2, PD1, PD0
};

/* gibt die aktuell anliegende Adresse an den Eingabepins zurueck */
uint16_t get_address_from_pins()
{
    /* 16 Bit-Adresse (wir benoetigen nur 11 Bit) */
    uint16_t addr = 0u;
    /* Schleifenindex */
    uint8_t i = 0u;
    /* temporaerer Speicher fuer gelesenes Bit */ 
    uint8_t bit = 0u;
    
    for(i = 0u; i < 11u; i = i + 1u) /* fuer jeden Eingabepin */
    {
        switch(i)
        {
            /* Bit 0, 4 und 5 => liegen an PINB an */
            case 0u:
            case 4u:
            case 5u:
                bit = (PINB & (1u << in_pins[i]));
                break;
            /* die restlichen Bits liegen an PIND an */
            case 1u:
            case 2u:
            case 3u:
            case 6u:
            case 7u:
            case 8u:
            case 9u:
            case 10u:
                bit = (PIND & (1u << in_pins[i]));
                break;
            default:
                /* sollte nie auftreten */
                break;
        }
        
        /* LSB von Adresse setzen */
        addr = (addr | bit);
        /* Linksschieben wenn nicht im letzten Schleifendruchlauf */
        /*in letzten Schleifendurchlauf nicht schiften*/
        addr = ((10u != i) ? (addr << 1u) : addr);
        
        /* temporaeren Speicher fuer naechsten Schleifendurchlauf zuruecksetzen */
        bit = 0u;
    }
    
    /* Adresse zurueckgeben */
    return addr;
}

/* Byte an der uebergebenen Adresse aus dem Programmspeicher lesen */
uint8_t get_byte(uint16_t addr)
{
    return pgm_read_byte(&(pong[addr]));
}

/* Das gewuenschte Byte lesen und an Ausgang anlegen */
void map_byte_to_o_pins()
{
    /* 16 Bit-Adresse (wir benoetigen lediglich 11 Bit => 2^11 Byte = 2KByte */
    uint16_t addr = 0u;
    /* das gelesene Byte */
    uint8_t byte = 0u;
    /* Schleifenindex */
    uint8_t i = 0u;
    /* temporaerer Speicher fuer aktuelles Bit innerhalb Schleife*/
    uint8_t bit = 0u;
    /* temporaerer Speicher fuer aktuelle Bitmaske innerhalb Schleife */
    uint8_t bitmask = 0u;
    
    /* gewuenschte Adresse holen */
    addr = get_address_from_pins();
    /* Byte an Adresse holen */
    byte = get_byte(addr);
    
    /* gelesenes Byte bitweise an die Ausgabepins legen */
    for(i = 0u; i < 8u; i = i + 1u)
    {
        /* Bit separieren */
        bit = (byte >> i) & 1u;
        /* Bitmaske erstellen */ 
        bitmask = (bit << out_pins[i]);
        
        /* Unteres Nibble an Port C*/
        if(i < 4u)
        {
            PORTC = ((0u == bit) ? (PORTC & (~bitmask)) : (PORTC | bitmask));
        }
        /* Oberes Nibble an Port B*/
        else
        {
            PORTB = ((0u == bit) ? (PORTB & (~bitmask)) : (PORTB | bitmask));
        }
        
        /* Variablen zuruecksetzen fuer naechsten Schleifendurchlauf */
        bit = 0u;
        bitmask = 0u;
    }
}

/*
    main-Funktion
*/
int main(void)
{
    /* PB1-PB4 auf Ausgang setzen */
    DDRB = 0x1E;
    /* PC2-PC5 auf Ausgang setzen */
    DDRC = 0x3C;
    /* Alle Pins von Port D auf Eingang setzen */
    DDRD = 0x00;
    
    /* Ausgangsports nullen */
    PORTB = 0x00;
    PORTC = 0x00;
    
    /* Hauptschleife */          
    while (1) 
    {
        map_byte_to_o_pins();
    }
    return 0;
}