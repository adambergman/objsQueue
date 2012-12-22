//
//  ObjsQueue.h
//  objsQueue
//
//  Created by Bergman, Adam on 3/13/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjsQueue : NSObject

@property (nonatomic, assign) BOOL isRunning;

-(id)initAndStartWithTarget:(id)queueTarget webView:(UIWebView *)webview;
-(void)startQueueWithTarget:(id)queueTarget webView:(UIWebView *)webview;
-(void)stopQueue;

@end
