//
//  AMNoteGame.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 15.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMNoteGame.h"
#import "AMNote.h"


typedef NS_ENUM(NSInteger, AMStateGame) {
    AMStateGameOn,
    AMStateGameOff
};

@interface AMNoteGame ()

@property (assign, nonatomic) AMStateGame stateGame;
@property (strong, nonatomic) AMNote* randomNote;

@property (assign, nonatomic) NSInteger correctAnswer;

@end

@implementation AMNoteGame

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.stateGame = AMStateGameOff;
        self.correctAnswer = 0;
        self.countQuestion = 10;
        
    }
    return self;
}

- (instancetype)initWithCountQuestion:(NSInteger)count {
    
    self = [self init];
    if (self) {
        
        self.countQuestion = count;
        
    }
    return self;
}

#pragma mark - Games

- (void) startGame {
    
    self.correctAnswer = 0;
    self.stateGame = AMStateGameOn;
    
}

- (void) stopGame {

    self.randomNote = nil;
    self.stateGame = AMStateGameOff;
    
}

- (BOOL) checkAnswerNote:(AMNote*)answerNote {
    
    if (self.randomNote.octave == answerNote.octave && self.randomNote.note == answerNote.note && self.randomNote.duration == answerNote.duration) {
        
        self.correctAnswer++;
        return YES;
        
    }
    
    return NO;
        
}

- (void) newQuestion {
    
    if (self.stateGame == AMStateGameOff) {
        return;
    }
    
    AMNoteName noteName = arc4random() % 7;
    AMNoteOctave noteOctave = arc4random() % 2;
    AMNoteDuration noteDuration = arc4random() % 5;
    
    AMNote* note = [[AMNote alloc] initWithNote:noteName octave:noteOctave duration:noteDuration];
    
    self.randomNote = note;
    
}

- (void) breakQuestion {
    
    self.randomNote = nil;
    
}

- (AMNote*) getQuestionNote {
    
    if (self.stateGame == AMStateGameOff) {
        
        return nil;
    }
    
    return self.randomNote;
    
}

- (BOOL) isStarted {
    
    if (self.stateGame == AMStateGameOn) {
        return YES;
    }
    
    return NO;
    
}

- (NSInteger) getCorrectAnswer {
    
    return self.correctAnswer;
    
}

@end
