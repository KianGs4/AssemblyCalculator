section .data                          

%macro read 2
 mov eax,3
 mov ebx,2
 mov ecx,%1 ; the destination of reading number
 mov edx,%2 ; size of number
 int 80h

%endmacro 

%macro print 2
  mov  eax, 4
   mov ebx, 1
   mov ecx, %1
   mov edx, %2
   int 80h
%endmacro

%macro neg 0

; Specify the sign 
   mov r14,0
   cmp byte [num1],'-' 
   jne firstNeg
   call shiftNumber1
   inc r14
firstNeg:
   cmp byte [num2],'-' 
   jne secondNeg
   call shiftNumber2
   inc r14
secondNeg:
   and r14,1

%endmacro


%macro clear 2
    mov rcx,%2
clearLoop:
    mov byte [%1 + rcx],0
    loop  clearLoop
%endmacro



section .bss           ;Uninitialized data
   num1 resb 80 
   num2 resb 80
   res  resb 80
   sign resb 1
   temp resb 1
   tempSum  resb 80
   tempNum1 resb 80
   tempNum2 resb 80
   tempNum3 resb 80

	
section .text          ;Code Segment
   global _start

;functions:

getSizeNumber1: ;get size of first number -> output: r10
  mov r10,-1 ;initialize
loopSize1:
  inc r10
  cmp byte  [num1 + r10],10 ; compare to white space
  jne loopSize1
  dec r10
  ret

shiftNumber1: ;use al and rdx
  mov rdx,-1 
loopShift1:
  inc rdx
  mov  al, [num1 + rdx + 1]
  mov  [num1 + rdx],al
  cmp byte  [num1 + rdx + 1],10 ; compare to white space
  jne loopShift1
  ret



getSizeNumber2: ;get size of first number -> output: r11
  mov r11,-1 ;initialize 
loopSize2:
  inc r11 
  cmp byte  [num2 + r11],10 ;compare to white space
  jne loopSize2
  dec r11
  ret

shiftNumber2: ;use al and rdx
  mov rdx,-1 
loopShift2:
  inc rdx
  mov  al, [num2 + rdx + 1]
  mov  [num2 + rdx],al
  cmp byte  [num2 + rdx + 1],10 ; compare to white space
  jne loopShift2
  ret

shiftRightRes:
   mov r12,-1 ;initialize 
loopSizeRes:
  inc r12
  cmp byte  [res + r12],10 ;compare to white space
  jne loopSizeRes
  inc r12
loopRight:  
  dec r12
  mov byte al, [res + r12]
  mov byte [res + r12 + 1],al
  cmp r12,0
  jne loopRight
  ret

 
   
killingZeroInResult: ;use al and rdx and rbx
  mov rdx,-1
  cmp byte [res + 0],'0' 
  jne exitKilling
loopInterv:
  inc rdx
  cmp byte [res + rdx],'0' 
  je loopInterv

  mov rbx,-1
  cmp byte [res + rdx],10
  jne loopReplace
  dec rdx
loopReplace:
  inc rbx
  mov byte  al, [res + rdx + rbx]
  mov byte [res + rbx], al
  cmp byte [res + rbx + 1],10 
  jne loopReplace 
  inc rbx
  mov byte  al, [res + rdx + rbx]
  mov byte [res + rbx], al

exitKilling:
  ret


clearRes: 
    mov rcx,80
loopClear:
    mov byte [res + rcx],0
    loop  loopClear
    ret 

convertTempNum2ToNum2: ;use rdx and al
    mov rdx,-1
loopConv:
   inc rdx
   mov byte al,[tempNum2 + rdx]
   mov byte [num2  + rdx],al
   cmp byte [tempNum2 + rdx],10
   jne loopConv
   ret

convertNum2ToTempNum2: ;use rdx and al
    mov rdx,-1
loopConv1:
   inc rdx
   mov byte al,[num2 + rdx]
   mov byte [tempNum2  + rdx],al
   cmp byte [num2 + rdx],10
   jne loopConv1
   ret 

