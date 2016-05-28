/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiButtonUtil.h"
#import "TiBase.h"


@implementation TiButtonUtil

+(UIView*)systemButtonWithType:(int)type
{
	switch (type)
	{
		case UIDorosh_Ian_Project1NativeItemInfoLight:
		{
			return [UIButton buttonWithType:UIButtonTypeInfoLight];
		}
		case UIDorosh_Ian_Project1NativeItemInfoDark:
		{
			return [UIButton buttonWithType:UIButtonTypeInfoDark];
		}
		case UIDorosh_Ian_Project1NativeItemDisclosure:
		{
			return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
		case UIDorosh_Ian_Project1NativeItemContactAdd:
		{
			return [UIButton buttonWithType:UIButtonTypeContactAdd];
		}
		case UIDorosh_Ian_Project1NativeItemSpinner:
		{
			UIActivityIndicatorView *button = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
			[button startAnimating];
			return button;
		}
	}
	return nil;
}

+(UIView*)buttonWithType:(int)type
{
	UIView *button = [TiButtonUtil systemButtonWithType:type];
	if (button==nil)
	{
		button = [UIButton buttonWithType:type];
	}
	return button;
}

@end
