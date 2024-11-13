.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    slli t2, t1, 2
    add t3, a0, t2
    
    lw t4, 0(t3)
    bge t4, zero, loop_continue  # If value >= 0, continue
    sw zero, 0(t3)       # If value < 0, store 0
    
loop_continue:
    addi t1, t1, 1
    blt t1, a1, loop_start # If counter < length, continue loop
    
    jr ra

error:
    li a0, 36          
    j exit          
