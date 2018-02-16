//
//  AMNote.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 28.01.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMNoteName) {
    AMNoteNameA,
    AMNoteNameB,
    AMNoteNameC,
    AMNoteNameD,
    AMNoteNameE,
    AMNoteNameF,
    AMNoteNameG
    
};

typedef NS_ENUM(NSInteger, AMNoteDuration) {
    AMNoteDurationWhole,
    AMNoteDurationHalf,
    AMNoteDurationQuarter,
    AMNoteDurationEight,
    AMNoteDurationSixteenth
};

typedef NS_ENUM(NSInteger, AMNoteOctave) {
    AMNoteOctaveFirst,
    AMNoteOctaveSecond
};

@interface AMNote : NSObject

@property (assign, nonatomic) AMNoteName note;
@property (assign, nonatomic) AMNoteOctave octave;
@property (assign, nonatomic) AMNoteDuration duration;

- (instancetype) initWithNote:(AMNoteName)note octave:(AMNoteOctave)octave duration:(AMNoteDuration)duration;

- (NSString*) nameNote;
- (NSString*) nameOctave;
- (NSString*) nameDuration;

@end
