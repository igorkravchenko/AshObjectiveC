
#import <Foundation/Foundation.h>
#import "ASHSignal2.h"

@interface ASHEntity : NSObject
{
    @package
    __weak ASHEntity * previous;
    __strong ASHEntity * next;
}

@property (nonnull, nonatomic, readonly) ASHSignal2 * componentAdded;
@property (nonnull, nonatomic, readonly) ASHSignal2 * componentRemoved;
@property (nonnull, nonatomic, readonly) NSMapTable * components;
@property (nonnull, nonatomic, readonly) ASHSignal2 * nameChanged;

- (instancetype __nonnull)initWithName:(NSString * __nullable)name;

- (ASHEntity * __nonnull)addComponent:(id __nonnull)component
          componentClass:(Class __nonnull)componentClass;

- (ASHEntity * __nonnull)addComponent:(id __nonnull)component;

- (id __nullable)removeComponent:(Class __nonnull)componentClass;

- (id __nullable)getComponent:(Class __nonnull)componentClass;

- (NSArray * __nonnull)allComponents;

- (BOOL)hasComponent:(Class __nonnull)componentClass;

- (NSString * __nonnull)name;

- (void)setName:(NSString * __nonnull)value;

@end
