//
//  ViewController.m
//  ozasikigame
//
//  Created by nanami on 2014/11/29.
//  Copyright (c) 2014年 nanami. All rights reserved.
//

#import "MainViewController.h"
#import "GameoverViewController.h"
#import "GameclearViewController.h"

@interface MainViewController (){
    NSTimer *timer;
    int timeCount;
    int doubleTap;
    BOOL guCount;
    
    int tapCount;
    
    BOOL isTapped;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //タップViewの生成
    //FIX: これなにしてる？
    UIView *tapView = [[UIView alloc]init];
    tapView.frame = CGRectMake(0, 0, 108, 97);
    tapView.backgroundColor = [UIColor clearColor];
    [tapButton addSubview:tapView];
    
    //タップ認識
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加（タップしたか確認のビュー）
    [tapView addGestureRecognizer:tapGesture];
    
    
    //ボタンの長押し設定部分
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHandler:)];
    [guButton addGestureRecognizer:gestureRecognizer];
    //初期値を設定
    timeCount = 1; //最初に手が出てくるようにするために１
    par.hidden=YES;
    gu.hidden=YES;
    red.hidden = NO;
    doubleTap = 0;
    number=0;
    
    //タップされていないので
    isTapped = NO;
    // ピンチ
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinchGesture];
}


-(void)time:(NSTimer*)timer{
    timeCount += 1;
    countLabel.text = [NSString stringWithFormat:@"%d",timeCount-1];
    NSLog(@"time:%d", timeCount-1);
    //-------------------------
    if (3 <= timeCount && timeCount%2 == 0) {
        if (isTapped == NO) {
            NSLog(@"no tap");
            //            NSAssert(isTappedOdd==YES, @"no tap");
            [self presentGameoverVC];
        }
    }
    //4以上の偶数の場合、Tapを消す
    if (timeCount%2 == 0) {
        isTapped = NO;
    }
    
    if (timeCount%4 == 0) {
        par.hidden = YES; // 非表示になる。
        gu.hidden = NO;
        
        NSLog(@"gu"); //手ぐーが出てきた時
        
        
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             gu.center = CGPointMake(160, 400);

        }completion:^(BOOL finished) {
            red.hidden =YES;
            [UIView animateWithDuration:0.4f delay:0.2 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                gu.center = CGPointMake(160, 50);
            }completion:^(BOOL finished) {
            }];
        }];
        
        
    }else if(timeCount%4==1){
        
//        red.hidden =YES;
        gu.hidden = YES;
        NSLog(@"par");//手パーが出てきたとき
        
    }else if(timeCount%2 == 0){
        
        par.hidden = NO;// 見えるようになる。
        
        
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             par.center = CGPointMake(160, 400);
//                             par.frame = CGRectMake(80, 300, 102, 183);

                         }completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.4f delay:0.2 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  par.center = CGPointMake(160, 50);
                                              }completion:^(BOOL finished) {
                                              }];
                         }];
        
        
        
        
        gu.hidden = YES;
        red.hidden = NO;
    }else{
        par.hidden=YES;
        gu.hidden=YES;
        red.hidden = NO;
        
        //ADD:
        if (4 < timeCount) {//FIX: 辛い
            if (guCount == YES) {
                NSLog(@"****ok");
            } else {
                GameoverViewController *gameover= [self.storyboard instantiateViewControllerWithIdentifier:@"gameover"];
                [self presentModalViewController:gameover animated:YES ];
            }
        }
        
    }
    //２秒ごとにダブルタップを初期化
    if (timeCount%2 == 0) {
        doubleTap = 0;
    }
}


-(IBAction)start{
    
    startButton.hidden=YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(time:)
                                           userInfo:nil
                                            repeats:YES];
}

//xibでmultipletouches
//TODO: 同時押し
-(IBAction)gubuttont:(UIButton*)sendButton andEvent:(UIEvent*) event {
    NSSet *touches = [event touchesForView:sendButton];
    int fingerCount = (int)[touches count];
    NSLog(@"%d",fingerCount);
    if (fingerCount == 2) {
        guCount = YES;
    } else {
        guCount = NO;
    }
}



- (void)view_Tapped:(UITapGestureRecognizer *)sender{
    tapCount++;
    NSLog(@"タップされました．");
    isTapped = YES;
    //
    if (timeCount%2 == 1) {
        doubleTap += 1;
        NSLog(@"%d",doubleTap);
        
        number=number+1;
        tapLabel.text =[NSString  stringWithFormat:@"%d",number];
        
        
        //間違って２連続タップでアウト
        NSLog(@"%d",doubleTap);
        if (doubleTap == 2) {
            [self presentGameoverVC];
        }
    }else{
        
        //NSAssert(isTappedOdd == NO, @"over");
        [self presentGameoverVC];
        
        
    }
    
    //10回でクリア
    if (number== 10) {
        //NSAssert(number == 11, @"clear");
        [self presentGameclearVC];
    }
}
- (void)presentGameclearVC{
    [timer invalidate];
    GameclearViewController*gameclear= [self.storyboard instantiateViewControllerWithIdentifier:@"gameclear"];
    [self presentViewController:gameclear animated:YES completion:nil];
}
- (void)presentGameoverVC{
    [timer invalidate];
    GameoverViewController *gameover= [self.storyboard instantiateViewControllerWithIdentifier:@"gameover"];
    [self presentViewController:gameover animated:YES completion:nil];
}
// セレクター
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    NSLog(@"factor %@",sender);
}
@end
