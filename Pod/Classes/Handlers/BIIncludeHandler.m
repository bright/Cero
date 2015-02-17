#import <Cero/BILayoutInflater.h>
#import "BIIncludeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"
#import "BILayoutLoader+BIIncludeAssistance.h"
#import "BIInflatedViewContainer.h"
#import "BIEXTScope.h"
#import "BIBuildersCache.h"
#import "BILayoutInflater.h"

@implementation BIIncludeHandler
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"include" isEqualToString:element.name];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

    NSString *childLayout = element.attributes[@"layout"];
    BISourceReference *sourceReference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
    if (childLayout.length > 0) {
        BILayoutInflater *loader = builder.layoutInflater;
        NSString *inBundlePath = [loader layoutPath:childLayout];
        if (inBundlePath.length > 0) {
            @weakify(loader);
            [builder addBuildStep:^(BIInflatedViewContainer *container) {
                @strongify(loader);
                [loader reloadSuperview:container.current path:inBundlePath notify:nil];
            }];
            [loader.buildersCache addChangeSource:inBundlePath contentChangeObserver:builder.rootInBundlePath];
        } else {
            NSLog(@"ERROR: Included file not found %@", sourceReference.sourceDescription);
        }
    } else {
        NSLog(@"ERROR: Empty layout attribute of include element %@", sourceReference.sourceDescription);
    }

    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

}

@end