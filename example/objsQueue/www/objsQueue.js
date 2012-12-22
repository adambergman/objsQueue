// objsQueue

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

objsQueue.add = function(methodName, paramsObj, didComplete, didFail)
{
	var item = 
		{
			method: methodName,
			params: paramsObj,
			complete: didComplete.toString(),
			fail: didFail.toString(),
			value: null
		};
	
	objsQueue._queue.push(item);
}

