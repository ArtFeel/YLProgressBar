/*
 * YLProgressBar.h
 *
 * Copyright 2012 Yannick Loriot.
 * http://yannickloriot.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>
#import "ARCMacro.h"

@interface YLProgressBar : UIProgressView
{
@public
    BOOL        animated;
    UIColor*    progressTintColor;
    
@protected
    double      progressOffset;
    CGFloat     cornerRadius;
    NSTimer*    animationTimer;
}

@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer*    animationTimer;

@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSTimer*    growingTimer;

/** Run the animation of the progress bar. YES by default. */
@property (nonatomic, getter = isAnimated) BOOL animated;
@property (nonatomic, retain) UIColor *progressTintColor;
@property (nonatomic, retain) UIColor *progressSecondTintColor;

// BackgroundColor
@property (nonatomic, retain) UIColor *backgroundFillColor;
@property (nonatomic, retain) UIColor *backgroundStrokeColor;
@property (nonatomic, retain) UIColor *backgroundGlowColor;

// by default, is horizontal
@property (nonatomic, assign) BOOL verticalDarkGradient;

// by default black
@property (nonatomic, assign) BOOL whiteStripes;

// by default, hide
@property (nonatomic, assign) BOOL showGloss;

// by default, hide
@property (nonatomic, assign) BOOL showGlow;

// by default 7
@property (nonatomic, assign) NSInteger stripeWidth;

// you can make stripes vertical, set 0
// or with small angle, set 8
// or with large angle, set 20
@property (nonatomic, assign) NSInteger distanceBetweenTopAndBottomRightCorner;

// by default 1
@property (nonatomic, assign) NSInteger progressImageInset;

// by default 1
@property (nonatomic, assign) NSInteger backgroundStrokeSize;

// by default, 1/2 of height
@property (nonatomic, assign) CGFloat cornerRadius;

// by default 0.01
@property (nonatomic, assign) CGFloat animationTrackProgressIncrement;

// by default 0.0001
@property (nonatomic, assign) CGFloat animationTrackProgressDelay;


#pragma mark Constructors - Initializers

#pragma mark Public Methods

// we can't use
// - (void)setProgress:animated:YES;
// because there's drawRect method in progress view inside
- (void)showProgress:(CGFloat)progress animated:(BOOL)animated;


- (void)showAnimatedProgressWithTimer:(CGFloat)progress;

@end
