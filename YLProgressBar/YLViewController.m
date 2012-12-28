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
	
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f 
                                                           target:self 
                                                         selector:@selector(changeProgressValue)
                                                         userInfo:nil
                                                          repeats:YES];
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
   frame.size.height = 30;
   [self.progressView setFrame:frame];
   
   self.progressView.verticalDarkGradient = YES;
   
   self.progressView.whiteStripes = YES;
   
   
   self.progressView.progressTintColor = [UIColor colorWithRed:253/255.0 green:205/255.0 blue:64/255.0 alpha:1];
   self.progressView.progressSecondTintColor = [UIColor colorWithRed:253/255.0 green:161/255.0 blue:10/255.0 alpha:1];
   
   self.progressView.stripeWidth = 12;
   self.progressView.distanceBetweenTopAndBottomRightCorner = 20;
   self.progressView.progressImageInset = 2;
   
   self.progressView.progress = 0;
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
    
    progressValue       += 0.01f;
    if (progressValue > 1)
    {
        progressValue = 0;
    }
    
    
    [progressValueLabel setText:[NSString stringWithFormat:@"%.0f%%", (progressValue * 100)]];
    [progressView setProgress:progressValue];
}

- (IBAction)colorButtonTapped:(id)sender
{
   progressView.progressTintColor = [UIColor colorWithRed:253/255.0 green:205/255.0 blue:64/255.0 alpha:1];
}

#pragma mark YLViewController Private Methods

@end
