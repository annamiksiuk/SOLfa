//
//  AMAnswerView.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 29.01.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMAnswerView.h"
#import "AMStaffView.h"
#import "AMNoteImageView.h"
#import "AMNote.h"
#import "Global.h"

@interface AMAnswerView()

@property (strong, nonatomic) AMStaffView* staffView;
@property (strong, nonatomic) AMNoteImageView* draggingAnswer;
@property (assign, nonatomic) CGPoint touchOffset;

@property (assign, nonatomic) CGPoint oldPositionDraggedAnswer;
@property (strong, nonatomic) AMNoteImageView* answer;
@property (assign, nonatomic) CGPoint prevPositionAnswer;

@end

@implementation AMAnswerView

- (void) setAnswer:(AMNoteImageView *)answer {
    
    _answer = answer;
    
    if ([self.delegate respondsToSelector:@selector(didSelectNote:)]) {
        
        if (!answer) {
            
            [self.delegate didSelectNote:nil];
            
        } else {
            
            CGPoint point = answer.center;
            CGFloat offsetY = CGRectGetHeight(answer.frame) * 0.28f;
            point.y += offsetY;
            point = [self.staffView convertPoint:point fromView:self];
            
            AMNote* note = [self.staffView noteForPoint:point];
            note.duration = answer.duration;
            [self.delegate didSelectNote:note];
            
            
            if ((note.octave == AMNoteOctaveFirst && note.note == AMNoteNameG) || note.octave == AMNoteOctaveSecond) {
                
                CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI);
                CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(answer.frame) * 0.6);
                answer.transform = CGAffineTransformConcat(rotateTransform, translationTransform);
                
            }
            
        }
    }
}

#pragma  mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePan:)];
        panGesture.delegate = self;
        
        [self addGestureRecognizer:panGesture];
        
        self.draggingAnswer = nil;
        self.touchOffset = CGPointZero;
        self.oldPositionDraggedAnswer = CGPointZero;
        self.answer = nil;
        self.prevPositionAnswer = CGPointZero;

        [self createContent];
        
    }
    return self;
    
}



- (void) createContent {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    AMStaffView* staffView = [[AMStaffView alloc] initWithFrame:CGRectMake(0.1f * width, 0, 0.65f * width, height)];
    staffView.backgroundColor = [UIColor clearColor];
    staffView.opaque = NO;
    staffView.rowColor = BASE_PALETTE_COLOR5;
    self.staffView = staffView;
    [self addSubview:staffView];

    CGFloat offsetImage = 0.05f * height;
    
    for (NSInteger index = 0; index < 5; index++) {
        
        AMNoteImageView* noteImageView = [[AMNoteImageView alloc] initWithFrame:CGRectMake(0.8f * width, offsetImage, 0.14f * width, 0.14f * height)];
        noteImageView.duration = index;
        noteImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:noteImageView];
        
        offsetImage += 0.19 * height;
        
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.draggingAnswer) {
        return NO;
    }
    
    if (self.answer) {
        return YES;
    }

    return NO;
    
}

#pragma mark - Gestures

- (void) handlePan:(UIPanGestureRecognizer*)gesture {
    
    CGPoint currentPoint = [gesture locationInView:self];
    UIView* currentView = [self hitTest:currentPoint withEvent:nil];
    
    CGPoint currentPointForStaff = [self.staffView convertPoint:currentPoint fromView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([currentView isKindOfClass:[AMNoteImageView class]]) {
            
            if ([self.staffView pointInside:currentPointForStaff withEvent:nil] && self.answer) {
                
                
                CGPoint newPoint = [self.answer convertPoint:currentPoint fromView:self];
                
                if ([self.answer pointInside:newPoint withEvent:nil]) {
                    
                    self.draggingAnswer = self.answer;
                    self.oldPositionDraggedAnswer = self.prevPositionAnswer;
                    self.answer = nil;
                    self.prevPositionAnswer = CGPointZero;
                    self.touchOffset = CGPointZero;
                    
                    [self animateBeginMovesDraggingAnswer];
                }
                
            } else {
                
                self.oldPositionDraggedAnswer = currentView.center;
                self.draggingAnswer = (AMNoteImageView*)currentView;
                self.touchOffset = CGPointZero;
                
                [self animateBeginMovesDraggingAnswer];
                
            }
                
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        if ([self pointInside:currentPoint withEvent:nil]) {
            
            self.draggingAnswer.center = CGPointMake(currentPoint.x + self.touchOffset.x, currentPoint.y + self.touchOffset.y);
            
        } else {

            [self cancelDragging];
            
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if ([self.staffView pointInside:currentPointForStaff withEvent:nil] && self.draggingAnswer) {
            
            CGFloat offsetY = CGRectGetHeight(self.draggingAnswer.frame) * (0.5f - 0.22f);
            CGPoint point = CGPointMake(currentPoint.x, currentPoint.y + offsetY);
            
            CGPoint anchorPoint = [self.staffView anchorForPoint:[self.staffView convertPoint:point fromView:self]];
            anchorPoint = [self convertPoint:anchorPoint fromView:self.staffView];

            [self animateMovesView:self.draggingAnswer
                           toPoint:CGPointMake(anchorPoint.x + self.touchOffset.x, anchorPoint.y + self.touchOffset.y - offsetY)];
                
            [self setAnswer];
            
        } else {

            [self cancelDragging];
        }
    
    } else if (gesture.state == UIGestureRecognizerStateCancelled) {

        [self cancelDragging];
        
    }
    
}

#pragma mark - Animations

- (void) animateMovesView:(UIView*)view toPoint:(CGPoint)point {
    
    __weak typeof(view) weakView = view;
    [UIView animateWithDuration:0.2f
                          delay:0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakView.transform = CGAffineTransformIdentity;
                         weakView.center = point;
                    }
                     completion:nil];
    
    
}

- (void) animateBeginMovesDraggingAnswer {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         weakSelf.draggingAnswer.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                     }];
    
}

- (void) animateEndMovesDraggingAnswer {
  
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         weakSelf.draggingAnswer.transform = CGAffineTransformIdentity;
                     }];
    
}

#pragma mark - Own methods

- (void) cancelDragging {
    
    [self animateEndMovesDraggingAnswer];
    [self animateMovesView:self.draggingAnswer
                   toPoint:self.oldPositionDraggedAnswer];
    self.draggingAnswer = nil;
    self.touchOffset = CGPointZero;
    self.oldPositionDraggedAnswer = CGPointZero;

}

- (void) setAnswer {
    
    if (self.answer && ![self.answer isEqual:self.draggingAnswer]) {
        
        [self animateMovesView:self.answer
                       toPoint:self.prevPositionAnswer];
        
    }
    
    [self animateEndMovesDraggingAnswer];
    self.answer = self.draggingAnswer;
    self.prevPositionAnswer = self.oldPositionDraggedAnswer;
    self.draggingAnswer = nil;
    self.touchOffset = CGPointZero;
    self.oldPositionDraggedAnswer = CGPointZero;
    
}

@end
