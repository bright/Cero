#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BISegmentedControlHandler.h"
#import "BILayoutElement.h"

@implementation BISegmentedControlHandler
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"UISegmentedControl" isEqualToString:element.name];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *itemsAttribute = element.attributes[@"items"];
    NSArray *items = [itemsAttribute componentsSeparatedByString:@","];
    NSMutableArray *localizedItems = NSMutableArray.new;
    if (items.count > 0) {
        for (__strong NSString *itemValue in items) {
            itemValue = [itemValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (itemValue.length > 0) {
                [localizedItems addObject:NSLocalizedString(itemValue, nil)];
            }
        }
    }
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:localizedItems];
        [container setCurrentAsSubview:control];
    }];
    [element.attributes removeObjectForKey:@"items"];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        [container setSuperviewAsCurrent];
    }];
}

@end