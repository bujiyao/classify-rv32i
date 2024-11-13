.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end        # Check if done
    
    # Calculate offset for array1
    mv t2, t1                   # Copy counter
    li t3, 0                    # Initialize offset1
offset1_loop:
    beqz t2, offset1_done
    add t3, t3, a3             # Add stride1
    addi t2, t2, -1
    j offset1_loop
offset1_done:
    slli t3, t3, 2             # Convert to bytes
    add t3, a0, t3             # Add base address
    lw t4, 0(t3)               # Load from array1
    
    # Calculate offset for array2
    mv t2, t1                  # Copy counter
    li t3, 0                   # Initialize offset2
offset2_loop:
    beqz t2, offset2_done
    add t3, t3, a4            # Add stride2
    addi t2, t2, -1
    j offset2_loop
offset2_done:
    slli t3, t3, 2            # Convert to bytes
    add t3, a1, t3            # Add base address
    lw t5, 0(t3)              # Load from array2
    
    # Multiply elements
    li t6, 0                  # Initialize product
    bltz t4, handle_neg       # If negative, handle separately
    mv t3, t4                 # Copy multiplier
    j mult_loop

handle_neg:
    neg t3, t4                # Make positive
    neg t5, t5                # Negate multiplicand

mult_loop:
    beqz t3, mult_done        # If multiplier is 0, done
    add t6, t6, t5            # Add multiplicand
    addi t3, t3, -1           # Decrement multiplier
    j mult_loop

mult_done:
    add t0, t0, t6            # Add to sum
    addi t1, t1, 1           # Increment counter
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit