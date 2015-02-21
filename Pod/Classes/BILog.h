#ifndef BILog
#ifdef DEBUG
#define BILog(...) NSLog(__VA_ARGS__)
#else
#define BILog(...)
#endif

#define BILogDebug(...) BILog(__VA_ARGS__)
#define BILogInfo(...) BILog(__VA_ARGS__)
#define BILogWarn(...) BILog(__VA_ARGS__)
#define BILogError(...) BILog(__VA_ARGS__)

#endif