//
//  TSVideoPreviewViewController.m
//  DubheVideoCapture
//
//  Created by dubhe on 16/12/20.
//  Copyright © 2016年 dubhe. All rights reserved.
//

#import "TSVideoPreviewViewController.h"
#import "TSVideoCaptureUtility.h"

@interface TSVideoPreviewViewController ()

@property (nonatomic, strong) TSVideoCaptureUtility *videoCaptureUtility;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation TSVideoPreviewViewController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    TSVideoCaptureUtility *videoCaptureUtility = [[TSVideoCaptureUtility alloc] init];
    self.videoCaptureUtility = videoCaptureUtility;
    
    [self.videoCaptureUtility startRunning];
    
    [self addUI];
}

#pragma mark - -------------------------- UI --------------------------

- (void)addUI {
    
    self.previewLayer = self.videoCaptureUtility.previewLayer;
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
