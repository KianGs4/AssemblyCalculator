.data
.align 32
  num1:  .zero 80
.align 32
  num2:  .zero 80
.align 32
  res:   .zero 80
.align 2
  int_format:  .asciz "%d"
.align 2  
  string_format: .asciz "%s"
.align 2
  sign:   .zero 1
.align 2
  tempSign: .zero 1
.align 32
  tempSum:      .zero    80
.align 32
  tempNum1:      .zero    80
.align 32
  tempNum2:     .zero    80
.align 32
  tempNum3:      .zero    80
.align 32
  tempStorage:       .zero 40

.macro get_string arg1
        larl    %r3,\arg1
        larl    %r2,string_format
        brasl   %r14,scanf@PLT
.endm 


.macro print_string arg1
        larl    %r3,\arg1
        larl    %r2,string_format
        brasl   %r14,printf@PLT
.endm  

.macro alignment 
    stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
.endm 

.macro alignment_done
  lay     %r15, 8(%r15)
   lg      %r14, -4(%r15)
   br      %r14
.endm 

.macro negMul 
  xr   %r13,%r13
  xr   %r12,%r12
  larl %r1,num1
  lb   %r2,0(%r1)
  chi  %r2,'-' 
  je   negMul1C
  j    contNegMul
negMul1C:
  brasl 14,shiftLeftNumber1
  la    %r13,1
contNegMul:
  larl  %r1,num2
  lb    %r2,0(%r1)
  chi   %r2,'-' 
  je    negMul2C
  j     endNegMal
negMul2C:
  brasl 14,shiftLeftNumber2
  la    %r12,1
endNegMal:
  xr   %r13,%r12    
.endm

                        

  
.text 


print_int:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)
        lr      %r3,  %r2
        larl    %r2,  int_format
        brasl   %r14, printf
        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14

read_char:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)
        brasl   %r14, getchar
        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14

print_char:
	stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)
        brasl   %r14, putchar
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
        br      %r14


 print_nl:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)
        la      %r2,  10
        brasl   %r14, putchar
        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14


shiftLeftNumber1: 
  alignment 
  larl %r1,num1
loopShift1:
  mvc  0(1,%r1),1(%r1)
  ahi  %r1,1
  cli  0(%r1),0
  jne loopShift1
  alignment_done



shiftLeftNumber2:
  alignment
  larl %r1,num2
loopShift2:
  mvc  0(1,%r1),1(%r1)
  ahi  %r1,1
  cli  0(%r1),0
  jne loopShift2
  alignment_done

sizeNumber1:
    alignment
    xr %r4,%r4
    larl %r3,num1
loop_lc1:
    agfi %r3,1 #point to next char             
    lb   %r2, 0(%r3)
    agfi %r4,1
    chi  %r2, 0
    jne  loop_lc1
    lr %r2,%r4
    alignment_done

sizeNumber2:
    alignment
    xr %r4,%r4
    larl %r3,num2
loop_lc2:
    agfi %r3,1 #point to next char             
    lb   %r2, 0(%r3)
    agfi %r4,1
    chi  %r2, 0
    jne  loop_lc2
    lr %r2,%r4
    alignment_done    

shiftRightRes:
    alignment
    xr %r4,%r4
    larl %r3,res
sizeRLoop:
    agfi %r3,1 #point to next char             
    lb   %r2, 0(%r3)
    agfi %r4,1
    chi  %r2, 0
    jne  sizeRLoop
    ahi  %r4,-1
    larl %r1,res
    ar   %r1,%r4
shiftRLoop:
    mvc  1(1,%r1),0(%r1)
    ahi  %r1,-1
    ahi  %r4,-1
    chi  %r4,-1
    jne shiftRLoop
    alignment_done

killingZeroInResult:
    alignment
    xr  %r3,%r3
    ahi %r3,-1
    larl %r2,res
    lb   %r1,0(%r2)    
    chi  %r1,48
    jne  exitKilling
