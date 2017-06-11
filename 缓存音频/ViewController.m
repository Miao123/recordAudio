//
//  ViewController.m
//  缓存音频
//
//  Created by 苗建浩 on 2017/6/11.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//  录音对象
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;// 播放对象
@property (nonatomic, strong) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"缓存音频";
    
    NSArray *textArr = @[@"开始录音",@"停止录音",@"播放录音"];
    for (int i = 0; i < textArr.count; i++) {
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.frame = CGRectMake(50, 100 + 80 * i, 100, 50);
        clickBtn.backgroundColor = [UIColor grayColor];
        [clickBtn setTitle:textArr[i] forState:0];
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        clickBtn.tag = 1000 + i;
        [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clickBtn];
    }
    
    
    _url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    NSError *playerError;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&playerError];
    if (_audioPlayer == nil) {//    如果之前没有录音，不能播放
        
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];//    获取音频会话的实例
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];//    设置音频会话类别
    
    if (session == nil) {
        NSLog(@"创建音频会话失败  %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    
}


- (void)clickBtn:(UIButton *)sender{
    if (sender.tag == 1000) {
        //  开始录音
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:_url settings:nil error:nil];
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
        _audioPlayer = nil;
        NSLog(@"开始录音");
    }else if (sender.tag == 1001){
        //  停止录音
        [_audioRecorder stop];
        _audioRecorder = nil;
        
        NSError *playerError;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&playerError];
        if (_audioPlayer == nil) {
            NSLog(@"创建录音失败 %@",[_audioPlayer description]);
        }
        _audioPlayer.delegate = self;
        
        NSLog(@"停止录音");
    }else if (sender.tag == 1002){
        NSLog(@"播放录音");
        if ([_audioPlayer isPlaying]) {//   如果在播放状态下
            [_audioPlayer pause];
        }else{
            NSError *playerError;
            if (_audioPlayer == nil) {
                NSLog(@"创建录音失败 %@",[playerError description]);
            }
            NSLog(@"正在播放");
            _audioPlayer.delegate = self;
            [_audioPlayer play];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
