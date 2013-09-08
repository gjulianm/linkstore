var xhr = new XMLHttpRequest();
var loc = encodeURIComponent(location.href);
xhr.open("GET","http://{{host}}/links/create?user={{user}}&url=" + loc,true);
xhr.onreadystatechange=function(){if(this.readyState==4){window.alert("added!");}};
xhr.send();
