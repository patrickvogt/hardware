################################################################################
# VARIABLEN                                                                    #
################################################################################

# Dateien, die durch ein 'clean' gel�scht werden sollen
CLEANABLE_OBJS = dist/hello.prg

CONVERTER = petcat # Damit wird unser Text in PRG �bersetzt
EMU = nes # Legt den Emulator fest, mit dem wir unser PRG testen
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

# startet das erstellte ROM im Emulator
run: all
	$(EMU) dist/hello.prg
  
#deploy: all
#	$(DEPLOYER) dist/hello.prg

# erzeugt das eigentliche PRG
dist/hello.prg: src/main.l
	petcat -w2 -o $@ -- $^

# l�scht alle (durch dieses Makefile) erzeugten Dateien
clean:
	-rm $(CLEANABLE_OBJS)
