/* arch/ia64/atomic_arch.h */

#define a_barrier() __sync_synchronize()
#define a_pre_llsc()
#define a_post_llsc()

/* 
 * a_cas is polymorphic. By using __typeof__(t), it casts the void* pointer
 * to the exact size of the comparison value (int for 32-bit, long for 64-bit).
 */
#define a_cas(p,t,s) __sync_val_compare_and_swap((volatile __typeof__(t) *)(p), (t), (s))

/* 
 * a_cas_p is specifically for pointer-sized (64-bit on IA64) compare-and-swap.
 */
#define a_cas_p(p,t,s) ((void *)__sync_val_compare_and_swap((volatile long *)(p), (long)(t), (long)(s)))

/* 
 * The rest operate on word-sized (32-bit int) atomics.
 * We cast the void* to volatile int* to satisfy the GCC builtins.
 */
#define a_or(p,v) __sync_fetch_and_or((volatile int *)(p), (int)(v))
#define a_and(p,v) __sync_fetch_and_and((volatile int *)(p), (int)(v))
#define a_swap(p,v) __sync_lock_test_and_set((volatile int *)(p), (int)(v))
#define a_inc(p) __sync_add_and_fetch((volatile int *)(p), 1)
#define a_dec(p) __sync_sub_and_fetch((volatile int *)(p), 1)

