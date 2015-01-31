#import "BIInflatedViewContainer.h"

@interface BIInflatedViewContainer()
@property (nonatomic,strong)UIView *root;
@end

@implementation BIInflatedViewContainer {
    NSMapTable *_viewsCache;
}
+ (instancetype)container:(UIView *)root {
    return [[self alloc] initWithRoot:root];
}

- (instancetype)initWithRoot:(UIView *)view {
    self = [super init];
    if(self){
        _viewsCache = [NSMapTable strongToWeakObjectsMapTable];
        self.root = view;
    }
    return self;
}

- (UIView *)findViewById:(NSString *)viewId {
    UIView *view = [_viewsCache objectForKey:viewId];
    return view;
}


@end