#import "NSObject+KVCExtensions.h"

#import <objc/runtime.h>

@implementation NSObject (NSObject_KVCExtensions)


// Can set value for key follows the Key Value Settings search pattern as defined
// in the apple documentation
- (BOOL)canSetValueForKey:(NSString *)key {
    // Check if there is a selector based setter
    NSString *capKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:1] uppercaseString]];
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", capKey]);
    if ([self respondsToSelector:setter]) {
        return YES;
    }

    // If you can access the instance variable directly, check if that exists
    // Patterns for instance variable naming:
    //  1. _<key>
    //  2. _is<Key>
    //  3. <key>
    //  4. is<Key>
    if ([[self class] accessInstanceVariablesDirectly]) {
        // Declare all the patters for the key
        const char *pattern1 = [[NSString stringWithFormat:@"_%@", key] UTF8String];
        const char *pattern2 = [[NSString stringWithFormat:@"_is%@", capKey] UTF8String];
        const char *pattern3 = [[NSString stringWithFormat:@"%@", key] UTF8String];
        const char *pattern4 = [[NSString stringWithFormat:@"is%@", capKey] UTF8String];

        unsigned int numIvars = 0;
        Ivar *ivarList = class_copyIvarList([self class], &numIvars);
        for (unsigned int i = 0; i < numIvars; i++) {
            const char *name = ivar_getName(*ivarList);
            if (strcmp(name, pattern1) == 0 ||
                    strcmp(name, pattern2) == 0 ||
                    strcmp(name, pattern3) == 0 ||
                    strcmp(name, pattern4) == 0) {
                return YES;
            }
            ivarList++;
        }
    }

    return NO;
}

// Traverse the key path finding you can set the values
// Keypath is a set of keys delimited by "."
- (BOOL)canSetValueForKeyPath:(NSString *)keyPath {
    NSRange delimeterRange = [keyPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];

    if (delimeterRange.location == NSNotFound) {
        return [self canSetValueForKey:keyPath];
    }

    NSString *first = [keyPath substringToIndex:delimeterRange.location];
    NSString *rest = [keyPath substringFromIndex:(delimeterRange.location + 1)];

    if ([self canSetValueForKey:first]) {
        return [[self valueForKey:first] canSetValueForKeyPath:rest];
    }

    return NO;
}

@end
