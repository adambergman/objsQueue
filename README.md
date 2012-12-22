objsQueue 0.9.0
===============

objsQueue is lightweight library that provides connectivity between the content running in a UIWebView and the native, Objective-C application, that contains the UIWebView.  To use it, add the Objective-C library files, then initialize and start the queue.  In your HTML or JavaScript files, import the objQueue.js file, and your web content is now connected to your native app.  For more detailed instructions, see the 'How to Use objsQueue' section below.  The Objective-C portion of this library includes four files: an interface, an implementation, and the JSONKit library.  The JavaScript portion includes one JavaScript file.


How it Works
------------

objsQueue uses an NSTimer in Objective-C to run a JavaScript command (found in objsQueue.js) on your UIWebView every 100ms.  The command responds with the next native method in its queue.  The native method is sent to Objective-C where it is ran and, finally, any callbacks to JavaScript are made.


Background
----------

A traditional pattern for communication between a native application and its UIWebView contents is to use Objective-C to intercept URLs with the UIWebViewDelegate method shouldStartLoadWithRequest.  When the UIWebView tries to navigate to a URL, this delegate method is fired, the URL in the passed request is parsed, and if it meets certain conditions, the request is canceled and routed to native code.  

The above approach is not always reliable because multiple requests, sent in short succession, will fail to make it to the shouldStartLoadWithRequest method.  If you try and send a command to be interpreted by your native code, and try to navigate to a new URL at or around the same time, your command may not go through.  This can also be triggered by a user tapping on a link at the same time as a native request is being sent through.  To solve this problem, setTimeouts or other types of delays are used to allow enough time for a request to be processed before the next one comes in.  

Additionally, callbacks can be tricky to write and hard to maintain. Long conditionals or switch statements have to be used to parse the request URL, and after that, to send data back to JavaScript, you must invoke a named JavaScript function in the page by using the UIWebView's stringByEvaluatingJavaScriptFromString method. 


The Benefits of Using objsQueue
-------------------------------

There is no need for string parsing URLs and writing large conditional blocks, all of your methods are mapped by default.

You can call any native method on the target class from JavaScript without any additional code:

    objsQueue.add('methodSignature', null);

Including methods that take NSString parameters:

	objsQueue.add('methodSignature:withAnotherParam', {params:['param1','param2']});

JavaScript callbacks can be defined at runtime in JavaScript and your native code will automatically map back to them:

	objsQueue.add('methodSignature', { 
										fail:function(obj){ alert('failed') },
										complete:function(obj){ alert('completed') }
									 });	

Multiple method calls can be added to the objsQueue without using setTimeout or other delays.

	for(var i=100; i < 100; i++)
	{
		objsQueue.add('methodSignature', {});
	}
	
You'll have cleaner, more reliable, and more maintainable code!

How to Use objsQueue
--------------------

In your implementation file of the ViewController that owns the UIWebView (in this example the UIWebView is named 'web'):

	#import "ObjsQueue.h"
	...
	@property (nonatomic, retain) ObjsQueue *queue;
	...
	@synthesize queue;
	...
	- (void)viewDidLoad
	{
	    [super viewDidLoad];

		// Please read the Security Concerns.  Ideally, a class should be created
		// that includes only methods you wish to connect to your UIWebView and used 
		// as the target parameter below instead of 'self'.
		
	    // Initalize and Start the Queue
	    queue = [[ObjsQueue alloc] initAndStartWithTarget:self webView:web];  
	}
	
	-(NSString *)methodName
	{
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello World!" 
														message:@"The objsQueue command worked" 
													   delegate:self cancelButtonTitle:@"Dismiss" 
											  otherButtonTitles:nil, nil];
	    [alert show];
	    return @"";
	}

In your HTML/JavaScript:

	<script type="text/javascript" src="objsQueue.js"></script>
	<script type="text/javascript">
		// Adds an objective-c command to objsQueue
		function runCommandNoParams()
		{
    		objsQueue.add("methodName");
		}
	</script>
	
	
A Note About Performance
------------------------

Initially, when approaching this solution, the thought of spamming a JavaScript function using stringByEvaluatingJavaScriptFromString on a UIWebView every 100ms caused performance concerns.  After writing the libraries and testing performance, I was surprisingly satisfied with the results.  

