/*
 * YLProgressBar.m
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

#import "YLProgressBar.h"
#import "ARCMacro.h"

// Colors
#define YLProgressBarColorBackground        [UIColor colorWithRed:0.0980f green:0.1137f blue:0.1294f alpha:1.0f]
#define YLProgressBarColorBackgroundGlow    [UIColor colorWithRed:0.0666f green:0.0784f blue:0.0901f alpha:1.0f]

@interface YLProgressBar ()
{
    UIColor* _progressTintColor;
    UIColor* _progressSecondTintColor;
}
@property (nonatomic, assign)               double      progressOffset;

/** Init the progress bar. */
- (void)initializeProgressBar;

/** Build the stripes. */
- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame;

/** Draw the background (track) of the slider. */
- (void)drawBackgroundWithRect:(CGRect)rect;
/** Draw the progress bar. */
- (void)drawProgressBarWithRect:(CGRect)rect;
/** Draw the gloss into the given rect. */
- (void)drawGlossWithRect:(CGRect)rect;
/** Draw the stipes into the given rect. */
- (void)drawStripesWithRect:(CGRect)rect;

@end

@implementation YLProgressBar
@synthesize progressOffset, cornerRadius, animationTimer;
@synthesize animated;

- (void)dealloc
{
    if (animationTimer && [animationTimer isValid])
    {
        [animationTimer invalidate];
    }
    
    SAFE_ARC_RELEASE (animationTimer);
    SAFE_ARC_RELEASE (_progressTintColor);
    SAFE_ARC_RELEASE (_progressSecondTintColor);
    
    SAFE_ARC_SUPER_DEALLOC ();
}

-(id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        [self initializeProgressBar];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initializeProgressBar];
}

- (void)drawRect:(CGRect)rect
{

    // Compute the progressOffset for the animation
    self.progressOffset = (self.progressOffset > 2 * self.stripeWidth - 1) ? 0 : ++self.progressOffset;
    
    // Draw the background track
    [self drawBackgroundWithRect:rect];
    
    if (self.progress > 0)
    {
       // to start from nice shape
       CGFloat startWidth = MIN((2 * self.cornerRadius), rect.size.width * 0.2f);
       
       // -1 is because background has 1 pxl light stripe on bottom edge
        CGRect innerRect = CGRectMake(self.progressImageInset,
                                      self.progressImageInset, 
                                      startWidth + (rect.size.width - startWidth)* self.progress - 2 * self.progressImageInset,
                                      rect.size.height - 2 * self.progressImageInset - 1);
        
        [self drawProgressBarWithRect:innerRect];
        [self drawStripesWithRect:innerRect];
       
       if (self.showGloss) {
          [self drawGlossWithRect:innerRect];
       }
    }
}

- (void)setProgressTintColor:(UIColor *)aProgressTintColor
{
    SAFE_ARC_RELEASE(_progressTintColor);
    _progressTintColor = SAFE_ARC_RETAIN(aProgressTintColor);
   
   if (!_progressSecondTintColor) {
       const CGFloat* components = CGColorGetComponents(_progressTintColor.CGColor);
      
      _progressSecondTintColor = SAFE_ARC_RETAIN([UIColor colorWithRed:components[0] / 4.0f
                                                               green:components[1] / 4.0f
                                                                blue:components[2] / 4.0f
                                                               alpha:CGColorGetAlpha(_progressTintColor.CGColor)]);
   }

}

- (void)setProgressSecondTintColor:(UIColor *)progressSecondTintColor {
   SAFE_ARC_RELEASE(_progressSecondTintColor);
   _progressSecondTintColor = SAFE_ARC_RETAIN(progressSecondTintColor);
}

- (void)setFrame:(CGRect)frame {
   [super setFrame:frame];
   
   self.cornerRadius   = self.frame.size.height / 2;
}

- (UIColor*)progressTintColor
{
    if (!_progressTintColor)
    {
        [self setProgressTintColor:[UIColor purpleColor]];
    }
    return _progressTintColor;
}

#pragma mark -
#pragma mark YLProgressBar Public Methods

