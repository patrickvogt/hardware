# RechnerOrganisation
# Hausaufgabe 02
# Autor: Patrick VOGT (Matr.Nr. 256558)	
# Datum: 30.05.2008
# Beschreibung: Sortieren mit dem QuickSort unter MIPS64
# Letzte Aenderung: 31.05.2008
# ACHTUNG: Aufgrund der Rekursion und den Callee Saves muss der 'Adress Data Bus' ('Configure->Architecture') in WinMIPS64 auf 11 gesetzt werden
# damit der Stack auch noch genug Platz im Speicher hat
#
#	private static void quicksort(int[] a, int lo, int hi) {
#		int i=lo;
#		int j=hi;
#		int x=a[(lo+hi)/2];
#
#		//  Aufteilung
#		while (i<=j) {    
#			while (a[i]<x) {
#				i++;
#			} 
#
#			while (a[j]>x) {
#				j--;
#			}
#
#			if (i<=j) {
#				swap(a, i, j);
#				i++; 
#				j--;
#			}
#		}
#
#		// Rekursion
#		if (lo<j) {
#			quicksort(a, lo, j);
#		}
#
#		if (i<hi) {
#			quicksort(a, i, hi);
#		}
#	}
#
#	private static void swap(int[] a, int i, int j) {
#		int t=a[i];
#		a[i]=a[j];
#		a[j]=t;
#	}

		.data 

array:		.word  0x4F6961869342DC99,0x7A0B67101C85D9EE,0x5EF87A2B37CA911D,0x47EF58E8B7E01DD9
		.word  0x79A74EAB20CB53C9,0x6D26753D06F8E483,0x70F313AF126C0B47,0x745232A4035F1EF5
		.word  0x46036BDDE8D095FD,0x4DE3F1D89B5A43EA,0x5279659D102EABBA,0x4496CDA949E29089
		.word  0x6D594E2009B7D04A,0x4CE57C0D55905DE5,0x4115A0AC78A1848B,0x5051DAA648B3BDA6
		.word  0x71C3730CE11593C0,0x425A9FAE68370FC5,0x6B265F8485354426,0x4E935A849C713D01
		.word  0x773110588E5170D7,0x5B133F183803A780,0x49A52D37525C362C,0x4A0C150C49D8A123
		.word  0x7962EC77A41FB066,0x5D3A087AF3417D04,0x7076F96031DC3B2E,0x404EC3D105D02FDD
		.word  0x5484F578189A7A8B,0x65EA86F819037E03,0x4367E6F2AE35B27A,0x63C1CF869394DB43
		.word  0x59421109269E583C,0x6B9F1B529C8598EF,0x4C877DCC129AF1BD,0x58401EDBF56D884F
		.word  0x754C5475E3F8BFCF,0x1111111111111111,0x786213BFF3FAE203,0x53F6C77223F8D4B5
		.word  0x5304A0C74815DFBF,0x701BFCF2B7E84DED,0x72C3DEDE1BA476AD,0x557C05371C0A436C
		.word  0x741CECCDBAEBBBB3,0x577156E9E5C72202,0x641D1FEFF6E59822,0x623B6D2C45E6AFC6
		.word  0x6976994C37A754F0,0x4CE48C6E6963A020,0x4EDDBCD1CF3CD3AC,0x706AAA8FC1AE08E4
		.word  0x674DE62D8E4ACB59,0x791423B583AF7749,0x4589009608F70D0A,0x55159D9A3430F238
		.word  0x70BD250BE3048518,0x6D1B60128C603831,0x5397AB7F0E29CEE8,0x58EF0102374A9A97
		.word  0x625D9DBD94D1E2D1,0x5E8439437165FDF6,0x4F621F3A37353266,0x426B3ACC1149F170
		.word  0x59D789FA7FA3F476,0x4C4353E0D30D6D4B,0x492F120FA02F0B1C,0x720DFD78A97CFF59
		.word  0x5BC2140E14551D39,0x68718C039D4656B9,0x7FFFFFFFFFFFFFFF,0x48F63330CBC9A739
		.word  0x6E47955AFD5F8C20,0x44972B6AD10F9D2A,0x46578121CA1151A1,0x46281A1E7672B320
		.word  0x4094CC803E05BD98,0x5FF5B63C7812A363,0x6AF41E217F7612C5,0x4B7B4452B1E208AC
		.word  0x750F8A67FA5E72E4,0x51C8ECF29B5E8AD1,0x580550353D81B486,0x668CD4C5F3970ABF
		.word  0x480BEE00A16715AD,0x4888D5AC9EE02467,0x77C3DDBA62669040,0x48D55CDF7F706867
		.word  0x720670341FE6E445,0x6CAE4383191C2CC9,0x4F9E28BAD0270344,0x46DAD4328A8A3979
		.word  0x55B7AEB598729716,0x76D0F139C5FF97C5,0x4B876EB39C2DC380,0x781ADC2AD91E6FDF
		.word  0x53BDEAF8F4AA0625,0x624D7EA5B9A73772,0x75A02137A787850D,0x4259BDE1C33A32E6
       
