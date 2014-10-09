//
//  SplashViewController.m
//  leyellCamera
//
//  Created by  Andrew Huang on 14-10-7.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)delayMethod
{
    NSLog(@"执行延迟方法");
    [self performSegueWithIdentifier:@"MainWindow" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
