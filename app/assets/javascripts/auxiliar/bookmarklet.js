if (confirm("¿Añadir este enlace?")) {
	var xhr = new XMLHttpRequest();
	var loc = encodeURIComponent(location.href);
	var title = encodeURIComponent(document.title);
	xhr.open("GET", "{{host}}/links/create?user={{user}}&url=" + loc + "&title=" + title, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			window.alert("¡Añadido!");
		}
	};
	xhr.send();
}