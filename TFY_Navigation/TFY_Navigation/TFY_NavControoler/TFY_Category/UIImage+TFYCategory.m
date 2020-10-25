//
//  UIImage+TFYCategory.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/25.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "UIImage+TFYCategory.h"

@implementation UIImage (TFYCategory)

+ (UIImage *)tfy_imageNamed:(NSString *)name {
    NSString *bundleName = [@"TFY_NavigationImage.bundle" stringByAppendingPathComponent:name];
    NSString *frameWorkName = [@"Frameworks/TFY_NavigationImage.framework/TFY_NavigationImage.bundle" stringByAppendingPathComponent:name];
    return [UIImage imageNamed:bundleName] ? : [UIImage imageNamed:frameWorkName];
}

+ (UIImage *)tfy_imageWithColor:(UIColor *)color {
    return [self tfy_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)tfy_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)tfy_changeImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

