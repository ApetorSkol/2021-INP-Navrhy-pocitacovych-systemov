; Vernamova sifra na architekture DLX
; Matej Slivka xslivk03
; xslivk03-r5-r8-r15-r17-r18-r0

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xslivk03"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani

	; NACITA DO R5 ASCII HODNOTU "s"
	; NACITA DO R8 ASCII HODNOTU "l"
	addi r5,r5,2
	lb r8, login(r5)
	subi r5,r5,1
	lb r5, login(r5)
	
	; ODCITAME OD REGISTROV 96 NECH DOSTANEME NASE KLUCE
	; 97 cislo v ascii je 'a'
	subi r8,r8,96
	subi r5,r5,96

startcycle:
	; SKONTROLUJE CI SA JEDNA O CISLO (ci je ASCII znak mensi ako 96)
	nop
	lb r15, login(r18)
	slei r17,r15,96
	bnez r17,end1

	; PRIPOCITA KLUC A UPRAVUJE V PRIPADE ZNAKU KTORY NIEJE A-Z
	add r15,r15,r5
	sgei r17,r15,123
	bnez r17, decrease
	nop
	nop
	j printout
decrease:
	nop
	subi r15,r15,26
	j printout
printout:
	;VYPISE
	nop
	sb cipher(r18),r15
	
	; ROVNAKY POSTUP AKO PREDOSLI KOD LEN TENTOKRAT ODCITAME DRUHY KLUC OD ZNAKU
	addi r18,r18,1
	lb r15, login(r18)
	slei r17,r15,96
	bnez r17,end1

	;ODPOCITA A UPRAVUJE
	sub r15,r15,r8
	slei r17,r15,96
	bnez r17, increase
	nop
	nop
	j printout2
increase:
	nop
	addi r15,r15,26
	j printout2
printout2:
	nop
	sb cipher(r18),r15
	addi r18,r18,1
	;IDE ODZNOVU
	j startcycle


end1:	sb cipher(r18),r0
end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
