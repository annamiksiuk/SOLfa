//
//  AMMainViewController.m
//  SOL&fa
//
//  Created by Admin on 17.01.18.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMMainViewController.h"
#import "Global.h"
#import "AMAnswerView.h"
#import "AMSheetButton.h"
#import "AMStaffView.h"
#import "AMNote.h"
#import "AMNoteGame.h"
#import "AMTimeLineView.h"
#import "AMInfoManager.h"
#import <AVKit/AVKit.h>

@interface AMMainViewController () <AMAnswerViewDelegate, AMTimeLineViewDelegate>

@property (strong, nonatomic) UILabel* lastTimeLabel;
@property (strong, nonatomic) UILabel* lastScoreLabel;
@property (strong, nonatomic) UILabel* bestTimeLabel;
@property (strong, nonatomic) UILabel* bestScoreLabel;

@property (strong, nonatomic) AMSheetButton* currentSheet;
@property (strong, nonatomic) NSMutableArray<AMSheetButton*>* nextSheets;

@property (strong, nonatomic) AMSheetButton* noteOctaveButton;
@property (strong, nonatomic) AMSheetButton* noteNameButton;
@property (strong, nonatomic) AMSheetButton* noteDurationButton;

@property (strong, nonatomic) AMTimeLineView* timeLine;

@property (strong, nonatomic) AMNote* answerNote;
@property (strong, nonatomic) AMNoteGame* game;
@property (assign, nonatomic) NSTimeInterval timeOfGame;
@property (strong, nonatomic) UIView* helperView;

@property (strong, nonatomic) AMSheetButton* soundButton;
@property (strong, nonatomic) AVAudioPlayer* backgroundPlayer;

@end

@implementation AMMainViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView* statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = BASE_PALETTE_COLOR5;

    }
    
    //----------- Add background
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setFrame:self.view.frame];
    imageView.autoresizingMask =    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];
    
    CGFloat side = MAX(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    CGRect frameEffect = self.view.bounds;
    frameEffect.size.width = side;
    frameEffect.size.height = side;
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = frameEffect;
    [self.view addSubview:visualEffectView];
    
    //------ Add gestures for view
    UISwipeGestureRecognizer* upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:upSwipeGesture];
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    //------- Create sheets
    self.currentSheet = nil;
    self.nextSheets = [NSMutableArray array];
    
    [self createSheets];
    
    //--------- Create info
    
    [self createInfoScreen];
    [[AMInfoManager sharedManager] loadInfo];
    [self updateInfo];
    [self animateShowInfo];
    
    //--------- Create info question
    
    [self createQuestionScreen];
    
    //--------- Create line of time
    
    [self createTimeLine];
    
    //---------- Game
    
    self.game = [[AMNoteGame alloc] initWithCountQuestion:COUNT_QUESTION];
    self.timeOfGame = 0;
    
    //---------- Sound
    
    [self createBackgroundPlayer];
    
}

- (void) viewWillLayoutSubviews {
    
    [self changeOrientationSheetsForSize:self.view.frame.size];
    [self changeOrientationQuestionForSize:self.view.frame.size];
    [self changeOrientationTimeLineForSize:self.view.frame.size];
    
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (self.currentSheet) {
        
        self.currentSheet.frame = [self calculateFrameCurrentSheetForSize:size];
    }
    
}

#pragma mark - Created UI

- (void) createSheets {
    
    NSArray* arrayColors = [NSArray arrayWithObjects:   BASE_PALETTE_COLOR1,    BASE_PALETTE_COLOR2,
                                                        BASE_PALETTE_COLOR3,    BASE_PALETTE_COLOR4,
                                                        BASE_PALETTE_COLOR5, nil];
    
    for (NSInteger indexSheet = 0; indexSheet < COUNT_QUESTION; indexSheet++) {
        
        UIColor* backgroundColor = [arrayColors objectAtIndex:indexSheet % [arrayColors count]];
        AMSheetButton* sheet = [self createSheetButtonWithFrame:CGRectZero backgroundColor:backgroundColor];
        [self.nextSheets addObject:sheet];
        if (self.lastTimeLabel) {
            
            [self.view insertSubview:sheet belowSubview:self.lastTimeLabel];
        } else {
            
            [self.view addSubview:sheet];
        }
        
    }
    
}

