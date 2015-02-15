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
    [self fillView:controller.view];
}


- (void)fillView:(UIView *)view andNotify:(OnViewInflated)notify {
    [self fillSuperview:view withViewInflatedFrom:_fileInBundlePath andCall:notify];
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)from andCall:(OnViewInflated)notify {
    [self updateSuperView:view withInflatedViewFromPath:from andCall:notify];
}

- (BIInflatedViewContainer *)updateSuperView:(UIView *)superView withInflatedViewFromPath:(NSString *)path andCall:(OnViewInflated)notify {
    BIInflatedViewContainer *newView = [self fillSuperview:superView path:path notify:notify];
    BIContentChangeObserver *observer = [_layoutInflater.buildersCache contentChangedObserver:path];
    @weakify(self);
    [observer addHandler:^{
        @strongify(self);
        [self fillSuperview:superView path:path notify:notify];
    }            boundTo:superView];
    return newView;
}

- (BIInflatedViewContainer *)fillSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify {
    [superview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BIInflatedViewContainer *newView = [_layoutInflater inflateFilePath:path superview:superview];
    if (notify != nil) {
        notify(newView);
    }
    return newView;
}

@end