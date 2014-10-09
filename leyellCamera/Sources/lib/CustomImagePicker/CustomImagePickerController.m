//
//  CustomImagePickerController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "CustomImagePickerController.h"
#import "IphoneScreen.h"
#import "UIImage+Cut.h"



#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>


@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

@synthesize customDelegate = _customDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isAutoTake = NO;
    }
    return self;
}

#pragma mark get/show the UIView we want
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_header.png"];
    if (version >= 5.0) {
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage]  atIndex:1];
    }
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *deviceImage = [UIImage imageNamed:@"camera_button_switch_camera.png"];
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setBackgroundImage:deviceImage forState:UIControlStateNormal];
        [deviceBtn addTarget:self action:@selector(swapFrontAndBackCameras:) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setFrame:CGRectMake(250, 20, deviceImage.size.width, deviceImage.size.height)];
        
        UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
        [PLCameraView addSubview:deviceBtn];
        
        [self setShowsCameraControls:NO];
        
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 34, 320, 44)];
        [overlyView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImage = [UIImage imageNamed:@"camera_cancel.png"];
        [backBtn setImage: backImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setFrame:CGRectMake(8, 5, backImage.size.width, backImage.size.height)];
        [overlyView addSubview:backBtn];
        
        UIImage *camerImage = [UIImage imageNamed:@"camera_shoot.png"];
        UIButton *cameraBtn = [[UIButton alloc] initWithFrame:
                               CGRectMake(110, 5, camerImage.size.width, camerImage.size.height)];
        [cameraBtn setImage:camerImage forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:cameraBtn];
        
        UIImage *photoImage = [UIImage imageNamed:@"camera_album.png"];
        UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 70, 40)];
        [photoBtn setImage:photoImage forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:photoBtn];
        
        self.cameraOverlayView = overlyView;
       
//        if(self.isAutoTake){
//            //[ self takePicture ];
//            //[self performSelector:@selector(takePicture) withObject:nil afterDelay:0.5f];
//            [NSThread sleepForTimeInterval:1.0f]; [self autoTakePicture];
//            self.isAutoTake = NO;
//        }
        
    }
}

-(void)autoTakePicture{
    [self takePicture];
    
   [self closeView];
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   
}

- (void)initVolumeCapture{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    
//    AVAudioPlayer* p = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"photoshutter.wav"]] error:NULL];
//    [p prepareToPlay];
//    [p stop];
//    
//    //make MPVolumeView Offscreen
//    CGRect frame = CGRectMake(-1000, -1000, 100, 100);
//    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:frame];
//    [volumeView sizeToFit];
//    [self.view addSubview:volumeView];
    
    
}

- (void)volumeChanged:(NSNotification *)notification{
    DLog(@"valueChanged:+++----");
    [self takePicture ];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
	// Do any additional setup after loading the view.
    [self initVolumeCapture ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonAction Methods

- (IBAction)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)takePicture
{
  if(self.sourceType == UIImagePickerControllerSourceTypeCamera)
    [super takePicture];
}

- (void)showPhoto
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image clipImageWithScaleWithsize:CGSizeMake(320, 480)]  ;
    
    //选择图库
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
           [picker dismissViewControllerAnimated:NO completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
                [_customDelegate cameraPhoto:image];
            }];
    }
    else {
    //不退出，进入连拍模式
     //[_customDelegate cameraPhoto:image];
     UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    
     picker.sourceType =    UIImagePickerControllerSourceTypeCamera;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    if(_isSingle){
        [picker dismissModalViewControllerAnimated:YES];
    }else{
        if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [picker dismissModalViewControllerAnimated:YES];
        }
    }
}

/*
 if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
 
 imagePickerController = [[UIImagePickerController alloc] init];
 imagePickerController.delegate = self;
 imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
 
 if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
 
 imagePickerController.cameraDevice =  UIImagePickerControllerCameraDeviceFront;
 } else {
 imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
 }
 
 [self presentModalViewController:imagePickerController animated:YES];
 [imagePickerController release];
 }
 else {
 // do stuff ///....Alert
 }

 */




@end
