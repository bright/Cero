#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutInflater.h>
#import "BIInflatedViewHelper.h"
#import "TestHelpers.h"
#import <asl.h>

id <BIInflatedViewHelper> testInflate(NSString *xml){
    BILayoutConfiguration *config = BILayoutConfiguration.new;
    [config setup];
    BILayoutInflater *inflater = [BILayoutInflater inflaterWithConfiguration:config];
    NSObject<BIInflatedViewHelper>* container = [inflater inflateFilePath:@"ignore" withContentString:xml];
    return container;
}

UIView *testInflateView(NSString *xml){
    id<BIInflatedViewHelper> container = testInflate(xml);
    return container.root;
}

NSString *testReadLog(NSDate* since){
    [NSThread sleepForTimeInterval:0.4];
    aslmsg query, message;
    uint32_t messageKey;
    const char *key, *val;

    query = asl_new(ASL_TYPE_QUERY);
    NSString *logSince = [NSString stringWithFormat:@"%.0f", [since timeIntervalSince1970]];
    asl_set_query(query, ASL_KEY_SENDER, "Cero", ASL_QUERY_OP_EQUAL);
    asl_set_query(query, ASL_KEY_TIME, [logSince UTF8String], ASL_QUERY_OP_GREATER_EQUAL);
    aslresponse searchCursor = asl_search(NULL, query);
    NSMutableString *result = @"".mutableCopy;
    while (NULL != (message = asl_next(searchCursor)))
    {
//        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];

        val = asl_get(message, "Message");
        NSString *string = [NSString stringWithUTF8String:val];
        [result appendString:string];
        [result appendString:@"\n"];
//        for (messageKey = 0; (NULL != (key = asl_key(message, messageKey))); messageKey++)
//        {
//            NSString *keyString = [NSString stringWithUTF8String:(char *)key];
//
//            val = asl_get(message, key);
//
//            NSString *string = [NSString stringWithUTF8String:val];
//            tmpDict[keyString] = string;
//        }
//
//        NSLog(@"%@", tmpDict);
    }
    asl_release(searchCursor);
    return result;
}
