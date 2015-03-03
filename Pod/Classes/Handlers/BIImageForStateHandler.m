#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BIImageForStateHandler.h"
#import "BILayoutElement.h"
#import "BIEnumsRegistry.h"
#import "BIEnum.h"

@implementation BIImageForStateHandler

- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"image" isEqualToString:element.name]
            && [builder.current respondsToSelector:@selector(setImage:forState:)];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    element.handledAllAttributes = YES;

    NSString *stateValue = element.attributes[@"forState"];
    BIEnum *anEnum = BIEnumFor(UIControlState);
    NSNumber *state = [anEnum numberValueFor:stateValue orDefault:@(UIControlStateNormal)];
    UIControlState controlState = (UIControlState) state.unsignedIntegerValue;

    NSString *imageAttribute = element.attributes[@"image"];
    if (imageAttribute.length > 0) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIImage *image = [UIImage imageNamed:imageAttribute];
            UIButton *button = (UIButton *) container.current;
            [button setImage:image forState:controlState];
        }];
    }
    NSString *backgroundImageAttribute = element.attributes[@"backgroundImage"];
    if (backgroundImageAttribute.length > 0) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIImage *image = [UIImage imageNamed:backgroundImageAttribute];
            UIButton *button = (UIButton *) container.current;
            [button setBackgroundImage:image forState:controlState];
        }];
    }
}

- (UIImage *)parseImageAttribute:(NSString *)attributeName element:(BILayoutElement *)element {
    NSString *imageAttribute = element.attributes[attributeName];
    if (imageAttribute.length > 0) {
        return [UIImage imageNamed:imageAttribute];
    }
    return nil;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end