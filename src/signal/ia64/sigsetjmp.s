.global sigsetjmp
.global __sigsetjmp
.type sigsetjmp, @function
.type __sigsetjmp, @function
.hidden __sigsetjmp_tail
sigsetjmp:
__sigsetjmp:
	alloc r2 = ar.pfs, 2, 4, 2, 0  ;;   /* 2 in, 4 locals, 2 out */
	mov r34 = in0                  ;;   /* jb               */
	mov r35 = in1                  ;;   /* savemask         */
	mov r36 = b0                   ;;   /* return address   */
	mov r37 = r2                   ;;   /* caller's ar.pfs  */
	mov out0 = r34                 ;;
	br.call.sptk.many b0 = setjmp
	;;
	/* r8 = setjmp retval: 0 first time, longjmp value after */
	cmp.eq p6, p0 = r35, r0
	;;
	(p6) br.cond.dpnt .Lsigsj_nomask
	;;
	mov out0 = r34                 ;;   /* jb  */
	mov out1 = r8                  ;;   /* ret */
	br.call.sptk.many b0 = __sigsetjmp_tail
	;;
.Lsigsj_nomask:
	mov b0 = r36                   ;;   /* restore return address */
	mov ar.pfs = r37               ;;   /* restore caller's pfs   */
	br.ret.sptk.many b0

