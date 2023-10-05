"""
Constructs an interface with libc to get the current clock time
"""

from memory.unsafe import Pointer
from sys.intrinsics import external_call

@value
@register_passable("trivial")
struct CTimeSpec:
    var seconds: Int
    var nanoseconds: Int

    fn __init__() -> Self:
        return Self {seconds: 0, nanoseconds: 0}

fn get_clocktime() -> CTimeSpec:
    var timespec = CTimeSpec()
    let timespec_pointer = Pointer[CTimeSpec].address_of(timespec)
    external_call["clock_gettime", NoneType, Int, Pointer[CTimeSpec]](0, timespec_pointer)
    
    return timespec