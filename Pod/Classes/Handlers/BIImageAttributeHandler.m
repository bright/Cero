#import "BIImageAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"

@implementation BIImageAttributeHandler {

}
- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"image" isEqualToString:attribute] && [builder.current isKindOfClass:UIImageView.class];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    UIImageView *current = (UIImageView *) builder.current;
    UIImage *image = [UIImage imageNamed:element.attributes[attribute]];
    current.image = image;
    CGRect rect = current.frame;
    CGPoint origin = rect.origin;
    rect = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
    current.frame = rect;
}

@end