
#import <Foundation/Foundation.h>
#import "ASHNodeList.h"

@protocol ASHFamily <NSObject>

@required

- (ASHNodeList *)nodeList;
- (void)newEntity:(ASHEntity *)entity;
- (void)removeEntity:(ASHEntity *)entity;
- (void)componentAddedToEntity:(ASHEntity *)entity
                componentClass:(Class)componentClass;
- (void)componentRemovedFromEntity:(ASHEntity *)entity
                    componentClass:(Class)componentClass;
- (void)cleanUp;

@end
