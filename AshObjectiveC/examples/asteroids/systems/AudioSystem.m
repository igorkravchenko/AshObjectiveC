
#import "AudioSystem.h"
#import "AudioNode.h"
#import "Audio.h"

#import <AVFoundation/AVAudioPlayer.h>

@interface AudioSystem() <AVAudioPlayerDelegate>

@end

@implementation AudioSystem
{
    NSMapTable * _players;
}

- (instancetype)init
{
    self = [super initWithNodeClass:AudioNode.class
                 nodeUpdateSelector:@selector(updateNode:time:)];
    if (self)
    {
        _players = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                         valueOptions:NSMapTableStrongMemory];
        [self warmUp];
    }

    return self;
}

// play sound once to initialize AVAudioPlayer, thus avoid delay in the gameplay
- (void)warmUp
{
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:ShootGun ofType:nil];
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                    error:nil];
    if([player prepareToPlay])
    {
        player.delegate = self;
        [_players setObject:player forKey:player];
        player.volume = 0;
        [player play];
    }
}

- (void)updateNode:(AudioNode *)node
              time:(NSNumber *)time
{
    NSBundle * bundle = [NSBundle mainBundle];

    for (NSString * sound in node.audio.toPlay)
    {
        NSString * path = [bundle pathForResource:sound ofType:nil];
        AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                        error:nil];
        if([player prepareToPlay])
        {
            player.delegate = self;
            [_players setObject:player forKey:player];
            [player play];
        }
    }

    [node.audio.toPlay removeAllObjects];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [_players removeObjectForKey:player];
}


@end