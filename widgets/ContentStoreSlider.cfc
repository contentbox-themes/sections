/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders a preview of a ContentStore's category, which is displayed in a as a slideshow.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ContentStoreSlider function init(){
		// Widget Properties
		setName( "ContentStoreSlider" );
		setVersion( "1.0" );
		setDescription( "A widget that renders a preview of a ContentStore's category, which is displayed as a slideshow." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "Content" );

		return this;
	}

	/**
	* Renders a published ContentStore object, if no default value is used, this throws an exception
	* @max.hint The maximum number of records to paginate
	* @titleLevel.hint The H{level} to use, by default we use H2
	* @category.hint The category to filter the content on
	*/
	any function renderIt( 
		numeric max=3,
		string titleLevel="2", 
		string category="" 
	){
		var contentResults 	= contentStoreService.findPublishedContent( max=arguments.max, category=arguments.category );
		var rString			= "";
		var tempPath 		= "";
		var tempTitle 		= "";
		var tempLink 		= "";
		var tempLinkText	= "";
		var activeClass		= "";
		
		if( contentResults.count ){
			
			// iteration cap
			if( contentResults.count lt arguments.max){
				arguments.max = contentResults.count;
			}

			// generate
			saveContent variable="rString"{
				writeOutput('<div id="carousel-category-#arguments.category#" class="carousel slide" data-ride="carousel">');
				writeOutput( '<div class="carousel-inner" role="listbox"> ' );
				writeOutput( '<ol class="carousel-indicators">' );
				// iterate and create indicators
				for(var x=1; x lte arguments.max; x++){
					if( x == 1 ){
						activeClass = 'class="active"';
					}
					else{
						activeClass = "";	
					}
					writeOutput( '<li data-target="##carousel-category-#arguments.category#" data-slide-to="#x#-1" #activeClass#></li>' );
				}
				writeOutput( '</ol>' );
				// iterate and create
				for(var x=1; x lte arguments.max; x++){
					tempPath = contentResults.content[ x ].getCustomField( "imageURL", "" );
					tempTitle = contentResults.content[ x ].getTitle();
					tempLink = contentResults.content[ x ].getCustomField( "linkURL", "" );
					tempLinkText = contentResults.content[ x ].getCustomField( "linkText", "" );
					 
					if( x == 1 ){
						writeOutput('<div class="item active">');
					}
					else{
						writeOutput('<div class="item">');	
					}
					if( tempPath != "" ){
						writeOutput('<img src="#tempPath#" class="carousel-img" alt="#tempTitle#"/>');
					}
					writeOutput('<div class="carousel-caption">');
					writeOutput('<h#arguments.titleLevel# class="title"><a href="#tempLink#">#tempTitle#</a></h#arguments.titleLevel#>' );
					writeOutput('<div class="desc">#contentResults.content[ x ].getDescription()#</div>');
					if( tempLink != "" & tempLinkText != "" ){
						writeOutput('<a href="#tempLink#"class="btn btn-default">#tempLinkText#</a>');
					}
					writeOutput( '</div>' );
					writeOutput( '</div>' )
				}
				writeOutput( '</div>' );
				writeOutput( '<a class="left carousel-control" href="##carousel-category-#arguments.category#" role="button" data-slide="prev">');
				writeOutput( '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>' );
				writeOutput( '<span class="sr-only">Previous</span>' );
				writeOutput( '</a>' );
				writeOutput( '<a class="right carousel-control" href="##carousel-category-#arguments.category#" role="button" data-slide="next">' );
				writeOutput( '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>' );
				writeOutput( '<span class="sr-only">Next</span>' );
				writeOutput( '</a>' );
				writeOutput( '</div>' );
			}
		}
		return rString;
	}
}
