#import "BIConstraintHanlder.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"
#import "BIInflatedViewContainer.h"
#import "BIEXTScope.h"

typedef UIView *(^ViewFinder)(BIInflatedViewContainer *container);

@interface BIIConstraintBuilder : NSObject
@property(nonatomic, strong) UIView *firstItem;
@property(nonatomic, strong) NSArray *firstAttributes;

@property(nonatomic) enum NSLayoutRelation relation;

@property(nonatomic, copy) ViewFinder otherItemFinder;

@property(nonatomic, strong) NSArray *otherItemAttibutes;

@property(nonatomic) CGFloat multiplier;

@property(nonatomic) CGFloat constant;

@property(nonatomic, strong) BISourceReference *sourceReference;

+ (instancetype)builderFor:(UIView *)view;

- (instancetype)initWithView:(UIView *)view;

- (void)constraintOn:(NSString *)on;

- (void)withRelation:(NSString *)relation;

- (void)withOtherItem:(NSString *)otherItemSpec;

- (void)withMultiplier:(NSString *)multiplier;

- (void)withConstant:(NSString *)constant;

- (void)withSourceReference:(BISourceReference *)reference;

- (BOOL)validForCompletion:(NSError **)pError;

- (BOOL)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error;
@end

@implementation BIConstraintHanlder {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"Constraint"];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BISourceReference *reference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
    if (builder.current == nil) {
        NSLog(@"WARN: Constraint not under view %@", reference);
        return;
    }
    NSMutableDictionary *attributes = element.attributes;
    NSString *on = attributes[@"on"];

    BIIConstraintBuilder *constraintBuilder = [BIIConstraintBuilder builderFor:builder.current];
    [constraintBuilder constraintOn:on];
    [constraintBuilder withRelation:attributes[@"relation"]];

    [constraintBuilder withOtherItem:attributes[@"with"]];
    [constraintBuilder withMultiplier:attributes[@"multiplier"]];
    [constraintBuilder withConstant:attributes[@"constant"]];
    [constraintBuilder withSourceReference:reference];

    NSError *validationError;
    if ([constraintBuilder validForCompletion:&validationError]) {
        [builder registerOnReady:^(BIInflatedViewContainer *container) {
            NSError *installError;
            if (![constraintBuilder tryInstall:container error:&installError]) {
                NSLog(@"Failed to isntall constraint: %@", installError);
            }
        }];
    } else {
        NSLog(@"ERROR Constraint cannot be build: %@", validationError);
    }

    element.attributes = NSMutableDictionary.new;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end


@implementation BIIConstraintBuilder {
}

- (void)withSourceReference:(BISourceReference *)reference {
    self.sourceReference = reference;
}

- (BOOL)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error {
    NSUInteger index = 0;
    NSMutableArray *constraints = NSMutableArray.new;
    self.firstItem.translatesAutoresizingMaskIntoConstraints = NO;
    for (NSNumber *attributeWrap in self.firstAttributes) {
        NSLayoutAttribute attribute = (NSLayoutAttribute) attributeWrap.integerValue;
        NSLayoutAttribute otherAttribute = attribute;
        if (self.otherItemAttibutes.count == self.firstAttributes.count) {
            otherAttribute = (NSLayoutAttribute) self.otherItemAttibutes[index];
        }
        UIView *otherItem = nil;
        if (self.otherItemFinder != nil) {
            otherItem = self.otherItemFinder(container);
            if (otherItem == nil) {
                //TODO Error handling
            }
        }

        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                      attribute:attribute
                                                                      relatedBy:self.relation
                                                                         toItem:otherItem
                                                                      attribute:otherAttribute
                                                                     multiplier:self.multiplier
                                                                       constant:self.constant];

        [constraints addObject:constraint];
        index += 1;
    }
    //TODO common ancestor would be better here
    [container.root addConstraints:constraints];
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.multiplier = 1;
        self.constant = 0;
        self.relation = NSLayoutRelationEqual;
    }

    return self;
}

- (void)withConstant:(NSString *)constant {
    if (constant.length > 0) {
        self.constant = constant.floatValue;
    } else {
        self.constant = 0;
    }
}

- (BOOL)validForCompletion:(NSError **)pError {
    return YES;
}


- (void)withMultiplier:(NSString *)multiplier {
    if (multiplier.length > 0) {
        self.multiplier = multiplier.floatValue;
    } else {
        self.multiplier = 1;
    }
}

- (void)withOtherItem:(NSString *)otherItemSpec {
    if (otherItemSpec.length > 0) {
        NSArray *components = [otherItemSpec componentsSeparatedByString:@","];
        ViewFinder viewFinder = [self parseViewFinder:components[0]];
        self.otherItemFinder = viewFinder;
        if (components.count > 1) {
            NSString *attributePart = components[1];
            components = [self parseAttributes:attributePart];
            self.otherItemAttibutes = components;
        }
    }
}

- (ViewFinder)parseViewFinder:(NSString *)pseudoSelector {
    if ([pseudoSelector characterAtIndex:0] == '#') {
        NSString *viewId = [pseudoSelector substringFromIndex:1];
        if (viewId.length > 0) {
            return ^(BIInflatedViewContainer *container) {
                return [container findViewById:viewId];
            };
        }
    }
    if ([pseudoSelector isEqualToString:@":superview"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container) {
            @strongify(self);
            return self.firstItem.superview;
        };
    }
    return NULL;
}

- (void)withRelation:(NSString *)relation {
    if (relation.length > 0) {
        self.relation = [self parseRelation:relation];
    } else {
        self.relation = NSLayoutRelationEqual;
    }
}

- (enum NSLayoutRelation)parseRelation:(NSString *)relation {
    [self initRelationMap];
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