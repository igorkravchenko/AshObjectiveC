
#import <Foundation/Foundation.h>
#import "ASHSignal0.h"
#import "ASHEntity.h"
#import "ASHNodeList.h"

@class ASHSystem;

@interface ASHEngine : NSObject

@property (nonatomic, assign) BOOL updating;
@property (nonatomic, readonly) ASHSignal0 * updateComplete;
@property (nonatomic, assign) Class familyClass;

- (void)addEntity:(ASHEntity *)entity;
- (void)removeEntity:(ASHEntity *)entity;
- (void)removeAllEntities;
- (NSArray *)allEntities;
- (ASHNodeList *)getNodeList:(Class)nodeClass;
- (void)releaseNodeList:(Class)nodeClass;
- (void)addSystem:(ASHSystem *)system
         priority:(NSInteger)priority;
- (ASHSystem *)getSystem:(Class)type;
- (NSArray *)allSystems;
- (void)removeSystem:(ASHSystem *)system;
- (void)removeAllSystems;
- (void)update:(double)time;

@end
