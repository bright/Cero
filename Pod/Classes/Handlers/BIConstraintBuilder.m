#import "BIConstraintBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIEXTScope.h"

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
        if (self.otherItemAttributes.count == self.firstAttributes.count) {
            otherAttribute = (NSLayoutAttribute) self.otherItemAttributes[index];
        }
        UIView *otherItem = nil;
        if (self.otherItemFinder != nil) {
            otherItem = self.otherItemFinder(container);
            if (otherItem == nil || ![otherItem isKindOfClass:UIView.class]) {
                //TODO Error handling
                NSLog(@"Could not find other item view %@", _sourceReference);
                continue;
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
    //TODO first common ancestor would be better here
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
            self.otherItemAttributes = components;
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
    NSString *longName = rawValue;
    if ([rawValue rangeOfString:prefix].location == NSNotFound) {
        longName = [prefix stringByAppendingString:rawValue];
    }
    NSArray *synonyms = @[
            rawValue,
            longName
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
                @"left" : @(NSLayoutAttributeLeft),
                @"nslayoutattributeright" : @(NSLayoutAttributeRight),
                @"right" : @(NSLayoutAttributeRight),
                @"nslayoutattributetop" : @(NSLayoutAttributeTop),
                @"top" : @(NSLayoutAttributeTop),
                @"nslayoutattributebottom" : @(NSLayoutAttributeBottom),
                @"bottom" : @(NSLayoutAttributeBottom),
                @"nslayoutattributeleading" : @(NSLayoutAttributeLeading),
                @"leading" : @(NSLayoutAttributeLeading),
                @"nslayoutattributetrailing" : @(NSLayoutAttributeTrailing),
                @"trailing" : @(NSLayoutAttributeTrailing),
                @"nslayoutattributewidth" : @(NSLayoutAttributeWidth),
                @"width" : @(NSLayoutAttributeWidth),
                @"nslayoutattributeheight" : @(NSLayoutAttributeHeight),
                @"height" : @(NSLayoutAttributeHeight),
                @"nslayoutattributecenterx" : @(NSLayoutAttributeCenterX),
                @"centerx" : @(NSLayoutAttributeCenterX),
                @"nslayoutattributecentery" : @(NSLayoutAttributeCenterY),
                @"centery" : @(NSLayoutAttributeCenterY),
                @"nslayoutattributebaseline" : @(NSLayoutAttributeBaseline),
                @"baseline" : @(NSLayoutAttributeBaseline),
                @"nslayoutattributelastbaseline" : @(NSLayoutAttributeLastBaseline),
                @"lastbaseline" : @(NSLayoutAttributeLastBaseline),
                @"nslayoutattributefirstbaseline" : @(NSLayoutAttributeFirstBaseline ),
                @"firstbaseline" : @(NSLayoutAttributeFirstBaseline ),
                @"nslayoutattributeleftmargin" : @(NSLayoutAttributeLeftMargin ),
                @"leftmargin" : @(NSLayoutAttributeLeftMargin ),
                @"nslayoutattributerightmargin" : @(NSLayoutAttributeRightMargin ),
                @"rightmargin" : @(NSLayoutAttributeRightMargin ),
                @"nslayoutattributetopmargin" : @(NSLayoutAttributeTopMargin ),
                @"topmargin" : @(NSLayoutAttributeTopMargin ),
                @"nslayoutattributebottommargin" : @(NSLayoutAttributeBottomMargin ),
                @"bottommargin" : @(NSLayoutAttributeBottomMargin ),
                @"nslayoutattributeleadingmargin" : @(NSLayoutAttributeLeadingMargin ),
                @"leadingmargin" : @(NSLayoutAttributeLeadingMargin ),
                @"nslayoutattributetrailingmargin" : @(NSLayoutAttributeTrailingMargin ),
                @"trailingmargin" : @(NSLayoutAttributeTrailingMargin ),
                @"nslayoutattributecenterxwithinmargins" : @(NSLayoutAttributeCenterXWithinMargins),
                @"centerxwithinmargins" : @(NSLayoutAttributeCenterXWithinMargins),
                @"nslayoutattributecenterywithinmargins" : @(NSLayoutAttributeCenterYWithinMargins),
                @"centerywithinmargins" : @(NSLayoutAttributeCenterYWithinMargins)
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