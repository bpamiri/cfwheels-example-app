<cfoutput>
	<h1>Example App Install</h1>

	<table class="table">
		<tbody>
			<cfset continueChecks = true >

			<!--- check datasource not blank --->
			<cfif continueChecks >
				<cfif len(get("dataSourceName")) >
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>The dataSourceName is defined and is named `#get("dataSourceName")#`</td>
					</tr>
				<cfelse>
					<tr>
						<th scope="row">
							<i class="fas fa-times-circle text-danger"></i>
						</th>
						<td>The dataSourceName is not defined or is blank. Please check to make sure you have setup a datasource. If you asked the wizard to setup a H2 dabase for you this would be defined in `config/settings.cfm`</td>
					</tr>
					<cfset continueChecks = false >
				</cfif>
			</cfif>

			<!--- check if the datasource is setup to use an H2 Database --->
			<cfset driverIsH2 = false >
			<cfif continueChecks >
				<cftry>
						<cfdbinfo type="version" name="db_info" datasource="#get('dataSourceName')#">
						<cfif db_info.DATABASE_PRODUCTNAME eq "H2">
							<cfset driverIsH2 = true >
						</cfif>
					<cfcatch type="any">
						<cfif find("[org.h2.Driver]",cfcatch.message) >
							<cfset driverIsH2 = true >
						</cfif>
					</cfcatch>
				</cftry>
			</cfif>

			<!--- check if H2 extension is installed --->
			<cfif continueChecks and driverIsH2>
				<cfif ExtensionExists( id="465E1E35-2425-4F4E-8B3FAB638BD7280A", version="1.3.172" ) >
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>The H2 extension for Lucee seems to be installed and the datasource is setup to use H2.</td>
					</tr>
				<cfelse>
					<tr>
						<th scope="row">
							<i class="fas fa-times-circle text-danger"></i>
						</th>
						<td>
							It appears the datasource is setup for H2 but the H2 extension for Lucee is
							not installed. To install it, run `box install` in the root of your
							application. It takes Lucee about a minute to recognize the new extension.
							Reload this page to continue the install process.
						</td>
					</tr>
					<cfset continueChecks = false >
				</cfif>
			</cfif>

			<!--- check if we can communicate with the database --->
			<cfif continueChecks >
				<cftry>
					<cfquery name="appSettings" datasource="#get('dataSourceName')#">
						select count(*) as count
						from migratorversions
					</cfquery>
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>We were able to select from the `migratorversions` table, so at least one migration has run.</td>
					</tr>
					<cfcatch type="any">
						<tr>
							<th scope="row">
								<i class="fas fa-times-circle text-danger"></i>
							</th>
							<td>We were unable to select from the `migratorversions` table. Pleae insure that the database has been created and all migrations have been run. To run the migrations, run `box wheels dbmigrate latest` in the root of your application.</td>
						</tr>
						<cfset continueChecks = false >
					</cfcatch>
				</cftry>
			</cfif>

			<!--- check that all migrations have been completed --->
			<cfif continueChecks >
				<cfif isDefined("appSettings") and isQuery(appSettings) and appSettings.count eq 13>
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>All migrations appear to have been run</td>
					</tr>
				<cfelse>
					<tr>
						<th scope="row">
							<i class="fas fa-times-circle text-danger"></i>
						</th>
						<td>Looks like we are missing some migrations. Pleae insure that all migrations have been run. To run the migrations, run `box wheels dbmigrate latest` in the root of your application.</td>
					</tr>
					<cfset continueChecks = false >
				</cfif>
			</cfif>

			<!--- check if we can call a model method --->
			<cfif continueChecks >
				<cftry>
					<cfset settings = model("setting").findAll() >
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>We were able to call a model method `findAll()` on the `setting` model.</td>
					</tr>
					<cfcatch type="any">
						<tr>
							<th scope="row">
								<i class="fas fa-times-circle text-danger"></i>
							</th>
							<td>We were unable to call a model method `findAll()` on the `setting` model. Try restarting your server to see if this issue resolves itself.</td>
						</tr>
						<cfset continueChecks = false >
					</cfcatch>
				</cftry>
			</cfif>

		<!--- Change the default route to load the app --->
		<cfif continueChecks >
			<cftry>
				<cffile action="read" file="#expandPath("config/routes.cfm")#" variable="fileContent">
				<cfset newContent = replace(fileContent, '"install', '"main')>
				<cffile action="write" file="#expandPath("config/routes.cfm")#" output="#newContent#">
				<tr>
					<th scope="row">
						<i class="fas fa-check-circle text-success"></i>
					</th>
					<td>
						Your installation has been reconfigured to load the applicaiton root.	This
						means that `install##index` has been changed to `main##index` in the
						`config/routes.cfm` file.
					</td>
				</tr>
				<cfcatch type="any">
					<tr>
						<th scope="row">
							<i class="fas fa-times-circle text-danger"></i>
						</th>
						<td>
							We were unable to reconfigure the `config/routes.cfm` file.
						</td>
					</tr>
					<cfset continueChecks = false >
				</cfcatch>
			</cftry>
		</cfif>

	</tbody>
</table>

	<!--- All is good so reconfigure the main route --->
	<cfif continueChecks >

		<h2>Congradulations</h2>
		<p>
			Click the reload button below to reload the framework and launch your application. You may safely remove the `install` folder
			from the `views` folder before moving into production.
		</p>

		<p>To log into the sample app interface, some default user accounts should be available:<br>
			admin@domain.com<br>
			editor@domain.com<br>
			user@domain.com<br>
			user2@domain.com<br>
			user3@domain.com (Pending Verification)<br>
			All of them have the password set to Password123!<br>
			<br>
		Copy this information for future reference.</p>

		#linkTo(text="Reload", route="root", params="reload=yes&password=#get('reloadPassword')#", class="btn btn-primary")#
	</cfif>

</cfoutput>
