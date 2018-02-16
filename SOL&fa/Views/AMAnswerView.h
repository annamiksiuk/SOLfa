//
//  AMAnswerView.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 29.01.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMStaffView;
@class AMNoteImageView;
@class AMNote;

@protocol AMAnswerViewDelegate;

@interface AMAnswerView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <AMAnswerViewDelegate> delegate;

@end

@protocol AMAnswerViewDelegate <NSObject>

@optional

- (void) didSelectNote:(AMNote*)note;

@end
