//
//  PainterView.h
//  Painter
//
//  Created by Karl Stiefvater on 5/2/15.
//  Copyright (c) 2015 Karl Stiefvater. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PainterView : UIView
{
    UIImageView* canvasView;
    UIImage* mona;
    CGSize resolution;
    
    float difference;
}

@end
