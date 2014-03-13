
#import <Foundation/Foundation.h>

@class MockPoint;
@class MockRectangle;

@interface MockReflectionObject : NSObject

@property (nonatomic, assign) NSInteger intVariable;
@property (nonatomic, assign) NSUInteger uintVariable;
@property (nonatomic, assign) float numberVariable;
@property (nonatomic, assign) BOOL booleanVariable;
@property (nonatomic, strong) NSString * stringVariable;
@property (nonatomic, strong) MockPoint * pointVariable;
@property (nonatomic, strong) MockPoint * point2Variable;
@property (nonatomic, strong) MockRectangle * rectVariable;
@property (nonatomic, strong) MockRectangle * rect2Variable;
@property (nonatomic, strong) NSArray * arrayVariable;

@property (nonatomic, readwrite) NSInteger fullAccessor;

@property (nonatomic, readonly) NSInteger getOnlyAccessor;

- (void)setOnlyAccessor:(NSInteger)value;

@end