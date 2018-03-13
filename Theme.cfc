﻿/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A theme is composed of the following pieces
* 
* /ThemeDirectory
*  + Theme.cfc (The CFC that models your theme implementation)
*  / layouts (The folder that contains layouts in your theme)
*    + blog.cfm (Mandatory layout used for all blog views by convention)
*    + pages.cfm (Mandatory layout used for all pages by convention)
*    + maintenance.cfm (Optional used when in maintenance mode, else defaults to pages)
*    + search.cfm (Optional used when doing searches, else defaults to pages)
*  / views (The folder that contains views for rendering)
*  	 + archives.cfm (MANDATORY: The view used to render out blog archives.)
*  	 + entry.cfm (MANDATORY: The view used to render out a single blog entry with comments, etc.)
*  	 + error.cfm (MANDATORY: The view used to display errors when they ocurr in your blog or pages)
*  	 + index.cfm (MANDATORY: The view used to render out the home page where all blog entries are rendered)
*  	 + notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
*  	 + page.cfm (MANDATORY: The view used to render out individual pages.)
*  	 + maintenance.cfm (OPTIONAL: Used when in maintenance mode)
* / templates (The folder that contains optional templates for collection rendering that are used using the quick rendering methods in the CB Helper)
* 	 + category.cfm (The template used to display an iteration of entry categories using coldbox collection rendering)
* 	 + comment.cfm (The template used to display an iteration of entry or page comments using coldbox collection rendering)
* 	 + entry.cfm (The template used to display an iteration of entries in the home page using coldbox collection rendering)
* / widgets (A folder that can contain layout specific widgets which override core ContentBox widgets)
* 
* Templates
* Templates are a single cfm template that is used by ContentBox to iterate over a collection (usually entries or categories or comments) and
* render out all of them in uniformity.  Please refer to ColdBox Collection Rendering for more information.  Each template recevies
* the following:
* 
* _counter (A variable created for you that tells you in which record we are currently looping on)
* _items (A variable created for you that tells you how many records exist in the collection)
* {templateName} The name of the object you will use to display: entry, comment, category
*
* Layout Local CallBack Functions:
* onActivation()
* onDelete()
* onDeactivation()
* 
* Settings
* You can declare settings for your layouts that ContentBox will manage for you.
* 
* this.settings = [
* 	{ name="Title", defaultValue="My Awesome Title", required="true", type="text", label="Title:" },
* 	{ name="Colors", defaultValue="blue", required="false", type="select", label="Color:", options="red,blue,orange,gray" }
* ];
* 
* The value is an array of structures with the following keys:
* 
* - name : The name of the setting (required), the setting is saved as cb_layoutname_settingName
* - defaultValue : The default value of the setting (required)
* - required : Whether the setting is required or not. Defaults to false
* - type : The type of the HTMl control (text=default, textarea, boolean, select)
* - label : The HTML label of the control (defaults to name)
* - title : The HTML title of the control (defaults to empty string)
* - options : The select box options. Can be a list or array of values or an array of name-value pair structures
* - group : lets you group inputs under a Group name - settings should be in order for groupings to work as expected
* - groupIntro : Lets you add a description for a group of fields
* - fieldDescription : Lets you add a description for an individual field
* - fieldHelp : Lets you add a chunk of HTML for a Modal, openable by the User by clicking on question mark next to the field label. Recommended use is to readFiles from the ./includes/help directory, with a helper function, for example: loadHelpFile( 'cbBootswatchTheme.html' ); 
*/
component{
 	
 	property name="settingService"		inject="id:settingService@cb";
 	property name="menuService" 		inject="id:MenuService@cb";
 	property name="categoryService" 	inject="id:CategoryService@cb";
 	property name="contentStoreService" inject="id:ContentStoreService@cb";
 	property name="customFieldService"  inject="customFieldService@cb";
  
	// Layout Variables
    this.name       	= "ContentBox Sections Theme";
	this.description 	= "ContentBox Sections layout for ContentBox 3 based on Bootstrap 3";
    this.version        = "@build.version@+@build.number@";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "https://www.ortussolutions.com";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	
	
	function onDIComplete( ){
		
		// Layout Settings
		this.settings = [
			{ name="cbBootswatchTheme", 	group="Colors", defaultValue="corporate", 	type="select", 	label="ContentBox Color Palette:", 	required="false", optionsUDF="getSwatches", groupIntro="Control the color scheme of your entire site by changing the color palette.", fieldHelp="#loadHelpFile( 'cbBootswatchTheme.html' )#"  },
			
			{ name="headerLogo", 			group="Header", defaultValue="", 			type="text", 	label="Logo URL:", groupIntro="Customize the header section of your theme.", 	fieldDescription="Enter a relative or full url for the website logo. Recommended dimensions: 300x50."  },
			{ name="headerTopNav", 			group="Header", defaultValue="none", 		type="select", 	label="Top Navigation:", optionsUDF="menus", fieldDescription="Select a menu for the Top Navigation (top right corner of the header)."},
			
			{ name="footerEntriesTitle", 	group="Footer Entries", defaultValue="", 		type="text", 	label="Footer Entries Title:", groupIntro="Blog Category feed that appears in the footer.", fieldDescription="Enter a title for your feed." },
			{ name="footerEntriesCategory", group="Footer Entries", defaultValue="none", 	type="select", 	label="Footer Entries Category:", optionsUDF="entryCategories", fieldDescription="Select the blog category."  },
			
			{ name="locAddress", 			group="Location", defaultValue="", 		type="text", 	label="Address:", groupIntro="The address and phone number appears in the footer." },
			{ name="locCity", 				group="Location", defaultValue="", 		type="text", 	label="City:" },
			{ name="locState", 				group="Location", defaultValue="", 		type="text", 	label="State:" },
			{ name="locZip", 				group="Location", defaultValue="", 		type="text", 	label="Zip:" },
			{ name="locPhone", 				group="Location", defaultValue="", 		type="text", 	label="Phone:" },
			
			{ name="sec1Category", 			group="Section 1: Slideshow", defaultValue="none", 	type="select", 		label="Content Category:", optionsUDF="entryCategories", groupIntro="Customize the slider that appears in the homepage.", fieldDescription="Select the content store category.", fieldHelp="#loadHelpFile( 'contentStoreSlider.html' )#" },
			
			{ name="sec2Category", 			group="Section 2", defaultValue="none", 	type="select", 		label="Content Category:", optionsUDF="entryCategories", groupIntro="Customize the section below the slider.", fieldDescription="Select the content store category.", fieldHelp="#loadHelpFile( 'contentStoreGrid.html' )#"},
			
			{ name="sec3Title", 		group="Section 3", defaultValue="", 		type="text", 		label="Section 3 Title:", groupIntro="Customize the section with the large text in the homepage." },
			{ name="sec3Text",			group="Section 3", defaultValue="", 		type="textarea", 	label="Section 3 Text:" },
			{ name="sec3BtnText", 		group="Section 3", 	defaultValue="", 		type="text", 		label="Section 3 Button Text:" },
			{ name="sec3Link", 			group="Section 3", 	defaultValue="", 		type="text", 		label="Section 3 Button Link:" },
			
			{ name="sec5Title", 		group="Section 5", defaultValue="", 		type="text", 		label="Section 5 Title:", groupIntro="Customize the text section above the footer." },
			{ name="sec5Text",			group="Section 5", defaultValue="", 		type="textarea", 	label="Section 5 Text:" },
			{ name="sec5Align", 		group="Section 5", defaultValue="right", 	type="select", 		label="Section 5 Text Alignment:", options="left,right" },
			{ name="sec5ImgBg", 		group="Section 5", defaultValue="", 		type="text", 		label="Section 5 Image Background:" },
			
			{ name="rssDiscovery", 			group="Homepage", 	defaultValue="true", 	type="boolean",		label="Active RSS Discovery Links", 	required="false" },
			{ name="showCategoriesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",		label="Show Categories in Blog Sidebar", 	required="false" },
			{ name="showRecentEntriesBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Recent Enties in Blog Sidebar", 	required="false" },
			{ name="showSiteUpdatesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Site Updates in Blog Sidebar", 	required="false" },
			{ name="showEntryCommentsBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entry Comments in Blog Sidebar", 	required="false" },
			{ name="showArchivesBlogSide", 		group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Archives in Blog Sidebar", 	required="false" },
			{ name="showEntriesSearchBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entries Search in Blog Sidebar", 	required="false" },
			
			{ name="socialFB", 		group="Social", defaultValue="", 		type="text", 	label="Facebook:"},
			{ name="socialIG", 		group="Social", defaultValue="", 		type="text", 	label="Instagram:" },
			{ name="socialT", 		group="Social", defaultValue="", 		type="text", 	label="Twitter:" },
			{ name="socialGP", 		group="Social", defaultValue="", 		type="text", 	label="Google+:" },
			{ name="socialYT", 		group="Social", defaultValue="", 		type="text", 	label="YouTube:" }
			
		];
		return this;
	}
	
	/**
	* Build the swatches options
	*/
	array function getSwatches(){
		return listToArray( "corporate,teetime" );
	}
	
	/**
	* loadHelpFile - helper function for loading html help into a variable for modal
	* @helpFileName - the name of the file to read and return
	* @helpFilePath - the relative directory for the help files. Defaulting to ./includes/help/ inside the theme.
	* @return the contents of the file or empty string if the file does not exist
	*/
	function loadHelpFile( required string helpFileName, string helpFilePath='./includes/help/' ){
		try {
			return fileRead( arguments.helpFilePath & arguments.helpFileName );
		} catch( any e ){
			return '';
		}
	}
	
	/**
	* Call Back when layout is activated
	*/
	function onActivation(){
	
	}

	/**
	* Call Back when layout is deactivated
	*/
	function onDeactivation(){

	}

	/**
	* Call Back when layout is deleted from the system
	*/
	function onDelete(){

	}
	
	/**
	* After saving theme generate required settings
	*/
	function cbadmin_postThemeSettingsSave(event, interceptData, buffer){
		generateContentStoreSliderFields();
		generateContentStoreGridFields();
	}
	
	/**
	* Generates the custom fields for the Content Store Lider Widget
	*/
	private function generateContentStoreSliderFields(){
		var aFieldKeys 		= [ "linkURL", "linkText","imageURL" ];
		var contentCatName 	= settingService.getSetting("cb_theme_#settingService.getSetting( 'cb_site_theme' )#_sec1Category");
				
		// is there a category selected
		if( contentCatName != "none" ){
			var oCategory = categoryService.findWhere( criteria={category=contentCatName} );
			var sContent  = contentStoreService.search( category=oCategory.getCategoryID() );
			
			generateCustomFields( aFieldKeys, sContent.content );
		}
	}
	/**
	* Generates the custom fields for the Content Store Grid Widget
	*/
	private function generateContentStoreGridFields(){
		var aFieldKeys 		= [ "linkURL","imageURL" ];
		var contentCatName 	= settingService.getSetting("cb_theme_#settingService.getSetting( 'cb_site_theme' )#_sec2Category");
				
		// is there a category selected
		if( contentCatName != "none" ){
			var oCategory = categoryService.findWhere( criteria={category=contentCatName} );
			var sContent  = contentStoreService.search( category=oCategory.getCategoryID() );
			
			generateCustomFields( aFieldKeys, sContent.content );
		}
	}
	
	/**
	* Generates the custom fields on specified content
	* @fieldKeys field keys to be created
	* @pages array of page objects
	*/
	private function generateCustomFields( array fieldKeys, array cbContent ){
		
		transaction{
			for( var contentItem in arguments.cbContent ) {
					var sfields = contentItem.getCustomFieldsAsStruct();
						
					for ( var field in arguments.fieldKeys ) {
				
						// if page does not have field	
						if( !structKeyExists( sfields, field  ) ){
								
							// create field
							var args = { key = field, value = "" };
							var oField = customFieldService.new(properties=args);
							oField.setRelatedContent( contentItem );
							customFieldService.save(oField);		
						}
					}
			}		
		}
	}
	
	/**
	* Gets names of categories
	*/
	string function entryCategories() {
		var categoryList = arraytoList( categoryService.getAllNames() );
		categoryList = ListPrepend( categoryList, "none" );
		return categoryList;
	}
	
	/**
	* Gets all menu slugs
	*/
	string function menus() { 
		var menuList = arraytoList( menuService.getAllSlugs() );
		menuList = ListPrepend( menuList, "none" );
		return menuList;
	}
}
