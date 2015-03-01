#import <Cero/BILayoutInflater.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BIIncludeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"
#import "BIEXTScope.h"
#import "BIBuildersCache.h"
#import "BILayoutInflater.h"
#import "BILog.h"

@implementation BIIncludeHandler
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"include" isEqualToString:element.name];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

    NSString *childLayout = element.attributes[@"layout"];
    BISourceReference *sourceReference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
    if (childLayout.length > 0) {
        NSString *inBundlePath = [builder.layoutInflater layoutPath:childLayout];
        if (inBundlePath.length > 0) {
            @weakify(builder);
            [builder addBuildStep:^(BIInflatedViewContainer *container) {
                @strongify(builder);
                BIViewHierarchyBuilder *childBuilder;
                BILogDebug(@"Include handler step will inflate path %@", inBundlePath.lastPathComponent);
                childBuilder = [builder.layoutInflater inflateBuilder:inBundlePath
                                              superview:container.current];
                BIInflatedViewContainer *inflatedViewContainer = childBuilder.container;
                NSError *error;
                if (![container tryAddingElementsFrom:inflatedViewContainer error:&error]) {
                    //TODO log error
                }
                [container addOnReadyStepsFrom:inflatedViewContainer];
            }];

            BIBuildersCache *cache = builder.layoutInflater.buildersCache;
            [cache setupInvalidateOnContentChange:inBundlePath];

            [cache addReloadSource:inBundlePath
             contentChangeObserver:builder.rootInBundlePath];
        } else {
            BILog(@"ERROR: Included file not found %@", sourceReference.sourceDescription);
        }
    } else {
        BILog(@"ERROR: Empty layout attribute of include element %@", sourceReference.sourceDescription);
    }

    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

}

@end