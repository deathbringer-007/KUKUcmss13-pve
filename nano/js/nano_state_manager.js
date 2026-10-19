// NanoStateManager handles data from the server and uses it to render templates
NanoStateManager = function () 
{
	// _isInitialised is set to true when all of this ui's templates have been processed/rendered
	var _isInitialised = false;

	// the data for this ui
	var _data = null;
	
	// this is an array of callbacks which are called when new data arrives, before it is processed
	var _beforeUpdateCallbacks = {};
	// this is an array of callbacks which are called when new data arrives, before it is processed
	var _afterUpdateCallbacks = {};		
	
	// this is an array of state objects, these can be used to provide custom javascript logic
	var _states = {};	
	
	var _currentState = null;
	
	// the init function is called when the ui has loaded
	// this function sets up the templates and base functionality
	var init = function () 
	{
		// We store initialData and templateData in the body tag, it's as good a place as any
		_data = window.initial_data;
		
		if (_data == null || !_data.hasOwnProperty('config') || !_data.hasOwnProperty('data'))
		{
			alert('错误：初始数据未能正确加载。');
		}

		var stateKey = 'default';
		if (_data['config'].hasOwnProperty('stateKey') && _data['config']['stateKey'])
		{
			stateKey = _data['config']['stateKey'].toLowerCase();
		}

		NanoStateManager.setCurrentState(stateKey);
		
		$(document).on('templatesLoaded', function () {
			doUpdate(_data);
			
			_isInitialised = true;
		});
	};
	
	// Receive update data from the server
	var receiveUpdateData = function (jsonString)
	{
		var updateData;
		try
		{
			jsonString = jsonString.replace("\\improper","").replace("\\proper","")
			// parse the JSON string from the server into a JSON object
			updateData = jQuery.parseJSON(jsonString);
		}
		catch (error)
		{
			alert(error.Message);
			return;
		}

		if (!updateData.hasOwnProperty('data'))
		{
			if (_data && _data.hasOwnProperty('data'))
			{
				updateData['data'] = _data['data'];
			}
			else
			{
				updateData['data'] = {};
			}
		}
		
		if (_isInitialised) // all templates have been registered, so render them
		{
			doUpdate(updateData);
		}
		else
		{
			_data = updateData; // all templates have not been registered. We set _data directly here which will be applied after the template is loaded with the initial data
		}	
	};

	// This function does the update by calling the methods on the current state
	var doUpdate = function (data)
	{
        if (_currentState == null)
        {
            return;
        }

		data = _currentState.onBeforeUpdate(data);

		if (data === false)
		{
            alert('界面更新已取消。');
			return; // A beforeUpdateCallback returned a false value, this prevents the render from occuring
		}
		
		_data = data;

        _currentState.onUpdate(_data);

        _currentState.onAfterUpdate(_data);
	};
	
	// Execute all callbacks in the callbacks array/object provided, updateData is passed to them for processing and potential modification
	var executeCallbacks = function (callbacks, data)
	{	
		for (var key in callbacks)
		{
			if (callbacks.hasOwnProperty(key) && jQuery.isFunction(callbacks[key]))
			{
                data = callbacks[key].call(this, data);
			}
		}
		
		return data;
	};

	return {
        init: function () 
		{
            init();
        },
		receiveUpdateData: function (jsonString) 
		{
			receiveUpdateData(jsonString);
        },
		addBeforeUpdateCallback: function (key, callbackFunction)
		{
			_beforeUpdateCallbacks[key] = callbackFunction;
		},
		addBeforeUpdateCallbacks: function (callbacks) {		
			for (var callbackKey in callbacks) {
				if (!callbacks.hasOwnProperty(callbackKey))
				{
					continue;
				}
				NanoStateManager.addBeforeUpdateCallback(callbackKey, callbacks[callbackKey]);
			}
		},
		removeBeforeUpdateCallback: function (key)
		{
			if (_beforeUpdateCallbacks.hasOwnProperty(key))
			{
				delete _beforeUpdateCallbacks[key];
			}
		},
        executeBeforeUpdateCallbacks: function (data) {
            return executeCallbacks(_beforeUpdateCallbacks, data);
        },
		addAfterUpdateCallback: function (key, callbackFunction)
		{
			_afterUpdateCallbacks[key] = callbackFunction;
		},
		addAfterUpdateCallbacks: function (callbacks) {		
			for (var callbackKey in callbacks) {
				if (!callbacks.hasOwnProperty(callbackKey))
				{
					continue;
				}
				NanoStateManager.addAfterUpdateCallback(callbackKey, callbacks[callbackKey]);
			}
		},
		removeAfterUpdateCallback: function (key)
		{
			if (_afterUpdateCallbacks.hasOwnProperty(key))
			{
				delete _afterUpdateCallbacks[key];
			}
		},
        executeAfterUpdateCallbacks: function (data) {
            return executeCallbacks(_afterUpdateCallbacks, data);
        },
		addState: function (state)
		{
			if (!(state instanceof NanoStateClass))
			{
				alert('错误：无法添加状态，提供的对象不是NanoStateClass的实例。');
				return;
			}
			if (!state.key)
			{
				alert('错误：无法添加状态，stateKey无效。');
				return;
			}
			_states[state.key] = state;
		},
		setCurrentState: function (stateKey)
		{
			if (typeof stateKey == 'undefined' || !stateKey) {
				alert('错误：未提供状态键！');
                return false;
            }
			if (!_states.hasOwnProperty(stateKey))
			{
				alert('错误：无法切换到不存在的状态：' + stateKey);
				return false;
			}			
			
			var previousState = _currentState;
			
            _currentState = _states[stateKey];

            if (previousState != null) {
                previousState.onRemove(_currentState);
            }            
			
			_currentState.onAdd(previousState);

            return true;
		},
		getCurrentState: function ()
		{
			return _currentState;
		}
	};
} ();
