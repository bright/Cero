#import "BIEnum.h"

@implementation BIEnum {
    dispatch_once_t _prepared;
    NSMutableDictionary *_values;
    NSString *_enumTypeName;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _values = NSMutableDictionary.new;
    }
    return self;
}

- (void)prepare {
    dispatch_once(&_prepared, ^{
        [self defineEnum];
    });
}

- (void)defineEnum {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)defineEnumValue:(NSNumber *)number enumValueName:(NSString *)key enumTypeName:(NSString *)enumTypeName {
    NSAssert(_values[key] == nil, @"Value already exists for key %@", key);
    NSAssert(_enumTypeName == nil || [_enumTypeName isEqualToString:enumTypeName], @"Inconsisten type name %@", enumTypeName);
    _enumTypeName = enumTypeName;
    _values[key.lowercaseString] = number;
    NSString *shortName = [key substringFromIndex:enumTypeName.length];
    _values[shortName.lowercaseString] = number;
}

- (NSNumber *)valueFor:(NSString *)key orDefault:(NSNumber *)defaultValue {
    NSString *normalizedKey = key.lowercaseString;
    NSNumber *existing = _values[normalizedKey];
    if (existing == nil) {
        return defaultValue;
    }
    return existing;
}


@end