loopInterv:
    ahi %r3,1    
    lb  %r1,0(%r2,%r3)
    chi %r1,48
    je loopInterv
      
    xr %r4,%r4
    ahi %r4,-1
    lb %r1,0(%r2,%r3)
    chi %r1,0
    jne  loopReplace
    ahi %r3,-1
loopReplace:
    ahi %r4,1
    lb  %r1,0(%r2,%r3)
    stc %r1,0(%r2,%r4)
    lb  %r1,0(%r2,%r4)
    ahi %r3,1
    chi %r1,0
    jne loopReplace
    ahi %r4,1
 

exitKilling: 
    alignment_done




clearRes:
    alignment
    la      %r1,79
    larl    %r2,res
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop:
   stc      %r3,0(%r2) 
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop
   alignment_done


clearNum2:
    alignment
    la      %r1,79
    larl    %r2,num2
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop1:
   stc      %r3,0(%r2)
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop1
   alignment_done

clearNum1:
    alignment
    la      %r1,79
    larl    %r2,num1
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop2:
   stc      %r3,0(%r2)
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop2
   alignment_done

clearTempNum1:
    alignment
    la      %r1,79
    larl    %r2,tempNum1
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop3:
   stc      %r3,0(%r2)
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop3
   alignment_done

clearTempSum:
    alignment
    la      %r1,79
    larl    %r2,tempSum
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop4:
   stc      %r3,0(%r2)
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop4
   alignment_done

clearTempNum2:
    alignment
    la      %r1,79
    larl    %r2,tempNum2
    ar      %r2,%r1
    xr      %r3,%r3
clearLoop5:
   stc      %r3,0(%r2)
   ahi    %r1,-1
   ahi    %r2,-1
   chi     %r1,-1
   jne     clearLoop5
   alignment_done



convertResToNum1:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv1:
    ahi   %r1,1
    larl  %r3 , res
    larl  %r4 , num1
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv1

    alignment_done


convertNum2ToTempNum2:
    alignment    
    la   %r1,0
    ahi  %r1,-1
loopConv2:
    ahi   %r1,1
    larl  %r3 , num2
    larl  %r4 , tempNum2
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv2   
 
    alignment_done

convertResToNum2:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv3:
    ahi   %r1,1
    larl  %r3 , res
    larl  %r4 , num2
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv3

    alignment_done

convertNum1ToTempNum1:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv4:
    ahi   %r1,1
    larl  %r3 , num1
    larl  %r4 , tempNum1
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv4

    alignment_done

convertTempNum1ToNum1:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv5:
    ahi   %r1,1
    larl  %r3 , tempNum1
    larl  %r4 , num1
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv5

    alignment_done

convertTempSumToNum1:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv6:
    ahi   %r1,1
    larl  %r3 , tempSum
    larl  %r4 , num1
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv6

    alignment_done

convertResToTempSum:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv7:
    ahi   %r1,1
    larl  %r3 , res
    larl  %r4 , tempSum
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv7

    alignment_done

convertTempSumToRes:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv8:
    ahi   %r1,1
    larl  %r3 , tempSum
    larl  %r4 , res
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv8

    alignment_done

convertNum1ToRes:
    alignment
    la   %r1,0
    ahi  %r1,-1
loopConv9:
    ahi   %r1,1
    larl  %r3 , num1
    larl  %r4 , res
    lb    %r5 , 0(%r3,%r1)
    stc   %r5 , 0(%r4,%r1)
    chi   %r5 , 0
    jne    loopConv9

    alignment_done





addDigitMul: # digit -> r6
   alignment
   brasl 14,clearNum2
   larl  %r1,num2
   la   %r2,48
   stc  %r2,0(%r1)
loopDigitM:
   brasl 14,add_numbers
   ahi  %r6,-1
   chi  %r6,0
   je   exitDigitM
   brasl 14,convertResToNum2 
   j  loopDigitM
exitDigitM:
   alignment_done



