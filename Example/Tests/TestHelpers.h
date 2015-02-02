#import "SpectaDSL.h"
#import "BILayoutConfiguration.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewHelper.h"

typedef UIView *(^InflateTestView)(NSString *);

UIView *testInflateView(NSString *xml){
    BILayoutConfiguration *config = BILayoutConfiguration.new;
    [config setup];
    BILayoutInflater *inflater = [BILayoutInflater inflaterWithConfiguration:config];
    id<BIInflatedViewHelper> container = [inflater inflateFilePath:@"ignore" withContentString:xml];
    return container.root;
}

