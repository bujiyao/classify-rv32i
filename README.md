# Assignment 2: Classify

## abs
Core Logic of Absolute Value (abs) Implementation:

- Check if number is non-negative.
- If already positive (>= 0), keep original value.
- If negative, subtract from zero to make it positive.
```assembly
bge t0, zero, done  # If t0 >= 0, branch to done
sub t0, x0, t0      # t0 = 0 - t0
sw t0 0(a0)         # Store the result
```
## ReLU
Core Logic of ReLU (Rectified Linear Unit) Implementation:

- For each array element:
  - Keep value if positive or zero
  - Replace with zero if negative
```assembly
loop_start:
    slli t2, t1, 2
    add t3, a0, t2
    
    lw t4, 0(t3)
    bge t4, zero, loop_continue  # If value >= 0, continue
    sw zero, 0(t3)       # If value < 0, store 0
    
loop_continue:
    addi t1, t1, 1
    blt t1, a1, loop_start # If counter < length, continue loop
    
    jr ra
```
## argmax
Core Logic of Maximum Element Index Finder (argmax):

- Initialize with first element as current maximum
- Compare each element with current maximum
- Only update when finding strictly larger value
- Skip update when current value is less than or equal
```assembly
loop_start:
    bge t2, a1, loop_end     # If current index >= length, exit loop
    
    # Calculate current element address
    slli t3, t2, 2           # t3 = current index * 4
    add t4, a0, t3           # t4 = base address + offset
    lw t5, 0(t4)             # t5 = current element
    
    # Compare with current maximum
    ble t5, t0, loop_continue # If current <= max, skip update
    
    # Update maximum
    mv t0, t5
    mv t1, t2
    
loop_continue:
    addi t2, t2, 1
    j loop_start
    
loop_end:
    mv a0, t1
    jr ra
```
## Dot Product
The core logic of the dot function can be divided into 2 main parts:

1. **Main Loop**:
   - The function enters a loop where it processes each element from the two arrays, one by one.
   - For each element:
     - It calculates the memory offset for both arrays based on the current index (`i`) and the respective strides. This is done by adding the appropriate stride repeatedly for each index until the final offset for that element is reached.
     - It then accesses the elements from both arrays at the calculated offsets.
   
2. **Element Multiplication**:
   - The two elements are then multiplied. If either of the elements is negative, the function adjusts the signs by negating both values to ensure the multiplication is done using positive numbers.
   - To perform the multiplication, the function uses repeated addition. The element from the first array serves as the multiplier, and the element from the second array is repeatedly added to the result based on the value of the multiplier.
   - After the multiplication of the elements, the result is added to the sum.

Basic Operation Principle (Repeated Addition):
```
Multiplication a × b converted to:
result = 0
Repeat a times:
  result += b
```

## Matrix Multiplication (matmul)
Implementation of the matmul function, defined as:

$C[i][j] = \text{dot}(A[i], B[:,j])$

The `matmul` function performs matrix multiplication, specifically computing the result matrix ( C ) from the multiplication of two matrices \( M0 ) and ( M1 ). Here is the detailed explanation of its core logic:

1. **Outer Loop**:
   - The outer loop iterates over each row of matrix ( M0 ).
   - Each iteration of the outer loop corresponds to one row of the result matrix ( C ).

2. **Inner Loop**:
   - The inner loop iterates over each column of matrix ( M1 ) .
   - Each iteration of the inner loop computes one element of the result matrix ( C ), which is the dot product of the corresponding row from ( M0 ) and the corresponding column from ( M1 ).

## Read Matrix
To implement `mul`, we use the same logic from `Dot Product`:
```assembly
    # Calculate rows * cols using the dot product multiplication logic
    li s1, 0          # Initialize result
    mv t3, t1         # Copy rows to t3 (multiplier)
    mv t4, t2         # Copy cols to t4 (multiplicand)
    
    # Handle negative case if any
    bltz t3, mult_neg
    j mult_loop
    
mult_neg:
    neg t3, t3        # Make multiplier positive
    neg t4, t4        # Negate multiplicand

mult_loop:
    beqz t3, mult_done
    add s1, s1, t4    # Add multiplicand
    addi t3, t3, -1   # Decrement multiplier
    j mult_loop
```

## Write Matrix
To implement `mul`, we use the same logic from `Dot Product`:
```assembly
    # Calculate total elements (rows * cols)
    li s4, 0              # Initialize result
    mv t0, s2             # Copy rows (s2)
    mv t1, s3             # Copy cols (s3)
    
    # Handle negative case
    bltz t0, mult_neg
    j mult_loop
    
mult_neg:
    neg t0, t0            # Make rows positive
    neg t1, t1            # Negate cols

mult_loop:
    beqz t0, mult_done   
    add s4, s4, t1        # Add cols
    addi t0, t0, -1       # Decrement row counter
    j mult_loop
```

## Classification
Core Logic for Multiplication Implementation in Matrix Operations:
- All inputs are positive (matrix dimensions)
- No need to handle negative cases
- Can simplify multiplication implementation

Here's the solution to replace all `mul` instructions in your code:

