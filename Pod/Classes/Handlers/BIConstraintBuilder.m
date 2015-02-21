#import "BIConstraintBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIEXTScope.h"
#import "BISourceReference.h"
#import "UIView+Finders.h"
#import "BILog.h"

@interface BIIConstraintBuilder ()
@property(nonatomic, copy) ViewFinder firstItemFinder;
@property(nonatomic, strong) NSArray *firstAttributes;
@property(nonatomic) enum NSLayoutRelation relation;

@property(nonatomic, copy) ViewFinder otherItemFinder;

@property(nonatomic, strong) NSArray *otherItemAttributes;

@property(nonatomic) CGFloat multiplier;

@property(nonatomic) CGFloat constant;

@property(nonatomic, strong) BISourceReference *sourceReference;

@property(nonatomic, strong) NSNumber *priority;
@end

@implementation BIIConstraintBuilder

- (void)withSourceReference:(BISourceReference *)reference {
    self.sourceReference = reference;
}

- (NSArray *)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error {
    NSUInteger index = 0;
    NSMutableArray *constraints = NSMutableArray.new;
    UIView *firstItem = self.firstItemFinder(container);
    if (firstItem != nil) {
        for (NSNumber *attributeWrap in self.firstAttributes) {
            NSLayoutAttribute attribute = (NSLayoutAttribute) attributeWrap.integerValue;
            NSLayoutAttribute otherAttribute = attribute;
            if (self.otherItemAttributes.count == self.firstAttributes.count) {
                NSNumber *otherAttributeWrap = self.otherItemAttributes[index];
                otherAttribute = (NSLayoutAttribute) otherAttributeWrap.integerValue;
            }
            UIView *otherItem = nil;
            if (self.otherItemFinder != nil) {
                otherItem = self.otherItemFinder(container);
                if (otherItem == nil || ![otherItem isKindOfClass:UIView.class]) {
                    //TODO Error handling
                    BILog(@"Could not find other item view %@", _sourceReference.sourceDescription);
                    continue;
                }
            }

            firstItem.translatesAutoresizingMaskIntoConstraints = NO;

            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                          attribute:attribute
                                                                          relatedBy:self.relation
                                                                             toItem:otherItem
                                                                          attribute:otherAttribute
                                                                         multiplier:self.multiplier
                                                                           constant:self.constant];
            constraint.identifier = self.sourceReference.source;
            if (self.priority != nil) {
                constraint.priority = self.priority.floatValue;
            }

            UIView *constraintRoot = [firstItem bi_commonSuperviewForConstraint:otherItem];
            if (constraintRoot == nil) {
                BILog(@"ERROR: Can't find common superview for %@ and %@", firstItem, otherItem);
            } else {
                [constraintRoot addConstraint:constraint];
                [constraints addObject:constraint];
            }
            index += 1;
        }
    } else {
        BILog(@"Error first item for constraint not found: %@", _sourceReference.sourceDescription);
    }
    return constraints;
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
        NSArray *components = [otherItemSpec componentsSeparatedByString:@"."];
        NSString *viewSelector = components[0];
        ViewFinder viewFinder = [self parseViewFinder:viewSelector];
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
    if ([pseudoSelector isEqualToString:@":topLayoutGuide"]) {
        @weakify(self);
        return ^UIView *(BIInflatedViewContainer *container) {
            @strongify(self);
            UIView *view = self.firstItemFinder(container);
            UIViewController *controller = view.bi_firstViewController;
            return (id) controller.topLayoutGuide;
        };
    }
    if ([pseudoSelector isEqualToString:@":bottomLayoutGuide"]) {
        @weakify(self);
        return ^UIView *(BIInflatedViewContainer *container) {
            @strongify(self);
            UIView *view = self.firstItemFinder(container);
            UIViewController *controller = view.bi_firstViewController;
            return (id) controller.topLayoutGuide;
        };
    }
    if ([pseudoSelector isEqualToString:@":superview"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container) {
            @strongify(self);
            UIView *view = self.firstItemFinder(container);
            return view.superview;
        };
    }
    if ([pseudoSelector isEqualToString:@":previous"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container) {
            @strongify(self);
            UIView *firstItem = self.firstItemFinder(container);
            NSArray *siblings = firstItem.superview.subviews;
            NSUInteger indexOfFirstItem = [siblings indexOfObject:firstItem];
            if (indexOfFirstItem > 0) {
                UIView *sibling = siblings[indexOfFirstItem - 1];
                return sibling;
            }
            return (UIView *) nil;
        };
    }
    if ([pseudoSelector isEqualToString:@":next"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container) {
            @strongify(self);
            UIView *firstItem = self.firstItemFinder(container);
            NSArray *siblings = firstItem.superview.subviews;
            NSUInteger indexOfFirstItem = [siblings indexOfObject:firstItem];
            if (indexOfFirstItem < siblings.count - 1) {
                UIView *sibling = siblings[indexOfFirstItem + 1];
                return sibling;
            }
            return (UIView *) nil;
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
                             defaultValue:@(NSLayoutRelationEqual)
                                   prefix:@"NSLayoutRelation"
                                 valueMap:stringToRelationMap].integerValue;
}

