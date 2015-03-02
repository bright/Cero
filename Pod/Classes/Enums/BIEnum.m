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

- (void)defineEnumValue:(NSNumber *)value enumValueName:(NSString *)key enumTypeName:(NSString *)enumTypeName {
    [self defineEnumValue_:value key:key enumTypeName:enumTypeName];
}

- (void)defineStringEnumValue:(NSString *)value enumValueName:(NSString *)key enumTypeName:(NSString *)enumTypeName {
    [self defineEnumValue_:value key:key enumTypeName:enumTypeName];
}

- (NSString *)stringValueFor:(NSString *)key orDefault:(NSString *)defaultValue {
    return [self valueFor_:key defaultValue:defaultValue];
}

- (NSString *)enumTypeName {
    return _enumTypeName;
}


- (void)defineEnumValue_:(id)value key:(NSString *)key enumTypeName:(NSString *)enumTypeName {
    NSAssert(_values[key] == nil, @"Value already exists for key %@", key);
    NSAssert(_enumTypeName == nil || [_enumTypeName isEqualToString:enumTypeName], @"Inconsisten type name %@", enumTypeName);
    _enumTypeName = enumTypeName;
    _values[key.lowercaseString] = value;
    NSString *commonName = [self longestCommonPrefix:enumTypeName other:key];
    NSString *shortName = [key substringFromIndex:commonName.length];
    _values[shortName.lowercaseString] = value;
}

- (NSString *)longestCommonPrefix:(NSString *)left other:(NSString *)right {
    NSUInteger index = 0;
    while (index < left.length && index < right.length && [left characterAtIndex:index] == [right characterAtIndex:index]) {
        index += 1;
    }
    return [left substringToIndex:index];
}

- (NSNumber *)valueFor:(NSString *)key orDefault:(NSNumber *)defaultValue {
    return [self valueFor_:key defaultValue:defaultValue];
}

- (id)valueFor_:(NSString *)key defaultValue:(id)defaultValue {
    if (key.length == 0) {
        return defaultValue;
    }
    NSString *normalizedKey = key.lowercaseString;
    NSNumber *existing = _values[normalizedKey];
    if (existing == nil) {
        return defaultValue;
    }
    return existing;
}


@end