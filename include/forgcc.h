#ifndef _FORGCC_H_
#define _FORGCC_H_

typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;
typedef unsigned short u16;
typedef signed long s32;
typedef unsigned long u32;
typedef float 	f32;
typedef double 	f64;

#define BIT(x) (1uL << (x))

#ifndef NULL
#define NULL	((void *)0)
#endif

#ifndef __even_in_range
#define __even_in_range(x,NUM)	(x & (~1uL))
#endif
// Macro for button IRQ
#define IRQ_TRIGGERED(flags, bit)               ((flags & bit) == bit)

#endif

