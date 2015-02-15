#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutInflater.h>
#import "BIInflatedViewHelper.h"
#import "TestHelpers.h"
#import "BIInflatedViewContainer.h"

id <BIInflatedViewHelper> testInflate(NSString *xml){
    BILayoutConfiguration *config = BILayoutConfiguration.new;
    [config setup];
    BILayoutInflater *inflater = [BILayoutInflater inflaterWithConfiguration:config];
    BIInflatedViewContainer *container = [inflater inflateFilePath:@"ignore"];
    return container;
}

UIView *testInflateView(NSString *xml){
    id<BIInflatedViewHelper> container = testInflate(xml);
    return container.root;
}

