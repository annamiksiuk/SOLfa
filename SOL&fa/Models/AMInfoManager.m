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

@interface AMInfoManager()

@property (assign, nonatomic) NSTimeInterval bestTime;
@property (assign, nonatomic) NSInteger bestScore;

@end

@implementation AMInfoManager

- (void) setLastTime:(NSTimeInterval)lastTime {
    
    _lastTime = lastTime;
    
    if (lastTime < self.bestTime) {
        
        self.bestTime = lastTime;
        
    }
        
}

- (void) setLastScore:(NSInteger)lastScore {

    _lastScore = lastScore;
    
    if (lastScore > self.bestScore) {
        
        self.bestScore = lastScore;
        
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
    
}

- (NSTimeInterval) valueBestTime {
    
    return self.bestTime;
    
}

- (NSInteger) valueBestScore {
    
    return self.bestScore;
    
}

@end
