#import <Foundation/Foundation.h>


@interface NSObject (NSObject_KVCExtensions)

- (BOOL)canSetValueForKey:(NSString *)key;

- (BOOL)canSetValueForKeyPath:(NSString *)keyPath;

@end
