function Get-Holidays
{
<#
.SYNOPSIS
    Returns an array of observed holidays
.PARAMETER ReturnType
    Specifies if you'd like to get back string or datetime objects for the dates. Default behavior is DateTime
.PARAMETER ReturnSet
    Specifies the holidays you'd like returned. The default is all observed
.PARAMETER IsTodayAHHoliday
    Returns a true/false for if the current date falls on a holiday in the ReturnSet
.PARAMETER IncludeDayAfter
    This will include the day following each specified holiday in the return set
.PARAMETER OnlyDayAfter
    This will only return the days after holidays in the return set
#>
	[CmdletBinding()]
	param (
		[ValidateSet("String", "DateTime")]
		[parameter(Mandatory = $false)]
		[string]$ReturnType = "DateTime",
		[ValidateSet("New Year's Day", "Martin Luther King Day", "Presidents' Day", "Memorial Day", "Independence Day", "Labor Day", "Columbus Day", "Veterans Day", "Thanksgiving Day", "Christmas Day")]
		[parameter(Mandatory = $false)]
		[string[]]$ReturnSet = ("New Year's Day", "Martin Luther King Day", "Presidents' Day", "Memorial Day", "Independence Day", "Labor Day", "Columbus Day", "Veterans Day", "Thanksgiving Day", "Christmas Day"),
		[parameter(Mandatory = $false)]
		[switch]$IsTodayAHoliday,
		[parameter(Mandatory = $false)]
		[switch]$IncludeDayAfter,
        [parameter(Mandatory = $false)]
		[switch]$OnlyDayAfter,
        [parameter(Mandatory = $false)]
		[string]$Year = (get-date -format yyyy)

	)
	PROCESS
	{	
		$NewYearsDay = "01/01/$Year"
		$IndependenceDay = "07/04/$Year"
		$VeteransDay = "11/11/$Year"
		$Christmas = "12/25/$Year"
		
		#region Calculate MLKDay
		[datetime]$Temp = "01/01/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Monday")
			{
				$Count++
			}
			if ($Count -ne 3)
			{
				$Temp = $Temp.AddDays(1)
			}
		}
		while ($Temp.Month -eq 1 -and $Count -ne 3)
		$MLKDay = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		#region Calculate Presidents Day
		[datetime]$Temp = "02/01/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Monday")
			{
				$Count++
			}
			if ($Count -ne 3)
			{
				$Temp = $Temp.AddDays(1)
			}
		}
		while ($Temp.Month -eq 2 -and $Count -ne 3)
		$PresidentsDay = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		#region Calculate Labor Day
		[datetime]$Temp = "09/01/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Monday")
			{
				$Count++
			}
			if ($Count -ne 1)
			{
				$Temp = $Temp.AddDays(1)
			}
		}
		while ($Temp.Month -eq 9 -and $Count -ne 1)
		$LaborDay = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		#region Calculate Columbus Day
		[datetime]$Temp = "10/01/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Monday")
			{
				$Count++
			}
			if ($Count -ne 2)
			{
				$Temp = $Temp.AddDays(1)
			}
		}
		while ($Temp.Month -eq 10 -and $Count -ne 2)
		$ColumbusDay = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		#region Calculate Thanksgiving
		[datetime]$Temp = "11/01/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Thursday")
			{
				$Count++
			}
			if ($Count -ne 4)
			{
				$Temp = $Temp.AddDays(1)
			}
		}
		while ($Temp.Month -eq 11 -and $Count -ne 4)
		$Thanksgiving = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		#region Calculate Memorial Day
		[datetime]$Temp = "05/31/$Year"
		$Count = 0
		do
		{
			if ($Temp.DayOfWeek -eq "Monday")
			{
				$Count++
			}
			if ($Count -ne 1)
			{
				$Temp = $Temp.AddDays(-1)
			}
		}
		while ($Temp.Month -eq 5 -and $Count -ne 1)
		$MemorialDay = $Temp.ToString("MM/dd/yyyy")
		#endregion
		
		[DateTime[]]$Holidays = @()
		
		foreach ($Date in $ReturnSet)
		{
			switch ($Date)
			{
				"New Year's Day" { $Holidays += $NewYearsDay }
				"Martin Luther King Day" { $Holidays += $MLKDay }
				"Presidents' Day" { $Holidays += $PresidentsDay }
				"Memorial Day" { $Holidays += $MemorialDay }
				"Independence Day" { $Holidays += $IndependenceDay }
				"Labor Day" { $Holidays += $LaborDay }
				"Columbus Day" { $Holidays += $ColumbusDay }
				"Veterans Day" { $Holidays += $VeteransDay }
				"Thanksgiving Day" { $Holidays += $Thanksgiving }
				"Christmas Day" { $Holidays += $Christmas }
			}
		}		
        
        [DateTime[]]$DaysAfterHolidays = @()

		if ($IncludeDayAfter -or $OnlyDayAfter)
		{
			foreach ($Date in $Holidays)
			{
				$DaysAfterHolidays += ($Date.AddDays(1))
			}
		}
        
        If($OnlyDayAfter)
        {
            $Holidays = $DaysAfterHolidays
        }
        ElseIf($IncludeDayAfter)
        {
            $Holidays += $DaysAfterHolidays
        }
		
		$Holidays = $Holidays | sort-object
		
		if ($ReturnType -eq "String")
		{
			$Holidays = [string[]]$Holidays
		}
		
		if ($IsTodayAHoliday)
		{
			return ((get-date -Format MM/dd/yyyy) -in [string[]]$Holidays)
		}
		else
		{
			return $Holidays
		}
	}
}
