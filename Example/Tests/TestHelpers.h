#import "SpectaDSL.h"
#import <UIKit/UIKit.h>
#import "BILayoutConfiguration.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewHelper.h"
#import "BILayoutLoader.h"

typedef UIView *(^InflateTestView)(NSString *);

id <BIInflatedViewHelper> testInflate(NSString *xml);

BILayoutConfiguration *testConfig();

BILayoutInflater *testInflater();

BILayoutLoader *testLoader();

id <BIInflatedViewHelper> testInflateConfig(NSString *xml, BILayoutConfiguration *configuration);

id <BIInflatedViewHelper> testInflateConfigPath(NSString *xml, BILayoutConfiguration *config, NSString *pathOrFake);

UIView *testInflateView(NSString *xml);
