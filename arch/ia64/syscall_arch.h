/* arch/ia64/syscall_arch.h */
#define __SYSCALL_LL_E(x) (x)
#define __SYSCALL_LL_O(x) (x)
#define __scc(X) ((long) (X))
typedef long syscall_arg_t;

static inline long __syscall0(long n)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out0", "out1", "out2", "out3", "out4", "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall1(long n, long a1)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out1", "out2", "out3", "out4", "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall2(long n, long a1, long a2)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	register long out1 __asm__("out1") = a2;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0), "+r"(out1)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out2", "out3", "out4", "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall3(long n, long a1, long a2, long a3)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	register long out1 __asm__("out1") = a2;
	register long out2 __asm__("out2") = a3;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0), "+r"(out1), "+r"(out2)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out3", "out4", "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall4(long n, long a1, long a2, long a3, long a4)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	register long out1 __asm__("out1") = a2;
	register long out2 __asm__("out2") = a3;
	register long out3 __asm__("out3") = a4;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0), "+r"(out1), "+r"(out2), "+r"(out3)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out4", "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall5(long n, long a1, long a2, long a3, long a4, long a5)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	register long out1 __asm__("out1") = a2;
	register long out2 __asm__("out2") = a3;
	register long out3 __asm__("out3") = a4;
	register long out4 __asm__("out4") = a5;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0), "+r"(out1), "+r"(out2), "+r"(out3), "+r"(out4)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out5", "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

static inline long __syscall6(long n, long a1, long a2, long a3, long a4, long a5, long a6)
{
	register long r8 __asm__("r8");
	register long r10 __asm__("r10");
	register long r15 __asm__("r15") = n;
	register long out0 __asm__("out0") = a1;
	register long out1 __asm__("out1") = a2;
	register long out2 __asm__("out2") = a3;
	register long out3 __asm__("out3") = a4;
	register long out4 __asm__("out4") = a5;
	register long out5 __asm__("out5") = a6;
	__asm__ __volatile__ ("break 0x100000;;"
		: "=r"(r8), "=r"(r10), "+r"(r15), "+r"(out0), "+r"(out1), "+r"(out2), "+r"(out3), "+r"(out4), "+r"(out5)
		:
		: "memory", "r2", "r3", "r9", "r11", "r14", 
		  "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
		  "out6", "out7",
		  "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "b6", "b7"
	);
	return r10 == -1 ? -r8 : r8;
}

#define VDSO_USEFUL
/* We don't have a proper vDSO mapped yet, but define this to avoid fallback errors later */

#define IPC_64 0
