//
//  UIImage+TRNColoring.m
//  Transported
//
//  Created by Luke Stringer on 17/05/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "UIImage+TRNColoring.h"

@implementation UIImage (TRNColoring)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *originalImage = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, originalImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    CGContextDrawImage(context, rect, originalImage.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
