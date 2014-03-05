
#import <Foundation/Foundation.h>

@interface ASHObjectReflection : NSObject

@property (nonatomic, readonly) NSDictionary * propertyTypes;
@property (nonatomic, readonly) NSString * type;

- (id)initWithComponent:(NSObject *)component;

@end