- (void) createBackgroundPlayer {
    
    NSData* audioData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BackgroundSound" ofType:@"mp3"]];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    audioPlayer.numberOfLoops = -1;
    
    if ([AMInfoManager sharedManager].sound) {
        [audioPlayer play];
    }
    
    self.backgroundPlayer = audioPlayer;
    
}

- (UILabel*) createLabelWithFrame:(CGRect)frame {
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:frame];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.font = [UIFont fontWithName:BASE_FONT_NAME size:BASE_FONT_SIZE];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = BASE_PALETTE_COLOR5;
    infoLabel.autoresizingMask =    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return infoLabel;
    
}

- (void) createInfoScreen {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat stepY = 0.1f * height;
    
    CGRect frame = CGRectMake(width * 0.1f, height / 2 - 2 * stepY, width * 0.7f, height * 0.1f);
    
    UILabel *lastTimeLabel = [self createLabelWithFrame:frame];
    lastTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.lastTimeLabel = lastTimeLabel;
    [self.view addSubview:lastTimeLabel];
    
    frame.origin.y += stepY / 2;
    
    UILabel *lastScoreLabel = [self createLabelWithFrame:frame];
    lastScoreLabel.textAlignment = NSTextAlignmentRight;
    self.lastScoreLabel = lastScoreLabel;
    [self.view addSubview:lastScoreLabel];
    
    frame.origin.y += stepY;
    
    UILabel *bestTimeLabel = [self createLabelWithFrame:frame];
    bestTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.bestTimeLabel = bestTimeLabel;
    [self.view addSubview:bestTimeLabel];
    
    frame.origin.y += stepY / 2;
    
    UILabel *bestScoreLabel = [self createLabelWithFrame:frame];
    bestScoreLabel.textAlignment = NSTextAlignmentRight;
    self.bestScoreLabel = bestScoreLabel;
    [self.view addSubview:bestScoreLabel];

    self.lastTimeLabel.alpha = 0.f;
    self.lastScoreLabel.alpha = 0.f;
    self.bestTimeLabel.alpha = 0.f;
    self.bestScoreLabel.alpha = 0.f;
    
}

- (AMSheetButton*) createSheetButtonWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor {
    
    AMSheetButton* sheetButton = [[AMSheetButton alloc] initWithFrame:frame];
    sheetButton.backgroundColor = backgroundColor;
    return sheetButton;
    
}