convertTempSumToRes: ;use rdx and al 
   mov rdx,-1
loopConv2:
   inc rdx
   mov byte al,[tempSum + rdx]
   mov byte [res + rdx],al
   cmp byte [tempSum + rdx],10
   jne loopConv2
   ret

convertResToNum1: ;use rdx and al 
   mov rdx,-1
loopConv3:
   inc rdx
   mov byte al,[res + rdx]
   mov byte [num1 + rdx],al
   cmp byte [res + rdx],10
   jne loopConv3
   ret

convertResToNum2: ;use rdx and al 
   mov rdx,-1
loopConv4:
   inc rdx
   mov byte al,[res + rdx]
   mov byte [num2 + rdx],al
   cmp byte [res + rdx],10
   jne loopConv4
   ret
convertNum1ToTempNum3: ;use rdx and al 
   mov rdx,-1
loopConv5:
   inc rdx
   mov byte al,[num1 + rdx]
   mov byte [tempNum3 + rdx],al
   cmp byte [num1 + rdx],10
   jne loopConv5
   ret
convertTempNum3ToNum1: ;use rdx and al 
   mov rdx,-1
loopConv6:
   inc rdx
   mov byte al,[tempNum3 + rdx]
   mov byte [num1 + rdx],al
   cmp byte [tempNum3 + rdx],10
   jne loopConv6
   ret
 

addInDigit: ;bl -> number of add operation
  ;initialize num2 to 0
  mov byte [num2],48
  mov byte [num2 + 1],10
  
loopAddDigit:
  push rbx
  call add_numbers
  pop rbx ;move res to num2: 
  dec bl
  cmp byte bl,0
  je  exitSingleAdd
  mov rdx,-1
loopConvert:
   inc rdx
   mov byte al,[res + rdx]
   mov byte [num2  + rdx],al
   cmp byte [res + rdx],10
   jne loopConvert
   jmp loopAddDigit
exitSingleAdd:
   ret


addToSum:
  mov rdx,-1
movLoop1:
   inc rdx
   mov byte al,[res + rdx]
   mov byte [num2  + rdx],al
   cmp byte [res + rdx],10
   jne movLoop1

   mov rdx,-1
movLoop2:
   inc rdx
   mov byte al,[num1 + rdx]
   mov byte [tempNum1  + rdx],al
   cmp byte [num1 + rdx],10
   jne movLoop2

   mov rdx,-1
movLoop3:
   inc rdx
   mov byte al,[tempSum + rdx]
   mov byte [num1  + rdx],al
   cmp byte [tempSum + rdx],10
   jne movLoop3

   call add_numbers
   
   mov rdx,-1
movLoop4:
   inc rdx
   mov byte al,[res + rdx]
   mov byte [tempSum  + rdx],al
   cmp byte [res + rdx],10
   jne movLoop4
   
   mov rdx,-1
movLoop5:
   inc rdx
   mov byte al,[tempNum1 + rdx]
   mov byte [num1  + rdx],al
   cmp byte [tempNum1 + rdx],10
   jne movLoop5

   ret


divSubDigit:

  mov al,0
  push rbx
  mov byte [sign],'-' 
loopSubDigit:
  push rax
  call add_numbers
  call killingZeroInResult
  pop  rax
  cmp  r14,1
  je   endLoopSubDigit
  inc  rax

  mov rdx,-1
convertDivLoop:
   inc rdx
   mov byte bl,[res + rdx]
   mov byte [num1  + rdx],bl
   cmp byte [res + rdx],10
   jne convertDivLoop
   
   jmp  loopSubDigit  

endLoopSubDigit:
  cmp byte [res],48
  jne notDivisible
  inc al 
notDivisible:
  cmp al,10
  jne notRem
   sub al,10
notRem:
  pop rbx
  add al,48
  mov byte [tempSum + rbx],al
  mov byte [tempSum + rbx + 1],10
  ret
 



