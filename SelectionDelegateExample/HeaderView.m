//
//  HeaderView.m
//  FlowLayoutNoNIB
//
//  Created by Beau G. Bolle on 2012.10.29.
//
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        CGFloat hue = 69./255.;
        UIColor *color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		[self setBackgroundColor:color];
	}
	return self;
}

@end
