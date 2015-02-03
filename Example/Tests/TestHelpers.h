#import "SpectaDSL.h"
#import "BILayoutConfiguration.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewHelper.h"

typedef UIView *(^InflateTestView)(NSString *);

id <BIInflatedViewHelper> testInflate(NSString *xml);
UIView *testInflateView(NSString *xml);
NSString *testReadLog(NSDate* since);
