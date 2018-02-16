//
//  AMTimeLineView.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 14.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMTimeLineView.h"
#import "Global.h"

@interface AMTimeLineView()
    
@property (strong, nonatomic) UIView* timeView;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) BOOL isOnTimer;
@property (assign, nonatomic) NSTimeInterval currentTime;

@end

@implementation AMTimeLineView

- (void) setHidesWhenStopped:(BOOL)hidesWhenStopped {
    
    _hidesWhenStopped = hidesWhenStopped;
    
    if (!hidesWhenStopped) {
        
        self.alpha = 1.f;
        
    } else {
        
        self.alpha = 0.f;
    }
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    for (CALayer* layer in self.timeView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    self.timeView = nil;
    
    [self createTimeView];
    
}

- (void) setColorFrame:(UIColor *)colorFrame {
    
    _colorFrame = colorFrame;
    
    self.layer.borderColor = self.colorFrame.CGColor;
    
}

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.colorFrame = [UIColor greenColor];
        
        self.layer.borderWidth = 1.5f;
        self.layer.cornerRadius = CORNER_RADIUS / 3.f;
        self.layer.masksToBounds = YES;
        
        self.isOnTimer = NO;
        self.currentTime = 0;
        self.hidesWhenStopped = NO;
        
        self.totalTime = 30.f;
        self.stepTime = 1.f;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stepTime
                                                      target:self
                                                    selector:@selector(decreaseTime:)
                                                    userInfo:0
                                                     repeats:YES];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame totalTime:(NSTimeInterval)totalTime stepTime:(NSTimeInterval)stepTime {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.colorFrame = [UIColor greenColor];
        
        self.layer.borderWidth = 1.5f;
        self.layer.cornerRadius = CORNER_RADIUS / 3.f;
        self.layer.masksToBounds = YES;

        self.isOnTimer = NO;
        self.currentTime = 0;
        self.hidesWhenStopped = NO;
        self.totalTime = totalTime;
        self.stepTime = stepTime;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:stepTime
                                                      target:self
                                                    selector:@selector(decreaseTime:)
                                                    userInfo:0
                                                     repeats:YES];
    }
    return self;
}

#pragma mark - Time

- (void) decreaseTime:(NSTimer*)timer {
    
    if (self.isOnTimer) {
        
        self.currentTime -= self.stepTime;
        
        [self animateDecreaseTime];
        
        if (self.currentTime <= 0) {
            
            [self stopTime];
            
        }
        
    }
    
}

- (void) startTime {
    
    self.isOnTimer = YES;
    self.currentTime = self.totalTime;
    
    if (self.hidesWhenStopped) {
        
        [self animateShow];
        
    }
    
}

- (void) stopTime {
    
    if (!self.isOnTimer) {
        return;
    }
    
    self.isOnTimer = NO;
    
    if (self.hidesWhenStopped) {
        
        [self animateHide];
        
    }
    
    if (self.currentTime <= 0) {
        
        if ([self.delegate respondsToSelector:@selector(didEndedTime)]) {
            
            [self.delegate didEndedTime];
            
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(didPassedTime:)]) {
            
            [self.delegate didPassedTime:self.totalTime - self.currentTime];
            
        }
        
    }
    
}

#pragma mark - Animations

- (void) animateDecreaseTime {
    
    for (CALayer* layer in self.timeView.layer.sublayers) {
        
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            
            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat height = CGRectGetHeight(self.frame);
            
            CGRect frameTimeView = self.timeView.frame;
            
            if (width > height) {
                
                CGFloat decreaseWidth = width * self.stepTime / self.totalTime;
                
                frameTimeView.size.width -= decreaseWidth;
                
            } else {
                
                CGFloat decreaseHeight = height * self.stepTime / self.totalTime;
                frameTimeView.origin.y += decreaseHeight;
                frameTimeView.size.height -= decreaseHeight;
                
            }
            
            self.timeView.frame = frameTimeView;
        }
        
    }
   
}

- (void) animateShow {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         weakSelf.alpha = 1.f;
                         
                     }];
    
}

- (void) animateHide {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         weakSelf.alpha = 0.f;
                         
                     }];
        
}

#pragma mark - Own methods

- (void) createTimeView {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect frame = (width > height) ?   CGRectMake(0, 0, width * 0.97f, height * 0.6f) :
                                        CGRectMake(0, 0, width * 0.6f, height * 0.97f);
        
    UIView* timeView = [[UIView alloc] initWithFrame:frame];
    timeView.center = CGPointMake(width / 2, height / 2);
    timeView.alpha = 0.7f;
    timeView.layer.cornerRadius = CORNER_RADIUS / 4.f;
    timeView.layer.masksToBounds = YES;
    timeView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    NSMutableArray* colors = [NSMutableArray array];

    for (UIColor* color in self.gradientColors) {
        [colors addObject:(id)color.CGColor];
    }

    gradientLayer.colors = colors;
    gradientLayer.frame = timeView.bounds;

    if (width > height) {
        gradientLayer.startPoint = CGPointMake(0.f, 0.5f);
        gradientLayer.endPoint = CGPointMake(1.f, 0.5f);
    } else {
        gradientLayer.startPoint = CGPointMake(0.5f, 0.f);
        gradientLayer.endPoint = CGPointMake(0.5f, 1.f);
    }

    [timeView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self addSubview:timeView];
    
    self.timeView = timeView;
    
    if (self.isOnTimer) {
        
        frame = self.timeView.frame;
        
        if (width > height) {
            
            frame.size.width = self.currentTime / self.totalTime * width * 0.97f;
            
        } else {
            
            frame.origin.y += height * 0.97f - self.currentTime / self.totalTime * height;
            frame.size.height = self.currentTime / self.totalTime * height;
            
        }
        self.timeView.frame = frame;
        
    }

}

@end
