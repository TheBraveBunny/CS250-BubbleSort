.data
/* Only declare static strings here */
.text
.global bubble
bubble:
/* your code goes here */
	mov	%rdi,	%r8	#length of array
	imul	$4,	%r8	#length of array in bytes
	movq	%rsi,	%r9	#ptr to first value
	mov	$0,	%r10	#checks if had to switch
	#mov	$0,	%r11	#number of times through array
	movq	%r9,	%r12	#position 1 in array
	movq	%r9,	%r13	#position 2 in array
	addq	$4,	%r13
	mov	$4,	%r15	#place of position 2 in array

	start:
	pushq	%rbp		#push base pointer
	movq	%rsp,	%rbp	#set base pointer to stack pointer
	subq	$8,	%rsp	#allocate 8 bytes for local use
	
	through_array:
	mov	(%r12),	%r12	#get value at position 1
	mov	(%r13),	%r13	#get value at position 2
	cmp	%r12d,	%r13d	#compare values
	jl	switch		#if first is larger, then switch
	
	movq	%r9,	%r12	#reset position 1 to address
	addq	%r15,	%r12
	subq	$4,	%r12
	movq	%r9,	%r13	#reset position 2 to address
	addq	%r15,	%r13
	jmp	check_end	#else, see if we're at the end of the array

	check_end:
	#add	%r11,	%r15	#adding the position 2 to number already determined
	add	$4,	%r15	#converting from index to length
	cmpl	%r15d,	%r8d	#comparing to length to see if done traversing
	je	check_correct	#if so, see if correct
	sub	$4,	%r15	#converting back to index
	#sub	%r11,	%r15	#else returning position 2 place to normal
	addq	$4,	%r12	#increment position 1
	addq	$4,	%r13	#increment position 2
	add	$4,	%r15	#increment place of position 2
	jmp	through_array	#and continuing on through array

	check_correct:
	cmp	$0,	%r10	#if no switches occurred
	je	finish		#then finish
	movq	%r9,	%r12	#else resetting position 1
	movq	%r9,	%r13	#resetting position 2
	addq	$4,	%r13	
	#add	$4,	%r11	#increment loop counter
	mov	$4,	%r15	#set position 2 index to current index
	mov	$0,	%r10	#set switch checked back to 0
	jmp	through_array	#starting loop over again
	
	switch:	
	movq	%r9,	%r12	#resetting position 1 to address	
	addq	%r15,	%r12
	subq	$4,	%r12
	movq	%r9,	%r13	#resetting position 2 to address
	addq	%r15,	%r13
	
	movl	(%r12),	%r14d	#put value at position 1 into holder
	movl	(%r13),	%r10d	#put value at position 2 into switch checker
	movl	%r10d,	(%r12)	#put value of position 2 in position 1
	movl	%r14d,	(%r13)	#put value of position 1 in position 2 with holder
	mov	$1,	%r10	#set switch checker to a value greater than 0
	jmp	check_end	#check to see if we've reached the end

	finish:
	addq	$8,	%rsp	#restore allocated local variables
	popq	%rbp		#pop the base pointer
	ret
