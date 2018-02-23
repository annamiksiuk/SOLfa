//
//  AMInfoManager.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 15.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMInfoManager.h"

static NSString* kLastTime = @"kLastTime";
static NSString* kLastScore = @"kLastScore";
static NSString* kBestTime = @"kBestTime";
static NSString* kBestScore = @"kBestScore";
static NSString* kSound = @"kSound";

@interface AMInfoManager()

@property (assign, nonatomic) NSTimeInterval bestTime;
@property (assign, nonatomic) NSInteger bestScore;

@end

@implementation AMInfoManager

- (void) setLastTime:(NSTimeInterval)lastTime {
    
    _lastTime = lastTime;
    
    [self checkTheBestTime:lastTime andScore:self.lastScore];
        
}

- (void) setLastScore:(NSInteger)lastScore {

    _lastScore = lastScore;
    
    [self checkTheBestTime:self.lastTime andScore:lastScore];
    
}

- (void) setSound:(BOOL)sound {
    
    _sound = sound;
    
    [self saveInfo];
    
}

- (void) checkTheBestTime:(NSTimeInterval)time andScore:(NSInteger)score {
    
    if (time <= self.bestTime && score >=self.bestScore) {
        
        self.bestTime = time;
        self.bestScore = score;
        
    }
    
}

+ (AMInfoManager*) sharedManager {
    
    static AMInfoManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMInfoManager alloc] init];
    });
    
    return manager;
    
}

- (void) saveInfo {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:self.lastTime forKey:kLastTime];
    [userDefaults setInteger:self.lastScore forKey:kLastScore];
    
    [userDefaults setDouble:self.bestTime forKey:kBestTime];
    [userDefaults setInteger:self.bestScore forKey:kBestScore];
    
    [userDefaults setBool:self.sound forKey:kSound];
    
    [userDefaults synchronize];
    
}

- (void) loadInfo {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.lastTime = [userDefaults doubleForKey:kLastTime];
    self.lastScore = [userDefaults integerForKey:kLastScore];
    
    self.bestTime = [userDefaults doubleForKey:kBestTime];
    self.bestScore = [userDefaults integerForKey:kBestScore];
    
    if (self.bestTime == 0) {
        self.bestTime = 500;
    }
    
    self.sound = [userDefaults boolForKey:kSound];
    
}

- (NSTimeInterval) valueBestTime {
    
    return self.bestTime;
    
}

- (NSInteger) valueBestScore {
    
    return self.bestScore;
    
}

@end
