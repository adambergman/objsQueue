//
//  OBJSQViewController.m
//  objsQueue
//
//  Created by Adam Bergman on 3/8/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//
#import <Twitter/Twitter.h>

#import "OBJSQViewController.h"
#import "ObjsQueue.h"


@implementation OBJSQViewController

@synthesize web;
@synthesize queue;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Initalize and Start the Queue
    queue = [[ObjsQueue alloc] initAndStartWithTarget:self webView:web];
    
    [self goHome];
}

// A method with a return value called from Javascript
// Examples of this method call can be found in:
//      /www/example_simple.html
//      /www/sunspider/sunspider-0.9.1/driver.html
//      /www/time_benchmark.html

-(NSString *)methodName:(NSString *)first secondString:(NSString *)second
{
    return @"This string is returned from an objective-c function.";
}

// A method called from JavaScript to send a Tweet
// Examples of this method call can be found in:
//      /www/example_twitter.html

-(void)sendTweet:(NSString *)message
{
    if([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];
        [tweet setInitialText:message];
        
        [self presentModalViewController:tweet animated:YES];
        
        [tweet setCompletionHandler:^(TWTweetComposeViewControllerResult result) 
        {
            [self dismissModalViewControllerAnimated:YES];
        }];

    }
}

-(void)openTweet
{
    [self sendTweet:@""];
}

// Example of starting and stoping an existing queue

-(IBAction)switchQueueToggled:(id)sender
{
    if(!queue){ return; }
    if(queue.isRunning)
    {
        [queue stopQueue];
    }else{
        [queue startQueueWithTarget:self webView:web];
    }    
}

// Refresh button action - reloads the current page
-(IBAction)buttonRefreshTouched:(id)sender
{
    // If on the SunSpider results page, reload driver.html instead.
    if([web.request.URL.absoluteString rangeOfString:@"results"].location != NSNotFound)
    {
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"/www/sunspider/sunspider-0.9.1/driver" ofType:@"html"] isDirectory:NO]]];
    }else{
        [web reload];
    }
}

// Home button action
-(IBAction)buttonExamplesHomeTouched:(id)sender
{
    [self goHome];
}

// Navigate to the Examples index
-(void)goHome
{
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"www/index" ofType:@"html"] isDirectory:NO]]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Stop the Queue and destroy it
    [queue stopQueue];
    queue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){ return NO; }
	return YES;
}

@end