- (void) createQuestionScreen {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat topArea = fabs((height - width) / 2.f) - HEIGHT_STATUS_BAR;
    
    if (iPad) {
        topArea *= 1.3f;
    }
    
    CGFloat side = MIN(topArea * 0.75f, MIN(width, height) * 0.2f);
    
    if (iPad) {
        
        side = MIN(topArea, MIN(width, height) * 0.2f);
        
    }
    
    CGRect frame = CGRectMake(0, 0, side, side);
    
    UIView* helperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(width, height) * 0.8f, side * 1.2f)];
    helperView.backgroundColor = [UIColor clearColor];
    helperView.layer.cornerRadius = CORNER_RADIUS;
    helperView.alpha = 0.f;
    [self.view addSubview:helperView];
    self.helperView = helperView;
    
    AMSheetButton* noteOctaveButton = [self createSheetButtonWithFrame:frame backgroundColor:BASE_PALETTE_COLOR1];
    noteOctaveButton.titleLabel.font = [UIFont fontWithName:BASE_FONT_NAME size:BASE_FONT_SIZE - 5];
    [self.view addSubview:noteOctaveButton];
    self.noteOctaveButton = noteOctaveButton;
    
    AMSheetButton* noteNameButton = [self createSheetButtonWithFrame:frame backgroundColor:BASE_PALETTE_COLOR2];
    [self.view addSubview:noteNameButton];
    self.noteNameButton = noteNameButton;
    
    AMSheetButton* noteDurationButton = [self createSheetButtonWithFrame:frame backgroundColor:BASE_PALETTE_COLOR3];
    [self.view addSubview:noteDurationButton];
    self.noteDurationButton = noteDurationButton;
    
    if (iPhone) {
        frame.size.width /= 2.f;
        frame.size.height /= 2.f;
    }
    
    AMSheetButton* soundButton = [self createSheetButtonWithFrame:frame backgroundColor:[UIColor clearColor]];
    soundButton.layer.shadowColor = [UIColor clearColor].CGColor;
    soundButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([AMInfoManager sharedManager].sound) {
        [soundButton setImage:[UIImage imageNamed:@"SoundOn"] forState:UIControlStateNormal];
    } else {
        [soundButton setImage:[UIImage imageNamed:@"SoundOff"] forState:UIControlStateNormal];
    }
    [soundButton addTarget:self
                    action:@selector(actionSound:)
          forControlEvents:UIControlEventTouchUpInside];
    self.soundButton = soundButton;
    [self.view addSubview:soundButton];
    
    [self animateHideQuestion];
    
}

- (AMAnswerView*) createAnswerViewForSheet:(AMSheetButton*)sheet {
    
    CGRect frame = sheet.bounds;
    frame.origin.x += frame.size.width * (100 - PERCENT_QUESTION_VIEW) / 100.f / 2.f;
    frame.origin.y += frame.size.height * (100 - PERCENT_QUESTION_VIEW) / 100.f / 2.f;
    frame.size.width *= PERCENT_QUESTION_VIEW / 100.f;
    frame.size.height *= PERCENT_QUESTION_VIEW / 100.f;
    
    AMAnswerView* answerView = [[AMAnswerView alloc] initWithFrame:frame];
    answerView.autoresizingMask =   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    answerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    answerView.alpha = 0.f;
    
    return answerView;
    
}

- (void) createTimeLine {

    AMTimeLineView* timeLine = [[AMTimeLineView alloc] initWithFrame:CGRectZero
                                                           totalTime:SECOND_FOR_ANSWER
                                                            stepTime:BASE_TIME_INTERVAL];
    
    timeLine.gradientColors = [NSArray arrayWithObjects: BASE_PALETTE_COLOR3, BASE_PALETTE_COLOR1, BASE_PALETTE_COLOR4, nil];
    timeLine.colorFrame = BASE_PALETTE_COLOR5;
    timeLine.delegate = self;
    timeLine.hidesWhenStopped = YES;
    [self.view addSubview:timeLine];
    self.timeLine = timeLine;
    
}

- (void) updateInfo {
   
    
    self.lastTimeLabel.text = [NSString stringWithFormat:@"%@:",
                               NSLocalizedString(@"Last", "")];
    
    self.lastScoreLabel.text = [NSString stringWithFormat:@"%ld/%d %@ %.1f %@",
                                [AMInfoManager sharedManager].lastScore, COUNT_QUESTION,
                                NSLocalizedString(@"In", ""),
                                [AMInfoManager sharedManager].lastTime,
                                NSLocalizedString(@"Second", "")];
    
    self.bestTimeLabel.text = [NSString stringWithFormat:@"%@:",
                               NSLocalizedString(@"Best", "")];
    
    self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld/%d %@ %.1f %@",
                               [AMInfoManager sharedManager].valueBestScore, COUNT_QUESTION,
                               NSLocalizedString(@"In", ""),
                               [AMInfoManager sharedManager].valueBestTime,
                               NSLocalizedString(@"Second", "")];
    
}

