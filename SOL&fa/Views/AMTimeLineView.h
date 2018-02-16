//
//  AMTimeLineView.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 14.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMTimeLineViewDelegate;

@interface AMTimeLineView : UIView

@property (assign, nonatomic) NSTimeInterval totalTime;
@property (assign, nonatomic) NSTimeInterval stepTime;

@property (strong, nonatomic) UIColor* colorFrame;
@property (strong, nonatomic) NSArray <UIColor*>* gradientColors;
@property (assign, nonatomic) BOOL hidesWhenStopped;

- (instancetype)initWithFrame:(CGRect)frame totalTime:(NSTimeInterval)totalTime stepTime:(NSTimeInterval)stepTime;

- (void) startTime;
- (void) stopTime;

@property (weak, nonatomic) id <AMTimeLineViewDelegate> delegate;

@end


@protocol AMTimeLineViewDelegate <NSObject>

@optional

- (void) didPassedTime:(NSTimeInterval)timeInterval;
- (void) didEndedTime;

@end

