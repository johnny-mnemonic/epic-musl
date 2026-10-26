#include <bits/syscall.h>

.global __unmapself
.type __unmapself, @function

.section .bss
.align 16
__unmapself_shared_stack:
	.skip 256

.text
.align 16
__unmapself:
	/* in0 = base, in1 = size */
	alloc r2 = ar.pfs, 2, 0, 0, 0

	/* keep base/size in preserved regs across the stack switch */
	mov r4 = in0                /* r4 = base */
	mov r5 = in1                /* r5 = size */

	/* switch r12 to top of shared_stack, 16-byte aligned */
	addl r14 = @ltoff(__unmapself_shared_stack), r1
	;;
	ld8 r14 = [r14]
	;;
	adds r12 = 256, r14
	;;
	dep r12 = r0, r12, 0, 4     /* clear low 4 bits -> align 16 */

	/* munmap(base, size) */
	mov r8 = r4                 /* arg1 = base */
	mov r9 = r5                 /* arg2 = size */
	movl r15 = __NR_munmap
	;;
	break 0x100000

	/* exit(0) */
	mov r8 = 0
	movl r15 = __NR_exit
	;;
	break 0x100000

1:	br.cond.sptk.few 1b          /* never reached */
