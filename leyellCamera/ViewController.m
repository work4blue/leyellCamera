//
//  ViewController.m
//  leyellCamera
//
//  Created by  Andrew Huang on 14-10-4.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    MPVolumeView* volumeView = [[MPVolumeView alloc] initWithFrame:self.volumeViewContainer.bounds];
//    volumeView.backgroundColor = [UIColor clearColor];
//    [self.volumeViewContainer addSubview:volumeView];
    
    [self startAudioSession];
 

}

- (void) startAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];
    
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback
                   error:&setCategoryError];
}

- (void) endAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *activationError = nil;
    [session setActive:NO
           withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                 error:&activationError];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showCameraView{
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [picker setCustomDelegate:self];
    
 //   [ AppDelegate sharedInstance ].cameraView = picker;
    [self presentModalViewController:picker animated:YES];
    
    if(self.needTake){
        picker.isAutoTake = YES;
        
    }
    
    
}

- (IBAction)onCamera:(id)sender{
    [self showCameraView ];
}

- (void)cameraPhoto:(UIImage *)image  //选择完图片
{
    //取消滤镜
    //    ImageFilterProcessViewController *fitler = [[ImageFilterProcessViewController alloc] init];
    //    [fitler setDelegate:self];
    //    fitler.currentImage = image;
    //    [self presentModalViewController:fitler animated:YES];
    
    [self imageFitlerProcessDone:image ];
    self.needTake = NO;
    
}

- (void)cancelCamera{
 //   [ AppDelegate sharedInstance ].cameraView = nil;
    
    self.needTake = NO;
}


- (void)imageFitlerProcessDone:(UIImage *)image //图片处理完
{
   [self.label setHidden:YES];
    [self.imageView setHidden:NO] ;
    [self.imageView setImage:image];
    
    
  //  [ AppDelegate sharedInstance ].cameraView = nil;
    
    //保存到相册中
    // UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 相册保存方法回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = [ NSString stringWithFormat:@"保存图片失败 %@",error] ;
	}else{
		//msg = @"保存图片成功" ;
        return;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}

- (void) becomeActiveAudioController {
    
    [self startAudioSession];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
   // [_nowPlayingManager start];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];
    [self becomeActiveAudioController];

    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}


- (BOOL) canBecomeFirstResponder {
    return YES;
}

//1. Edit your info.plist to stipulate that you do audio (UIBackgroundModes) in the background as well as foreground.


- (void)  remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
           case UIEventSubtypeRemoteControlTogglePlayPause:
                  NSLog(@"Play toggle play pause");
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"Play play");
              //  [self playOrStop: nil];
                break;
            case UIEventSubtypeRemoteControlPause:
                  NSLog(@"Play pause");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
               // [self previousTrack: nil];
                 NSLog(@"Play prev");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                //[self nextTrack: nil];
                 NSLog(@"Play next");
                break;
                
            default:
                break;
        }
    }
}

/*
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	if ([self canBecomeFirstResponder]) {
 [self becomeFirstResponder];
	}
 */



/*
 - (NSArray *)keyCommands
 {
 return @[[UIKeyCommand keyCommandWithInput:@"f"
 modifierFlags:UIKeyModifierCommand
 action:@selector(searchKeyPressed:)]];
 }
 
 - (void)searchKeyPressed:(UIKeyCommand *)keyCommand
 {
 // Respond to the event
 }
*/
@end
