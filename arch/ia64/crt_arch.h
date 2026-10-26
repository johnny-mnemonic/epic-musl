__asm__(
".text \n"
".global " START " \n"
".weak _DYNAMIC \n"
".hidden _DYNAMIC \n"
".align 16 \n"
START ": \n"
"	alloc r2 = ar.pfs, 0, 0, 2, 0 \n"      /* now 2 outputs: sp and dynv   */
"	movl r1 = @gprel(0f) \n"
"	;; \n"
"0: \n"
"	mov r3 = ip \n"
"	;; \n"
"	sub r1 = r3, r1 \n"                    /* r1 = runtime gp              */
"	;; \n"
"	adds out0 = 16, sp \n"                 /* out0 = &argc                 */
"	movl r3 = @gprel(_DYNAMIC) \n"         /* r3 = _DYNAMIC - gp           */
"	;; \n"
"	add out1 = r3, r1 \n"                  /* out1 = runtime &_DYNAMIC     */
"	;; \n"
"	br.call.sptk.many b0 = " START "_c \n"
);