- (void)setAnimated:(BOOL)_animated
{
    animated = _animated;
    
    if (animated)
    {
        if (self.animationTimer == nil)
        {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 
                                                                   target:self 
                                                                 selector:@selector(setNeedsDisplay)
                                                                 userInfo:nil
                                                                  repeats:YES];
           
           
           // add to runloop
           [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
           [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
        }
    } else
    {
        if (self.animationTimer && [animationTimer isValid])
        {
            [animationTimer invalidate];
        }
        
        self.animationTimer = nil;
    }
}


- (void)showProgress:(CGFloat)progress animated:(BOOL)animated {
   if (animated) {
      [self showAnimatedProgress:@(progress)];
   } else {
      [self setProgress:progress];
   }
}


- (void)showAnimatedProgress:(NSNumber *)progress {
   [self setProgress:self.progress + 0.01];
   if (self.progress < [progress floatValue]) {
      [self performSelector:@selector(showAnimatedProgress:) withObject:progress afterDelay:0.001];
   }
}


#pragma mark YLProgressBar Private Methods

- (void)initializeProgressBar
{
    self.progressOffset     = 0;
    self.animationTimer     = nil;
    self.animated           = YES;
    self.stripeWidth = 7;
    self.distanceBetweenTopAndBottomRightCorner = 8;
    self.progressImageInset = 1;
    self.cornerRadius   = self.frame.size.height / 2;
}

- (UIBezierPath *)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame
{    
    float height = frame.size.height;
    
    UIBezierPath *rect = [UIBezierPath bezierPath];
    
    [rect moveToPoint:origin];
    [rect addLineToPoint:CGPointMake(origin.x + self.stripeWidth, origin.y)];
    [rect addLineToPoint:CGPointMake(origin.x + self.stripeWidth - self.distanceBetweenTopAndBottomRightCorner, origin.y + height)];
    [rect addLineToPoint:CGPointMake(origin.x - self.distanceBetweenTopAndBottomRightCorner, origin.y + height)];
    [rect addLineToPoint:origin];
    [rect closePath]; 
    
    return rect;
}

- (void)drawBackgroundWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        // Draw the white shadow
        [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2] set];
        
        UIBezierPath* shadow        = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0, rect.size.width - 1, rect.size.height - 1) 
                                                          cornerRadius:cornerRadius];
        [shadow stroke];
        
        // Draw the track
        [YLProgressBarColorBackground set];
        
        UIBezierPath* roundedRect   = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height-1) cornerRadius:cornerRadius];
        [roundedRect fill];
        
        // Draw the inner glow
        [YLProgressBarColorBackgroundGlow set];
        
        CGMutablePathRef glow       = CGPathCreateMutable();
        CGPathMoveToPoint(glow, NULL, cornerRadius, 0);
        CGPathAddLineToPoint(glow, NULL, rect.size.width - cornerRadius, 0);
        CGContextAddPath(context, glow);
        CGContextDrawPath(context, kCGPathStroke);
        CGPathRelease(glow);
    }
    CGContextRestoreGState(context);
}

