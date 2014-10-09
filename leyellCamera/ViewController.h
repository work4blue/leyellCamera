//
//  ViewController.h
//  leyellCamera
//
//  Created by  Andrew Huang on 14-10-4.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomImagePickerController.h"
#import "ImageFilterProcessViewController.h"

@interface ViewController : UIViewController<CustomImagePickerControllerDelegate,ImageFitlerProcessDelegate,UINavigationControllerDelegate>


@property(nonatomic, retain) IBOutlet UIImageView * imageView;
@property(nonatomic, retain) IBOutlet UILabel * label;

@property(nonatomic) BOOL needTake ;

@end
