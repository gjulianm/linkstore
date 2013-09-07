var xhr = new XMLHttpRequest();
var loc = encoreURIComponent(location.href);
xhr.open("GET","http://{{host}}/links/create?url=" + loc,true);
xhr.onreadystatechange=function(){if(this.readyState==4){window.alert("added!");}}
xhr.send();
