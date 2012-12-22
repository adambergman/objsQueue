//
//  ObjsQueue.h
//  objsQueue
//
//  Created by Bergman, Adam on 3/13/12.
//  Copyright (c) 2012 Adam Bergman. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or
//  send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
//  California, 94041, USA.

#import <Foundation/Foundation.h>

@interface ObjsQueue : NSObject

@property (nonatomic, assign) BOOL isRunning;

-(id)initAndStartWithTarget:(id)queueTarget webView:(UIWebView *)webview;
-(void)startQueueWithTarget:(id)queueTarget webView:(UIWebView *)webview;
-(void)stopQueue;

@end
