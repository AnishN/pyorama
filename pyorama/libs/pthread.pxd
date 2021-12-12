from libc.stdint cimport *
from libc.stdio cimport *
from libc.stdlib cimport *

cdef extern from "pthread.h" nogil:
    cdef enum:
        PTHREAD_CREATE_JOINABLE
        PTHREAD_CREATE_DETACHED

    cdef enum:
        PTHREAD_MUTEX_TIMED_NP
        PTHREAD_MUTEX_RECURSIVE_NP
        PTHREAD_MUTEX_ERRORCHECK_NP
        PTHREAD_MUTEX_ADAPTIVE_NP

    ctypedef struct pthread_t:
        pass

    ctypedef struct pthread_attr_t:
        pass

    ctypedef struct pthread_mutex_t:
        pass

    ctypedef struct pthread_mutexattr_t:
        pass

    ctypedef struct pthread_cond_t:
        pass

    ctypedef struct pthread_condattr_t:
        pass

    ctypedef void *(*pthread_start_routine)(void *)
    
    int pthread_create(
        pthread_t *__newthread,
        pthread_attr_t *__attr,
        pthread_start_routine __start_routine,
        void *__arg,
    )
    void pthread_exit(void *__retval)
    int pthread_join(pthread_t __th, void **__thread_return)

    int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
    int pthread_mutex_destroy(pthread_mutex_t *mutex)
    int pthread_mutex_lock(pthread_mutex_t *mutex)
    int pthread_mutex_trylock(pthread_mutex_t *mutex)
    int pthread_mutex_unlock(pthread_mutex_t *mutex)


    int pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *attr)
    int pthread_cond_destroy(pthread_cond_t *cond)
    int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)
    #int pthread_cond_timedwait(pthread_cond_t *cond, pthread_mutex_t *mutex, const struct timespec *abstime)
    int pthread_cond_signal(pthread_cond_t *cond)
    int pthread_cond_broadcast(pthread_cond_t *cond)