1. First FIXME (computing h matrix size):
```assembly
# Original: mul a0, t0, t1
# Replace with:
li a0, 0              # Initialize result
mv t2, t0             # Copy rows value
mult1_loop:
    beqz t2, mult1_done
    add a0, a0, t1    # Add cols each iteration
    addi t2, t2, -1   # Decrement counter
    j mult1_loop
mult1_done:
```

2. Second FIXME (computing relu length):
```assembly
# Original: mul a1, t0, t1
# Replace with:
li a1, 0              # Initialize result
mv t2, t0             # Copy rows value
mult2_loop:
    beqz t2, mult2_done
    add a1, a1, t1    # Add cols each iteration
    addi t2, t2, -1   # Decrement counter
    j mult2_loop
mult2_done:
```

3. Third FIXME (computing o matrix size):
```assembly
# Original: mul a0, t0, t1
# Replace with:
li a0, 0              # Initialize result
mv t2, t0             # Copy rows value
mult3_loop:
    beqz t2, mult3_done
    add a0, a0, t1    # Add cols each iteration
    addi t2, t2, -1   # Decrement counter
    j mult3_loop
mult3_done:
```

4. Fourth FIXME (computing argmax length):
```assembly
# Original: mul a1, t0, t1
# Replace with:
li a1, 0              # Initialize result
mv t2, t0             # Copy rows value
mult4_loop:
    beqz t2, mult4_done
    add a1, a1, t1    # Add cols each iteration
    addi t2, t2, -1   # Decrement counter
    j mult4_loop
mult4_done:
```
## Result
```
test_abs_minus_one (__main__.TestAbs.test_abs_minus_one) ... ok
test_abs_one (__main__.TestAbs.test_abs_one) ... ok
test_abs_zero (__main__.TestAbs.test_abs_zero) ... ok
test_argmax_invalid_n (__main__.TestArgmax.test_argmax_invalid_n) ... ok
test_argmax_length_1 (__main__.TestArgmax.test_argmax_length_1) ... ok
test_argmax_standard (__main__.TestArgmax.test_argmax_standard) ... ok
test_chain_1 (__main__.TestChain.test_chain_1) ... ok
test_classify_1_silent (__main__.TestClassify.test_classify_1_silent) ... ok
test_classify_2_print (__main__.TestClassify.test_classify_2_print) ... ok
test_classify_3_print (__main__.TestClassify.test_classify_3_print) ... ok
test_classify_fail_malloc (__main__.TestClassify.test_classify_fail_malloc) ... ok
test_classify_not_enough_args (__main__.TestClassify.test_classify_not_enough_args) ... ok
test_dot_length_1 (__main__.TestDot.test_dot_length_1) ... ok
test_dot_length_error (__main__.TestDot.test_dot_length_error) ... ok
test_dot_length_error2 (__main__.TestDot.test_dot_length_error2) ... ok
test_dot_standard (__main__.TestDot.test_dot_standard) ... ok
test_dot_stride (__main__.TestDot.test_dot_stride) ... ok
test_dot_stride_error1 (__main__.TestDot.test_dot_stride_error1) ... ok
test_dot_stride_error2 (__main__.TestDot.test_dot_stride_error2) ... ok
test_matmul_incorrect_check (__main__.TestMatmul.test_matmul_incorrect_check) ... ok
test_matmul_length_1 (__main__.TestMatmul.test_matmul_length_1) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul.test_matmul_negative_dim_m0_x) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul.test_matmul_negative_dim_m0_y) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul.test_matmul_negative_dim_m1_x) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul.test_matmul_negative_dim_m1_y) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul.test_matmul_nonsquare_1) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul.test_matmul_nonsquare_2) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul.test_matmul_nonsquare_outer_dims) ... ok
test_matmul_square (__main__.TestMatmul.test_matmul_square) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul.test_matmul_unmatched_dims) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul.test_matmul_zero_dim_m0) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul.test_matmul_zero_dim_m1) ... ok
test_read_1 (__main__.TestReadMatrix.test_read_1) ... ok
test_read_2 (__main__.TestReadMatrix.test_read_2) ... ok
test_read_3 (__main__.TestReadMatrix.test_read_3) ... ok
test_read_fail_fclose (__main__.TestReadMatrix.test_read_fail_fclose) ... ok
test_read_fail_fopen (__main__.TestReadMatrix.test_read_fail_fopen) ... ok
test_read_fail_fread (__main__.TestReadMatrix.test_read_fail_fread) ... ok
test_read_fail_malloc (__main__.TestReadMatrix.test_read_fail_malloc) ... ok
test_relu_invalid_n (__main__.TestRelu.test_relu_invalid_n) ... ok
test_relu_length_1 (__main__.TestRelu.test_relu_length_1) ... ok
test_relu_standard (__main__.TestRelu.test_relu_standard) ... ok
test_write_1 (__main__.TestWriteMatrix.test_write_1) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix.test_write_fail_fclose) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix.test_write_fail_fopen) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix.test_write_fail_fwrite) ... ok

----------------------------------------------------------------------
Ran 46 tests in 26.891s

OK
```

## Reference
- [Assignment2: Complete Applications](https://hackmd.io/@sysprog/2024-arch-homework2#Part-A-Mathematical-Functions)
