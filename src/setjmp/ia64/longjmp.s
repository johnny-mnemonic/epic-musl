.global longjmp
.global _longjmp
.global __longjmp
.type longjmp, @function
.type _longjmp, @function
.type __longjmp, @function
longjmp:
_longjmp:
__longjmp:
	alloc r2 = ar.pfs, 2, 0, 0, 0
	;;
	mov r3 = in0                /* jmp_buf base              */
	mov r8 = in1                /* requested return value    */
	;;

	/* --- words 0..6: sp, gp, r4-r7, ar.unat --- */
	ld8 r12 = [r3], 8 ;;
	ld8 r1  = [r3], 8 ;;
	ld8 r4  = [r3], 8 ;;
	ld8 r5  = [r3], 8 ;;
	ld8 r6  = [r3], 8 ;;
	ld8 r7  = [r3], 8 ;;
	ld8 r14 = [r3], 8 ;;  mov ar.unat = r14 ;;
	/* re-load with .fill so the NaT bits come back from ar.unat */
	adds r15 = -56, r3 ;;
	ld8.fill r12 = [r15], 8 ;;
	ld8.fill r1  = [r15], 8 ;;
	ld8.fill r4  = [r15], 8 ;;
	ld8.fill r5  = [r15], 8 ;;
	ld8.fill r6  = [r15], 8 ;;
	ld8.fill r7  = [r15], 8 ;;

	/* --- words 7..13: b0-b5, pr --- */
	ld8 r14 = [r3], 8 ;;  mov b0 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov b1 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov b2 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov b3 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov b4 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov b5 = r14 ;;
	ld8 r14 = [r3], 8 ;;  mov pr = r14, -1 ;;

	/* --- words 14..19: ar.lc, ar.fpsr, ar.pfs, ar.bsp, ar.rsc, save_size --- */
	ld8 r11 = [r3], 8 ;;          /* ar.lc      -> r11 */
	ld8 r18 = [r3], 8 ;;          /* ar.fpsr    -> r18 */
	ld8 r24 = [r3], 8 ;;          /* ar.pfs     -> r24 */
	ld8 r25 = [r3], 8 ;;          /* ar.bsp     -> r25 */
	ld8 r26 = [r3], 8 ;;          /* ar.rsc     -> r26 */
	ld8 r27 = [r3], 8 ;;          /* save_size  -> r27 */

	/* r3 is now base+160; align to 16 for the FP area */
	adds r16 = 15, r3 ;;
	dep  r3  = r0, r16, 0, 4 ;;

	/* --- words 20..59: preserved FP regs --- */
	ldf.fill f2  = [r3], 16 ;;  ldf.fill f3  = [r3], 16 ;;
	ldf.fill f4  = [r3], 16 ;;  ldf.fill f5  = [r3], 16 ;;
	ldf.fill f16 = [r3], 16 ;;  ldf.fill f17 = [r3], 16 ;;
	ldf.fill f18 = [r3], 16 ;;  ldf.fill f19 = [r3], 16 ;;
	ldf.fill f20 = [r3], 16 ;;  ldf.fill f21 = [r3], 16 ;;
	ldf.fill f22 = [r3], 16 ;;  ldf.fill f23 = [r3], 16 ;;
	ldf.fill f24 = [r3], 16 ;;  ldf.fill f25 = [r3], 16 ;;
	ldf.fill f26 = [r3], 16 ;;  ldf.fill f27 = [r3], 16 ;;
	ldf.fill f28 = [r3], 16 ;;  ldf.fill f29 = [r3], 16 ;;
	ldf.fill f30 = [r3], 16 ;;  ldf.fill f31 = [r3], 16 ;;

	/* r3 is now base+480 = the saved backing-store slice */

	ld8 r28 = [r3], 8            ;;   /* saved rnat ; r3 -> base+488 */

	mov r16 = ar.rsc             ;;
	flushrs                      ;;
	dep r16 = r0, r16, 0, 2      ;;
	mov ar.rsc = r16             ;;   /* enforced lazy */

	sub r17 = r25, r27           ;;   /* dst = bsp - save_size */
	mov r19 = r27                ;;
.Llj_cp:
	cmp.eq p6, p0 = r19, r0
	;;
	(p6) br.cond.dpnt .Llj_done
	;;
	ld8 r14 = [r3], 8
	;;
	st8 [r17] = r14, 8
	;;
	adds r19 = -8, r19
	;;
	br .Llj_cp
	;;
.Llj_done:
	mov ar.bspstore = r25        ;;
	mov ar.rnat = r28            ;;   /* restored, NOT zero */
	loadrs                       ;;
	mov ar.rsc = r26             ;;
	mov ar.lc = r11              ;;
	mov ar.fpsr = r18            ;;
	mov ar.pfs = r24             ;;   /* CFM AFTER loadrs */
	cmp.eq p6, p0 = r8, r0
	;;
	(p6) add r8 = 1, r0
	;;
	br.ret.sptk.many b0