add_numbers:
 
  ; r13 -> 1:sub_mode or 0:add_mode, r14 -> - sign for result, r15 -> wich one of number is bigger 0:first 1:second
  ;initialize r13,r14,r15:
  
  xor r13,r13
  xor r14,r14
  xor r15,r15
  cmp byte [num1 + 0],'-'   
  je  firstNumberNeg
  jmp secondNumerRec
  
firstNumberNeg:
  call shiftNumber1
  mov  r13,1

secondNumerRec:
  cmp byte [num2 + 0],'-' 
  je  secondNumberNeg
  jmp signChange
secondNumberNeg: 
  call shiftNumber2
  mov  r14,1
signChange:
  cmp  byte [sign], '-' 
  jne  getSizes
  add  r14,1
  and  r14,1
getSizes: 
  call  getSizeNumber1 ;result: r10
  call  getSizeNumber2 ;result: r11
  xor  rax,rax
  xor  rbx,rbx
  mov  r15,r10
  sub  r15,r11
  cmp  r15,0
  je   wichOneIsBigger
  cmp  r15,0
  jg   firstBigger
  mov  r15,1
  jmp  resultForSign
firstBigger:
  mov  r15,0
  jmp   resultForSign
wichOneIsBigger:
  mov  r15,1
  mov  dl, byte [num1 + rax]
  sub  dl, byte [num2 + rbx]
  cmp  dl,0
  jg   firstBigger
  cmp  rax,r10
  je   resultForSign
  inc  rax
  inc  rbx
  cmp  dl,0
  je   wichOneIsBigger
 
resultForSign:
  mov  r9,r13
  add  r13,r14
  and   r13,1
  cmp  r13,0
  je   simplyRecognize
  ;r9 -> 1  #r15 ->0 r14 ->1
  ;r9 -> 1  #r15 ->1 r14 ->0
  ;r9 -> 0  #r15 ->0 r14 ->0
  ;r9 -> 0  #r15 ->1 r14 ->1
  xor  r9,r15
simplyRecognize:
  mov  r14,r9

  ; calculate size of result to r12
  mov   r12,r10
  cmp   r10,r11
  jg    right_guess
  mov   r12,r11
right_guess:
  inc r12
  mov byte [res + r12],10 ; add white space for end of the result number
  dec r12

  ; dl -> first digit, bl -> second digit, al -> carry


  mov al,0
addLoop:
  mov dl,0
  mov bl,0     

  cmp r10,-1
  je  nextDigit 
  mov dl,[num1 + r10]
  sub dl,48
  dec r10

nextDigit:  
  cmp r11,-1
  je  digitOperation
  mov bl,[num2 + r11]
  sub bl,48
  dec r11  

digitOperation: 
  cmp r13,0
  jne subDigit
sumDigit:
  add  al,bl
  add  al,dl
  cmp al,10
  jge withCarrySum
  add al,48
  mov [res + r12],al
  mov al,0
  jmp endLoop
withCarrySum:
  sub al,10
  add al,48
  mov [res + r12],al
  mov al,1
  jmp  endLoop

subDigit:
  cmp  r15,0
  je   firstDigitBigger
  jmp  secondDigitBigger

firstDigitBigger:
  add al,dl
  sub al,bl
  jmp carryCheck
secondDigitBigger:
  add al,bl
  sub al,dl 

carryCheck:
  cmp al,0
  jl  withCarrySub
  add al,48
  mov [res + r12],al
  mov al,0
  jmp endLoop
withCarrySub:
  add al,10
  add al,48
  mov [res + r12],al
  mov al,-1
  jmp endLoop

endLoop:
  dec r12
  cmp r12,-1
  jne addLoop
  cmp al,0 
  je  retAdd
  call shiftRightRes
  mov byte [res + 0],49

retAdd:
   ret



