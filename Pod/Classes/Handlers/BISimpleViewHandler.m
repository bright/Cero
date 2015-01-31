#import <UIKit/UIKit.h>

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
    UIView *view = [viewClass new];
    [builder setCurrentAsSubview:view];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    [builder setSuperviewAsCurrent];
}


@end
