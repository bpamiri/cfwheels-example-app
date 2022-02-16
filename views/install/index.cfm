<h1>Example App Install</h1>

<table class="table">
  <tbody>
		<cfoutput>
			<!--- check datasource not blank --->
			<cfif len(get("dataSourceName")) >
				<tr>
					<th scope="row">
						<i class="fas fa-check-circle text-success"></i>
					</th>
					<td>The dataSourceName is defined as #get("dataSourceName")#</td>
				</tr>
			<cfelse>
				<tr>
					<th scope="row">
						<i class="fas fa-times-circle text-danger"></i>
					</th>
					<td>The dataSourceName is not defined or is blank</td>
				</tr>
			</cfif>

			<!--- check if we can communicate with the database --->
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
					</cfcatch>
			</cftry>

			<!--- check that all migrations have been completed --->
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
			</cfif>
		</cfoutput>
  </tbody>
</table>
