//
//  NSObject+DominantColor.h
//  PicSumGallary
//
//  Created by SARA on 19/01/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DominantColor)
- (UIColor *)averageColor;
@end

NS_ASSUME_NONNULL_END
