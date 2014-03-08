
#import <Foundation/Foundation.h>

@interface MockReflectionObject : NSObject

@property (nonatomic, assign) NSInteger intVariable;
@property (nonatomic, assign) NSUInteger uintVariable;
@property (nonatomic, assign) float numberVariable;
@property (nonatomic, assign) BOOL booleanVariable;
@property (nonatomic, strong) NSString * stringVariable;
@property (nonatomic, assign) CGPoint pointVariable;
@property (nonatomic, assign) CGPoint point2Variable;
@property (nonatomic, assign) CGRect rectVariable;
@property (nonatomic, assign) CGRect rect2Variable;
@property (nonatomic, assign) NSArray * arrayVariable;

@property (nonatomic, readwrite) NSInteger fullAccessor;

@property (nonatomic, readonly) NSInteger getOnlyAccessor;

- (void)setOnlyAccessor:(NSInteger)value;

@end