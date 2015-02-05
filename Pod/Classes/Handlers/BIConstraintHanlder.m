#import "BIConstraintHanlder.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"

@interface BIIConstraintBuilder : NSObject
@property(nonatomic, strong) UIView *firstItem;
@property(nonatomic, strong) NSArray *firstAttributes;

@property(nonatomic) enum NSLayoutRelation relation;

+ (instancetype)builderFor:(UIView *)view;

- (instancetype)initWithView:(UIView *)view;

- (void)constraintOn:(NSString *)on;

- (void)withRelation:(NSString *)relation;
@end

@implementation BIConstraintHanlder {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"Constraint"];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    if (builder.current == nil) {
        NSLog(@"WARN: Constraint not under view %@", [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber]);
        return;
    }
    NSMutableDictionary *attributes = element.attributes;
    NSString *on = attributes[@"on"];

    BIIConstraintBuilder *constraintBuilder = [BIIConstraintBuilder builderFor:builder.current];
    [constraintBuilder constraintOn:on];
    [constraintBuilder withRelation:attributes[@"relation"]];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:builder.current
//                                                                  attribute:constraintedAttribute
//                                                                  relatedBy:contraintRelation
//                                                                     toItem:
//                                                                  attribute:<#(NSLayoutAttribute)attr2#>
//                                                                 multiplier:<#(CGFloat)multiplier#>
//                                                                   constant:<#(CGFloat)c#>];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    element.attributes = NSMutableDictionary.new;
}

@end


@implementation BIIConstraintBuilder {
}

- (void)withRelation:(NSString *)relation {
    if (relation.length > 0) {
        self.relation = [self parseRelation:relation];
    } else {
        self.relation = NSLayoutRelationEqual;
    }
}

- (enum NSLayoutRelation)parseRelation:(NSString *)relation {
    [self initAttributeMap];
    return (NSLayoutRelation) [self parse:relation
                             defaultValue:NSLayoutRelationEqual
                                   prefix:@"NSLayoutRelation"
                                 valueMap:stringToRelationMap];
}

- (void)constraintOn:(NSString *)on {
    self.firstAttributes = [self parseAttributes:on];
}

- (NSArray *)parseAttributes:(NSString *)on {
    NSArray *components = [on componentsSeparatedByString:@","];
    NSMutableArray *attributes = NSMutableArray.new;
    for (NSString *component in components) {
        if (component.length > 0) {
            NSLayoutAttribute attribute = [self attributeFromString:component];
            if (attribute != NSLayoutAttributeNotAnAttribute) {
                [attributes addObject:@(attribute)];
            } else {
                NSLog(@"ERROR: No layout attribute found for name '%@'", component);
            }
        }
    }
    return attributes;
}


- (NSLayoutAttribute)attributeFromString:(NSString *)component {
    [self initAttributeMap];
    return (NSLayoutAttribute) [self parse:component
                              defaultValue:NSLayoutAttributeNotAnAttribute
                                    prefix:@"NSLayoutAttribute"
                                  valueMap:stringToAttributeMap];
}

- (NSInteger)parse:(NSString *)rawValue defaultValue:(NSInteger)defaultValue prefix:(NSString *)prefix valueMap:(NSDictionary *)sourceMap {
    NSString *shortName = [rawValue substringFromIndex:prefix.length];
    NSArray *synonyms = @[
            rawValue,
            shortName
    ];
    NSNumber *attributeValue;
    for (NSString *attributeName in synonyms) {
        attributeValue = sourceMap[attributeName.lowercaseString];
        if (attributeValue != nil) {
            return (NSLayoutAttribute) attributeValue.integerValue;
        }
    }
    return defaultValue;
}


+ (instancetype)builderFor:(UIView *)view {
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view {
    self = [self init];
    if (self) {
        self.firstItem = view;
    }
    return self;
}

static NSDictionary *stringToAttributeMap;

- (void)initAttributeMap {
    static dispatch_once_t initAttributeMap;
    dispatch_once(&initAttributeMap, ^{
        stringToAttributeMap = @{
                @"nslayoutattributeleft" : @(NSLayoutAttributeLeft),
                @"nslayoutattributeright" : @(NSLayoutAttributeRight),
                @"nslayoutattributetop" : @(NSLayoutAttributeTop),
                @"nslayoutattributebottom" : @(NSLayoutAttributeBottom),
                @"nslayoutattributeleading" : @(NSLayoutAttributeLeading),
                @"nslayoutattributetrailing" : @(NSLayoutAttributeTrailing),
                @"nslayoutattributewidth" : @(NSLayoutAttributeWidth),
                @"nslayoutattributeheight" : @(NSLayoutAttributeHeight),
                @"nslayoutattributecenterx" : @(NSLayoutAttributeCenterX),
                @"nslayoutattributecentery" : @(NSLayoutAttributeCenterY),
                @"nslayoutattributebaseline" : @(NSLayoutAttributeBaseline),
                @"nslayoutattributelastbaseline" : @(NSLayoutAttributeLastBaseline),
                @"nslayoutattributefirstbaseline" : @(NSLayoutAttributeFirstBaseline ),
                @"nslayoutattributeleftmargin" : @(NSLayoutAttributeLeftMargin ),
                @"nslayoutattributerightmargin" : @(NSLayoutAttributeRightMargin ),
                @"nslayoutattributetopmargin" : @(NSLayoutAttributeTopMargin ),
                @"nslayoutattributebottommargin" : @(NSLayoutAttributeBottomMargin ),
                @"nslayoutattributeleadingmargin" : @(NSLayoutAttributeLeadingMargin ),
                @"nslayoutattributetrailingmargin" : @(NSLayoutAttributeTrailingMargin ),
                @"nslayoutattributecenterxwithinmargins" : @(NSLayoutAttributeCenterXWithinMargins),
                @"nslayoutattributecenterywithinmargins" : @(NSLayoutAttributeCenterYWithinMargins)
        };
    });
}

static NSDictionary *stringToRelationMap;

- (void)initRelationMap {
    static dispatch_once_t init;
    dispatch_once(&init, ^{
        stringToRelationMap = @{
                @"nslayoutrelationequal" : @(NSLayoutRelationEqual),
                @"eq" : @(NSLayoutRelationEqual),
                @"nslayoutrelationgreaterthanorequal" : @(NSLayoutRelationGreaterThanOrEqual),
                @"gt" : @(NSLayoutRelationGreaterThanOrEqual),
                @"more" : @(NSLayoutRelationGreaterThanOrEqual),
                @"nslayoutrelationlessthanorequal" : @(NSLayoutRelationLessThanOrEqual),
                @"less" : @(NSLayoutRelationLessThanOrEqual),
        };
    });
}

@end