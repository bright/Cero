#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutInflater.h>
#import "BIInflatedViewHelper.h"
#import "TestHelpers.h"
#import "BIInflatedViewContainer.h"
#import "BIViewHierarchyBuilder.h"

id <BIInflatedViewHelper> testInflate(NSString *xml){
    BILayoutConfiguration *config = BILayoutConfiguration.new;
    [config setup];
    BILayoutInflater *inflater = [BILayoutInflater inflaterWithConfiguration:config];
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    BIViewHierarchyBuilder *builder = [inflater inflateFilePath:@"ignore" superview:nil content:data];
    BIInflatedViewContainer *container = builder.container;
    return container;
}

UIView *testInflateView(NSString *xml){
    id<BIInflatedViewHelper> container = testInflate(xml);
    return container.root;
}

