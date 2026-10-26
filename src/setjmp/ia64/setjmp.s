.global setjmp
.global _setjmp
.global __setjmp
.type setjmp, @function
.type _setjmp, @function
.type __setjmp, @function
setjmp:
_setjmp:
__setjmp:
	flushrs                       ;;   /* spill caller's stacked regs to RBS   */
	mov r8  = ar.pfs              ;;   /* caller's CFM (sof in bits 0..6)      */
	mov r9  = ar.bsp              ;;   /* top of backing store = restore point  */
	mov r15 = ar.rsc              ;;   /* RSE configuration                     */
	alloc r2 = ar.pfs, 1, 0, 0, 0 ;;
	mov r3 = in0                  ;;   /* r3 walks the jmp_buf                  */

	st8.spill [r3] = r12, 8 ;;         /*  0 sp  */
	st8.spill [r3] = r1,  8 ;;         /*  1 gp  */
	st8.spill [r3] = r4,  8 ;;         /*  2     */
	st8.spill [r3] = r5,  8 ;;         /*  3     */
	st8.spill [r3] = r6,  8 ;;         /*  4     */
	st8.spill [r3] = r7,  8 ;;         /*  5     */
	mov r14 = ar.unat ;; st8 [r3] = r14, 8 ;;   /* 6  */
	mov r14 = b0 ;; st8 [r3] = r14, 8 ;;        /* 7  */
	mov r14 = b1 ;; st8 [r3] = r14, 8 ;;        /* 8  */
	mov r14 = b2 ;; st8 [r3] = r14, 8 ;;        /* 9  */
	mov r14 = b3 ;; st8 [r3] = r14, 8 ;;        /* 10 */
	mov r14 = b4 ;; st8 [r3] = r14, 8 ;;        /* 11 */
	mov r14 = b5 ;; st8 [r3] = r14, 8 ;;        /* 12 */
	mov r14 = pr ;; st8 [r3] = r14, 8 ;;        /* 13 */
	mov r14 = ar.lc   ;; st8 [r3] = r14, 8 ;;   /* 14 */
	mov r14 = ar.fpsr ;; st8 [r3] = r14, 8 ;;   /* 15 */
	st8 [r3] = r8,  8 ;;               /* 16 ar.pfs  */
	st8 [r3] = r9,  8 ;;               /* 17 ar.bsp  */
	st8 [r3] = r15, 8 ;;               /* 18 ar.rsc  */
	st8 [r3] = r17, 8 ;;               /* 19 save_size */

	adds r14 = 15, r3 ;;               /* align r3 to 16 bytes (FP area) */
	dep  r3  = r0, r14, 0, 4 ;;

	stf.spill [r3] = f2,  16 ;;  stf.spill [r3] = f3,  16 ;;
	stf.spill [r3] = f4,  16 ;;  stf.spill [r3] = f5,  16 ;;
	stf.spill [r3] = f16, 16 ;;  stf.spill [r3] = f17, 16 ;;
	stf.spill [r3] = f18, 16 ;;  stf.spill [r3] = f19, 16 ;;
	stf.spill [r3] = f20, 16 ;;  stf.spill [r3] = f21, 16 ;;
	stf.spill [r3] = f22, 16 ;;  stf.spill [r3] = f23, 16 ;;
	stf.spill [r3] = f24, 16 ;;  stf.spill [r3] = f25, 16 ;;
	stf.spill [r3] = f26, 16 ;;  stf.spill [r3] = f27, 16 ;;
	stf.spill [r3] = f28, 16 ;;  stf.spill [r3] = f29, 16 ;;
	stf.spill [r3] = f30, 16 ;;  stf.spill [r3] = f31, 16 ;;

	mov r20 = r3                 ;;   /* r20 = base+480 */

	/* read ar.rnat in enforced-lazy mode (safe: flushrs already done) */
	mov r15 = ar.rsc             ;;
	dep r16 = r0, r15, 0, 2      ;;
	mov ar.rsc = r16             ;;
	mov r18 = ar.rnat            ;;
	mov ar.rsc = r15             ;;
	st8 [r3] = r18, 8            ;;   /* [+480]=rnat ; r3 -> base+488 */

	/* walk back sof register slots from bsp -> exact frame base */
	extr.u r17 = r8, 0, 7        ;;   /* sof */
	mov r16 = r9                 ;;
	mov r18 = r17                ;;
.Lsj_back:
	cmp.eq p6, p0 = r18, r0
	;;
	(p6) br.cond.dpnt .Lsj_bdone
	;;
	adds r16 = -8, r16           ;;
	extr.u r19 = r16, 3, 6       ;;   /* address bits 3..8 */
	cmp.eq p7, p0 = 63, r19      ;;   /* RNAT slot iff bits3..8==0x3f */
	;;
	(p7) adds r16 = -8, r16
	;;
	adds r18 = -1, r18
	;;
	br .Lsj_back
	;;
.Lsj_bdone:
	sub r17 = r9, r16            ;;   /* save_size = bsp - frame_base */
	adds r21 = -328, r20         ;;   /* base+152 = word 19 */
	st8 [r21] = r17              ;;   /* store exact save_size */

	mov r18 = r17                ;;
.Lsj_cp:
	cmp.eq p6, p0 = r18, r0
	;;
	(p6) br.cond.dpnt .Lsj_done
	;;
	ld8 r14 = [r16], 8
	;;
	st8 [r3] = r14, 8
	;;
	adds r18 = -8, r18
	;;
	br .Lsj_cp
	;;
.Lsj_done:
	mov r8 = 0 ;;
	br.ret.sptk.many b0
