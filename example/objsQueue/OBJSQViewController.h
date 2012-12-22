//
//  OBJSQViewController.h
//  objsQueue
//
//  Created by Adam Bergman on 3/8/12.
//  Copyright (c) 2012 Blue Diesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjsQueue;

@interface OBJSQViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) ObjsQueue *queue;

-(IBAction)switchQueueToggled:(id)sender;
-(IBAction)buttonRefreshTouched:(id)sender;
-(IBAction)buttonExamplesHomeTouched:(id)sender;

-(void)goHome;

@end
