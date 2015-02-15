#import "BIEXTScope.h"
#import "BIFileWatcher.h"


@implementation BIFileWatcher {
    NSString *_path;
    dispatch_source_t _source;
    int _fileDescriptor;
    BOOL _recreateDispatchSource;
    dispatch_queue_t _dispatchQueue;
}

+ (instancetype)fileWatcher:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        NSAssert(path.length > 0, @"File watcher must have not empty path");
        _path = path;
        _dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [self watchPathForContentChanges];
    }
    return self;
}

- (void)watchPathForContentChanges {
    char const *fileSystemRepresentation = [_path fileSystemRepresentation];
    _fileDescriptor = open(fileSystemRepresentation, O_EVTONLY);
    unsigned long watchMode = DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_RENAME;
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, (uintptr_t) _fileDescriptor, watchMode, _dispatchQueue);
    @weakify(self);
    dispatch_source_set_event_handler(_source, ^{
        @strongify(self);
        [self notifyOfChanges];
    });
    dispatch_source_set_cancel_handler(_source, ^{
        @strongify(self);
        [self cleanResourcesAndRestartIfNeeded];
    });
    dispatch_resume(_source);
}

- (void)notifyOfChanges {
    if (self.onContentChange != nil) {
        NSString *path = _path;
        NSData *data = [NSData dataWithContentsOfFile:path];
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            OnContentChange change = self.onContentChange;
            if (change != nil) {
                change(path, data);
            }
        });
    }
    _recreateDispatchSource = YES;
    dispatch_source_cancel(_source);
}


- (void)cleanResourcesAndRestartIfNeeded {
    close(_fileDescriptor);
    _fileDescriptor = 0;
    _source = nil;
    if (_recreateDispatchSource) {
        _recreateDispatchSource = NO;
        [self watchPathForContentChanges];
    }
}

- (void)dealloc {
    _recreateDispatchSource = NO;
    dispatch_source_cancel(_source);
}

@end
