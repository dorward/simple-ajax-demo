(function (){

var messages_container;

var wait_then_go = function () {
	// Succeed or fail - we poll every 30 seconds
	setTimeout(update_messages, 30000);
};

var update_messages_fail = function () {
	wait_then_go();
};

var update_messages_success = function (data) {
	// Are they are messages?
	if (data.messages.length) {
		// There are new messages
		var i = data.messages.length;
		while (i--) {
			var message = data.messages[i];
			
			var container = document.createElement('div');
			var heading = document.createElement('h2');
			heading.appendChild(document.createTextNode(message.user));
			var paragraph = document.createElement('p');
			paragraph.appendChild(document.createTextNode(message.message));
			var date = document.createElement('p');
			date.appendChild(document.createTextNode(message.time));
			container.appendChild(heading);
			container.appendChild(paragraph);
			container.appendChild(date);
			messages_container.insertBefore(container, messages_container.firstChild);
		}
		messages_container.className = "most_recent_message_" + data.most_recent;
	}
	wait_then_go();
};

var update_messages = function (){

	// Identify last known message
	messages_container = document.getElementById('messages');
	var className = messages_container.className;
	var id = className.match(/message_(\d+)/)[1];

	// Make Ajax request and tell it what functions to use to handle the response
	var conf = {
		success    : update_messages_success,
		error      : update_messages_fail,
		url        : "/demo.pl?type=json;start=" + encodeURIComponent(id),
		dataType   : "json"
	};
	jQuery.ajax(conf);
};

// Start the cycle on page load
jQuery(document).ready(update_messages);

}());