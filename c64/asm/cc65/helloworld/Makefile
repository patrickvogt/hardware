################################################################################
# VARIABLEN                                                                    #
################################################################################

# Dateien, die durch ein 'clean' gel�scht werden sollen
CLEANABLE_OBJS = dist/hello.prg obj/main.o

ASSEMBLER = ca65 # Damit wird unser Assemblercode in eine Objektdatei kompiliert
LINKER = ld65 # Dieser 'linkt' unsere Objektdateien in ein PRG
EMU = x64 # Legt den Emulator fest, mit dem wir unser PRG testen
#DEPLOYER = # Legt das Programm fest, um das PRG auf eine Karte zu �bertragen
CC = gcc # C-Compiler
CFLAGS = -Wall -ansi -pedantic -g -O0 # C-Compiler-Argumente
ASSFLAGS = # Argumente f�r den Assembler

################################################################################
# RULES                                                                        #
################################################################################

# 'Phony targets' sind Aktionen und keine Dateien und m�ssen daher immer
# ausgef�hrt werden

.PHONY: all run clean tools deploy

# Standard-Target wird automatisch bei einem 'make' ausgef�hrt
all: dist/hello.prg

# startet das erstellte PRG im Emulator
run: all
	$(EMU) dist/hello.prg
  
#deploy: all
#	$(DEPLOYER) dist/hello.prg
 
# erstellt den .text-Bereich des PRGs
dist/hello.prg: ./C64_PRG_LAYOUT.link obj/main.o
	$(LINKER) -o dist/hello.prg -C $^
 
# kompiliert die Quelldatei
obj/main.o: src/main.asm
	cd src && $(ASSEMBLER) $(ASSFLAGS) main.asm -o ../obj/main.o && cd ..

# l�scht alle (durch dieses Makefile) erzeugten Dateien
clean:
	-rm $(CLEANABLE_OBJS)
