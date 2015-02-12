#import "BIImageAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"

@implementation BIImageAttributeHandler {

}
- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"image" isEqualToString:attribute] && [builder.current isKindOfClass:UIImageView.class];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    UIImage *image = [UIImage imageNamed:element.attributes[attribute]];
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        UIImageView *current = (UIImageView *) container.current;
        current.image = image;
        CGRect rect = current.frame;
        CGPoint origin = rect.origin;
        rect = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
        current.frame = rect;
    }];

}

@end