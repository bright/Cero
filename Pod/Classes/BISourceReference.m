#import "BISourceReference.h"

@interface BISourceReference ()
@property(nonatomic, strong) NSString *sourceContent;
@property(nonatomic) NSUInteger startLine;
@property(nonatomic) NSUInteger startColumn;
@end

@implementation BISourceReference {}

+ (instancetype)reference:(NSString *)path andContent:(NSString *)data {
    return [[self alloc] initWithFilePath:path andContent:data];
}

- (instancetype)initWithFilePath:(NSString *)path andContent:(NSString *)data {
    self = [super init];
    if(self){
        self.sourcePath = path;
        self.sourceContent = data;
        self.startLine =  0;
        self.startColumn = 0;
    }
    return self;
}

- (BISourceReference *)subReferenceFromLine:(NSUInteger)lineNumber andColumn:(NSUInteger)columnNumber {
    NSString *string;
    NSUInteger lineCount, index, stringLength = [self.sourceContent length];
    NSRange lineRange = NSMakeRange(0, stringLength);
    for (index = 0, lineCount = 0; index < stringLength && lineCount != lineNumber; lineCount++) {
        lineRange = [self.sourceContent lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);
    }
    NSString *relevant = [self.sourceContent substringWithRange:lineRange];
    BISourceReference *reference = [BISourceReference reference:self.sourcePath andContent:relevant];
    reference.startLine = lineNumber;
    reference.startColumn = columnNumber;
    return reference;
}

- (NSString *)sourceDescription {
    return [NSString stringWithFormat:@"%@(%@:%@)\n%@", self.sourcePath,
        @(self.startLine), @(self.startColumn), self.sourceContent];
}
@end