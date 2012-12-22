//
//  OBJSQViewController.h
//  objsQueue
//
//  Created by Adam Bergman on 3/8/12.
//  Copyright (c) 2012 Adam Bergman. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or
//  send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
//  California, 94041, USA.


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
