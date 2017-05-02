// Copyright (c) 2017 Mystic Pants Pty Ltd
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

// nextTick - a simple function to manage all imp.wakeup(0, callback) executions 
// with a single timer.
function nextTick(callback) {
    // Put the callback function into the queue and create it if required
    if (!("ntQ" in getroottable())) {
        ::ntQ <- [];
        ::ntFn <- null;
    }
    if (callback) ::ntQ.push(callback);
    
    // If we aren't busy running a function, pop one off the queue now
    if (::ntFn == null && ::ntQ.len() > 0) {
        ::ntFn = ::ntQ.remove(0);
        imp.wakeup(0, function() {
            ::ntFn();
            ::ntFn = null;
            // Go back to see if the queue is full still
            if (::ntQ.len() > 0) nextTick(null);
        }.bindenv(this));
    }
}
