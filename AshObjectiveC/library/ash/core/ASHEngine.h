
#import <Foundation/Foundation.h>
#import "ASHSignal0.h"
#import "ASHEntity.h"
#import "ASHNodeList.h"

@class ASHSystem;

@interface ASHEngine : NSObject

@property (nonatomic, assign) BOOL updating;
@property (nonnull, nonatomic, readonly) ASHSignal0 * updateComplete;
@property (nonnull, nonatomic, assign) Class familyClass;

- (void)addEntity:(ASHEntity * __nonnull)entity;
- (void)removeEntity:(ASHEntity * __nonnull)entity;
- (void)removeAllEntities;
- (NSArray <ASHEntity *> * __nonnull)allEntities;
- (ASHNodeList * __nonnull)getNodeList:(Class __nonnull)nodeClass;
- (void)releaseNodeList:(Class __nonnull)nodeClass;
- (void)addSystem:(ASHSystem * __nonnull)system
         priority:(NSInteger)priority;
- (ASHSystem * __nullable)getSystem:(Class __nonnull)type;
- (NSArray <ASHSystem *> * __nonnull)allSystems;
- (void)removeSystem:(ASHSystem * __nonnull)system;
- (void)removeAllSystems;
- (void)update:(double)time;
- (ASHEntity * __nullable)getEntityByName:(NSString * __nonnull)name;

@end