- (void) updateQuestion {
    
    
    [self.noteOctaveButton setTitle:[[self.game getQuestionNote] nameOctave]
                           forState:UIControlStateNormal];
    
    [self.noteNameButton setTitle:[[self.game getQuestionNote] nameNote]
                         forState:UIControlStateNormal];
    
    [self.noteDurationButton setTitle:[[self.game getQuestionNote] nameDuration]
                             forState:UIControlStateNormal];
    
}

#pragma mark - AMAnswerViewDelegate

- (void) didSelectNote:(AMNote*)note {
    
    self.answerNote = note;
    
}

#pragma mark - AMTimeLineViewDelegate

- (void) didPassedTime:(NSTimeInterval)timeInterval {
    
    if ([self.game checkAnswerNote:self.answerNote]) {
        
        self.timeOfGame += timeInterval;
        [self animateRightAnswer];
        
    } else {
        
        self.timeOfGame += SECOND_FOR_ANSWER;
        [self animateWrongAnswer];
        
    }
    
    self.answerNote = nil;
    
}

- (void) didEndedTime {
    
    self.timeOfGame += SECOND_FOR_ANSWER;
    [self animateWrongAnswer];
    self.answerNote = nil;
    [self.game breakQuestion];
    [self moveSheet];
    
}

#pragma mark - Gestures

- (void) handleUpSwipe:(UISwipeGestureRecognizer*)sender {
    
    if (CGRectGetWidth(self.view.frame) > CGRectGetHeight(self.view.frame)) {
        return;
    }
    
    [self moveSheet];
    
}

- (void) handleLeftSwipe:(UISwipeGestureRecognizer*)sender {
    
    if (CGRectGetWidth(self.view.frame) < CGRectGetHeight(self.view.frame)) {
        return;
    }
    
    [self moveSheet];
    
}

#pragma mark - Actions

- (void) actionSound:(AMSheetButton*)sender {
    
    [AMInfoManager sharedManager].sound = ![AMInfoManager sharedManager].sound;
    
    if ([AMInfoManager sharedManager].sound) {
        
        [self.soundButton setImage:[UIImage imageNamed:@"SoundOn"] forState:UIControlStateNormal];
        [self.backgroundPlayer play];
        
    } else {
        
        [self.soundButton setImage:[UIImage imageNamed:@"SoundOff"] forState:UIControlStateNormal];
        [self.backgroundPlayer stop];
    }
    
}

#pragma mark - Animations

- (void) animateShowQuestion {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.noteDurationButton.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                         weakSelf.noteNameButton.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                         weakSelf.noteOctaveButton.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                     }
                     completion:^(BOOL finished) {
                         [weakSelf updateQuestion];
                         [UIView animateWithDuration:0.3f
                                          animations:^{
                                              weakSelf.noteDurationButton.transform = CGAffineTransformIdentity;
                                              weakSelf.noteNameButton.transform = CGAffineTransformIdentity;
                                              weakSelf.noteOctaveButton.transform = CGAffineTransformIdentity;
                                          }
                                          completion:nil];
                         
                     }];
}

- (void) animateHideQuestion {
    
    self.noteDurationButton.transform = CGAffineTransformMakeScale(0.f, 0.f);
    self.noteNameButton.transform = CGAffineTransformMakeScale(0.f, 0.f);
    self.noteOctaveButton.transform = CGAffineTransformMakeScale(0.f, 0.f);
    
}

- (void) animateShowSheetsForSize:(CGSize)size {
    
    if (size.width < size.height) {
        
        [self animateVerticalSheetsForSize:size];
        
    } else {
        
        [self animateHorizontalSheetsForSize:size];
        
    }
    
}

