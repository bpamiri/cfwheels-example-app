<h1>Example App Install</h1>

<table class="table">
  <tbody>
		<cfoutput>
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
						<td>The dataSourceName is not defined or is blank</td>
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
						<td>It appears the datasource is setup for H2 but the H2 extension for Lucee is not installed. To install it, run `box install` in the root of your application.</td>
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
							<td>We were unable to select from the `migratorversions` table. Pleae insure that the database has been created and all migrations have been run.</td>
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
						<td>Looks like we are missing some migrations. Pleae insure that all migrations have been run.</td>
					</tr>
					<cfset continueChecks = false >
				</cfif>
			</cfif>

		</cfoutput>
  </tbody>
</table>
<cftry>
	<cfset settings = model("setting") >
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>
