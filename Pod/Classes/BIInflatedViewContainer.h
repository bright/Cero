#import "BIInflatedViewHelper.h"

@class BILayoutElement;
@class BISourceReference;

@interface BIInflatedViewContainer : NSObject <BIInflatedViewHelper>
@property(nonatomic, weak, readonly) UIView *root;

@property(nonatomic, strong) UIView *current;

+ (instancetype)container:(UIView *)root;

- (BOOL)tryAddingElement:(id)element withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error;

- (void)setSuperviewAsCurrent;

- (void)setCurrentAsSubview:(UIView *)view;
@end