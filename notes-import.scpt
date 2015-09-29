//
// notes-import.scpt 
// Steven Frank <stevenf@panic.com>
//
// Import a folder full of HTML or text files into Notes.app.
// Crude, but better than nothing. Maybe?
//
// Usage:
//   - Open this file in Script Editor
//   - Run
//   - Select folder containing files to import
//
// Known issues:
//   - Attachments don't get imported
//   - Formatting/HTML is not preserved
//   - No idea how text encoding is handled
//   - File extension should be stripped from title of new note
//

var notesApp = Application('Notes')
notesApp.includeStandardAdditions = true
notesApp.activate()

// Prompt user to pick a folder

var folderName = notesApp.chooseFolder()

var folderContents = Application('System Events').folders.byName(folderName.toString()).diskItems.name()

folderContents.forEach(function(item) 
{
	var fileContents = fileContentsAtPath(folderName + '/' + item)
	
	if ( fileContents )
	{
		var note = notesApp.Note({
			'name': item,
			'body': fileContents.replace(/\n/g,'<br>')
		})

		notesApp.folders[0].notes.push(note)
	}
})

function fileContentsAtPath(pathAsString) 
{
	var path = Path(pathAsString)

	var app = Application.currentApplication()
	app.includeStandardAdditions = true
		
	var file = app.openForAccess(path);
    
	var eof = app.getEof(file)
	var data = null
	
    if(eof > 0) {
		data = app.read(file, 
		{
			'to': eof
		});
	}

    app.closeAccess(file);

	
	return data;
}
