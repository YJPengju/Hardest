//
//  WNXGameControllerViewManager.m
//  Hardest
//
//  Created by sfbest on 16/3/2.
//  Copyright © 2016年 维尼的小熊. All rights reserved.
//

#import "WNXGameControllerViewManager.h"
#import "WNXRYBViewController.h"
#import "WNXStage01ViewController.h"
#import "WNXStage02ViewController.h"
#import "WNXStage03ViewController.h"

@implementation WNXGameControllerViewManager

+ (WNXBaseGameViewController *)viewControllerWithStage:(WNXStage *)stage {
    WNXBaseGameViewController *gameVC;
    
    switch (stage.num) {
        case 1:
            gameVC = [[WNXStage01ViewController alloc] init];
            gameVC.stage = stage;
            gameVC.guideType = WNXGameGuideTypeOneFingerClick;
            gameVC.scoreboardType = WNXScoreboardTypeCountPTS;
            break;
        case 2:
            gameVC = [[WNXStage02ViewController alloc] init];
            gameVC.stage = stage;
            gameVC.guideType = WNXGameGuideTypeOneFingerClick;
            gameVC.scoreboardType = WNXScoreboardTypeTimeMS;
            break;
        case 3:
            gameVC = [[WNXStage03ViewController alloc] init];
            gameVC.stage = stage;
            gameVC.guideType = WNXGameGuideTypeReplaceClick;
            gameVC.scoreboardType = WNXScoreboardTypeSecondAndMS;
            break;
        default:
            break;
    }
        
    return gameVC;
}

@end