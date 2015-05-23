//
//  PainterView.m
//  Painter
//
//  Created by Karl Stiefvater on 5/2/15.
//  Copyright (c) 2015 Karl Stiefvater. All rights reserved.
//

#import "PainterView.h"

@implementation PainterView

- (PainterView*) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        canvasView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:canvasView];
        
        mona = [UIImage imageNamed:@"Mona.jpg"];

        // compute resolution of target image so it fits nicely in our window
        float monaAspectRatio = mona.size.width / mona.size.height;
        resolution = CGSizeMake(frame.size.width, (int) (frame.size.width / monaAspectRatio));
        
        // scale the image without changing its apsect ratio
        canvasView.contentMode = UIViewContentModeScaleAspectFit;

        // initialize difference to be the maximum possible value
        difference = MAXFLOAT;
    
        // call the paint method every 0.01 second
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(paint) userInfo:nil repeats:YES];
    }
    
    return self;
}



- (void) paint
{
    for (int i = 0; i < 10; i++)
    {
        UIGraphicsBeginImageContext(resolution);
        
        [canvasView.image drawInRect:CGRectMake(0, 0, resolution.width, resolution.height)];

        float red = arc4random_uniform(100)/100.0;
        float green = arc4random_uniform(100)/100.0;
        float blue = arc4random_uniform(100)/100.0;
        
        UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [color setFill];

        
        // draw random oval
        // int width = arc4random_uniform(200);
        // int height = arc4random_uniform(200);
        //
        // int left = arc4random_uniform(self.bounds.size.width - width);
        // int top = arc4random_uniform(self.bounds.size.height - height);
        //
        // UIBezierPath* circlePath =
        //   [UIBezierPath bezierPathWithOvalInRect:CGRectMake(left, top, width, height)];
        // [circlePath fill];

        
        // draw random glyph
        NSString* glyph = [NSString stringWithFormat:@"%c", 'A' + arc4random_uniform(26)];
        NSDictionary* appearance =
        @{ NSFontAttributeName :
               [UIFont fontWithName:@"Times" size:arc4random_uniform(200) + 5],
           NSForegroundColorAttributeName : color
           };
        
        CGSize size = [glyph sizeWithAttributes:appearance];
        int width = size.width;
        int height = size.height;
        int left = arc4random_uniform(resolution.width - width);
        int top = arc4random_uniform(resolution.height - height);
        
        [glyph drawAtPoint:CGPointMake(left, top) withAttributes:appearance];
        
        
        // get image from current drawing context
        UIImage* thisImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // compute its difference with Mona
        float thisDifference = [self differenceBetweenImage1:thisImage andImage2:mona];
        
        // if the difference has decreased (gotten better) then use it
        if (thisDifference < difference)
        {
            canvasView.image = thisImage;
            difference = thisDifference;
        }
        
        UIGraphicsEndImageContext();
    }
    
}


// compute a numerical "difference" value between two images
- (float) differenceBetweenImage1:(UIImage*)image1 andImage2:(UIImage*)image2
{
    float totalDifference = 0;
    
    CGRect frame = CGRectMake(0, 0, 100, 100);
    
    // draw image1 into a pixel buffer
    UIGraphicsBeginImageContext(frame.size);
    [image1 drawInRect:frame];
    UIImage* resized1 = UIGraphicsGetImageFromCurrentImageContext();
    CFDataRef data1 = CGDataProviderCopyData(CGImageGetDataProvider(resized1.CGImage));
    const UInt8* dataPointer1 = CFDataGetBytePtr(data1);
    UIGraphicsEndImageContext();
    
    // draw image2 into a pixel buffer
    UIGraphicsBeginImageContext(frame.size);
    [image2 drawInRect:frame];
    UIImage* resized2 = UIGraphicsGetImageFromCurrentImageContext();
    CFDataRef data2 = CGDataProviderCopyData(CGImageGetDataProvider(resized2.CGImage));
    const UInt8* dataPointer2 = CFDataGetBytePtr(data2);
    UIGraphicsEndImageContext();

    // loop over all the data in the pixel buffers, add up the differences between them
    for (int i = 0; i < CFDataGetLength(data1); i++)
    {
        float pixel1 = dataPointer1[i];
        float pixel2 = dataPointer2[i];
        
        float thisDifference = fabs(pixel1 - pixel2);
        
        totalDifference = totalDifference + thisDifference;
    }
    
    CFRelease(data1);
    CFRelease(data2);

    return totalDifference;
}


@end
