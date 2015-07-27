
#import <Foundation/Foundation.h>
#import "ASHNode.h"

@class Audio;


@interface AudioNode : ASHNode

@property (nonatomic, weak) Audio * audio;

@end