(function() {
	var xhr = new XMLHttpRequest();
	var loc = encoreURIComponent(location.href);
	xhr.open("GET","http://127.0.0.1:3000/links/create?url=" + loc,true);
	xhr.onreadystatechange=function(){if(this.readyState==4){window.alert("added!");}}
	xhr.send();
})();