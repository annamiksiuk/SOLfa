//
//  AMNoteImageView.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 02.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMNoteImageView.h"
#import "Global.h"

@implementation AMNoteImageView

- (void) setDuration:(AMNoteDuration)duration {
    
    NSArray* colors = [NSArray arrayWithObjects:    BASE_PALETTE_COLOR2,    BASE_PALETTE_COLOR3,
                                                    BASE_PALETTE_COLOR4,    BASE_PALETTE_COLOR5, nil];

    _duration = duration;
    
    UIImage* image;
    
    switch (duration) {
        case AMNoteDurationWhole:
            image = [UIImage imageNamed:@"Whole"];
            break;
        case AMNoteDurationHalf:
            image = [UIImage imageNamed:@"Half"];
            break;
        case AMNoteDurationQuarter:
            image = [UIImage imageNamed:@"Quarter"];
            break;
        case AMNoteDurationEight:
            image = [UIImage imageNamed:@"Eight"];
            break;
        case AMNoteDurationSixteenth:
            image = [UIImage imageNamed:@"Sixteenth"];
            break;
    }

    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    NSInteger randomIndex = arc4random() % [colors count];
    [self setTintColor:[colors objectAtIndex:randomIndex]];
    
    self.image = image;

    self.userInteractionEnabled = YES;
    
}

@end
