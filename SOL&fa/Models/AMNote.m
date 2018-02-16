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
            return @"A";
        case AMNoteNameB:
            return @"B";
        case AMNoteNameC:
            return @"C";
        case AMNoteNameD:
            return @"D";
        case AMNoteNameE:
            return @"E";
        case AMNoteNameF:
            return @"F";
        case AMNoteNameG:
            return @"G";
    }
}

- (NSString*) nameOctave {
    
    switch (self.octave) {
        case AMNoteOctaveFirst:
            return @"One";
        case AMNoteOctaveSecond:
            return @"Two";
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
