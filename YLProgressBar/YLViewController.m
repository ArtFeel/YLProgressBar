//
//  YLViewController.m
//  YLProgressBar
//
//  Created by Yannick Loriot on 05/02/12.
//  Copyright (c) 2012 Yannick Loriot. All rights reserved.
//

#import "YLViewController.h"

#import "YLProgressBar.h"

@interface YLViewController ()
@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer*    progressTimer;

@end

@implementation YLViewController
@synthesize progressView;
@synthesize progressValueLabel;
@synthesize progressTimer;

- (void)dealloc
{
    if (progressTimer && [progressTimer isValid])
    {
        [progressTimer invalidate];
    }
    
    SAFE_ARC_RELEASE (progressTimer);
    SAFE_ARC_RELEASE (progressValueLabel);
    SAFE_ARC_RELEASE (progressView);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f
//                                                           target:self
//                                                         selector:@selector(changeProgressValue)
//                                                         userInfo:nil
//                                                          repeats:YES];
//
//   // add to runloop
//   [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSDefaultRunLoopMode];
//   [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)viewDidUnload
{
    [self setProgressValueLabel:nil];
    [self setProgressView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGRect frame = self.progressView.frame;
    frame.size.height = 24;
    [self.progressView setFrame:frame];

    self.progressView.verticalDarkGradient = YES;
    self.progressView.whiteStripes = YES;

    self.progressView.progressTintColor = [UIColor colorWithRed:88/255.0 green:155/255.0 blue:207/255.0 alpha:0.6];
    self.progressView.progressSecondTintColor = [UIColor colorWithRed:0/255.f green:63/255.f blue:110/255.f alpha:0.6];

    self.progressView.backgroundStrokeColor = [UIColor colorWithRed:127/255.f green:164/255.f blue:191/255.f alpha:1];
    self.progressView.backgroundFillColor = [UIColor colorWithRed:244/255.f green:247/255.f blue:250/255.f alpha:1];
//    self.progressView.animated = NO;

    self.progressView.stripeWidth = 5;
    self.progressView.distanceBetweenTopAndBottomRightCorner = 20;
    self.progressView.progressImageInset = 0;
    self.progressView.cornerRadius = 4;

    self.progressView.progress = 0.4;

    self.progressView.animationTrackProgressDelay = 0.04f;
    self.progressView.animationTrackProgressIncrement = 0.001f;
    [self.progressView showAnimatedProgressWithTimer:1];
//   

    CGRect frame2 = self.progressView2.frame;
    frame2.size.height = 24;
    [self.progressView2 setFrame:frame2];

    self.progressView2.verticalDarkGradient = YES;
    self.progressView2.whiteStripes = NO;

    self.progressView2.progressTintColor = [UIColor colorWithRed:88/255.0 green:183/255.0 blue:254/255.0 alpha:0.5];
    self.progressView2.progressSecondTintColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:154/255.0 alpha:0.5];

    self.progressView2.backgroundStrokeColor = [UIColor colorWithRed:127/255.f green:164/255.f blue:191/255.f alpha:1];
    self.progressView2.backgroundFillColor = [UIColor colorWithRed:244/255.f green:247/255.f blue:250/255.f alpha:1];
//    self.progressView2.animated = NO;

    self.progressView2.stripeWidth = 5;
    self.progressView2.distanceBetweenTopAndBottomRightCorner = 20;
    self.progressView2.progressImageInset = 0;

    self.progressView2.progress = 0.6;
//    [self showProg];


    CGRect frame3 = self.progressView3.frame;
    frame3.size.height = 30;
    [self.progressView3 setFrame:frame3];

    self.progressView3.verticalDarkGradient = YES;

    self.progressView3.whiteStripes = YES;


    self.progressView3.progressTintColor = [UIColor colorWithRed:253/255.0 green:205/255.0 blue:64/255.0 alpha:1];
    self.progressView3.progressSecondTintColor = [UIColor colorWithRed:253/255.0 green:161/255.0 blue:10/255.0 alpha:1];

    self.progressView3.stripeWidth = 12;
    self.progressView3.distanceBetweenTopAndBottomRightCorner = 20;
    self.progressView3.progressImageInset = 2;

//    [self showProg3];
}


- (void)showProg {
   self.progressView2.progress = 0;
   
//   self.progressView2.animationTrackProgressDelay = 0.01f;
//   self.progressView2.animationTrackProgressIncrement = 0.01f;
//   [self.progressView2 showProgress:1 animated:YES];
//   [self performSelector:@selector(showProg) withObject:nil afterDelay:1];
}

- (void)showProg3 {
   self.progressView3.progress = 0;
   
   self.progressView3.animationTrackProgressDelay = 0.03f;
   self.progressView3.animationTrackProgressIncrement = 0.01f;
   [self.progressView3 showAnimatedProgressWithTimer:1];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark YLViewController Public Methods

- (void)changeProgressValue
{
    float progressValue = progressView.progress;
    
    progressValue += 0.001f;
    if (progressValue > 1)
    {
        progressValue = 0;
    }
    
    
    [progressValueLabel setText:[NSString stringWithFormat:@"%.00f%%", (progressValue * 100)]];
    [progressView setProgress:progressValue];
}

- (IBAction)colorButtonTapped:(id)sender
{
//   progressView.progressTintColor = [UIColor colorWithRed:253/255.0 green:205/255.0 blue:64/255.0 alpha:1];
}

#pragma mark YLViewController Private Methods

@end
