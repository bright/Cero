#import "BILayoutLoader.h"
#import "BIInflatedViewHelper.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewContainer.h"
#import "BIBuildersCache.h"
#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"

@implementation BILayoutLoader {
    BILayoutInflater *_layoutInflater;
    NSString *_fileInBundlePath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutInflater = [BILayoutInflater defaultInflater];
    }

    return self;
}

- (instancetype)initWithFilePath:(NSString *)fileInBundlePath {
    self = [self init];
    if (self) {
        _fileInBundlePath = fileInBundlePath;
    }
    return self;
}


+ (BILayoutLoader *)watchingInflaterForLayout:(NSString *)name {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
    return [[self alloc] initWithFilePath:fullPath];
}

- (void)fillView:(UIView *)superview {
    [self fillView:superview andNotify:nil];
}

- (void)fillViewOfController:(UIViewController *)controller {
    [self fillViewOfController:controller andNotify:nil];
}

- (void)fillViewOfController:(UIViewController *)controller andNotify:(OnViewInflated)notify {
    [self fillView:controller.view andNotify:notify];
}


- (void)fillView:(UIView *)view andNotify:(OnViewInflated)notify {
    [self fillSuperview:view withViewInflatedFrom:_fileInBundlePath andCall:notify];
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)from andCall:(OnViewInflated)notify {
    [self updateSuperView:view withInflatedViewFromPath:from andCall:notify];
}

- (BIInflatedViewContainer *)updateSuperView:(UIView *)superview withInflatedViewFromPath:(NSString *)path andCall:(OnViewInflated)notify {
    BIInflatedViewContainer *newView = [self reloadSuperview:superview path:path notify:notify];
    BIContentChangeObserver *observer = [_layoutInflater.buildersCache contentChangedObserver:path];
    @weakify(self, superview);
    [observer addHandler:^{
        @strongify(self, superview);
        [self reloadSuperview:superview
                         path:path
                       notify:notify];
    } boundTo:superview];
    return newView;
}

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify {
    for (UIView *view in superview.subviews) {
        //TODO: this is an awful hack - some of the subviews are not create by layout i.e. top layout guide
        //to fix this we need to either:
        // - remember all views created by layout
        // - mark them with some property (tag or associated object)
        if (![[NSStringFromClass(view.class) substringToIndex:1] isEqualToString:@"_"]) {
            [view removeFromSuperview];
        } else {
            NSLog(@"Subviews item is a private UIView %@", view);
        }
    }
    BIInflatedViewContainer *newView = [_layoutInflater inflateFilePath:path superview:superview];
    if (notify != nil) {
        notify(newView);
    }
    return newView;
}

@end