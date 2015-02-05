#import "BIButtonHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"


@implementation BIButtonHandler
static NSDictionary *buttonTypes;

- (id)init {
    self = [super init];
    if (self) {
        static dispatch_once_t initButtonTypes;
        dispatch_once(&initButtonTypes, ^{
            buttonTypes = @{
                    @"UIButtonTypeCustom" : @(UIButtonTypeCustom),
                    @"UIButtonTypeContactAdd" : @(UIButtonTypeContactAdd),
                    @"UIButtonTypeDetailDisclosure" : @(UIButtonTypeDetailDisclosure),
                    @"UIButtonTypeInfoDark" : @(UIButtonTypeInfoDark),
                    @"UIButtonTypeInfoLight" : @(UIButtonTypeInfoLight),
                    @"UIButtonTypeRoundedRect" : @(UIButtonTypeRoundedRect),
                    @"UIButtonTypeSystem" : @(UIButtonTypeSystem),
            };
        });
    }

    return self;
}

- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [self isButton:element] || [self parentIsButton:builder];
}

- (BOOL)parentIsButton:(BIViewHierarchyBuilder *)builder {
    return [builder.current isKindOfClass:UIButton.class];
}

- (BOOL)isButton:(BILayoutElement *)element {
    return [element.name isEqualToString:NSStringFromClass(UIButton.class)];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    UIButtonType buttonType = [self parseButtonType:element.attributes];
    UIButton *button = [UIButton buttonWithType:buttonType];
    [element.attributes removeObjectForKey:@"type"];
    [builder setCurrentAsSubview:button];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    [builder setSuperviewAsCurrent];
}

- (enum UIButtonType)parseButtonType:(NSDictionary *)attributes {
    enum UIButtonType type = UIButtonTypeCustom;
    NSString *buttonType = attributes[@"type"];
    NSNumber *typeNumber = buttonTypes[buttonType];
    if (typeNumber != nil) {
        type = (UIButtonType) typeNumber.integerValue;
    }
    return type;
}

@end