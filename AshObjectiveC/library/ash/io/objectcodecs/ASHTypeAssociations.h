
#import <Foundation/Foundation.h>

@interface ASHTypeAssociations : NSObject

+ (ASHTypeAssociations *)instance;

- (void)addTypeAssociation:(Class)type
               association:(NSString *)association;
- (NSString *)associationForType:(Class)type;

@end