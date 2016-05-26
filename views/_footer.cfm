<cfoutput>
<cfset prc.footerEntriesTitle = cb.themeSetting( 'footerEntriesTitle', '' )>
<cfset prc.footerEntriesCategory = html.slugify( cb.themeSetting( 'footerEntriesCategory', 'none' ) )>
				
<footer id="footer">
	 <!--- contentboxEvent --->
	 #cb.event( "cbui_footer" )#
	<div id="footer-main">
		<div class="container">
			<div class="col-md-4">
				<cfif prc.footerEntriesCategory is not "none">
					#cb.widget(name='RecentEntries',args={title=prc.footerEntriesTitle,category=prc.footerEntriesCategory})#
				</cfif>
			</div>
			<div class="col-md-4">
				
			</div>
			<div class="col-md-4">
				<h2>#cb.siteName()#</h2>
				<cfif cb.themeSetting( 'locAddress', '' ) is not "">
					<div class="address-footer">
						<div class="locicon">
							<span class="glyphicon glyphicon-map-marker"></span>
						</div>
						<span>#cb.themeSetting( 'locAddress' )#</span><br/>
						<span>#cb.themeSetting( 'locCity' )#</span>, <span>#cb.themeSetting( 'locState' )#</span> <span>#cb.themeSetting( 'locZip' )#</span>
					</div>
				</cfif>
				<cfif cb.themeSetting( 'locPhone', '' ) is not "">
					<div class="locicon">
						<span class="glyphicon glyphicon-phone"></span>
					</div>
					<span>#cb.themeSetting( 'locPhone' )#</span>
				</cfif>
			</div>
		</div>
	</div>
	<div id="copyright">
		<div class="container">
			<div class="col-md-6">
				<p class="text-muted">Copyright &copy; #cb.siteName()#.  All rights reserved.</p>
				<p class="text-muted">Powered by ContentBox v#cb.getContentBoxVersion()#</p>
			</div>
			<div class="col-md-6">
				<div class="social">
					<cfif cb.themeSetting( 'socialFB', '' ) is not "">
						<div class="icon icon-facebook">
							<a href="#cb.themeSetting( 'socialFB' )#"><span class="sr-only">Facebook</span></a>
						</div>
					</cfif>
					<cfif cb.themeSetting( 'socialT', '' ) is not "">
						<div class="icon icon-twitter">
							<a href="#cb.themeSetting( 'socialT' )#"><span class="sr-only">Twitter</span></a>
						</div>
					</cfif>
					<cfif cb.themeSetting( 'socialGP', '' ) is not "">
						<div class="icon icon-google">
							<a href="#cb.themeSetting( 'socialGP' )#"><span class="sr-only">Google+</span></a>
						</div>
					</cfif>
					<cfif cb.themeSetting( 'socialIG', '' ) is not "">
						<div class="icon icon-instagram">
							<a href="#cb.themeSetting( 'socialIG' )#"><span class="sr-only">Instagram</span></a>
						</div>
					</cfif>
					<cfif cb.themeSetting( 'socialYT', '' ) is not "">
						<div class="icon icon-youtube">
							<a href="#cb.themeSetting( 'socialYT' )#"><span class="sr-only">YouTube</span></a>
						</div>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</footer>
</cfoutput>