- (void) animateVerticalSheetsForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat widthSheet = width;
    CGFloat heightSheet = height * PERCENT_BOTTOM_AREA / 100;
    CGFloat stepOffsetX = widthSheet * 0.1f / COUNT_QUESTION / 2;
    
    for (AMSheetButton* sheet in self.nextSheets) {
        
        NSInteger indexSheet = [self.nextSheets indexOfObject:sheet];
        
        CGFloat stepOffsetY = heightSheet / 4.f;
        CGFloat offsetSheetX = (COUNT_QUESTION - indexSheet) * stepOffsetX;
        
        CGRect frame = CGRectMake(offsetSheetX, height - heightSheet + stepOffsetY, widthSheet - offsetSheetX * 2, heightSheet);
        
        __weak typeof(sheet) weakSheet = sheet;
        [UIView animateWithDuration:0.7f
                              delay:0.1 * indexSheet
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [weakSheet setFrame:frame];
                             
                         }
                         completion:nil];
        
        heightSheet -= stepOffsetY;
    }
    
}

- (void) animateHorizontalSheetsForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat widthSheet = width * PERCENT_BOTTOM_AREA / 100;
    CGFloat heightSheet = height;
    CGFloat stepOffsetY = heightSheet * 0.1f / COUNT_QUESTION / 2;
    
    for (AMSheetButton* sheet in self.nextSheets) {
        
        NSInteger indexSheet = [self.nextSheets indexOfObject:sheet];
        
        CGFloat offsetSheetY = (COUNT_QUESTION - indexSheet) * stepOffsetY;
        CGFloat offsetSheetX = widthSheet / 4.f;
        
        CGRect frame = CGRectMake(width - widthSheet + offsetSheetX, offsetSheetY, widthSheet, heightSheet - offsetSheetY * 2);
        
        __weak typeof(sheet) weakSheet = sheet;
        [UIView animateWithDuration:0.7f
                              delay:0.1 * indexSheet
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [weakSheet setFrame:frame];
                             
                         }
                         completion:nil];
        
        widthSheet -= offsetSheetX;
    }
    
}
- (void) animateMoveSheetToCurrent:(AMSheetButton*)sheet {
    
    CGRect newFrame = [self calculateFrameCurrentSheetForSize:self.view.frame.size];
    
    __weak typeof(sheet) weakSheet = sheet;

    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         weakSheet.frame = newFrame;
                         
                     }
                     completion:nil];
    

    AMAnswerView* answerView = [self createAnswerViewForSheet:sheet];
    answerView.delegate = self;
    [sheet addSubview:answerView];
 
    [self animateShowAnswerView:answerView];
    
    [self.timeLine startTime];
    
}

- (void) animateShowAnswerView:(AMAnswerView*)answerView {
    
    __weak typeof(answerView) weakAnswerView = answerView;
    [UIView animateWithDuration:0.3f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakAnswerView.alpha = 1.f;
                     }
                     completion:nil];
    
}

- (void) animateHideAnswerView:(AMAnswerView*)answerView {
    
    __weak typeof(answerView) weakAnswerView = answerView;
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         
                         weakAnswerView.alpha = 0.f;
                         
                     }];
}

- (void) animateMoveSheetToPrevios:(AMSheetButton*)sheet {
    
    CGRect frame = sheet.frame;
    if (CGRectGetWidth(self.view.frame) < CGRectGetHeight(self.view.frame)) {
        
        frame.origin.x = arc4random_uniform(CGRectGetWidth(self.view.frame));
        frame.origin.y -= CGRectGetHeight(self.view.frame) / 2;
    } else {
        
        frame.origin.x -= CGRectGetWidth(self.view.frame) / 2;
        frame.origin.y = arc4random_uniform(CGRectGetHeight(self.view.frame));
    }
    
    frame.size.width /= 20;
    frame.size.height /= 30;
    
    for (UIView* subview in sheet.subviews) {
        if ([subview isKindOfClass:[AMAnswerView class]]) {
            
            [self animateHideAnswerView:(AMAnswerView*)subview];
        }
    }
    
    __weak typeof(sheet) weakSheet = sheet;
    
    [UIView animateWithDuration:1.5f
                     animations:^{
                         
                         weakSheet.frame = frame;
                         weakSheet.backgroundColor = [self decreaseColorSaturation:weakSheet.backgroundColor];
                         
                     }];
    
}

