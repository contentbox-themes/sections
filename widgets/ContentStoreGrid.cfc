/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders a preview of a ContentStore's category, which is displayed in a three column grid.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ContentStoreGrid function init(){
		// Widget Properties
		setName( "ContentStoreGrid" );
		setVersion( "1.0" );
		setDescription( "A widget that renders a preview of a ContentStore's category, which is displayed in a three column grid." );
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

		var contentResults = contentStoreService.findPublishedContent( max=arguments.max, category=arguments.category );
		var rString		= "";
		var tempPath 	= "";
		var tempTitle 	= "";
		var tempLink 	= "";
		
		if( contentResults.count ){
			
			// iteration cap
			if( contentResults.count lt arguments.max){
				arguments.max = contentResults.count;
			}
			// generate
			saveContent variable="rString"{
				// iterate and create
				for(var x=1; x lte arguments.max; x++){
					tempPath = contentResults.content[ x ].getCustomField( "imageURL", "" );
					tempTitle = contentResults.content[ x ].getTitle();
					tempLink = contentResults.content[ x ].getCustomField( "linkURL", "" );
					 
					writeOutput('<div class="col-md-4">');
					if( tempPath != "" ){
						writeOutput('<div class="pic"><img src="#tempPath#" class="img-responsive" alt="#tempTitle#"/></div>');
					}
					writeOutput('<h#arguments.titleLevel# class="title"><a href="#tempLink#">#tempTitle#</a></h#arguments.titleLevel#>' );
					writeOutput('<div class="desc">#contentResults.content[ x ].getDescription()#</div>');
					writeOutput( "</div>" );
				}
			}
		}
		return rString;
	}
}
