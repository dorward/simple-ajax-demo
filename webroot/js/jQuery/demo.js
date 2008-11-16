jQuery(document).ready(function (){
	var conf = {
		success    : function () { window.alert('OK'); },
		error      : function () { window.alert('FAIL'); },
		url        : "/demo.pl?type=json",
		dataType   : "json"
	};
	jQuery.ajax(conf);
});
