#import "BILog.h"

#ifndef BIBench
#ifdef DEBUG

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

#define BIBench(tag, block) uint64_t took = dispatch_benchmark(1, ^{ block }); BILogDebug(@"%@ - %.2f ms", tag, took/1000000.0)
#else
    #define BIBench(tag, block) block
#endif
#endif
