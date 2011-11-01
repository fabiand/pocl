/* OpenCL built-in library: vloa()

   Copyright (c) 2011 Universidad Rey Juan Carlos
   
   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:
   
   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.
   
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
*/

#include "templates.h"



#define IMPLEMENT_VLOAD(TYPE, MOD)                                      \
                                                                        \
  TYPE##2 __attribute__ ((__overloadable__))                            \
  vload2(size_t offset, const MOD TYPE *p)                              \
  {                                                                     \
    return (TYPE##2)(p[offset*2], p[offset*2+1]);                       \
  }                                                                     \
                                                                        \
  TYPE##3 __attribute__ ((__overloadable__))                            \
  vload3(size_t offset, const MOD TYPE *p)                              \
  {                                                                     \
    return (TYPE##3)(vload2(0, &p[offset*3]), p[offset*3+2]);           \
  }                                                                     \
                                                                        \
  TYPE##4 __attribute__ ((__overloadable__))                            \
  vload4(size_t offset, const MOD TYPE *p)                              \
  {                                                                     \
    return (TYPE##4)(vload2(0, &p[offset*4]), vload2(0, &p[offset*4+2])); \
  }                                                                     \
                                                                        \
  TYPE##8 __attribute__ ((__overloadable__))                            \
  vload8(size_t offset, const MOD TYPE *p)                              \
  {                                                                     \
    return (TYPE##8)(vload4(0, &p[offset*8]), vload4(0, &p[offset*8+4])); \
  }                                                                     \
                                                                        \
  TYPE##16 __attribute__ ((__overloadable__))                           \
  vload16(size_t offset, const MOD TYPE *p)                             \
  {                                                                     \
    return (TYPE##16)(vload8(0, &p[offset*16]), vload8(0, &p[offset*16+8])); \
  }



IMPLEMENT_VLOAD(char  , __global)
IMPLEMENT_VLOAD(short , __global)
IMPLEMENT_VLOAD(int   , __global)
IMPLEMENT_VLOAD(long  , __global)
IMPLEMENT_VLOAD(uchar , __global)
IMPLEMENT_VLOAD(ushort, __global)
IMPLEMENT_VLOAD(uint  , __global)
IMPLEMENT_VLOAD(ulong , __global)
IMPLEMENT_VLOAD(float , __global)
IMPLEMENT_VLOAD(double, __global)

IMPLEMENT_VLOAD(char  , __local)
IMPLEMENT_VLOAD(short , __local)
IMPLEMENT_VLOAD(int   , __local)
IMPLEMENT_VLOAD(long  , __local)
IMPLEMENT_VLOAD(uchar , __local)
IMPLEMENT_VLOAD(ushort, __local)
IMPLEMENT_VLOAD(uint  , __local)
IMPLEMENT_VLOAD(ulong , __local)
IMPLEMENT_VLOAD(float , __local)
IMPLEMENT_VLOAD(double, __local)

IMPLEMENT_VLOAD(char  , __constant)
IMPLEMENT_VLOAD(short , __constant)
IMPLEMENT_VLOAD(int   , __constant)
IMPLEMENT_VLOAD(long  , __constant)
IMPLEMENT_VLOAD(uchar , __constant)
IMPLEMENT_VLOAD(ushort, __constant)
IMPLEMENT_VLOAD(uint  , __constant)
IMPLEMENT_VLOAD(ulong , __constant)
IMPLEMENT_VLOAD(float , __constant)
IMPLEMENT_VLOAD(double, __constant)

/* __private is not supported yet
IMPLEMENT_VLOAD(char  , __private)
IMPLEMENT_VLOAD(short , __private)
IMPLEMENT_VLOAD(int   , __private)
IMPLEMENT_VLOAD(long  , __private)
IMPLEMENT_VLOAD(uchar , __private)
IMPLEMENT_VLOAD(ushort, __private)
IMPLEMENT_VLOAD(uint  , __private)
IMPLEMENT_VLOAD(ulong , __private)
IMPLEMENT_VLOAD(float , __private)
IMPLEMENT_VLOAD(double, __private)
*/