len:		.word 100

		.text

# ACHTUNG: Aufgrund der Rekursion und den Callee Saves muss der Adress Data Bus (Configure->Architecture) in WinMIPS64 auf min. 11 gesetzt werden
#
#		RegisterUebersicht:
#			
#		$t0 = bedingungs_tmp
#		$t1 = n
#		$t2 = pivot
#		$t3 = i
#		$t4 = j
#		$t6 = array[i]
#		$t7 = array[j]
#		$a1 = 1. Parameter -> lo
#		$a2 = 2. Parameter -> hi
#		$ra = RueckSprungAdresse
#		$sp = StackPointer -> ACHTUNG StackPointer wird auf 0 initialisiert

main:		ld $t0, len($zero)	# n = len
		dsll $t0, $t0, 3	# n = 8*n

		daddi $sp, $sp, 2048	# StackPointer ganz unten im Speicher platzieren -> waechst nach oben

		daddi $a1, $t0, -8	# r = n-1

		jal quicksort		# quicksort(0, n-1)

exit:		halt			# Programmende

quicksort:	dadd $t8, $a0, $a1	# tmp = lo+hi
		ori $t3, $a0, 0		# i = lo
		ori $t4, $a1, 0		# j = hi
		dsrl $t8, $t8, 4	# (lo+hi)/2
		dsll $t8, $t8, 3	# Indexanpassung
		ld $t2, array($t8)	# pivot = array[(lo+hi)/2]

		slt $t0, $t4, $t3	# j < i ?
		bnez $t0, calleesave

while1:		ld $t6, array($t3)	# array[i]
		slt $t0, $t6, $t2	# array[i] < pivot ?
		beqz $t0, vorwhile3
	
while2:		daddi $t3, $t3, 8	# i++;

		ld $t6, array($t3)	# array[i]
		slt $t0, $t6, $t2	# array[i] < pivot ?
		bnez $t0, while2

vorwhile3:	ld $t7, array($t4)	# array[j]
		slt $t0, $t2, $t7	# pivot < array[j] ?
		beqz $t0, if1

while3:		daddi $t4, $t4, -8	# j--;

		ld $t7, array($t4)	# array[j]
		slt $t0, $t2, $t7	# pivot < array[j] ?
		bnez $t0, while3

if1:		slt $t0, $t4, $t3	# j < i ?
		bnez $t0, endewhile1

swap:		sd $t7, array($t3)	# array[i] = array[j]
		sd $t6, array($t4)	# array[j] = array[i]

		daddi $t3, $t3, 8	# i++;
		daddi $t4, $t4, -8	# j--;

endewhile1:	slt $t0, $t4, $t3	# j < i ?
		beqz $t0, while1

calleesave:	sd $ra, -8($sp)		# Ruecksprungadresse auf dem Stack speichern
		sd $a1, -16($sp)	# hi auf dem Stack speichern -> wird fuer spaeteren 2. rekAufruf benoetigt
		sd $t3, -24($sp)	# i auf dem Stack speichern -> wird fuer spaeteren 2. rekAufruf benoetigt

if2:		slt $t0, $a0, $t4	# lo < j ?
		beqz $t0, if3

		ori $a1, $t4, 0		# hi = j

		daddi $sp, $sp, -24	# StackPointer um 3 nach oben verschieben

		jal quicksort		# quicksort (lo, j)

		daddi $sp, $sp, 24	# StackPointer wieder um 3 nach unten verschieben

		ld $t3, -24($sp)	# i vom Stack laden -> wird fuer spaeteren 2. rekAufruf benoetigt
		ld $a1, -16($sp)	# hi vom Stack laden -> wird fuer spaeteren 2. rekAufruf benoetigt

if3:		slt $t0, $t3, $a1	# i < hi ?
		beqz  $t0, endecalleesave

		ori $a0, $t3, 0		# lo = i

		daddi $sp, $sp, -24	# StackPointer um 3 nach oben verschieben

		jal quicksort		# quicksort (i, hi)

		daddi $sp, $sp, 24	# StackPointer wieder um 3 nach unten verschieben

endecalleesave: ld $ra, -8($sp)		# Ruecksprungadresse zuerueck ins Register $ra laden

back:		jr $ra			# zurueck zum Aufruf