mergeMulRes:
  alignment
  brasl 14,clearTempNum1
  brasl 14,convertNum1ToTempNum1
  brasl 14,clearNum1
  brasl 14,convertTempSumToNum1 
  brasl 14,clearNum2
  brasl 14,convertResToNum2
  brasl 14,add_numbers
  brasl 14,clearNum1
  brasl 14,convertTempNum1ToNum1
  brasl 14,convertResToTempSum
  alignment_done

subDigitDiv: #digit -> r6 
  alignment  
  xr %r6,%r6
  larl %r1,sign
  la   %r2,45
  stc  %r2,0(%r1)
  brasl 14,clearRes

loopDigitD:
  brasl 14,add_numbers
  brasl 14,killingZeroInResult 
  chi  %r13,1
  je  divisibleCond
  ahi  %r6,1
  brasl 14,clearNum1
  brasl 14,convertResToNum1
  brasl 14,clearRes
  j    loopDigitD
divisibleCond:

  larl %r1,res
  lb   %r2,0(%r1)
  chi  %r2,48
  jne  endDigitD
  ahi  %r6,1
  j    noRem
endDigitD:
   brasl  14,convertNum1ToRes
noRem:
  chi  %r6,10
  jne  exitNormal
  ahi  %r6,-10 
exitNormal:
  alignment_done


add_numbers: 
  alignment
#helpRegisters:
# r12 -> sub_mode or add_mode r -> r13 sign of the result r10 -> which of is bigger 
  xr  %r12,%r12
  xr  %r13,%r13
  xr  %r10,%r10

  larl %r1,num1
  lb   %r2,0(%r1)
  chi  %r2,'-' 
  je   num1Neg
  j  num2Sign
num1Neg:
  brasl 14,shiftLeftNumber1
  la    %r12,1
num2Sign:
  larl  %r1,num2
  lb    %r2,0(%r1)
  chi   %r2,'-' 
  je    num2Neg
  j     signChange
num2Neg:
  brasl 14,shiftLeftNumber2
  la    %r13,1
signChange:
  larl  %r1,sign 
  lb    %r2,0(%r1)
  chi   %r2,'-' 
  jne   getCompare
  ahi   %r13,1
  nilf   %r13,1
getCompare:
  brasl 14,sizeNumber1
  lr  %r7,%r2
  brasl 14,sizeNumber2
  lr  %r8,%r2
  ahi %r7,-1
  ahi %r8,-1

  xr   %r3,%r3
  lr   %r5,%r7
  sr   %r5,%r8
 
  chi  %r5,0
  je   whichOneIsBigger 
  chi  %r5,0
  jp   firstBigger
  la   %r10,1
  j    resultForSign
firstBigger:
  la   %r10,0
  j    resultForSign
  
whichOneIsBigger: 
  la   %r10,1
  larl %r1,num1
  lb   %r5,0(%r1,%r3)
  larl %r1,num2
  lb   %r4,0(%r1,%r3)
  sr   %r5,%r4
  chi  %r5,0
  jp   firstBigger
  cr   %r3,%r7
  je   resultForSign
  ahi  %r3,1
  chi  %r5,0
  je   whichOneIsBigger
  
resultForSign:
  lr  %r3,%r12
  ar  %r12,%r13
  nilf  %r12,1
  chi %r12,0 
  je  simplyRecognize 
  xr  %r3,%r10
 
simplyRecognize:
  lr  %r13,%r3
#r9 -> result's length
  lr  %r9,%r7
  cr  %r7,%r8
  jnm  noChangeR9
  lr  %r9,%r8
noChangeR9:
  xr   %r3,%r3
add_sub_mode:
  xr  %r4,%r4
  xr  %r5,%r5
 
  chi %r7,-1
  jnp  nextNum
  larl %r1,num1
  ar   %r1,%r7
  lb  %r4,0(%r1)
  ahi %r4,-48
nextNum:
  chi %r8,-1
  jnp  optMode
  larl %r2,num2
  ar   %r2,%r8
  lb  %r5,0(%r2)
  ahi %r5,-48
 

optMode:
  chi  %r12,0
  jne  subOpt
