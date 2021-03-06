/* For information on usage and redistribution, and for a DISCLAIMER OF ALL
* WARRANTIES, see the file, "LICENSE.txt," in this distribution.

iemlib written by Thomas Musil, Copyright (c) IEM KUG Graz Austria 2000 - 2006 */

#ifndef __IEMLIB_H__
#define __IEMLIB_H__


#define IS_A_POINTER(atom,index) ((atom+index)->a_type == A_POINTER)
#define IS_A_FLOAT(atom,index) ((atom+index)->a_type == A_FLOAT)
#define IS_A_SYMBOL(atom,index) ((atom+index)->a_type == A_SYMBOL)
#define IS_A_DOLLAR(atom,index) ((atom+index)->a_type == A_DOLLAR)
#define IS_A_DOLLSYM(atom,index) ((atom+index)->a_type == A_DOLLSYM)
#define IS_A_SEMI(atom,index) ((atom+index)->a_type == A_SEMI)
#define IS_A_COMMA(atom,index) ((atom+index)->a_type == A_COMMA)


#ifdef NT
int sys_noloadbang;
//t_symbol *iemgui_key_sym=0;
#include <io.h>
#else
extern int sys_noloadbang;
//extern t_symbol *iemgui_key_sym;
#include <unistd.h>
#endif

#define DEFDELVS 64
#define XTRASAMPS 4
#define SAMPBLK 4


#define UNITBIT32 1572864.  /* 3*2^19; bit 32 has place value 1 */

/* machine-dependent definitions.  These ifdefs really
should have been by CPU type and not by operating system! */
#ifdef IRIX
/* big-endian.  Most significant byte is at low address in memory */
#define HIOFFSET 0    /* word offset to find MSB */
#define LOWOFFSET 1    /* word offset to find LSB */
#define int32 long  /* a data type that has 32 bits */
#else
#ifdef MSW
/* little-endian; most significant byte is at highest address */
#define HIOFFSET 1
#define LOWOFFSET 0
#define int32 long
#else
#ifdef __FreeBSD__
#include <machine/endian.h>
#if BYTE_ORDER == LITTLE_ENDIAN
#define HIOFFSET 1
#define LOWOFFSET 0
#else
#define HIOFFSET 0    /* word offset to find MSB */
#define LOWOFFSET 1    /* word offset to find LSB */
#endif /* BYTE_ORDER */
#include <sys/types.h>
#define int32 int32_t
#endif
#ifdef __linux__

#include <endian.h>

#if !defined(__BYTE_ORDER) || !defined(__LITTLE_ENDIAN)                         
#error No byte order defined                                                    
#endif                                                                          

#if __BYTE_ORDER == __LITTLE_ENDIAN                                             
#define HIOFFSET 1                                                              
#define LOWOFFSET 0                                                             
#else                                                                           
#define HIOFFSET 0    /* word offset to find MSB */                             
#define LOWOFFSET 1    /* word offset to find LSB */                            
#endif /* __BYTE_ORDER */                                                       

#include <sys/types.h>
#define int32 int32_t

#else
#ifdef __APPLE__
#define HIOFFSET 0    /* word offset to find MSB */
#define LOWOFFSET 1    /* word offset to find LSB */
#define int32 int  /* a data type that has 32 bits */

#endif /* __APPLE__ */
#endif /* __linux__ */
#endif /* MSW */
#endif /* SGI */

union tabfudge
{
  double tf_d;
  int32 tf_i[2];
};

#ifdef __i386__
#define IEM_DENORMAL(f) ((((*(unsigned int*)&(f))&0x60000000)==0) || \
(((*(unsigned int*)&(f))&0x60000000)==0x60000000))
/* more stringent test: anything not between 1e-19 and 1e19 in absolute val */
#else

#define IEM_DENORMAL(f) 0

#endif

#endif
