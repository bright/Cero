#import "BIEnumsRegistry.h"
#import "xlmetamacros.h"

@interface BIEnum : NSObject
- (void)prepare;

- (void)defineEnum;

- (void)defineEnumValue:(NSNumber *)value enumValueName:(NSString *)key enumTypeName:(NSString *)enumTypeName;

- (void)defineStringEnumValue:(NSString *)value enumValueName:(NSString *)key enumTypeName:(NSString *)enumTypeName;

- (NSNumber *)valueFor:(NSString *)key orDefault:(NSNumber *)defaultValue;

- (NSString *)stringValueFor:(NSString *)key orDefault:(NSString *)defaultValue;

- (NSString *)enumTypeName;
@end

#ifndef BIEnumDefine
#define BIEnumDefine(typeName, ...) BIEnumDefineStart(typeName); BIEnumDefineValues(typeName, __VA_ARGS__); BIEnumDefineEnd
#define BIEnumDefineStart(typeName) \
        {\
        typeName value; \
        NSString* typeNameAsString = @metamacro_stringify(typeName)
#define BIEnumDefineValues(typeName, ...) metamacro_foreach_cxt(BIEnumDefineEach,;,typeName,__VA_ARGS__)
#define BIEnumDefineEach(INDEX, CONTEXT, VAR) value = VAR; [self defineEnumValue:@(value) enumValueName: @metamacro_stringify(VAR) enumTypeName: typeNameAsString]
#define BIEnumDefineEnd }
#define BIStringEnumDefine(typeName, ...) BIStringEnumDefineStart(typeName); BIStringEnumDefineValues(typeName, __VA_ARGS__); BIStringEnumDefineEnd
#define BIStringEnumDefineStart(typeName) \
        {\
        typeName value; \
        NSString* typeNameAsString = @metamacro_stringify(typeName)
#define BIStringEnumDefineValues(typeName, ...) metamacro_foreach_cxt(BIStringEnumDefineEach,;,typeName,__VA_ARGS__)
#define BIStringEnumDefineEach(INDEX, CONTEXT, VAR) value = VAR; [self defineStringEnumValue:value enumValueName: @metamacro_stringify(VAR) enumTypeName: typeNameAsString]
#define BIStringEnumDefineEnd }
#endif