;******************************************************************************
; Author: Skye Antinozzi
; Description: A boolean calculator that can perform AND, OR, NOT and XOR
;			   operations with 32-bit hexadecimal integers.
;******************************************************************************
TITLE BooleanCalculator.asm

INCLUDE Irvine32.inc

.data
	;Define a lookup table
	CaseTable BYTE 1					;first option value
			  DWORD AND_op			;first option procedure

			  EntrySize = ($ - CaseTable)	;entry size (doesn't use memory)

			  BYTE 2				;second option value
			  DWORD OR_op				;second option procedure
			  BYTE 3				;third option value                
			  DWORD NOT_op			;third option procedure            
			  BYTE 4				;fourth option value
			  DWORD XOR_op			;fourth option procedure
			  BYTE 5				;fifth option value
			  DWORD EXIT_op			;fifth option procedure

			  ;number of entries (doesn't use memory)
			  NumEntries = ($ - CaseTable) / EntrySize	
	;end lookup table
			
	;display prompts
	prompt BYTE "Boolean Calculator", 10, 13, 
				"------------------", 10, 13,
				"1. x AND y", 10, 13,		
				"2. x OR y", 10, 13,
				"3. NOT x", 10, 13, 
				"4. x XOR y", 10, 13,
				"5. Exit program", 10, 10, 13,
				"Enter Selection: ", 0

	restartPrompt BYTE "Perform another calculation? (Yes = 1/No = 0) : ", 0
	resultPrompt BYTE "Result = ", 0 
	notFound BYTE "Could not find symbol: ", 0	
	msgAnd BYTE "Bitwise AND Operation", 10, 13, 0	
	msgOr BYTE "Bitwise OR Operation", 10, 13, 0
	msgNot BYTE "Bitwise NOT Operation", 10, 13, 0
	msgXor BYTE "Bitwise XOR Operation", 10, 13, 0
	msgExit BYTE "Exiting program...", 10, 13, 0
	firstInput BYTE "Enter a 32-bit hexadecimal integer: ", 0
	secondInput BYTE "Enter another 32-bit hexadecimal integer: ", 0
	;end display prompts


.code

main PROC

	;start of program
	start:
		call Clrscr					;refresh screen
		mov edx, OFFSET prompt		;set the menu
		call WriteString			;display the menu
		call ReadDec				;read selection, store in eax

		mov esi, OFFSET CaseTable		;point to the start of CaseTable
		mov ecx, NumEntries			;loop will run for each menu option

	;compare user selection to menu options
	selectionLoop:
		cmp al, [esi]			;compare lower eax (al) with table pointee
		jne continue			;not equal -> continue to next comparison
		call NEAR PTR [esi+1]	;equal -> call corresponding procedure		
		jmp finishLoop		;procedure returns -> leave the loop
	
	;no match, then continue to next comparison	
	continue:					
		add esi, EntrySize		;point to next menu option		
		loop selectionLoop		;continue loop

	;not in list, then symbol is unsupported
	unsupported:
		mov edx, OFFSET notFound	;symbol cannot be found
		call WriteString
		mov edx, eax			;show attempted symbol 
		call WriteDec
		call Crlf

	;end of loop
	finishLoop:					
		mov edx, OFFSET restartPrompt	;request for restart
		call WriteString
		call ReadDec				;read input
		cmp al, 1				;if input is 1
		je start				;then restart

	exit						;finish the program

main ENDP

;******************************************************************************
; Procedure: getOperands
; Description: Gets two 32-bit hexadecimal values from the user.
; Returns: ebx = first input
;		   eax = second input
;******************************************************************************
getOperands PROC

	;get first input
	mov edx, OFFSET firstInput
	call WriteString
	call ReadHex				
	
	;store first input
	mov ebx, eax				

	;get second input
	mov edx, OFFSET secondInput
	call WriteString
	call ReadHex					

	;return to caller
	ret	
	
getOperands ENDP

;******************************************************************************
; Procedure: displayHexResult
; Description: Displays a formatted string of the hex value stored in eax.
;******************************************************************************
displayHexResult PROC

	;output the result stored in eax
	mov edx, OFFSET resultPrompt
	call WriteString
	call WriteHex			
	call Crlf

	;return to caller
	ret		
	
displayHexResult ENDP

;******************************************************************************
; Procedure: AND_op
; Description: ANDs two 32-bit hex integers and displays the result in hex.
;******************************************************************************
AND_op PROC
	;output boolean operation message
	call Crlf					
	mov edx, OFFSET msgAnd		
	call WriteString			

	;get the operands
	call getOperands			

	;perform the indicated operation
	and eax, ebx				

	;output the result stored in eax
	call displayHexResult

	;return to caller
	ret	
	
AND_op ENDP

;******************************************************************************
; Procedure: OR_op
; Description: ORs two 32-bit hex integers and displays the result in hex.
;******************************************************************************
OR_op PROC
	;output boolean operation message
	call Crlf					
	mov edx, OFFSET msgOr		
	call WriteString			

	;get the operands
	call getOperands			

	;perform the indicated operation
	or eax, ebx				

	;output the result stored in eax
	call displayHexResult

	;return to caller
	ret
	
OR_op ENDP

;******************************************************************************
; Procedure: NOT_op
; Description: NOTs a 32-bit hex integer and displays the result in hex.
;******************************************************************************
NOT_op PROC
	;output boolean operation message
	call Crlf					
	mov edx, OFFSET msgNot		
	call WriteString			

	;get the operand
	mov edx, OFFSET firstInput
	call WriteString
	call ReadHex				
	
	;store first input
	not eax			

	;output the result stored in eax
	call displayHexResult

	;return to caller
	ret
	
NOT_op ENDP

;******************************************************************************
; Procedure: XOR_op
; Description: XORs two 32-bit hex integers and displays the result in hex.
;******************************************************************************
XOR_op PROC
	;output boolean operation message
	call Crlf					
	mov edx, OFFSET msgXor	
	call WriteString			

	;get the operands
	call getOperands			

	;perform the indicated operation
	xor eax, ebx	
	
	;output the result stored in eax
	call displayHexResult		

	;return to caller
	ret
	
XOR_op ENDP

;******************************************************************************
; Procedure: EXIT_op
; Description: Exits the program.
;******************************************************************************
EXIT_op PROC
	;output exit messsage
	mov edx, OFFSET msgExit
	call WriteString
	call Crlf

	;exit
	exit
	
EXIT_op ENDP

end main


