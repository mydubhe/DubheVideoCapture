//
//  TSVideoCaptureUtility.m
//  DubheVideoCapture
//
//  Created by dubhe on 16/12/12.
//  Copyright © 2016年 dubhe. All rights reserved.
//

#import "TSVideoCaptureUtility.h"

typedef NS_ENUM(NSInteger, TSVideoWriterRecordingStatus) {
    TSVideoWriterRecordingStatusStartingRecording,
    TSVideoWriterRecordingStatusRecordinf,
    TSVideoWriterRecordingStatusStoppingRecording
};

@interface TSVideoCaptureUtility ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice *currentCaptureDevice;          //当前设备
@property (nonatomic, strong) AVCaptureSession *captureSession;               //捕获视频的会话
@property (nonatomic, strong) AVCaptureDeviceInput *camreaInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;           //音频链接
@property (nonatomic, strong) AVCaptureConnection *videoConnection;           //视频链接
@property (nonatomic, strong) AVCaptureConnection *photoConnection;           //图片链接
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;       //捕捉预览layer
@property (nonatomic, assign) AVCaptureVideoOrientation videoBufferOrirntation; //视频的方向
@property (nonatomic, copy) dispatch_queue_t  sessionQueue;
@property (nonatomic, copy) dispatch_queue_t  videoDataOutputQueue;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput *photoDataOutput;

@property (nonatomic, assign) BOOL isCapturing;
@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, assign) TSVideoWriterRecordingStatus recordingStatus;

@end

@implementation TSVideoCaptureUtility

#pragma mark - -------------------------- private --------------------------

- (dispatch_queue_t)sessionQueue {
    if (_sessionQueue == nil) {
        _sessionQueue = dispatch_queue_create("TSVideoCapture.session", DISPATCH_QUEUE_SERIAL);
    }
    return _sessionQueue;
}

- (dispatch_queue_t)videoDataOutputQueue {
    if (_videoDataOutputQueue == nil) {
        _videoDataOutputQueue = dispatch_queue_create("TSVideoCapture.videoDataOutput", DISPATCH_QUEUE_SERIAL);
    }
    return _videoDataOutputQueue;
}

- (AVCaptureDevice *)currentCaptureDevice {
    if (_currentCaptureDevice == nil) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionBack) {
                _currentCaptureDevice = device;
            }
        }
    }
    return _currentCaptureDevice;
}

- (AVCaptureDeviceInput *)camreaInput {
    if (_camreaInput == nil) {
        NSError *error;
        _camreaInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.currentCaptureDevice error:&error];
        if (error) {
            NSLog(@"获取摄像头失败");
        }
    }
    return _camreaInput;
}

- (AVCaptureDeviceInput *)audioInput {
    if (_audioInput == nil) {
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:mic error:&error];
        if (error) {
            NSLog(@"获取麦克失败");
        }
    }
    return _audioInput;
}

#pragma mark - -------------------------- 初始化CaptureSession --------------------------
- (void)setupCaptureSession {
    if (_captureSession) {
        return;
    }
    
     _captureSession = [[AVCaptureSession alloc] init];
    
    if ([_captureSession canAddInput:self.audioInput]) {
        [_captureSession addInput:self.audioInput];
    }
    AVCaptureAudioDataOutput *audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    self.audioDataOutput = audioDataOutput;
    dispatch_queue_t audioCaptureQueue = dispatch_queue_create("TSVideoCapture.audio", DISPATCH_QUEUE_SERIAL);
    [self.audioDataOutput setSampleBufferDelegate:self queue:audioCaptureQueue];
    if ([_captureSession canAddOutput:self.audioDataOutput]) {
        [_captureSession addOutput:self.audioDataOutput];
    }
    
    _audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    
    if ([_captureSession canAddInput:self.camreaInput]) {
        [_captureSession addInput:self.camreaInput];
    }
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoDataOutput = videoDataOutput;
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    _videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    AVCaptureStillImageOutput *photoDataOutput = [[AVCaptureStillImageOutput alloc] init];
    self.photoDataOutput = photoDataOutput;
    if ([_captureSession canAddOutput:self.photoDataOutput]) {
        [_captureSession addOutput:self.photoDataOutput];
    }
    _photoConnection = [self.photoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
}

#pragma mark - -------------------------- 录制启动,暂停,停止 --------------------------
- (void)startRunning{
    dispatch_sync(self.sessionQueue, ^{
        [self setupCaptureSession];
        
        if (self.captureSession) {
            [self.captureSession startRunning];
            self.isCapturing = YES;
        }
    });
}

- (void)pauseRunning {
    dispatch_sync(self.sessionQueue, ^{
        if (self.isCapturing) {
            self.isPaused = YES;
        }
    });
}

- (void)stopRunning {
    dispatch_sync(self.sessionQueue, ^{
        self.isCapturing = NO;
        [self.captureSession stopRunning];
        
        [self captureSessionDidStopRunning];
        [self teardDownCaptureSession];
    });
}

- (void)resumeRunning {
    dispatch_sync(self.sessionQueue, ^{
        if (self.isPaused) {
            self.isPaused = NO;
        }
    });
}

- (void)captureSessionDidStopRunning {
    //停止写入
}

- (void)teardDownCaptureSession {
    //释放CaptureSession
}

#pragma mark - -------------------------- AVCaptureVideoDataOutputSampleBufferDelegate --------------------------
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

@end
