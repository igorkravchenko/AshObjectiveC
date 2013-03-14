
#import <Foundation/Foundation.h>
#import "ASHSignal2.h"

@interface ASHEntity : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, readonly) ASHSignal2 * componentAdded;
@property (nonatomic, readonly) ASHSignal2 * componentRemoved;
@property (nonatomic, weak) ASHEntity * previous;
@property (nonatomic, strong) ASHEntity * next;
@property (nonatomic, readonly) NSMutableDictionary * components;

- (ASHEntity *)addComponent:(id)component
          componentClass:(Class)componentClass;

- (ASHEntity *)addComponent:(id)component;

- (id)removeComponent:(Class)componentClass;

- (id)getComponent:(Class)componentClass;

- (NSArray *)allComponents;

- (BOOL)hasComponent:(Class)componentClass;

@end
