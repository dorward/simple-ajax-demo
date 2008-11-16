jQuery(document).ready(function (){
	var conf = {
		success    : function () { window.alert('OK'); },
		error      : function () { window.alert('FAIL'); },
		beforeSend : function (xhr) { alert(xhr); xhr.setRequestHeader("accept", "application/json;q=1,text/html;q=0"); },
		url        : "/demo.fcgi"
	};
	jQuery.ajax(conf);
});