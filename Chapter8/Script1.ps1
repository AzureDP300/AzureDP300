workflow QuerySP
{
        [string] $SqlServer="mydemodp300.database.windows.net"
        [string] $Database="mydemodatabase"
        [string] $proc="dblist"
        [PSCredential] $SqlCredential=Get-AutomationPSCredential -Name "mydp300cred"
        

        # Get the username and password from the SQL Credential
        $SqlUsername = $SqlCredential.UserName
        $SqlPass = $SqlCredential.GetNetworkCredential().Password
    
    inlinescript {

        write-output $using:SqlServer;
        write-output $using:Database;
        write-output $using:proc;

        # Define the connection to the SQL Database
        $Conn = New-Object System.Data.SqlClient.SqlConnection("Server=tcp:$using:SqlServer;Database=$using:Database;User ID=$using:SqlUsername;Password=$using:SqlPass;")
        
        # Open the SQL connection
        $Conn.Open()

        # Define the SQL command to run. In this case we are getting the number of rows in the table
        $Cmd=new-object system.Data.SqlClient.SqlCommand("exec $using:proc", $Conn)
        $Cmd.CommandTimeout=120

        # Execute the SQL command
        $Ds=New-Object system.Data.DataSet
        $Da=New-Object system.Data.SqlClient.SqlDataAdapter($Cmd)
        [void]$Da.fill($Ds)

        # Output the count
        $Ds.tables[0].rows.count;
        $Ds.Tables[0].select();

        # Close the SQL connection
        $Conn.Close()
    }
}
