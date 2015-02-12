#import "BIInflatedViewContainer.h"
#import "BISimpleViewHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"

@implementation BISimpleViewHandler {
}

- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    Class viewClass = NSClassFromString(element.name);
    return [viewClass isSubclassOfClass:[UIView class]];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    Class viewClass = NSClassFromString(element.name);
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        UIView *view = (UIView *) [viewClass new];
        [container setCurrentAsSubview:view];
    }];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        [container setSuperviewAsCurrent];
    }];
}


@end