_start:
   read      sign,1
   cmp byte  [sign],'q'  ;sign -> exit mode
   je         exit
   read  num1,80 ; for white space between number and sign 
   read  num1,80
   read  num2,80
   cmp byte  [sign],'+' ; sign '+' -> add_mode
   je  add_mode
   cmp byte  [sign],'-' ; sinf '-' -> add_mode(add with neg(num2)
   je  add_mode
   cmp byte  [sign],'*' 
   je  mul_mode 
   cmp byte  [sign],'/' 
   je  div_mode
   cmp  byte [sign],'%' 
   je rem_mode
   jmp exit
printing_mode:
   call killingZeroInResult
   cmp r14,0
   je  printRes
   cmp byte [res],'0' 
   je  printRes
   mov byte  [temp],'-' 
   print temp,1
printRes:
   print res,80
   call clearRes
   jmp  _start


add_mode:
   call add_numbers
   jmp printing_mode

mul_mode:
   neg 
   push r14
   call getSizeNumber1
   call getSizeNumber2
   call convertNum2ToTempNum2
   ;initialize tempSum:
   mov byte [tempSum],48
   mov byte [tempSum + 1],10
   ;shift num1 in base 10 and multiply to digit in 10^k 
   mov rdx,r11
loopMul:
   mov byte bl, [tempNum2 + rdx]
   sub bl,48
   cmp rdx,r11
   je  noZero
   mov byte [num1 + r10 + 1], 48
   mov byte [num1 + r10 + 2], 10
   inc r10
noZero:
   push rdx 
   push r10
   push r11
   cmp  byte bl,0
   je   noAddOperation
   call addInDigit
   call addToSum
noAddOperation:
   pop  r11
   pop  r10
   pop  rdx

   dec  rdx
   cmp  rdx,-1
   jne   loopMul
   call  convertTempSumToRes
   pop r14
   cmp byte [temp],'%' 
   je  modCont2
   jmp printing_mode

div_mode:
   mov byte [tempSum],48
   mov byte [tempSum + 1],10
;Specify the sign 
   mov r14,0
   cmp byte [num1],'-' 
   jne firstNeg2
   call shiftNumber1
   inc r14
firstNeg2:
   cmp byte [num2],'-' 
   jne secondNeg2
   call shiftNumber2
   inc r14
secondNeg2:
   and r14,1
   push r14

   call getSizeNumber1
   call getSizeNumber2
   cmp r11,r10
   jg   printDiv
   mov rdx,r11
   push rdx
   dec rdx
addZeroLoop:
   inc rdx
   cmp rdx,r10
   je  endAddZeroLoop
   mov byte [num2 + r11 + 1],48
   inc r11
   jmp addZeroLoop
endAddZeroLoop:
   mov byte [num2 + r11 + 1],10
   mov rbx,r10
   pop rdx
   sub rbx,rdx
   mov rdx,rbx
   inc rdx
   xor rbx,rbx
divLoop:
   push rdx
   push rbx
   push r10
   push r11
   call divSubDigit
   pop  r11
   pop  r10
   pop  rbx
   pop  rdx
   mov  byte [num2 + r11 + 1],0
   mov byte  [num2 + r11],10
   dec  r11 
   inc  rbx
   cmp  rbx,rdx
   jne divLoop
printDiv:
   call clearRes 
   call convertTempSumToRes
   pop r14
   cmp byte [temp], '%' 
   je  modCont
   jmp printing_mode

rem_mode:
   call convertNum1ToTempNum3
   call convertNum2ToTempNum2
   mov byte [temp],'%' 
   jmp div_mode
modCont:
   push r14
   call convertTempNum2ToNum2
   call convertResToNum1
   jmp mul_mode
modCont2:
;sign:
   pop r13
   add r14,r13
   and r14,1
   call convertTempNum3ToNum1
   call convertResToNum2
   mov byte [sign],'-'   
   cmp r14,1
   jne noChange
   mov byte [sign],'+' 
noChange:
   mov byte [temp],'X' 
   call add_numbers
   jmp printing_mode
   

exit:
   mov eax, 1
   mov ebx, 0
   int 80h
