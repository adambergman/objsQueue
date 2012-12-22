//
//  ObjsQueue.m
//  objsQueue
//
//  Created by Bergman, Adam on 3/13/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import "ObjsQueue.h"
#import "JSONKit.h"

@interface ObjsQueue()

@property (nonatomic, retain) UIWebView *web;
@property (nonatomic, retain) id target;
@property (nonatomic, retain) NSTimer *queueTimer;

-(void)executeOBJSQueue;   

@end


@implementation ObjsQueue

@synthesize web;
@synthesize target;
@synthesize queueTimer;
@synthesize isRunning;

-(id)init
{
    if((self = [super init]))
    {
        isRunning = FALSE;
    }
    return self;
}

-(id)initAndStartWithTarget:(id)queueTarget webView:(UIWebView *)webview
{
    if((self = [self init]))
    {
        [self startQueueWithTarget:queueTarget webView:webview];
    }
    return self;
}

-(void)startQueueWithTarget:(id)queueTarget webView:(UIWebView *)webview
{
    if(!queueTimer)
    {
        NSLog(@"web setting.");
        web = webview;
        NSLog(@"target setting.");
        target = queueTarget;
        NSLog(@"queueTimer setting.");
        queueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f 
                                                      target:self 
                                                    selector:@selector(executeOBJSQueue)
                                                    userInfo:nil
                                                     repeats:YES];
        NSLog(@"isRunning set.");
        isRunning = TRUE;
    }
}

-(void)stopQueue
{
    if(queueTimer && isRunning)
    {
        [queueTimer invalidate];
        queueTimer = nil;
        //target = nil;
        //web = nil;
        isRunning = FALSE;
    }
}

-(void)executeOBJSQueue
{
    //NSLog(@"executeOBJSQueue sent.");
    
    if(!web || !target || !queueTimer){ return; }
    
    //NSLog(@"Execute JSQ");
    NSString *json = [web stringByEvaluatingJavaScriptFromString:@"objsQueue.execute()"];
    
    if(![json isEqualToString:@""])
    {
        NSMutableDictionary *resultsDictionary = [[NSMutableDictionary alloc] initWithDictionary:[json objectFromJSONString]];
        if([resultsDictionary objectForKey:@"method"])
        {
            NSString *namedSelector = [resultsDictionary objectForKey:@"method"];                
            SEL select = NSSelectorFromString(namedSelector);
            if ([target respondsToSelector:select]) 
            {
                NSInvocation* inv = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:select]];
                [inv setTarget:target];
                [inv setSelector:select];                    
                if([resultsDictionary objectForKey:@"params"])
                {
                    for(int i = 0; i < [[resultsDictionary objectForKey:@"params"] count]; i++)
                    {
                        id argument = [[resultsDictionary objectForKey:@"params"] objectAtIndex:i];
                        [inv setArgument:&argument atIndex:i+2];
                    }
                }   
                
                [inv invokeWithTarget:target];
                
                // Crashing on attempt to get a return value even with Try/Catch
                
                //NSLog(@"Method return type: %@, method return bytes: %i", [NSString stringWithCString:[[target methodSignatureForSelector:select] methodReturnType] encoding:NSUTF8StringEncoding], [[target methodSignatureForSelector:select] methodReturnLength]);
                
                if([[target methodSignatureForSelector:select] methodReturnLength] > 0)
                {
                    id anObjectValue;
                    [inv getReturnValue:&anObjectValue];
                    if(anObjectValue)
                    {
                        [resultsDictionary setValue:anObjectValue forKey:@"value"];
                    }
                }else{
                    [resultsDictionary setValue:@"null" forKey:@"value"];
                }
                
                [web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"objsQueue.completed(true, %@)", [resultsDictionary JSONString]]];
                return;
            }
        }
        [web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"objsQueue.completed(false, %@)", [resultsDictionary JSONString]]];
    }
}

@end
