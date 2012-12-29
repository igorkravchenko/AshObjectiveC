
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHEntityList : NSObject

@property (nonatomic, strong) ASHEntity * head;
@property (nonatomic, strong) ASHEntity * tail;

- (void)addEntity:(ASHEntity *)entity;
- (void)removeEntity:(ASHEntity *)entity;
- (void)removeAll;

@end