- (void) animateShowInfo {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:1.5f
                          delay:1.f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.lastTimeLabel.alpha = 1.f;
                         weakSelf.lastScoreLabel.alpha = 1.f;
                         weakSelf.bestTimeLabel.alpha = 1.f;
                         weakSelf.bestScoreLabel.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         if ([weakSelf.nextSheets count] == 0) {
                             [weakSelf createSheets];
                         }
                     }];
    
}

- (void) animateHideInfo {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         weakSelf.lastTimeLabel.alpha = 0.f;
                         weakSelf.lastScoreLabel.alpha = 0.f;
                         weakSelf.bestTimeLabel.alpha = 0.f;
                         weakSelf.bestScoreLabel.alpha = 0.f;
                         
                     }
                     completion:nil];
    
}

- (void) animateRightAnswer {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.helperView.backgroundColor = BASE_PALETTE_COLOR4;
                         weakSelf.helperView.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2f
                                          animations:^{
                                              weakSelf.helperView.alpha = 0.f;
                                          }];
                         
                     }];
    
}

- (void) animateWrongAnswer {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.helperView.backgroundColor = BASE_PALETTE_COLOR3;
                         weakSelf.helperView.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2f
                                          animations:^{
                                              weakSelf.helperView.alpha = 0.f;
                                          }];
                     }];
    
}

#pragma mark - Own Methods

- (CGPoint) calculateCenterFreeAreaForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    return CGPointMake(width / 2, height / 2);
    
}

- (CGSize) calculateSizeFreeAreaForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    return CGSizeMake(MIN(width, height), MIN(width, height));
}

- (CGSize) calculateSizeFullSheetForSize:(CGSize)size {
    
    CGSize sizeFreeArea = [self calculateSizeFreeAreaForSize:size];
    
    return CGSizeMake(sizeFreeArea.width * PERCENT_QUESTION_SHEET / 100.f, sizeFreeArea.height * PERCENT_QUESTION_SHEET / 100.f);
}

- (CGRect) calculateFrameCurrentSheetForSize:(CGSize)size {
    
    CGSize sizeSheet = [self calculateSizeFullSheetForSize:size];
    CGPoint centerSheet = [self calculateCenterFreeAreaForSize:size];
    
    return CGRectMake(centerSheet.x - sizeSheet.width / 2, centerSheet.y - sizeSheet.height / 2, sizeSheet.width, sizeSheet.height);
    
}

- (void) changeOrientationSheetsForSize:(CGSize)size {
    
    if (size.width < size.height) {
        
        for (AMSheetButton* sheet in self.nextSheets) {
            
            sheet.transform = CGAffineTransformMakeTranslation(0, size.height);
        }
        
        [self animateVerticalSheetsForSize:size];
        
    } else {
        
        for (AMSheetButton* sheet in self.nextSheets) {
            
            sheet.transform = CGAffineTransformMakeTranslation(size.width, 0);
        }
        
        [self animateHorizontalSheetsForSize:size];
        
    }
    
    [self.currentSheet setNeedsDisplay];
}

