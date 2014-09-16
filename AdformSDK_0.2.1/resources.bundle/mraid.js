//Copyright (c) 2011, The ORMMA.org project authors.
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//- Neither the name of the ORMMA.org nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS MR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER MR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, MR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS MR SERVICES; LOSS OF USE, DATA, MR PROFITS; MR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, MR TORT (INCLUDING NEGLIGENCE MR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(function() {
  var isIOS = (/iphone|ipad|ipod/i).test(window.navigator.userAgent.toLowerCase());
  if (isIOS) {
    console = {};
    console.log = function(log) {
      var iframe = document.createElement('iframe');
      iframe.setAttribute('src', 'ios-log://' + log);
      document.documentElement.appendChild(iframe);
      iframe.parentNode.removeChild(iframe);
      iframe = null;
    };
    console.debug = console.info = console.warn = console.error = console.log;
  }
}());

function finishedLoading() {
  var iframe = document.createElement('iframe');
  iframe.setAttribute('src', 'loading:finished');
  document.documentElement.appendChild(iframe);
  iframe.parentNode.removeChild(iframe);
  iframe = null;
};
window.onload = function(){finishedLoading();};

(function() {
  // Establish the root mraidbridge object.
  var mraidbridge = window.mraidbridge = {};

  // Listeners for bridge events.
  var listeners = {};

  // Queue to track pending calls to the native SDK.
  var nativeCallQueue = [];

  // Whether a native call is currently in progress.
  var nativeCallInFlight = false;

  //////////////////////////////////////////////////////////////////////////////////////////////////

  mraidbridge.fireReadyEvent = function() {
    mraidbridge.fireEvent('ready');
  };

  mraidbridge.fireChangeEvent = function(properties) {
    mraidbridge.fireEvent('change', properties);
  };

  mraidbridge.fireErrorEvent = function(message, action) {
    mraidbridge.fireEvent('error', message, action);
  };

  mraidbridge.fireEvent = function(type) {
    var ls = listeners[type];
    if (ls) {
      var args = Array.prototype.slice.call(arguments);
      args.shift();
      var l = ls.length;
      for (var i = 0; i < l; i++) {
        ls[i].apply(null, args);
      }
    }
  };

  mraidbridge.nativeCallComplete = function(command) {

    if (nativeCallQueue.length === 0) {
      nativeCallInFlight = false;
      return;
    }

    var nextCall = nativeCallQueue.pop();
    mraidbridge.openLocation(nextCall);
  };

  mraidbridge.executeNativeCall = function(command) {
    var call = 'mraid://' + command;

    var key, value;
    var isFirstArgument = true;

    for (var i = 1; i < arguments.length; i += 2) {
      key = arguments[i];
      value = arguments[i + 1];

      if (value === null) continue;

      if (isFirstArgument) {
        call += '?';
        isFirstArgument = false;
      } else {
        call += '&';
      }

      call += encodeURIComponent(key) + '=' + encodeURIComponent(value);
    }

    if (nativeCallInFlight) {
      nativeCallQueue.push(call);
    } else {
      nativeCallInFlight = true;
      //window.location = call;
      mraidbridge.openLocation(call);
    }
  };

  mraidbridge.openLocation = function(call) {
    var iframe = document.createElement('iframe');

    iframe.setAttribute('src', call);  
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////

  mraidbridge.addEventListener = function(event, listener) {
    var eventListeners;
    listeners[event] = listeners[event] || [];
    eventListeners = listeners[event];

    for (var l in eventListeners) {
      // Listener already registered, so no need to add it.
      if (listener === l) return;
    }

    eventListeners.push(listener);
  };

  mraidbridge.removeEventListener = function(event, listener) {
    if (listeners.hasOwnProperty(event)) {
      var eventListeners = listeners[event];
      if (eventListeners) {
        var idx = eventListeners.indexOf(listener);
        if (idx !== -1) {
          eventListeners.splice(idx, 1);
        }
      }
    }
  };
}());

(function() {
  var mraid = window.mraid = {};
  var bridge = window.mraidbridge;

  // Constants. ////////////////////////////////////////////////////////////////////////////////////

  var VERSION = '2.0';

  var STATES = {
    LOADING: 'loading',     // Initial state.
    DEFAULT: 'default',
    EXPANDED: 'expanded',
    HIDDEN: 'hidden',
    RESIZED: 'resized'
  };

  var EVENTS = {
    ERROR: 'error',
    READY: 'ready',
    STATECHANGE: 'stateChange',
    VIEWABLECHANGE: 'viewableChange',
    SIZECHANGE: 'sizeChange'
  };

  var PLACEMENT_TYPES = {
    UNKNOWN: 'unknown',
    INLINE: 'inline',
    INTERSTITIAL: 'interstitial'
  };

  // External MRAID state: may be directly or indirectly modified by the ad JS. ////////////////////

  // Properties which define the behavior of an expandable ad.
  var expandProperties = {
    width: -1,
    height: -1,
    useCustomClose: false,
    isModal: true,
  };

  var hasSetExpandPropertiesSize = false;

  var hasSetCustomClose = false;

  var listeners = {};

  // Internal MRAID state. Modified by the native SDK. /////////////////////////////////////////////

  var state = STATES.LOADING;

  var isViewable = false;

  var screenSize = { width: -1, height: -1 };

  var placementType = PLACEMENT_TYPES.UNKNOWN;

  var supports = {
    sms: false,
    tel: false,
    calendar: false,
    storePicture: false,
    inlineVideo: false
  };

  var defaultPosition = {x: 0, y: 0, width: 0, height: 0};

  var currentPosition = {x: 0, y: 0, width: 0, height: 0};

  var maxSize = {width: 0, height: 0};

  var orientationProperties = {allowOrientationChange: true, forceOrientation: 'none'};

  var resizeProperties = {
    width: null,
    height: null,
    offsetX: null,
    offsetY: null,
    customClosePosition: 'top-right',
    allowOffscreen: true
  } 

  //////////////////////////////////////////////////////////////////////////////////////////////////

  var EventListeners = function(event) {
    this.event = event;
    this.count = 0;
    var listeners = {};

    this.add = function(func) {
      var id = String(func);
      if (!listeners[id]) {
        listeners[id] = func;
        this.count++;
      }
    };

    this.remove = function(func) {
      var id = String(func);
      if (listeners[id]) {
        listeners[id] = null;
        delete listeners[id];
        this.count--;
        return true;
      } else {
        return false;
      }
    };

    this.removeAll = function() {
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) this.remove(listeners[id]);
      }
    };

    this.broadcast = function(args) {
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) listeners[id].apply({}, args);
      }
    };

    this.toString = function() {
      var out = [event, ':'];
      for (var id in listeners) {
        if (listeners.hasOwnProperty(id)) out.push('|', id, '|');
      }
      return out.join('');
    };
  };

  var broadcastEvent = function() {
    var args = new Array(arguments.length);
    var l = arguments.length;
    for (var i = 0; i < l; i++) args[i] = arguments[i];
      var event = args.shift();
    if (listeners[event]) listeners[event].broadcast(args);
  };

  var contains = function(value, array) {
    for (var i in array) {
      if (array[i] === value) return true;
    }
    return false;
  };

  var clone = function(obj) {
    if (obj === null) return null;
    var f = function() {};
    f.prototype = obj;
    return new f();
  };

  var stringify = function(obj) {
    if (typeof obj === 'object') {
      var out = [];
      if (obj.push) {
        // Array.
        for (var p in obj) out.push(obj[p]);
          return '[' + out.join(',') + ']';
      } else {
        // Other object.
        for (var p in obj) out.push("'" + p + "': " + obj[p]);
          return '{' + out.join(',') + '}';
      }
    } else return String(obj);
  };

  var trim = function(str) {
    return str.replace(/^\s+|\s+$/g, '');
  };

  // Functions that will be invoked by the native SDK whenever a "change" event occurs.
  var changeHandlers = {
    state: function(val) {
      state = val;
      broadcastEvent(EVENTS.STATECHANGE, state);
    },

    viewable: function(val) {
      isViewable = val;
      broadcastEvent(EVENTS.VIEWABLECHANGE, isViewable);
    },

    placementType: function(val) {
      placementType = val;
    },

    screenSize: function(val) {
      for (var key in val) {
        if (val.hasOwnProperty(key)) screenSize[key] = val[key];
      }

      if (!hasSetExpandPropertiesSize) {
        expandProperties['width'] = screenSize['width'];
        expandProperties['height'] = screenSize['height'];
      }
    },

    expandProperties: function(val) {
      for (var key in val) {
        if (val.hasOwnProperty(key)) expandProperties[key] = val[key];
      }
    },

    supports: function(val) {
      supports = val;
    },

    defaultPosition: function(val) {
      for (var key in val) {
        if (val.hasOwnProperty(key)) defaultPosition[key] = val[key];
      }
    },

    currentPosition: function(val) {
      for (var key in val) {
        if (val.hasOwnProperty(key)) currentPosition[key] = val[key];
      }
    },

    maxSize: function(val) {
      for (var key in val) {
        if (val.hasOwnProperty(key)) maxSize[key] = val[key];
      }
    },

    size: function(val) {
      broadcastEvent(EVENTS.SIZECHANGE, val['width'], val['height']);
    },
  };

  var validate = function(obj, validators, action, mandatory) {

    if (obj === null) {
      broadcastEvent(EVENTS.ERROR, 'Required object not provided.', action);
      return false;
    }  

    var length = 0;
    if (mandatory != null) {
      length = mandatory.length;
    }
    for (var i = 0; i < length; i ++) {
      var propname = mandatory[i];
      if (!obj.hasOwnProperty(propname)) {
        broadcastEvent(EVENTS.ERROR, 'Object is missing required property: ' + propname + '.', action);
        return false;
      }
    }

    for (var prop in obj) {
      var validator = validators[prop];
      var value = obj[prop];
      if (validator && !validator(value)) {
        // Failed validation.
        broadcastEvent(EVENTS.ERROR, 'Value of property ' + prop + ' is invalid.', action);
        return false;
      }
    }
    return true;
  };

  var expandPropertyValidators = {
    width: function(v) { return !isNaN(v) && (v % 1) === 0 && v >= 0; },
    height: function(v) { return !isNaN(v) && (v % 1) === 0 && v >= 0; },
    useCustomClose: function(v) { return v !== null && typeof v === 'boolean'; },
    isModal: function(v) { return false; },
  };

  //////////////////////////////////////////////////////////////////////////////////////////////////

  bridge.addEventListener('change', function(properties) {
    for (var p in properties) {
      if (properties.hasOwnProperty(p)) {
        var handler = changeHandlers[p];
        handler(properties[p]);
      }
    }
  });

  bridge.addEventListener('error', function(message, action) {
    broadcastEvent(EVENTS.ERROR, message, action);
  });

  bridge.addEventListener('ready', function() {
    broadcastEvent(EVENTS.READY);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  mraid.addEventListener = function(event, listener) {
    if (!event || !listener) {
      broadcastEvent(EVENTS.ERROR, 'Both event and listener are required.', 'addEventListener');
    } else if (!contains(event, EVENTS)) {
      broadcastEvent(EVENTS.ERROR, 'Unknown MRAID event: ' + event, 'addEventListener');
    } else {
      if (!listeners[event]) listeners[event] = new EventListeners(event);
      listeners[event].add(listener);
    }
  };

  mraid.close = function() {
    if (state === STATES.HIDDEN) {
      broadcastEvent(EVENTS.ERROR, 'Ad cannot be closed when it is already hidden.',
        'close');
    } else bridge.executeNativeCall('close');
  };

  mraid.expand = function(URL) {
    if (this.getState() !== STATES.DEFAULT && this.getState() !== STATES.RESIZED) {
      broadcastEvent(EVENTS.ERROR, 'Ad can only be expanded from the default or resized states.', 'expand');
    } else {
      var args = ['expand'];

      if (hasSetCustomClose) {
        args = args.concat(['useCustomClose', expandProperties.useCustomClose ? 'true' : 'false']);
      }

      if (hasSetExpandPropertiesSize) {
        if (expandProperties.width >= 0 && expandProperties.height >= 0) {
          args = args.concat(['width', expandProperties.width, 'height', expandProperties.height]);
        }
      }

      if (URL) {
        args = args.concat(['url', URL]);
      }

      bridge.executeNativeCall.apply(this, args);
    }
  };

  mraid.getExpandProperties = function() {
    var properties = {
      width: expandProperties.width,
      height: expandProperties.height,
      useCustomClose: expandProperties.useCustomClose,
      isModal: expandProperties.isModal
    };
    return properties;
  };

  mraid.getOrientationProperties = function() {
  	var properties = {
  		allowOrientationChange: orientationProperties.allowOrientationChange,
  		forceOrientation: orientationProperties.forceOrientation
  	};
  	return properties;
  };

  mraid.resize = function() {

    if (this.getState() !== STATES.DEFAULT && this.getState() !== STATES.RESIZED) {
      broadcastEvent(EVENTS.ERROR, 'Ad can only be expanded from the default or resized state.', 'resize');
    } else if (areResizePropertiesSet()) {
      var args = ['resize'];

      if (resizeProperties.width >= 50 && resizeProperties.height >= 50) {
        args = args.concat(['width', resizeProperties.width, 'height', resizeProperties.height]);
      }

      args = args.concat(['offsetX', resizeProperties.offsetX, 'offsetY', resizeProperties.offsetY]);

      if (resizeProperties.customClosePosition !== null) {
        args = args.concat(['customClosePosition', resizeProperties.customClosePosition]);
      }

      if (typeof resizeProperties.allowOffscreen === 'boolean') {
        args = args.concat(['allowOffscreen', resizeProperties.allowOffscreen ? 'true' : 'false']);
      }

      bridge.executeNativeCall.apply(this, args);
    }
  };

  areResizePropertiesSet = function() {
    var valid = true;
    var errorMessage = 'Resize properties: ';

    if (resizeProperties.width === null) {
      errorMessage += 'width, ';
      valid = false;
    } 
    if (resizeProperties.height === null) {
      errorMessage += 'height, ';
      valid = false;
    } 
    if (resizeProperties.offsetX === null) {
      errorMessage += 'offsetX, ';
      valid = false;
    } 
    if (resizeProperties.offsetY === null) {
      errorMessage += 'offsetY ';
      valid = false;
    }

    if (!valid) {
      errorMessage += 'must be set before calling mraid.resize().';
      broadcastEvent(EVENTS.ERROR, errorMessage, 'resize');
    }

    return valid;
  };

  var resizePropertyValidators = {
    width: function(v) { return !isNaN(v) && (v % 1) === 0 && v >= 50; },
    height: function(v) { return !isNaN(v) && (v % 1) === 0 && v >= 50; },
    offsetX: function(v) { return !isNaN(v) && (v % 1) === 0; },
    offsetY: function(v) { return !isNaN(v) && (v % 1) === 0; },
    customClosePosition: function(v) { return v !== null && typeof v === 'string'; },
    allowOffscreen: function(v) { return v !== null && typeof v === 'boolean'; },
  };

  checkResizeProperties = function(properties) {

    var validPositions = ['top-left', 'top-center', 'top-right' ,'center', 'bottom-left', 'bottom-center', 'bottom-right'];
    var customClosePosition = resizeProperties['customClosePosition'];
    if (properties.hasOwnProperty('customClosePosition')) {
     customClosePosition = properties['customClosePosition'];
     var index = validPositions.indexOf(customClosePosition);
     if (index < 0) {
      broadcastEvent(EVENTS.ERROR, 'Value of property customClosePosition is invalid.', 'setResizeProperties');
      return false;
    }
  }
  var allowOffscreen = resizeProperties.allowOffscreen;
  if (properties.hasOwnProperty('allowOffscreen')) {
    allowOffscreen = properties['allowOffscreen'];
  }

  if (!allowOffscreen && (properties['height'] > maxSize.height || properties['width'] > maxSize.width)) {
    broadcastEvent(EVENTS.ERROR, '"Invalid size, it doesn\'t fit in maxSize.', 'setResizeProperties');
    return false;

  } else if (allowOffscreen) {
    var index = validPositions.indexOf(customClosePosition);
    var closeRegionRect = rectForCloseIndicator(index, {width: properties['width'], height: properties['height']});

    closeRegionRect.x += (currentPosition.x + properties['offsetX']);
    closeRegionRect.y += (currentPosition.y + properties['offsetY']);

    if (closeRegionRect.x < 0 
      || closeRegionRect.y < 0
      || closeRegionRect.x + closeRegionRect.width > maxSize.width
      || closeRegionRect.y + closeRegionRect.height > maxSize.height) {
      broadcastEvent(EVENTS.ERROR, '"Provided resize properties will result in the close event region being offscreen.', 'setResizeProperties');
    return false;
  }
}
return true;
};

rectForCloseIndicator = function(index, size) {
  var indicatorRect = {
    x: 0,
    y: 0,
    width: 50,
    height: 50
  };
  switch(index) {
    case 0:
    break;
    case 1:
    indicatorRect.x = (size.width - 50) / 2;
    break;
    case 2:
    indicatorRect.x = (size.width - 50);
    break;
    case 3:
    indicatorRect.x = (size.width - 50) / 2;
    indicatorRect.y = (size.height - 50) / 2;
    break;
    case 4:
    indicatorRect.y = (size.height - 50);
    break;
    case 5:
    indicatorRect.x = (size.width - 50) / 2;
    indicatorRect.y = (size.height - 50);
    break;
    case 6:
    indicatorRect.x = (size.width - 50);
    indicatorRect.y = (size.height - 50);
    break;
  }

  return indicatorRect;
};

mraid.getResizeProperties = function() {
  return resizeProperties;
};

mraid.setResizeProperties = function(properties) {

  if (validate(properties, resizePropertyValidators, 'setResizeProperties', ['width', 'height', 'offsetX', 'offsetY'])) {

    checkResizeProperties(properties)

    var desiredProperties = ['width', 'height', 'offsetX', 'offsetY', 'customClosePosition', 'allowOffscreen'];
  var length = desiredProperties.length;
  for (var i = 0; i < length; i++) {
    var propname = desiredProperties[i];
    if (properties.hasOwnProperty(propname)) resizeProperties[propname] = properties[propname];
  } 
}
};

mraid.getPlacementType = function() {
  return placementType;
};

mraid.getState = function() {
  return state;
};

mraid.getVersion = function() {
  return VERSION;
};

mraid.isViewable = function() {
  return isViewable;
};

mraid.open = function(URL) {
  if (!URL) broadcastEvent(EVENTS.ERROR, 'URL is required.', 'open');
  else bridge.executeNativeCall('open', 'url', URL);
};

mraid.removeEventListener = function(event, listener) {
  if (!event) broadcastEvent(EVENTS.ERROR, 'Event is required.', 'removeEventListener');
  else {
    if (listener && (!listeners[event] || !listeners[event].remove(listener))) {
      broadcastEvent(EVENTS.ERROR, 'Listener not currently registered for event.', 'removeEventListener');
      return;
    } else if (listeners[event]) listeners[event].removeAll();

    if (listeners[event] && listeners[event].count === 0) {
      listeners[event] = null;
      delete listeners[event];
    }
  }
};

mraid.setExpandProperties = function(properties) {
  if (validate(properties, expandPropertyValidators, 'setExpandProperties', null)) {
    if (properties.hasOwnProperty('width') || properties.hasOwnProperty('height')) {
      hasSetExpandPropertiesSize = true;
    }
    if (properties.hasOwnProperty('useCustomClose')) hasSetCustomClose = true;

    var desiredProperties = ['width', 'height', 'useCustomClose'];
    var length = desiredProperties.length;
    for (var i = 0; i < length; i++) {
      var propname = desiredProperties[i];
      if (properties.hasOwnProperty(propname)) expandProperties[propname] = properties[propname];
    }
  }
};

mraid.setOrientationProperties = function(properties) {

 if (properties.hasOwnProperty('allowOrientationChange')) {
  orientationProperties['allowOrientationChange'] = properties['allowOrientationChange'];
}
if (properties.hasOwnProperty('forceOrientation')) {
  orientationProperties['forceOrientation'] = properties['forceOrientation'];
}

bridge.executeNativeCall.apply(this, ['orientationProperties', 'allowOrientationChange', orientationProperties.allowOrientationChange, 'forceOrientation', orientationProperties.forceOrientation]);
};

mraid.useCustomClose = function(shouldUseCustomClose) {
  expandProperties.useCustomClose = shouldUseCustomClose;
  hasSetCustomClose = true;
  bridge.executeNativeCall('useCustomClose', 'shouldUseCustomClose', shouldUseCustomClose);
};

  // MRAID 2.0 APIs ////////////////////////////////////////////////////////////////////////////////

  mraid.createCalendarEvent = function(parameters) {
    CalendarEventParser.initialize(parameters);
    if (CalendarEventParser.parse()) {
      bridge.executeNativeCall.apply(this, CalendarEventParser.arguments);
    } else {
      broadcastEvent(EVENTS.ERROR, CalendarEventParser.errors[0], 'createCalendarEvent');
    }
  };

  mraid.supports = function(feature) {
    return supports[feature];
  };

  mraid.playVideo = function(uri) {
    if (!mraid.isViewable()) {
      broadcastEvent(EVENTS.ERROR, 'playVideo cannot be called until the ad is viewable', 'playVideo');
      return;
    }

    if (!uri) {
      broadcastEvent(EVENTS.ERROR, 'playVideo must be called with a valid URI', 'playVideo');
    } else {
      bridge.executeNativeCall.apply(this, ['playVideo', 'uri', uri]);
    }
  };

  mraid.storePicture = function(uri) {
    if (!mraid.isViewable()) {
      broadcastEvent(EVENTS.ERROR, 'storePicture cannot be called until the ad is viewable', 'storePicture');
      return;
    }

    if (!uri) {
      broadcastEvent(EVENTS.ERROR, 'storePicture must be called with a valid URI', 'storePicture');
    } else {
      bridge.executeNativeCall.apply(this, ['storePicture', 'uri', uri]);
    }
  };

  mraid.getCurrentPosition = function() {
    //bridge.executeNativeCall('getCurrentPosition');
    return currentPosition;
  };

  mraid.getDefaultPosition = function() {
    //bridge.executeNativeCall('getDefaultPosition');
    return defaultPosition;
  };

  mraid.getMaxSize = function() {
    //bridge.executeNativeCall('getMaxSize');
    return maxSize;
  };

  mraid.getScreenSize = function() {
 //bridge.executeNativeCall('getScreenSize');
 return screenSize;
};

var CalendarEventParser = {
  initialize: function(parameters) {
    this.parameters = parameters;
    this.errors = [];
    this.arguments = ['createCalendarEvent'];
  },

  parse: function() {
    if (!this.parameters) {
      this.errors.push('The object passed to createCalendarEvent cannot be null.');
    } else {
      this.parseDescription();
      this.parseLocation();
      this.parseSummary();
      this.parseStartAndEndDates();
      this.parseReminder();
      this.parseRecurrence();
      this.parseTransparency();
    }

    var errorCount = this.errors.length;
    if (errorCount) {
      this.arguments.length = 0;
    }

    return (errorCount === 0);
  },

  parseDescription: function() {
    this._processStringValue('description');
  },

  parseLocation: function() {
    this._processStringValue('location');
  },

  parseSummary: function() {
    this._processStringValue('summary');
  },

  parseStartAndEndDates: function() {
    this._processDateValue('start');
    this._processDateValue('end');
  },

  parseReminder: function() {
    var reminder = this._getParameter('reminder');
    if (!reminder) {
      return;
    }

    if (reminder < 0) {
      this.arguments.push('relativeReminder');
      this.arguments.push(parseInt(reminder) / 1000);
    } else {
      this.arguments.push('absoluteReminder');
      this.arguments.push(reminder);
    }
  },

  parseRecurrence: function() {
    var recurrenceDict = this._getParameter('recurrence');
    if (!recurrenceDict) {
      return;
    }

    this.parseRecurrenceInterval(recurrenceDict);
    this.parseRecurrenceFrequency(recurrenceDict);
    this.parseRecurrenceEndDate(recurrenceDict);
    this.parseRecurrenceArrayValue(recurrenceDict, 'daysInWeek');
    this.parseRecurrenceArrayValue(recurrenceDict, 'daysInMonth');
    this.parseRecurrenceArrayValue(recurrenceDict, 'daysInYear');
    this.parseRecurrenceArrayValue(recurrenceDict, 'monthsInYear');
  },

  parseTransparency: function() {
    var validValues = ['opaque', 'transparent'];

    if (this.parameters.hasOwnProperty('transparency')) {
      var transparency = this.parameters['transparency'];
      if (contains(transparency, validValues)) {
        this.arguments.push('transparency');
        this.arguments.push(transparency);
      } else {
        this.errors.push('transparency must be opaque or transparent');
      }
    }
  },

  parseRecurrenceArrayValue: function(recurrenceDict, kind) {
    if (recurrenceDict.hasOwnProperty(kind)) {
      var array = recurrenceDict[kind];
      if (!array || !(array instanceof Array)) {
        this.errors.push(kind + ' must be an array.');
      } else {
        var arrayStr = array.join(',');
        this.arguments.push(kind);
        this.arguments.push(arrayStr);
      }
    }
  },

  parseRecurrenceInterval: function(recurrenceDict) {
    if (recurrenceDict.hasOwnProperty('interval')) {
      var interval = recurrenceDict['interval'];
      if (!interval) {
        this.errors.push('Recurrence interval cannot be null.');
      } else {
        this.arguments.push('interval');
        this.arguments.push(interval);
      }
    } else {
        // If a recurrence rule was specified without an interval, use a default value of 1.
        this.arguments.push('interval');
        this.arguments.push(1);
      }
    },

    parseRecurrenceFrequency: function(recurrenceDict) {
      if (recurrenceDict.hasOwnProperty('frequency')) {
        var frequency = recurrenceDict['frequency'];
        var validFrequencies = ['daily', 'weekly', 'monthly', 'yearly'];
        if (contains(frequency, validFrequencies)) {
          this.arguments.push('frequency');
          this.arguments.push(frequency);
        } else {
          this.errors.push('Recurrence frequency must be one of: "daily", "weekly", "monthly", "yearly".');
        }
      }
    },

    parseRecurrenceEndDate: function(recurrenceDict) {
      var expires = recurrenceDict['expires'];

      if (!expires) {
        return;
      }

      this.arguments.push('expires');
      this.arguments.push(expires);
    },

    _getParameter: function(key) {
      if (this.parameters.hasOwnProperty(key)) {
        return this.parameters[key];
      }

      return null;
    },

    _processStringValue: function(kind) {
      if (this.parameters.hasOwnProperty(kind)) {
        var value = this.parameters[kind];
        this.arguments.push(kind);
        this.arguments.push(value);
      }
    },

    _processDateValue: function(kind) {
      if (this.parameters.hasOwnProperty(kind)) {
        var dateString = this._getParameter(kind);
        this.arguments.push(kind);
        this.arguments.push(dateString);
      }
    },
  };
}());