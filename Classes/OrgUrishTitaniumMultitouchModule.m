//
//  OrgUrishTitaniumMultitouchModule.m
//  TiMultitouch
//
//  Copyright (c) 2011, 2012, Uri Shaked.
//  Original version Copyright 2010 Big Canvas Inc. All rights reserved.
//

#import "OrgUrishTitaniumMultitouchModule.h"

@implementation OrgUrishTitaniumMultitouchModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"3cfea9ea-13ff-4d13-ac12-8543fec2f132";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"org.urish.titanium.multitouch";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	[super dealloc];
}

@end

@interface  TiViewProxy
-(UIView*)view;
-(BOOL)viewAttached;
@end

@implementation TiViewProxy (multitouch)
-(id)multitouch
{
    __block BOOL result = NO;
    TiThreadPerformOnMainThread(^{
        result = self.view.multipleTouchEnabled;
    }, YES);
    return NUMBOOL(result);
}

-(void)setMultitouch:(id)value;
{
    BOOL newValue = [value boolValue];
    TiThreadPerformOnMainThread(^{
        self.view.multipleTouchEnabled = newValue;
    }, YES);
}
@end

@implementation TiUIView (multitouch)

- (NSDictionary*)touchToDictionary: (UITouch*) touch {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:[touch locationInView:self]]];
    [result setValue:[TiUtils pointToDictionary:[touch locationInView:nil]] forKey:@"globalPoint"];
    return result;
}

- (void)addTouches: (NSSet*)touches toEvent:(NSMutableDictionary*)target 
{
    NSMutableDictionary *ts = [NSMutableDictionary dictionary];
    for (UITouch* t in touches) {
        [ts setObject:[self touchToDictionary:t] forKey:[NSString stringWithFormat:@"%p",t]];
    }
    [target setValue:ts forKey:@"points"];
}

- (void)processTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
	if (handlesTouches)
	{
		NSMutableDictionary *evt = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:[touch locationInView:self]]];
		[evt setValue:[TiUtils pointToDictionary:[touch locationInView:nil]] forKey:@"globalPoint"];
        [self addTouches:touches toEvent:evt];
        
		if ([proxy _hasListeners:@"touchstart"])
		{
			[proxy fireEvent:@"touchstart" withObject:evt propagate:YES];
			[self handleControlEvents:UIControlEventTouchDown];
		}
        // Click handling is special; don't propagate if we have a delegate,
        // but DO invoke the touch delegate.
		// clicks should also be handled by any control the view is embedded in.
		if ([touch tapCount] == 1 && [proxy _hasListeners:@"click"])
		{
			if (touchDelegate == nil) {
				[proxy fireEvent:@"click" withObject:evt propagate:YES];
				return;
			} else {
				[touchDelegate touchesBegan:touches withEvent:event];
			}
		} else if ([touch tapCount] == 2 && [proxy _hasListeners:@"dblclick"]) {
			[proxy fireEvent:@"dblclick" withObject:evt propagate:YES];
			return;
		}
	}
}

- (void)processTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if (handlesTouches)
	{
		NSMutableDictionary *evt = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:[touch locationInView:self]]];
		[evt setValue:[TiUtils pointToDictionary:[touch locationInView:nil]] forKey:@"globalPoint"];
        [self addTouches:touches toEvent:evt];
		if ([proxy _hasListeners:@"touchmove"])
		{
			[proxy fireEvent:@"touchmove" withObject:evt propagate:YES];
		}
	}
    
	if (touchDelegate!=nil)
	{
		[touchDelegate touchesMoved:touches withEvent:event];
	}
}

- (void)processTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (handlesTouches)
	{
		UITouch *touch = [touches anyObject];
		NSMutableDictionary *evt = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:[touch locationInView:self]]];
		[evt setValue:[TiUtils pointToDictionary:[touch locationInView:nil]] forKey:@"globalPoint"];
        [self addTouches:touches toEvent:evt];
		if ([proxy _hasListeners:@"touchend"])
		{
			[proxy fireEvent:@"touchend" withObject:evt propagate:YES];
			[self handleControlEvents:UIControlEventTouchCancel];
		}
	}
    
	if (touchDelegate!=nil)
	{
		[touchDelegate touchesEnded:touches withEvent:event];
	}
}

- (void)processTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (handlesTouches)
	{
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:self];
		NSMutableDictionary *evt = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:point]];
        [self addTouches:touches toEvent:evt];
		if ([proxy _hasListeners:@"touchcancel"])
		{
			[proxy fireEvent:@"touchcancel" withObject:evt propagate:YES];
		}
	}
    
	if (touchDelegate!=nil)
	{
		[touchDelegate touchesCancelled:touches withEvent:event];
	}
}
@end
