<cfoutput>
<!--- View Arguments --->
<cfparam name="args.print" 		default="false">
<cfparam name="args.sidebar" 	default="true">

<cfset prc.sec1Category = html.slugify( cb.themeSetting( 'sec1Category', 'none' ) )>
<cfset prc.sec2Category = html.slugify( cb.themeSetting( 'sec2Category', 'none' ) )>

<cfif cb.themeSetting( 'sec5ImgBg', '' ) is not "">
	<cfset prc.sec5ImgBg = 'style="background-image: url(' & cb.themeSetting( 'sec5ImgBg' ) & ')"'>
<cfelse>
	<cfset prc.sec5ImgBg = "">
</cfif>

<cfset prc.sec5AlignDirection = cb.themeSetting( 'sec5Align', 'left' ) >
<cfset prc.sec5Align = 'style="float:' & prc.sec5AlignDirection & '"'>

<!--- If homepage, present homepage jumbotron --->
<cfif cb.isHomePage()>
	<!--- Section 1 --->
	<cfif prc.sec1Category is not "none">
		<section id="section-1">
			#cb.widget( name='ContentStoreSlider',args={max=3,category=prc.sec1Category} )#
		</section>
	</cfif>
<cfelse>
	<div id="body-header">
		<div class="container">
			<!--- Title --->
			<div class="underlined-title">
				<h1>#prc.page.getTitle()#</h1>
				<div class="text-divider5">
					#prc.page.getExcerpt()#
				</div>
			</div>
		</div>
	</div>
</cfif>

<cfif cb.isHomePage()>
	<cfif prc.sec2Category is not "none">
		<!--- Section 2 --->
		<section id="section-2">
			<div class="container">
				#cb.widget( name='ContentStoreGrid',args={max=3,category=prc.sec2Category} )#
			</div>
		</section><!--- end section 2 --->
	</cfif>
	
	<!--- Section 3 --->
	<section id="section-3">
		<div class="container">
			<div class="section-text-box">
				<h2>#cb.themeSetting( 'sec3Title', '' )#</h2>
				<div class="section-text">
					#cb.themeSetting( 'sec3Text', '' )#
				</div>
				<a href="#cb.themeSetting( 'sec3Link', '' )#" class="btn btn-trans">#cb.themeSetting( 'sec3BtnText', '' )#</a>
			</div>
		</div>
	</section><!--- end section 3 --->
	
	<!--- Section 4 --->
	<section id="section-4">
		<div class="container">
			#cb.widget(name='BasicSlider',args={folder='logos'})#
		</div>
	</section><!--- end section 4 --->
	
	<!--- Section 5 --->

	<section id="section-5" #prc.sec5ImgBg#>
		<div class="container">
			<div class="section-text-box col-md-4 text-#prc.sec5AlignDirection#" #prc.sec5Align#>
				<h2>#cb.themeSetting( 'sec5Title', '' )#</h2>
				<div class="section-text">
					#cb.themeSetting( 'sec5Text', '' )#
				</div>
			</div>
		</div>
	</section><!--- end section 5 --->
	
<cfelse>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_prePageDisplay" )#
	
	<!--- Body Main --->
	<section id="body-main">
		<div class="container">
	
			<!--- Export and Breadcrumbs Symbols --->
			<cfif !args.print AND !isNull( "prc.page" ) AND prc.page.getSlug() neq cb.getHomePage()>
				<!--- Exports --->
				<div class="btn-group pull-right">
					<button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Export Page...">
						<i class="fa fa-print"></i> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="#cb.linkPage( cb.getCurrentPage() )#.print" target="_blank">Print Format</a></li>
						<li><a href="#cb.linkPage( cb.getCurrentPage() )#.pdf" target="_blank">PDF</a></li>
					</ul>
				</div>
	
				<!--- BreadCrumbs --->
				<div id="body-breadcrumbs" class="col-sm-12">
					<i class="fa fa-home"></i> #cb.breadCrumbs( separator="<i class='fa fa-angle-right'></i> " )#
				</div>
			</cfif>
	
			<!--- Determine span length due to sidebar or homepage --->
			<cfif cb.isHomePage() OR !args.sidebar>
				<cfset variables.span = 12>
			<cfelse>
				<cfset variables.span = 9>
			</cfif>
			<div class="col-sm-#variables.span#">
				
				<!--- Render Content --->
				#prc.page.renderContent()#
	
				<!--- Comments Bar --->
				<cfif cb.isCommentsEnabled( prc.page )>
				<section id="comments">
					#html.anchor( name="comments" )#
					<div class="post-comments">
						<div class="infoBar">
							<p>
								<button class="button2" onclick="toggleCommentForm()"> <i class="icon-comments"></i> Add Comment (#prc.page.getNumberOfApprovedComments()#)</button>						
							</p>
						</div>
						<br/>
					</div>
	
					<!--- Separator --->
					<div class="separator"></div>
	
					<!--- Comment Form: I can build it or I can quick it? --->
					<div id="commentFormShell">
						<div class="row">
							<div class="col-sm-12">
								#cb.quickCommentForm(prc.entry)#
							</div>
						</div>
					</div>
	
					<!--- clear --->
					<div class="clr"></div>
	
					<!--- Display Comments --->
					<div id="comments">
						#cb.quickComments()#
					</div>
				</section>
				</cfif>
	    	</div>
	
	    	<!--- Sidebar --->
	    	<cfif args.sidebar and !cb.isHomePage()>
				<div class="col-sm-3 sidenav">
					#cb.quickView( view='_pagesidebar' )#
				</div>
	    	</cfif>
		</div>
	</section>
</cfif>

<!--- ContentBoxEvent --->
#cb.event("cbui_postPageDisplay")#

<!--- Custom JS --->
<!---<script type="text/javascript">
	$(document).ready(function() {
		<cfif cb.isCommentFormError()>
			toggleCommentForm();
		</cfif>
	});
	function toggleCommentForm(){
		$("##commentForm").slideToggle();
	}
</script>--->
</cfoutput>