addOpt:
  ar %r4,%r5
  ar %r4,%r3
  chi %r4,10
  jm  noCarry
  la %r3,1
  ahi %r4,-10
  j moveDigit
noCarry:  
  la %r3,0
  j  moveDigit 

subOpt:

 chi %r10,0
 je  firstBiggerSub
 sr  %r5,%r4
 ar  %r5,%r3
 lr  %r4,%r5
 j carrySubCheck
firstBiggerSub:
 sr  %r4,%r5
 ar  %r4,%r3
carrySubCheck:
 chi %r4,0
 jnm  noCarrySub
 xr  %r3,%r3
 ahi %r3,-1
 ahi  %r4,10
 j    moveDigit
noCarrySub:
 la   %r3,0

moveDigit:
  larl %r1,res
  ahi %r4,48
  stc  %r4,0(%r1,%r9)
  ahi %r9,-1
  ahi %r8,-1
  ahi %r7,-1
  chi %r9,-1
  jne add_sub_mode

  chi %r3,1
  jne doneAdd
  brasl 14,shiftRightRes
  la  %r1,49
  larl %r2,res
  stc  %r1,0(%r2)
doneAdd:
  
   alignment_done


.globl asm_main
    asm_main:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)
ask:
        brasl  14,read_char
        larl   %r1,sign
        stc    %r2,0(%r1)

        chi  %r2,'q' 
        je   exitCode

        larl   %r1,sign
        stc    %r2,0(%r1)

        get_string num1
        get_string num2
        larl %r1,sign
        lb   %r2,0(%r1)
        chi  %r2,'+' 
        je   add_mode
        chi  %r2,'-' 
        je   add_mode
        chi  %r2,'*' 
        je   mul_mode
        chi  %r2,'/' 
        je   div_mode
        chi  %r2,'%' 
        je   div_mode
        j ask  


add_mode: 
  brasl 14,add_numbers
  j     print_mode

mul_mode:
# clear temp sum
  brasl 14,clearTempNum1
  brasl 14,clearTempNum2
  brasl 14,clearTempSum

  larl %r1,tempSum
  la   %r2,48
  stc  %r2,0(%r1)
# r13 < sign 
  negMul
  larl %r1,tempStorage
  stc  %r13,8(%r1)

#get sizes
  brasl 14,sizeNumber1
  lr    %r7,%r2
  ahi   %r7,-1
  brasl 14,sizeNumber2
  lr    %r8,%r2
  ahi   %r8,-1
#add zero to num1
  larl  %r1,num1
  ar    %r1,%r7
  ahi   %r1,1
  xr    %r2,%r2
loopAddingZero:
   cr  %r2,%r8
   je  endLoopAddingZero
   la  %r3,48
   stc  %r3,0(%r1)
   ahi %r1,1
   ahi %r2,1
   j   loopAddingZero
endLoopAddingZero:
 
   #save num1's length 
   brasl  14,sizeNumber1
   ahi    %r2,-1
   larl   %r1,tempStorage
   stc    %r2,4(%r1)
  
   brasl 14,convertNum2ToTempNum2
   xr    %r1,%r1
   larl  %r2,tempStorage
   stc   %r1,0(%r2)   

multiAddLoop:
   larl  %r1,tempStorage
   lb    %r2,0(%r1)
   larl  %r3,tempNum2
   lb    %r6,0(%r3,%r2)
   ahi   %r6,-48
   ahi   %r2,1
   stc   %r2,0(%r1)
   chi   %r6,0
   je    zeroException
#-----------
   brasl 14,clearRes
   brasl 14,addDigitMul
   brasl 14,mergeMulRes
   larl  %r1,num1
   larl  %r2,tempStorage
   lb    %r3,4(%r2)
   xr    %r4,%r4
   stc   %r4,0(%r1,%r3)
   ahi   %r3,-1
   stc   %r3,4(%r2) 
