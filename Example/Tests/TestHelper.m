#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutInflater.h>
#import <Cero/BILayoutLoader.h>
#import "BIInflatedViewHelper.h"
#import "TestHelpers.h"
#import "BIInflatedViewContainer.h"
#import "BIViewHierarchyBuilder.h"

BILayoutConfiguration *testConfig() {
    BILayoutConfiguration *config = BILayoutConfiguration.new;
    [config setRootProjectPathFrom:__FILE__];
    [config setup];
    return config;
}

id <BIInflatedViewHelper> testInflate(NSString *xml) {
    BILayoutConfiguration *config = testConfig();
    return testInflateConfig(xml, config);
}

id <BIInflatedViewHelper> testInflateConfigPath(NSString *xml, BILayoutConfiguration *config, NSString *pathOrFake) {
    BILayoutInflater *inflater = [BILayoutInflater inflaterWithConfiguration:config];
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    BIViewHierarchyBuilder *builder = [inflater inflateFilePathUntilReady:pathOrFake superview:nil content:data];
    BIInflatedViewContainer *container = builder.container;
    [container runOnReadySteps];
    return container;
}

id <BIInflatedViewHelper> testInflateConfig(NSString *xml, BILayoutConfiguration *config) {
    return testInflateConfigPath(xml, config, @"ignore");
}

UIView *testInflateView(NSString *xml) {
    id <BIInflatedViewHelper> container = testInflate(xml);
    return container.root;
}

BILayoutInflater *testInflater() {
    BILayoutConfiguration *configuration = testConfig();
    return [BILayoutInflater inflaterWithConfiguration:configuration];
}

BILayoutLoader *testLoader() {
    BILayoutInflater *inflater = testInflater();
    return [[BILayoutLoader alloc] initWithInflater:inflater];
}
