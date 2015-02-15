#import "UIView+Finders.h"

@implementation UIView (Finders)
- (UIViewController *)bi_firstViewController {
    return (UIViewController *) [self traverseResponderChainForUIViewController];
}

- (UIView *)bi_commonSuperviewForConstraint:(id)otherViewOrGuide {
    if ([otherViewOrGuide isKindOfClass:UIView.class]) {
        UIView *commonSuperview = nil;
        UIView *startView = self;
        do {
            if ([otherViewOrGuide isDescendantOfView:startView]) {
                commonSuperview = startView;
            }
            startView = startView.superview;
        } while (startView && !commonSuperview);
//        NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
        return commonSuperview;
    } else {
        return self;
    }
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end