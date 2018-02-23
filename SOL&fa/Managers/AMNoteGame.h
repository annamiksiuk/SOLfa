//
//  AMNoteGame.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 15.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMNote;

@interface AMNoteGame : NSObject

@property (assign, nonatomic) NSInteger countQuestion;

- (instancetype)initWithCountQuestion:(NSInteger)count;

- (void) startGame;
- (void) stopGame;
- (BOOL) checkAnswerNote:(AMNote*)answerNote;
- (void) newQuestion;
- (void) breakQuestion;
- (NSInteger) getCorrectAnswer;

- (AMNote*) getQuestionNote;
- (BOOL) isStarted;

@end