- (void)drawProgressBarWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    {
        UIBezierPath *progressBounds    = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        CGContextAddPath(context, [progressBounds CGPath]);
        CGContextClip(context);
       
       CFArrayRef colors = (CFArrayRef) [NSArray arrayWithObjects:(id)self.progressSecondTintColor.CGColor,
                                         (id)self.progressTintColor.CGColor,
                                         nil];
       
       CGPoint gradientPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
       CGFloat locations[] = {1.0, 0.0};
       
       if (self.verticalDarkGradient) {
          locations[0] = 0.0;
          locations[1] = 1.0;
          gradientPoint = CGPointMake(rect.origin.x, rect.origin.y +  + rect.size.height);
          colors = (CFArrayRef) [NSArray arrayWithObjects:
                                 (id)self.progressTintColor.CGColor,
                                 (id)self.progressSecondTintColor.CGColor,
                                 nil];
       }
       
       CGGradientRef gradient = CGGradientCreateWithColors (colorSpace, colors, locations);       
       CGContextDrawLinearGradient(context, gradient,
                                   CGPointMake(rect.origin.x, rect.origin.y),
                                   gradientPoint,
                                   (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
       
       CGGradientRelease(gradient);
       
    }
   
    CGContextRestoreGState(context);
   
    CGColorSpaceRelease(colorSpace);
}

- (void)drawGlossWithRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    {
        // Draw the gloss
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextBeginTransparencyLayerWithRect(context, CGRectMake(rect.origin.x, rect.origin.y + floorf(rect.size.height) / 2, rect.size.width, floorf(rect.size.height) / 2), NULL);
        {
            const CGFloat glossGradientComponents[] = {1.0f, 1.0f, 1.0f, 0.47f, 0.0f, 0.0f, 0.0f, 0.0f};
            const CGFloat glossGradientLocations[] = {1.0, 0.0};
            CGGradientRef glossGradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
            CGContextDrawLinearGradient(context, glossGradient, CGPointMake(0, 0), CGPointMake(0, rect.size.width), 0);
            CGGradientRelease(glossGradient);
        }
        CGContextEndTransparencyLayer(context);
        
        // Draw the gloss's drop shadow
        CGContextSetBlendMode(context, kCGBlendModeSoftLight);
        CGContextBeginTransparencyLayer(context, NULL);
        {
            CGRect fillRect = CGRectMake(rect.origin.x, rect.origin.y + floorf(rect.size.height / 2), rect.size.width, floorf(rect.size.height / 2));
            
            const CGFloat glossDropShadowComponents[] = {0.0f, 0.0f, 0.0f, 0.56f, 0.0f, 0.0f, 0.0f, 0.0f};
            CGColorRef glossDropShadowColor = CGColorCreate(colorSpace, glossDropShadowComponents);
            
            CGContextSaveGState(context);
            {
                CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 4, glossDropShadowColor);
                CGContextFillRect(context, fillRect);
                CGColorRelease(glossDropShadowColor);
            }
            CGContextRestoreGState(context);
            
            CGContextSetBlendMode(context, kCGBlendModeClear);   
            CGContextFillRect(context, fillRect);
        }
        CGContextEndTransparencyLayer(context);
    }
    CGContextRestoreGState(context);
    
    UIBezierPath *progressBounds    = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    // Draw progress bar glow
    CGContextSaveGState(context);
    {
        CGContextAddPath(context, [progressBounds CGPath]);
        const CGFloat progressBarGlowComponents[] = {1.0f, 1.0f, 1.0f, 0.12f};
        CGColorRef progressBarGlowColor = CGColorCreate(colorSpace, progressBarGlowComponents);
        
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextSetStrokeColorWithColor(context, progressBarGlowColor);
        CGContextSetLineWidth(context, 2.0f);
        CGContextStrokePath(context);
        CGColorRelease(progressBarGlowColor);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

- (void)drawStripesWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
    
    CGContextSaveGState(context);
    {
        UIBezierPath *allStripes = [UIBezierPath bezierPath];
    
       int count = 2;
        for (int i = 0; i <= rect.size.width / (count * self.stripeWidth) + (count * self.stripeWidth); i++)
        {
            UIBezierPath* stripe = [self stripeWithOrigin:CGPointMake(i * count * self.stripeWidth + self.progressOffset, self.progressImageInset)
                                                   bounds:rect];
            [allStripes appendPath:stripe];
        }
       
        // Clip the progress frame
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        
        CGContextAddPath(context, [clipPath CGPath]);
        CGContextClip(context);
        
        CGContextSaveGState(context);
        {
            // Clip the stripes
            CGContextAddPath(context, [allStripes CGPath]);
            CGContextClip(context);
           
           
           CGFloat stripeColor = 0.0f;
           if (self.whiteStripes) {
              stripeColor = 1.0f;
           }
           
           const CGFloat stripesColorComponents[] = { stripeColor, stripeColor, stripeColor, 0.3f };
           
            CGColorRef stripesColor = CGColorCreate(colorSpace, stripesColorComponents);
            
            CGContextSetFillColorWithColor(context, stripesColor);
            CGContextFillRect(context, rect);
            
            CGColorRelease(stripesColor);
        }
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

@end