- (void)constraintOn:(NSString *)on {
    self.firstAttributes = [self parseAttributes:on];
}

- (NSArray *)parseAttributes:(NSString *)on {
    NSArray *components = [on componentsSeparatedByString:@","];
    NSMutableArray *attributes = NSMutableArray.new;
    for (NSString *component in components) {
        NSString *componentTrimmed = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (componentTrimmed.length > 0) {
            NSLayoutAttribute attribute = [self attributeFromString:componentTrimmed];
            if (attribute != NSLayoutAttributeNotAnAttribute) {
                [attributes addObject:@(attribute)];
            } else {
                BILog(@"ERROR: No layout attribute found for name '%@'", component);
            }
        }
    }
    return attributes;
}


- (NSLayoutAttribute)attributeFromString:(NSString *)component {
    [self initAttributeMap];
    return (NSLayoutAttribute) [self parse:component
                              defaultValue:@(NSLayoutAttributeNotAnAttribute)
                                    prefix:@"NSLayoutAttribute"
                                  valueMap:stringToAttributeMap].integerValue;
}

- (NSNumber *)parse:(NSString *)rawValue defaultValue:(NSNumber *)defaultValue prefix:(NSString *)prefix valueMap:(NSDictionary *)sourceMap {
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
            return attributeValue;
        }
    }
    return defaultValue;
}


+ (instancetype)builderFor:(ViewFinder)viewFinder {
    return [[self alloc] initWithView:viewFinder];
}

- (instancetype)initWithView:(ViewFinder)view {
    self = [self init];
    if (self) {
        NSAssert(view != nil, @"View finder must not be nil");
        self.firstItemFinder = view;
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

static NSDictionary *stringToPriorityMap;

- (void)initPriorityMap {
    static dispatch_once_t init;
    dispatch_once(&init, ^{
        stringToPriorityMap = @{
                @"uilayoutpriorityrequired" : @(UILayoutPriorityRequired),
                @"required" : @(UILayoutPriorityRequired),
                @"uilayoutprioritydefaulthigh" : @(UILayoutPriorityDefaultHigh),
                @"high" : @(UILayoutPriorityDefaultHigh),
                @"uilayoutprioritydefaultlow" : @(UILayoutPriorityDefaultLow),
                @"low" : @(UILayoutPriorityDefaultHigh),
                @"uilayoutpriorityfittingsizelevel" : @(UILayoutPriorityFittingSizeLevel),
                @"fittingsizelevel" : @(UILayoutPriorityDefaultHigh),

        };
    });
}

- (void)withPriority:(NSString *)priority {
    if (priority.length > 0) {
        [self initPriorityMap];
        NSNumber *uiLayoutPriority = [self parse:priority
                                    defaultValue:nil
                                          prefix:@"UILayoutPriority"
                                        valueMap:stringToPriorityMap];
        if (uiLayoutPriority != nil) {
            self.priority = uiLayoutPriority;
        } else {
            float priorityValue = priority.floatValue;
            if (priorityValue >= 0 && priorityValue <= UILayoutPriorityRequired) {
                self.priority = @(priorityValue);
            } else {
                BILog(@"Invalid priority value %@ (values must be between 0 and 1000)", priority);
            }
        }
    }
}
@end