I have included two benchmark tests in the example project.  The first is a simple time test that you can run with objsQueue turned on and then toggle the on/off switch and refresh the page to run with objsQueue turned off (this will stop the NSTimer that is executing the JavaScript command every 100ms).  The second benchmark is a modified version of the SunSpider 0.91 JavaScript benchmark test.  I have added a timer that adds method calls to the objsQueue and the callback outputs the results in to a div.  My results are listed below. 

__Basic Time Test (25,000ms long, 100 native calls made, at 1 call per 250ms)__  

<table cellpadding="6">
	<tr>
		<td><strong>Platform</strong></td>
		<td><strong>Total Time [ON]</strong></td>
		<td><strong>Total Time [OFF]</strong></td>		
		<td><strong>Difference</strong></td>
	</tr>
	<tr>
		<td>iOS 5.1 iPad Simulator</td>
		<td>+159ms</td>
		<td>+130ms</td>
		<td>29ms</td>
	</tr>
	<tr>
		<td>iOS 6.0 iPad Simulator</td>
		<td>+150ms</td>
		<td>+145ms</td>
		<td>5ms</td>
	</tr>
	<tr>
		<td>iPad (3rd Generation) iOS 6.0</td>
		<td>+1,865ms</td>
		<td>+789ms</td>
		<td>1,076ms</td>
	</tr>
</table>

__SunSpider 0.9.1 Benchmark Totals (100 native calls made, at randomized intervals)__  

<table cellpadding="6">
	<tr>
		<td><strong>Platform</strong></td>
		<td><strong>Total Time [ON]</strong></td>
		<td><strong>Total Time [OFF]</strong></td>		
		<td><strong>Difference</strong></td>
	</tr>
	<tr>
		<td>iOS 5.1 iPad Simulator</td>
		<td>899.2ms</td>
		<td>896.6ms</td>
		<td>2.6ms</td>
	</tr>
	<tr>
		<td>iOS 6.0 iPad Simulator</td>
		<td>179.4ms</td>
		<td>178.6ms</td>
		<td>0.8ms</td>
	</tr>
	<tr>
		<td>iPad (3rd Generation) iOS 6.0</td>
		<td>5,501.8ms</td>
		<td>5,495.6ms</td>
		<td>6.2ms</td>
	</tr>
</table>


What's in the Example Project
-----------------------------

In the example project you'll find a single UIViewController (OBJSQViewController.m/h/xib) that contains a UIWebView and imports the objsQueue library.  The UIViewController also contains a UISwitch to toggle the objsQueue timer on and off, and two UIButtons to assist with navigation in the UIWebView (Home and Refresh).  Two example HTML pages and the two benchmark tests are included.  All HTML and JS files are found in the 'www' directory.


Production Usage
----------------

objsQueue should be considered beta software (denoted by the less than 1.0 version number).  The code compiles and works properly, however it has not been tested or deployed in a production environment.  This is not to say that it couldn't be, and if you are interested in doing this, or have done it, please drop me a line and let me know how it works for you.


Security Concerns
-----------------

For simplicity and by design, objsQueue allows you to run _any_ method on the object specified as its target.  This includes inherited methods (dealloc for instance).   Ideally, it's used with HTML and JavaScript code that is local and bundled with the application source.  __If third party sites will be loaded in your UIWebView it is highly recommended that you turn off the objsQueue (using the stopQueue method) before navigating away from a trusted source.__

__It is not recommended to use the host ViewController as the target.__  In the example code, you will notice that the parameter for initAndStartWithTarget is 'self'.  In production, a separate (and safe) class should be created specifically for objsQueue methods and an instance of this class should be set as the target.


Next Steps
----------

Ideally, a 1.0 version would address the security concerns above and support type inspection so that there could be parameter and return types outside of NSString.



Version History
---------------

12/22/2012 - 0.9.0 - Public release to GitHub


Acknowledgements
----------------

objsQueue uses JSONKit written by John Engelhart  
http://github.com/johnezang/JSONKit


License
-------

This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

A simple link to the project page on GitHub or my web site (adambergman.com) is a valid attribution.


Copyright
---------

objsQueue Copyright (c) 2012 Adam Bergman. All rights reserved.   
http://adambergman.com

JSONKit Copyright (c) 2011 John Engelhart  
http://github.com/johnezang/JSONKit
