// objsQueue 0.9

//  This work is licensed under the Creative Commons Attribution 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or
//  send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
//  California, 94041, USA.


var objsQueue = objsQueue || {};

objsQueue._queue = [];


// Function called from Objective-C to get the next 
// bridge function in the queue

objsQueue.execute = function()
{
	if(objsQueue._queue.length > 0)
	{
		return JSON.stringify(objsQueue._queue.shift());
	}
	return null;
}

// Callback function when objective-c has successfully 
// or unsuccessfully executed the queued bridge function

objsQueue.completed = function(success, returnObject)
{
	if(success)
	{
        var completeFunction;
        eval("completeFunction = " + returnObject.complete);
        completeFunction(returnObject);
	}else{
		var failFunction;
        eval("failFunction = " + returnObject.fail);
        failFunction(returnObject);
	}
}

// Function used to add an Objective-C call to the queue 

objsQueue.add = function(methodName, options)
{
   	if(!options){ options = {} }

    var params = {};
    if(options.params){ params = options.params; }
    
    var complete = '';
    if(options.complete){ complete = options.complete.toString(); }
    
    var fail = '';
    if(options.fail){ fail = options.fail.toString(); }
    
	var item = 
		{
			method: methodName,
			params: params,
			complete: complete,
			fail: fail,
			value: null
		};
	
	objsQueue._queue.push(item);
}

