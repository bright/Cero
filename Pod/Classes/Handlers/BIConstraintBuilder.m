#import "BIConstraintBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIEXTScope.h"
#import "BISourceReference.h"
#import "UIView+Finders.h"
#import "BILog.h"
#import "BIEnumsRegistry.h"
#import "BIEnum.h"

@interface BIIConstraintBuilder ()
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

- (instancetype)copy {
    BIIConstraintBuilder *builder = [self.class builder];
    builder.firstItemFinder = self.firstItemFinder;
    builder.firstAttributes = self.firstAttributes.copy;
    builder.relation = self.relation;
    builder.otherItemFinder = self.otherItemFinder;
    builder.otherItemAttributes = self.otherItemAttributes.copy;
    builder.multiplier = self.multiplier;
    builder.constant = self.constant;
    builder.sourceReference = self.sourceReference;
    builder.priority = self.priority;
    return builder;
}

- (void)withSourceReference:(BISourceReference *)reference {
    self.sourceReference = reference;
}

- (NSArray *)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error {
    NSUInteger index = 0;
    NSMutableArray *constraints = NSMutableArray.new;
    UIView *firstItem = self.firstItemFinder(container, self);
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
                otherItem = self.otherItemFinder(container, self);
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
            return ^(BIInflatedViewContainer *container, id _) {
                return [container findViewById:viewId];
            };
        }
    }
    if ([pseudoSelector isEqualToString:@":topLayoutGuide"]) {
        @weakify(self);
        return ^UIView *(BIInflatedViewContainer *container, BIIConstraintBuilder *builder) {
            @strongify(self);
            UIView *view = builder.firstItemFinder(container, builder);
            UIViewController *controller = view.bi_firstViewController;
            return (id) controller.topLayoutGuide;
        };
    }
    if ([pseudoSelector isEqualToString:@":bottomLayoutGuide"]) {
        @weakify(self);
        return ^UIView *(BIInflatedViewContainer *container, BIIConstraintBuilder *builder) {
            @strongify(self);
            UIView *view = builder.firstItemFinder(container, builder);
            UIViewController *controller = view.bi_firstViewController;
            return (id) controller.topLayoutGuide;
        };
    }
    if ([pseudoSelector isEqualToString:@":superview"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container, BIIConstraintBuilder *builder) {
            @strongify(self);
            UIView *view = builder.firstItemFinder(container, builder);
            return view.superview;
        };
    }
    if ([pseudoSelector isEqualToString:@":previous"]) {
        @weakify(self);
        return ^(BIInflatedViewContainer *container, BIIConstraintBuilder *builder) {
            @strongify(self);
            UIView *firstItem = builder.firstItemFinder(container, builder);
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
        return ^(BIInflatedViewContainer *container, BIIConstraintBuilder *builder) {
            @strongify(self);
            UIView *firstItem = builder.firstItemFinder(container, builder);
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
    BIEnum *relationEnum = BIEnumFor(NSLayoutRelation);
    NSNumber *relationNumber = [relationEnum valueFor:relation orDefault:@(NSLayoutRelationEqual)];
    return (enum NSLayoutRelation) relationNumber.integerValue;
}

- (void)constraintOn:(NSString *)on {
    self.firstAttributes = [self parseAttributes:on];
}

- (NSArray *)parseAttributes:(NSString *)on {
    BIEnum *layoutAttributeEnum = BIEnumFor(NSLayoutAttribute);
    NSArray *components = [on componentsSeparatedByString:@","];
    NSMutableArray *attributes = NSMutableArray.new;
    for (NSString *component in components) {
        NSString *componentTrimmed = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (componentTrimmed.length > 0) {
            NSLayoutAttribute attribute = (NSLayoutAttribute) [layoutAttributeEnum valueFor:componentTrimmed
                                                                                  orDefault:@(NSLayoutAttributeNotAnAttribute)].integerValue;
            if (attribute != NSLayoutAttributeNotAnAttribute) {
                [attributes addObject:@(attribute)];
            } else {
                BILog(@"ERROR: No layout attribute found for name '%@'", component);
            }
        }
    }
    return attributes;
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


+ (instancetype)builder {
    return [self new];
}

- (void)withPriority:(NSString *)priority {
    if (priority.length > 0) {
        BIEnum *priorityEnum = BIEnumFor(UILayoutPriority);
        NSNumber *uiLayoutPriority = [priorityEnum valueFor:priority orDefault:nil];
        if (uiLayoutPriority != nil) {
            self.priority = uiLayoutPriority;
        } else {
            float priorityValue = priority.floatValue;
            if (priorityValue > 0 && priorityValue <= UILayoutPriorityRequired) {
                self.priority = @(priorityValue);
            } else {
                BILog(@"Invalid priority value %@ (values must be greater than 0 and at most 1000)", priority);
            }
        }
    }
}


@end