function grabLink(id) {
	$('#editor' + id).text("...");
	$.get('/link/set_editor/' + id, function () {
		$('#editor' + id).text("Grabbed by me");
	});
}

function releaseLink(id) {	
	$('#editor' + id).text("...");
	$.get('/link/release/' + id, function () {
		$('#editor' + id).text("Released!");
	});
}

function markAsDone(id) {
	$('#done'+id).text("...");
	$.get('/link/done/' + id, function() {
		$('#done'+id).text("Done!");
	});
}

function remove(id) {
	$('#remove'+id).text("...");
	$.get('/link/remove/' + id, function() {
		location.reload(); // Well...
	});
}

function toggleComments(id) {
	$('#comments' + id).toggle();
}

function addComment(id) {
	$('#commentBox' + id).toggle();
}