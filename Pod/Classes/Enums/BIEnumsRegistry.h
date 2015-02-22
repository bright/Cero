#include "xlmetamacros.h"

@class BIEnum;

@interface BIEnumsRegistry : NSObject
+ (BIEnum *)enumFor:(NSString *)typeName;

+ (instancetype)defaultInstance;

- (void)registerEnum:(Class)enumClass name:(NSString *)typeName;

- (BIEnum *)enumFor:(NSString *)typeName;
@end

#ifndef BIEnumFor
#ifdef DEBUG
#define BIEnumFor(typeName) \
        [BIEnumsRegistry enumFor: @metamacro_stringify(typeName)]; \
_Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
        typeName _;\
_Pragma("clang diagnostic pop") \

#else
        #define BIEnumFor(typeName) [BIEnumsRegistry enumFor: @metamacro_stringify(typeName)]
    #endif
#endif

#ifndef BIRegisterSelfAsEnum
#ifdef DEBUG
#define BIRegisterSelfAsEnum(typeName) \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
        typeName _;\
        _Pragma("clang diagnostic pop") \
        [BIEnumsRegistry.defaultInstance registerEnum: self name:@metamacro_stringify(typeName)] \

#else
    #define BIRegisterSelfAsEnum(typeName) [BIEnumsRegistry.defaultInstance registerEnum:self name: @#typeName]
    #endif

#endif