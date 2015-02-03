#import "NSError+BIErrors.h"

@implementation NSError (BIErrors)
+ (NSError *)bi_error:(NSString *)description
               reason:(NSString*)reason
             recovery:(NSString *)recovery {
    NSError *error = [NSError errorWithDomain:@"pl.brightinventions.cero" code:42 userInfo:@{
            NSLocalizedDescriptionKey: description != nil ? description : @"",
            NSLocalizedFailureReasonErrorKey: reason != nil ? reason : @"",
            NSLocalizedRecoverySuggestionErrorKey: recovery != nil ? recovery : @""
    }];

    return error;
}

+ (NSError *)bi_error:(NSString *)description reason:(NSString *)reason {
    return [self bi_error:description reason:reason recovery:nil];
}

@end