.data
    array: .word 7, 9, 4, 3, 8, 1, 6, 2, 5
    output: .space 36
    count: .space 40
    newLine: .asciiz "\n"
    
.text
    main:
        addi $s0, $zero, 9 # Array Length, n
        addi $a1, $zero, 1
        jal radixSort
        jal printData
        li $v0, 10
        syscall #Exits program

    countSort:
        addi $a2, $zero, 0 # i = 0
        countSortLoop1:
            beq $a2, $s0, countSortLoop1Exit #Exit loop if i = n
            mul $t0, $a2, 4 # Multiply by number of bytes
            lw $t0, array($t0) # arr[i]
            div $t0, $t0, $a1 # (arr[i]/exp)
            addi $t2, $zero, 10
            div $t0, $t2 # (arr[i]/exp) % 10
            mfhi $t0
            mul $t0, $t0, 4
            lw $t1, count($t0) # count[(arr[i]/exp) % 10]
            addi $t1, $t1, 1 # (arr[i]/exp) % 10 + 1
            sw $t1, count($t0) # count[(arr[i]/exp) % 10]++
            addi $a2, $a2, 1 #i++
            j countSortLoop1
        countSortLoop1Exit:
            addi $a2, $zero, 1 # i = 1
            j countSortLoop2
        countSortLoop2:
            beq $a2, 10, countSortLoop2Exit # Exit loop if i = 10
            sub $t0, $a2, 1 # i-1
            mul $t0, $t0, 4 
            lw $t0, count($t0) # count[i-1]
            mul $t2, $a2, 4
            lw $t1, count($t2) # count[i]
            add $t0, $t0, $t1 # count[i] + count[i-1]
            sw $t0, count($t2) # count[i] = count[i] + count[i-1]
            addi $a2, $a2, 1
            j countSortLoop2
        countSortLoop2Exit:
            sub $a2, $s0, 1 # i = n - 1
            j countSortLoop3 
        countSortLoop3:
            slt $t1, $a2, $zero
            bne $t1, $zero, countSortLoop3Exit #Exit loop if i < 0
            mul $t0, $a2, 4
            lw $t0, array($t0) # arr[i]
            div $t1, $t0, $a1 # (arr[i]/exp)
            addi $t3, $zero, 10
            div $t1, $t3 # (arr[i]/exp) % 10
            mfhi $t1
            mul $t1, $t1, 4
            lw $t2, count($t1) # count[(arr[i]/exp) % 10]
            mul $t3, $t2, 4
            sub $t3, $t3, 4  # count[(arr[i]/exp) % 10] - 1
            sw $t0, output($t3) # output[count[(arr[i]/exp) % 10] - 1] = arr[i]
            div $t3, $t3, 4
            sw $t3, count($t1) # count[(arr[i]/exp) % 10] = count[(arr[i]/exp) % 10] - 1
            sub $a2, $a2, 1 # i--
            j countSortLoop3
        countSortLoop3Exit:
            addi $a2, $zero, 0 # i
            j countSortLoop4
        countSortLoop4:
            beq $a2, $s0, countSortLoop4Exit
            mul $t0, $a2, 4
            lw $t1, output($t0) # output[i]
            sw $t1, array($t0) # array[i] = output[i]
            addi $a2, $a2, 1 
            j countSortLoop4
        countSortLoop4Exit:
            mul $a1, $a1, 10 # exp *= 10
            addi $a2, $zero, 0
            addi $a3, $zero, 36
            j clearOutput
        clearOutput:
            beq $a2, $a3, clearOutputExit
            sw $zero, output($a2)
            addi $a2, $a2, 4
            j clearOutput
        clearOutputExit:
            addi $a2, $zero, 0
            addi $a3, $zero, 40
            j clearCount
        clearCount:
            beq $a2, $a3, clearCountExit
            sw $zero, count($a2)
            addi $a2, $a2, 4
            j clearCount
        clearCountExit:
            j radixSortLoop

    radixSort:
        j getMax
        radixSortLoop: # exp = a1
            div $a2, $v1, $a1 # m / exp
            slt $t1, $zero, $a2
            beq $t1, $zero, radixSortExit # Exit loop if m / exp <= 0
            j countSort
        radixSortExit: 
            jr $ra

    getMax:
        addi $t0, $zero, 0
        lw $s1, array($t0) # mx = arr[0]
        addi $a1, $zero, 1 # i = 1
        addi $a3, $zero, 4
        getMaxLoop:
            beq $a1, $s0, getMaxExit # Loop until i = mx
            lw $t0, array($a3) 
            slt	$t1, $s1, $t0
            addi $a1, $a1, 1 # i++
            bne $t1, $zero, loadIndex # if arr[i] > mx, then mx = arr[i]
            mul $a3, $a1, 4
            j getMaxLoop
        getMaxExit:
            add $v1, $zero, $s1 # return value
            addi $a1, $zero, 1 # i = 1
            j radixSortLoop

    loadIndex:
        lw $s1, array($a3)
        mul $a3, $a1, 4
        j getMaxLoop

    printData:
        addi $a1, $zero, 0 # i = 0
        addi $a2, $zero, 4
        mul $a2, $a2, $s0
        printDataLoop:
            beq $a1, $a2, printDataExit
            lw $t0, array($a1)
            li $v0, 1
            move $a0, $t0
            syscall #Prints current number
            li $v0, 4
            la $a0, newLine
            syscall #Prints new line
            addi $a1, $a1, 4
            j printDataLoop
        printDataExit:
            jr $ra


    
    


