#include "pthread_impl.h"

#ifdef __ia64__
void *__tls_get_addr(size_t m, size_t off)
{
	pthread_t self = __pthread_self();
	return (void *)(self->dtv[m] + off);
}
#else
void *__tls_get_addr(tls_mod_off_t *v)
{
	pthread_t self = __pthread_self();
	return (void *)(self->dtv[v[0]] + v[1]);
}
#endif
