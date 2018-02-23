//
//  AMNote.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 28.01.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMNote.h"

@implementation AMNote

- (instancetype) initWithNote:(AMNoteName)note octave:(AMNoteOctave)octave duration:(AMNoteDuration)duration {
    
    self = [super init];
    
    if (self) {
        self.note = note;
        self.octave = octave;
        self.duration = duration;
    }
    return self;
    
}

- (NSString*) nameNote {
    
    switch (self.note) {
        case AMNoteNameA:
            return NSLocalizedString(@"AMNoteNameA", "");
        case AMNoteNameB:
            return NSLocalizedString(@"AMNoteNameB", "");
        case AMNoteNameC:
            return NSLocalizedString(@"AMNoteNameC", "");
        case AMNoteNameD:
            return NSLocalizedString(@"AMNoteNameD", "");
        case AMNoteNameE:
            return NSLocalizedString(@"AMNoteNameE", "");
        case AMNoteNameF:
            return NSLocalizedString(@"AMNoteNameF", "");
        case AMNoteNameG:
            return NSLocalizedString(@"AMNoteNameG", "");
    }
}

- (NSString*) nameOctave {
    
    switch (self.octave) {
        case AMNoteOctaveFirst:
            return NSLocalizedString(@"AMNoteOctaveFirst", "");
        case AMNoteOctaveSecond:
            return NSLocalizedString(@"AMNoteOctaveSecond", "");
    }
}

- (NSString*) nameDuration {
    
    switch (self.duration) {
        case AMNoteDurationWhole:
            return @"1";
        case AMNoteDurationHalf:
            return @"1/2";
        case AMNoteDurationQuarter:
            return @"1/4";
        case AMNoteDurationEight:
            return @"1/8";
        case AMNoteDurationSixteenth:
            return @"1/16";
    }
}

@end
