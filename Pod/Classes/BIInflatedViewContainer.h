#import "BIInflatedViewHelper.h"

@class BILayoutElement;
@class BISourceReference;

@interface BIInflatedViewContainer : NSObject <BIInflatedViewHelper>
@property(nonatomic, readonly) UIView *root;

+ (instancetype)container:(UIView *)root;

- (BOOL)tryAddingElement:(id)element withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error;
@end