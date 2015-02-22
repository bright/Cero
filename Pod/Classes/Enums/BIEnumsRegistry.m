#import "BIEnumsRegistry.h"
#import "BIEnum.h"
#import "BILog.h"


@implementation BIEnumsRegistry {

    NSMutableDictionary *_typeNameToEnumClassCache;
    NSMutableDictionary *_typeNameToEnumCache;
}
static BIEnumsRegistry *DefaultInstance;

+ (BIEnum *)enumFor:(NSString *)typeName {
    return [[self defaultInstance] enumFor:typeName];
}

+ (instancetype)defaultInstance {
    static dispatch_once_t init;
    dispatch_once(&init, ^{
        DefaultInstance = BIEnumsRegistry.new;
    });
    return DefaultInstance;
}

- (void)registerEnum:(Class)enumClass name:(NSString *)typeName {
    NSAssert(_typeNameToEnumClassCache[typeName] == nil, @"Type name is already registered %@ with %@", typeName, NSStringFromClass(_typeNameToEnumClassCache[typeName]));
    _typeNameToEnumClassCache[typeName] = enumClass;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _typeNameToEnumCache = NSMutableDictionary.new;
        _typeNameToEnumClassCache = NSMutableDictionary.new;
    }

    return self;
}

- (BIEnum *)enumFor:(NSString *)typeName {
    BIEnum *biEnum = _typeNameToEnumCache[typeName];
    if (biEnum == nil) {
        @synchronized (self) {
            biEnum = _typeNameToEnumCache[typeName];
            if (biEnum == nil) {
                Class enumClass = _typeNameToEnumClassCache[typeName];
                if (enumClass == nil) {
                    BILogWarn(@"No know BIEnum for class %@", typeName);
                } else {
                    _typeNameToEnumCache[typeName] = biEnum = (BIEnum *) [enumClass new];
                }
            }
        }
    }
    [biEnum prepare];
    return biEnum;
}


@end