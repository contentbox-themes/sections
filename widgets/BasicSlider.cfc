/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that displays images from a media store folder, in a slider.
*/

component extends="contentbox.models.ui.BaseWidget" singleton{
	
	BasicSlider function init(){
		// Widget Properties
		setName( "BasicSlider" );
		setVersion( "1.0" );
		setDescription( "A widget that displays images from a media store folder, in a slider." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "image" );
		setCategory( "Content" );
		
		return this;
	}
	
	/**
	* Renders a file list
	* @folder.hint The folder (relative to the ContentBox content root) from which to list the files (meetings/minutes)
	* @sort.hint The sort field (Name, Size, DateLastModified)
	* @order.hint The sort order of the files listed (ASC/DESC)
	*/
	any function renderIt(
		string folder="",
		string sort="Name",
		string order="ASC"
	){
		var event = getRequestContext();
		var cbSettings = event.getValue(name="cbSettings",private=true);
		var mediaPath = cbSettings.cb_media_directoryRoot & "/" & arguments.folder;
		var mediaPathExpanded = expandPath(mediaPath);
		
		var listing = directoryList( mediaPathExpanded,false,"query","*.jpg",order );
		var rString			= "";
		var tempName = "";
		
		// generate slides
		saveContent variable="rString"{
			writeOutput('
				<div id="sections-#arguments.folder#-slider" class="carousel slide" data-ride="carousel">
					<div class="carousel-inner" role="listbox">
			');
			
			for (var x=1; x lte listing.recordcount; x++) {
				tempName = ListFirst( listing.name[x], '.');
				
				if( x == 1 || x%4 == 1){
					if( x == 1 ){
						writeOutput('<div class="item active">');
					}
					else{
						writeOutput('<div class="item">');	
					}
				}
				
				writeOutput( '
					<div class="col-xs-3">
						<img src="__media/#arguments.folder#/#listing.name[x]#" alt="#tempName#" />
					</div>
				'
			 	);
			 	
			 	if( x == 4 || x%4 == 0){
					writeOutput('</div>');
				}
			 }
			 
			 writeOutput('
					</div>
				</div>
			');
		
		}
		return rString;
	}
}