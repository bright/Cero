#import "BIContentChangeObservable.h"

@interface BIFileWatcher : NSObject <BIContentChangeObservable>
@property(nonatomic, copy) OnContentChange onContentChange;

+ (instancetype)fileWatcher:(NSString *)path;
@end