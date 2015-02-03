@interface NSError (BIErrors)
+ (NSError *)bi_error:(NSString *)description reason:(NSString *)reason recovery:(NSString *)recovery;
+ (NSError *)bi_error:(NSString *)description reason:(NSString *)reason;
@end