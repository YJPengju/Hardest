//
//  WNXStage06ViewController.m
//  Hardest
//
//  Created by sfbest on 16/4/5.
//  Copyright © 2016年 维尼的小熊. All rights reserved.
//

#import "WNXStage06ViewController.h"
#import "WNXStage06PeolpeView.h"
#import "WNXTimeCountView.h"
#import "WNXStateView.h"

@interface WNXStage06ViewController ()

@property (nonatomic, strong) WNXStage06PeolpeView *peopleView;
@property (nonatomic, strong) WNXStateView *stateView;

@end

@implementation WNXStage06ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildStageInfo];
}

- (void)buildStageInfo {
    self.backgroundIV.image = [UIImage imageNamed:@"19_bg-iphone4"];
    [self.leftButton setImage:[UIImage imageNamed:@"19_slap-iphone4"] forState:UIControlStateNormal];
    self.leftButton.contentEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    
    [self.rightButton setImage:[UIImage imageNamed:@"19_done-iphone4"] forState:UIControlStateNormal];
    [self.rightButton setContentEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    [self.rightButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchDown];
    
    self.peopleView = [WNXStage06PeolpeView viewFromNib];
    self.peopleView.frame = CGRectMake(0, ScreenHeight - self.leftButton.frame.size.height - self.peopleView.frame.size.height, self.peopleView.frame.size.width, self.peopleView.frame.size.height);
    [self.view insertSubview:self.peopleView belowSubview:self.leftButton];
    if (self.guideImageView) {
        [self.view bringSubviewToFront:self.guideImageView];
    }
    __weak typeof(self) weakSelf = self;
    self.peopleView.failBlock = ^{
        [weakSelf fail];
    };
}

#pragma mark Super Method
- (void)readyGoAnimationFinish {
    [super readyGoAnimationFinish];
    [self showScreamImageView];
    self.view.userInteractionEnabled = NO;
}

- (void)playAgainGame {
    [(WNXTimeCountView *)self.countScore cleadData];
    [self.peopleView cleanData];
    [super playAgainGame];
}

#pragma mark Private Method
- (void)showScreamImageView {
    UIImageView *screamIV = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -50, ScreenWidth + 40, ScreenHeight + 100)];
    screamIV.image = [UIImage imageNamed:@"19_beforegame-iphone4"];
    [self.view addSubview:screamIV];
    [[WNXSoundToolManager sharedSoundToolManager] playSoundWithSoundName:kSoundScreamName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [screamIV removeFromSuperview];
        [self startPlayGame];
        [self.view bringSubviewToFront:self.playAgainButton];
        [self.view bringSubviewToFront:self.pauseButton];
    });
}

- (void)fail {
    [(WNXTimeCountView *)self.countScore stopCalculateTime];
    [self showGameFail];
}

- (void)startPlayGame {
    self.view.userInteractionEnabled = YES;
    [(WNXTimeCountView *)self.countScore startCalculateTime];
}

- (void)pauseGame {
    [super pauseGame];
    [(WNXTimeCountView *)self.countScore pause];
}

- (void)continueGame {
    [super continueGame];
    [(WNXTimeCountView *)self.countScore resumed];
}

#pragma mark - Action
- (void)leftButtonClick {
    [self.peopleView punchTheFace];
}

- (void)doneButtonClick {
    NSTimeInterval time = [(WNXTimeCountView *)self.countScore stopCalculateTime];
    if ([self.peopleView doneBtnClick]) {
        if (self.stateView) {
            [self.stateView removeFromSuperview];
            self.stateView = nil;
        }
        self.stateView = [WNXStateView viewFromNib];
        self.stateView.frame = CGRectMake(0, ScreenHeight - self.stateView.frame.size.height - self.leftButton.frame.size.height - 10, self.stateView.frame.size.width, self.stateView.frame.size.height);
        [self.view addSubview:self.stateView];
        WNXResultStateType stageType;
        if (time <= 5) {
            stageType = WNXResultStateTypePerfect;
        } else if (time < 6) {
            stageType = WNXResultStateTypeGreat;
        } else if (time < 7) {
            stageType = WNXResultStateTypeGood;
        } else {
            stageType = WNXResultStateTypeOK;
        }
        
        [self.stateView showStateViewWithType:stageType];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showResultControllerWithNewScroe:time unit:@"秒" stage:self.stage isAddScore:YES];
        });
        
    } else {
        [self showGameFail];
    }
}

@end