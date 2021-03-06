DISP	MACRO    X
				MOV	DL,X          ;要显示的字符送DL寄存器
				MOV	AH,02H        ;DOS功能调用号是02H
				INT		21H           ;21H中断程序是DOS功能调用
		ENDM

		DATA	SEGMENT
		DATA1	DB '12732'
		DATA2	DB '06815'
		N	EQU  $-DATA2
		DATA	ENDS

		STACK	SEGMENT  STACK
		STA		DB 20 DUP (?)
		TOP	EQU  $-STA
		STACK	ENDS

		CODE	SEGMENT
				ASSUME  CS:CODE,DS:DATA,SS:STACK,ES:DATA
		START:MOV	AX,DATA
				MOV	DS,AX
				MOV	AX,STACK
				MOV	SS,AX
				MOV	AX,TOP
				MOV	SP,AX		
				LEA		SI,DATA1		;☆
				MOV	BX,0
				MOV	CX,N
				CALL	DISPL				;显示被加数
				DISP	'+'
			    LEA		SI,DATA2
				MOV	BX,0
				MOV	CX,N
				CALL	DISPL				;显示加数
				DISP	'='
				LEA		DI,DATA1
				MOV	CX,N
		        CALL	ADDA				;调用加法子程序	
				LEA		SI,DATA1
				MOV	BX,0
				MOV	CX,N
				CALL	DISPL				;显示运算结果
				DISP	0DH
				DISP	0AH
				MOV	AX,4C00H
				INT		21H

		DISPL	PROC						;显示子程序
		DS1:	MOV	AH,02H
				MOV	DL,[SI+BX]
				INT		21H
				INC		BX
				LOOP	DS1
				RET
		DISPL	ENDP

		ADDA	PROC						;加法子程序
				PUSH	CX
				MOV	BX,0
		AD1:  SUB 	BYTE  PTR [SI+BX],30H
		        SUB 	BYTE  PTR [DI+BX],30H
				INC		BX
				LOOP	AD1
				POP		CX
				PUSH	CX
				MOV	BX,N-1				;☆☆
				CLC
		AD2:	MOV	AL,[SI+BX]
				ADC	AL,[DI+BX]
				AAA
				MOV	[DI+BX],AL
				DEC		BX
				LOOP	AD2
				POP		CX
				PUSH	CX
				MOV	BX,0					;☆☆☆
		AD3:  ADD 	BYTE  PTR [DI+BX],30H
				INC		BX
				LOOP	AD3
				POP		CX
				RET								;☆☆☆☆
		ADDA	ENDP
		CODE	ENDS
				END	START
