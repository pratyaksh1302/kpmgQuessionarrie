function Get-NestValue {
    param (
      [Parameter(Mandatory=$true)]
      [Object]$Object,
      
      [Parameter(Mandatory=$true)]
      [String]$Key
    )
    
    $keys = $Key -split '\.'
    $value = $Object
    
    foreach ($k in $keys) {
      $value = $value[$k]
    }
    $value
  }
  
  $nestedObject = @{
    'a' = @{
        'b' = @{
            'c' = @{
              'd'= 'e'
            }
        }
    }
}

$value = Get-NestValue -Object $nestedObject -Key 'a.b.c.d'
Write-Output $value
