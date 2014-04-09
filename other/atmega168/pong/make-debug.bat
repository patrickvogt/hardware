avr-gcc -mmcu=atmega168 -DF_CPU=1000000 -Os pong-loader.c -o pong-loader.elf -g
avr-objcopy -O ihex -R .eeprom pong-loader.elf pong-loader.hex
pause