- (void) changeOrientationQuestionForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat topArea = fabs((height - width) / 2.f) - HEIGHT_STATUS_BAR;
    
    if (iPad) {
        topArea *= 1.3f;
    }
    
    CGFloat side = MIN(topArea * 0.75f, MIN(width, height) * 0.2f);
    
    if (iPad) {
        
        side = MIN(topArea, MIN(width, height) * 0.2f);
        
    }
    
    CGFloat offset = topArea * 0.75f / 2.f + HEIGHT_STATUS_BAR;
    
    if (size.width < size.height) {
        
        self.noteOctaveButton.center = CGPointMake(width / 4, offset);
        CGFloat offsetX = width / 4;
        self.noteNameButton.center = CGPointMake(width / 4 + offsetX, offset);
        self.helperView.frame = CGRectMake(0, 0, MIN(width, height) * 0.8f, side * 1.2f);
        offsetX += width / 4;
        self.noteDurationButton.center = CGPointMake(width / 4 + offsetX, offset);
        offsetX += width / 5;
        self.soundButton.center = CGPointMake(width / 4 + offsetX, offset);
    } else {
        
        self.noteOctaveButton.center = CGPointMake(offset, height / 4);
        CGFloat offsetY = height / 4;
        self.noteNameButton.center = CGPointMake(offset, height / 4 + offsetY);
        self.helperView.frame = CGRectMake(0, 0, side * 1.2f, MIN(width, height) * 0.8f);
        offsetY += height / 4;
        self.noteDurationButton.center = CGPointMake(offset, height / 4 + offsetY);
        offsetY += height / 5;
        self.soundButton.center = CGPointMake(offset, height / 4 + offsetY);
        
    }
    
    self.helperView.center = self.noteNameButton.center;
}

- (void) changeOrientationTimeLineForSize:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat topArea = fabs((height - width) / 2.f) - HEIGHT_STATUS_BAR;
    
    if (iPad) {
        topArea *= 1.4f;
    }
    
    CGFloat widthTimeLine =  (width < height) ? PERCENT_QUESTION_SHEET / 100.f * width : topArea * 0.2f;
    CGFloat heightTimeLine = (width < height) ? topArea * 0.2f : PERCENT_QUESTION_SHEET / 100.f * height;
    
    CGRect frame = CGRectMake(0, 0, widthTimeLine, heightTimeLine);
    self.timeLine.frame = frame;
    
    if (size.width < size.height) {
        
        self.timeLine.center = CGPointMake(width / 2, topArea + HEIGHT_STATUS_BAR);
        
    } else {
        
        self.timeLine.center = CGPointMake(topArea + HEIGHT_STATUS_BAR, height / 2);
        
    }
    
}

- (void) moveSheet {
    
    if ([self.game isStarted] && [self.game getQuestionNote] && !self.answerNote) {
        
        return;
        
    }
    
    [self.timeLine stopTime];
    
    if (!self.currentSheet && [self.nextSheets count] > 0) {
        
        [self animateHideInfo];
        
    }
    
    if (self.currentSheet) {
        
        [self animateMoveSheetToPrevios:self.currentSheet];
        self.currentSheet = nil;
        
        if ([self.nextSheets count] == 0) {
            
            [self.game stopGame];
            
            [self saveResults];
            
            [self updateInfo];
            
            [self animateHideQuestion];
            [self animateShowInfo];
            
        }
        
    }
    
    if ([self.nextSheets count] == COUNT_QUESTION) {
        
        [self.game startGame];
    }
    
    if ([self.nextSheets count] > 0) {
        
        AMSheetButton* sheet = [self.nextSheets firstObject];
        [self animateMoveSheetToCurrent:sheet];
        [self.nextSheets removeObject:sheet];
        self.currentSheet = sheet;
        
        [self.game newQuestion];
        [self animateShowQuestion];
        
    }
    
    [self animateShowSheetsForSize:self.view.frame.size];
    
}

- (void) saveResults {
    
    [AMInfoManager sharedManager].lastTime = self.timeOfGame;
    [AMInfoManager sharedManager].lastScore = [self.game getCorrectAnswer];
    [[AMInfoManager sharedManager] saveInfo];
    self.timeOfGame = 0;
    
}

- (UIColor*) decreaseColorSaturation:(UIColor*)color {
    
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    saturation /= 3;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.f];
    
}

@end
