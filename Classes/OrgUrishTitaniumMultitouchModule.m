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

@interface TiUIView (exists)
- (void)handleSwipeRight;
- (void)handleSwipeLeft;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	int count = [[event touchesForView:self] count];
    
	if (count == 0) {
		//The touch events are not for this view. Propagate and return
		[super touchesBegan:touches withEvent:event];
		return;
	}
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
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	int count = [[event touchesForView:self] count];
    
	if (count == 0) {
		//The touch events are not for this view. Propagate and return
		[super touchesMoved:touches withEvent:event];
		return;
	}
    
	UITouch *touch = [touches anyObject];
	if (handlesTouches)
	{
		NSMutableDictionary *evt = [NSMutableDictionary dictionaryWithDictionary:[TiUtils pointToDictionary:[touch locationInView:self]]];
		[evt setValue:[TiUtils pointToDictionary:[touch locationInView:nil]] forKey:@"globalPoint"];
        [self addTouches:event.allTouches toEvent:evt];
		if ([proxy _hasListeners:@"touchmove"])
		{
			[proxy fireEvent:@"touchmove" withObject:evt propagate:YES];
		}
	}
    
	if (touchDelegate!=nil)
	{
		[touchDelegate touchesMoved:touches withEvent:event];
	}
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	int count = [[event touchesForView:self] count];
    
	if (count == 0) {
		//The touch events are not for this view. Propagate and return
		[super touchesEnded:touches withEvent:event];
		return;
	}
    
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
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	int count = [[event touchesForView:self] count];
    
	if (count == 0) {
		//The touch events are not for this view. Propagate and return
		[super touchesCancelled:touches withEvent:event];
		return;
	}
    
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
	[super touchesCancelled:touches withEvent:event];
}
@end