#----------
zeroException:
   # one zero remove and tempSum adding 
   larl  %r1,tempStorage
   lb    %r2,0(%r1)
   larl  %r3,tempNum2
   lb    %r4,0(%r3,%r2)
   chi   %r4,0
   jne   multiAddLoop
   brasl 14,convertTempSumToRes
   larl  %r1,tempStorage
   lb    %r13,8(%r1)
   j     print_mode
  

div_mode:
  larl %r1,sign
  larl %r2,tempSign
  lb   %r3,0(%r1)
  stc  %r3,0(%r2)

# clear temp sum
  brasl 14,clearTempNum1
  brasl 14,clearTempNum2
  brasl 14,clearTempSum

  larl %r1,tempSum
  la   %r2,48
  stc  %r2,0(%r1)

  xr   %r13,%r13
  xr   %r12,%r12
  larl %r1,num1
  lb   %r2,0(%r1)
  chi  %r2,'-' 
  je   negDiv1
  j    contNegDiv
negDiv1:
  brasl 14,shiftLeftNumber1
  la    %r13,1
contNegDiv:
  larl  %r1,num2
  lb    %r2,0(%r1)
  chi   %r2,'-' 
  je    negDiv2
  j     endNegDiv
negDiv2:
  brasl 14,shiftLeftNumber2
  la    %r12,1
endNegDiv:
  larl %r1,tempStorage
  stc  %r13,24(%r1)
  stc  %r12,28(%r1)


#get sizes
  brasl 14,sizeNumber1
  lr    %r7,%r2
  ahi   %r7,-1
  brasl 14,sizeNumber2
  lr    %r8,%r2
  ahi   %r8,-1

  lr    %r4,%r7
  sr    %r4,%r8
  chi   %r4,0
  jnm   continueDiv
  brasl 14,convertNum1ToRes
  j   printingDiv
continueDiv:

  xr    %r3,%r3
  larl  %r1,num2
  ar    %r1,%r8
zeroAddingDiv:
  cr  %r3,%r4
  je  endZeroAddingDiv
  la  %r2,48
  stc %r2,1(%r1)
  ahi %r1,1
  ahi %r3,1  
  j   zeroAddingDiv
endZeroAddingDiv:
  lr    %r6,%r4
  brasl 14,sizeNumber2
  ahi   %r2,-1
  larl  %r1,tempStorage
  stc   %r2,12(%r1) # 12 -> num2's length
  stc  %r6,16(%r1) # 16 -> diff(size)

  xr   %r2,%r2
  stc  %r2,20(%r1)

loopExtractDigit:
   brasl 14,subDigitDiv
  
   larl  %r1,tempStorage
   larl  %r2,tempSum
   larl  %r3,num2
   lb    %r4,16(%r1)
   lb    %r5,12(%r1)
   lb    %r7,20(%r1)

   la    %r8,0
   ar    %r3,%r5
   stc   %r8,0(%r3)

   ar   %r2,%r7
   ahi  %r6,48
   stc  %r6,0(%r2)

   ahi   %r7,1
   ahi   %r5,-1 
   ahi   %r4,-1
   stc   %r7,20(%r1)
   stc   %r5,12(%r1)
   stc   %r4,16(%r1)    
   chi  %r4,-1
   jne  loopExtractDigit
printingDiv:
   larl %r3,tempStorage
   larl %r1,tempSign
   lb   %r2,0(%r1)
   chi  %r2,37
   je   modAsk
   lb  %r13,24(%r3)
   lb  %r12,28(%r3)
   xr  %r13,%r12
   brasl 14,convertTempSumToRes
   j    print_mode
modAsk:  
   lb  %r13,24(%r3)
   j   print_mode



print_mode: #sign -> r13
   brasl 14,killingZeroInResult
   chi  %r13,0
   je   printDefault
   larl %r1,res
   lb   %r2,0(%r1)
   chi  %r2,48
   je   printDefault
   la   %r2,45
   brasl 14,print_char
printDefault:
   print_string res
   brasl 14,clearRes
   brasl 14,print_nl
   brasl 14,read_char
   brasl 14,clearNum1
   brasl 14,clearNum2
   j ask

exitCode:
        lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
        br      %r14

