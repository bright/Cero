#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BISegmentedControlSegmentHandler.h"
#import "BILayoutElement.h"

@implementation BISegmentedControlSegmentHandler

- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"segment" isEqualToString:element.name]
            && [builder.current isKindOfClass:[UISegmentedControl class]];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *title = NSLocalizedString(element.attributes[@"title"], nil);
    NSString *imageName = element.attributes[@"image"];
    NSString *enabledAttribute = element.attributes[@"enabled"];
    BOOL enabled = enabledAttribute.boolValue;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        UISegmentedControl *control = (UISegmentedControl *) container.current;
        NSNumber *segmentedInsertedAtIndex = nil;
        if (title.length > 0) {
            segmentedInsertedAtIndex = @(control.numberOfSegments);
            [control insertSegmentWithTitle:NSLocalizedString(title, nil) atIndex:control.numberOfSegments animated:NO];
        }
        if (imageName.length > 0) {
            UIImage *image = [UIImage imageNamed:imageName];
            if (image != nil) {
                segmentedInsertedAtIndex = @(control.numberOfSegments);
                [control insertSegmentWithImage:image atIndex:control.numberOfSegments animated:NO];
            }
        }
        if (segmentedInsertedAtIndex != nil) {
            if (enabledAttribute.length > 0) {
                [control setEnabled:enabled forSegmentAtIndex:segmentedInsertedAtIndex.unsignedIntegerValue];
            }
        }
    }];
    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

}

@end