//
//  TSVideoCaptureUtility.h
//  DubheVideoCapture
//
//  Created by dubhe on 16/12/12.
//  Copyright © 2016年 dubhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TSVideoCaptureUtility : NSObject

@property (nonatomic, readonly, strong) AVCaptureVideoPreviewLayer *previewLayer;


- (void)startRunning;
- (void)pauseRunning;
- (void)stopRunning;
- (void)resumeRuning;

@end
