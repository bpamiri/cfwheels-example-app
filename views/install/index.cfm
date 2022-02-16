<h1>Example App Install</h1>

<table class="table">
  <tbody>
		<cfoutput>
			<cfset continueVerification = true >

			<!--- check datasource not blank --->
			<cfif continueVerification and len(get("dataSourceName")) >
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
				<cfset continueVerification = false >
			</cfif>

			<!--- check if we can communicate with the database --->
			<cfif continueVerification >
				<cftry>
					<cfquery name="appSettings" datasource="#get('dataSourceName')#">
						select count(*) as count
						from migratorversions
					</cfquery>
					<tr>
						<th scope="row">
							<i class="fas fa-check-circle text-success"></i>
						</th>
						<td>We were able to select from the migratorversions table</td>
					</tr>
					<cfcatch type="any">
						<tr>
							<th scope="row">
								<i class="fas fa-times-circle text-danger"></i>
							</th>
							<td>We were unable to select from the migratorversions table. Pleae insure that all migrations have been run.</td>
						</tr>
						<cfset continueVerification = false >
					</cfcatch>
				</cftry>
			</cfif>

			<!--- check that all migrations have been completed --->
			<cfif continueVerification and isDefined("appSettings") and isQuery(appSettings) and appSettings.count eq 13>
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
				<cfset continueVerification = false >
			</cfif>

		</cfoutput>
  </tbody>
</table>
