function grabLink(id) {
	$('#editor' + id).text("...");
	$.get('/link/set_editor/' + id, function() {
		$('#editor' + id).text("Grabbed by me");
	});
}

function releaseLink(id) {
	$('#editor' + id).text("...");
	$.get('/link/release/' + id, function() {
		$('#editor' + id).text("Released!");
	});
}

function markAsDone(id) {
	$('#done' + id).text("...");
	$.get('/link/done/' + id, function() {
		$('#done' + id).text("Done!");
	});
}

function remove(id) {
	$('#remove' + id).text("...");
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

function setPriority(id, priority) {
	$.post('/api/links/' + id + '/priority', {
		'priority': priority
	});
	var item = $('#link-' + id);
	for (var i = 0; i < 3; i++) {
		if (i == priority)
			item.addClass("priority-" + priority);
		else
			item.removeClass("priority-" + i);
	}
	$('#priorityOptions' + id).hide();
	$('#priorityLink' + id).show();
}

function showPriorityOptions(id) {
	$('#priorityOptions' + id).show();
	$('#priorityLink' + id).hide();
}
