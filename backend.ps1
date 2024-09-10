param (
    [string]$SourcePath,
    [string]$DestinationPath,
    [string]$SearchString1,
    [string]$SearchString2 = "",
    [string]$SearchString3 = "",
    [string]$SearchString4 = "",
    [string]$Operator1 = "",
    [string]$Operator2 = "",
    [string]$Operator3 = ""
)

# Prüfe, ob das Quell- und Zielverzeichnis angegeben sind
if (-not (Test-Path $SourcePath)) {
    Write-Host "Source path is invalid: $SourcePath"
    return "Source path is invalid"
}

if (-not (Test-Path $DestinationPath)) {
    Write-Host "Destination path is invalid: $DestinationPath"
    return "Destination path is invalid"
}

# Initialisiere den Filter basierend auf dem ersten Suchstring
$filter = { $_.Name -like "*$SearchString1*" -and $_.PSIsContainer -eq $false }

# Füge den Operator 1 hinzu, wenn SearchString2 definiert ist
if ($SearchString2 -ne "") {
    if ($Operator1 -eq "AND") {
        $filter = {
            ($_.Name -like "*$SearchString1*") -and ($_.Name -like "*$SearchString2*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator1 -eq "OR") {
        $filter = {
            ($_.Name -like "*$SearchString1*") -or ($_.Name -like "*$SearchString2*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator1 -eq "NOT") {
        $filter = {
            ($_.Name -like "*$SearchString1*") -and ($_.Name -notlike "*$SearchString2*") -and $_.PSIsContainer -eq $false
        }
    }
}

# Füge den Operator 2 hinzu, wenn SearchString3 definiert ist
if ($SearchString3 -ne "") {
    if ($Operator2 -eq "AND") {
        $filter = {
            (& $filter) -and ($_.Name -like "*$SearchString3*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator2 -eq "OR") {
        $filter = {
            (& $filter) -or ($_.Name -like "*$SearchString3*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator2 -eq "NOT") {
        $filter = {
            (& $filter) -and ($_.Name -notlike "*$SearchString3*") -and $_.PSIsContainer -eq $false
        }
    }
}

# Füge den Operator 3 hinzu, wenn SearchString4 definiert ist
if ($SearchString4 -ne "") {
    if ($Operator3 -eq "AND") {
        $filter = {
            (& $filter) -and ($_.Name -like "*$SearchString4*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator3 -eq "OR") {
        $filter = {
            (& $filter) -or ($_.Name -like "*$SearchString4*") -and $_.PSIsContainer -eq $false
        }
    } elseif ($Operator3 -eq "NOT") {
        $filter = {
            (& $filter) -and ($_.Name -notlike "*$SearchString4*") -and $_.PSIsContainer -eq $false
        }
    }
}

# Finde die passenden Dateien
$filesToMove = Get-ChildItem -Path $SourcePath -Recurse | Where-Object $filter

# Wenn keine Dateien gefunden wurden
if ($filesToMove.Count -eq 0) {
    Write-Host "No files found matching the criteria."
    return "No files found matching the criteria"
}

# Verschiebe die Dateien mit ihren übergeordneten Ordnern
foreach ($file in $filesToMove) {
    try {
        $parentFolder = $file.DirectoryName
        if (-not $parentFolder) {
            Write-Host "Invalid parent folder for file: $($file.FullName)"
            continue
        }
        
        $folderName = Split-Path $parentFolder -Leaf
        $destinationFolder = Join-Path $DestinationPath $folderName

        if (Test-Path $destinationFolder) {
            Write-Host "Target folder '$destinationFolder' already exists. File '$($file.Name)' will not be moved."
        } else {
            Move-Item -Path $parentFolder -Destination $destinationFolder
            Write-Host "Folder '$parentFolder' was moved to '$destinationFolder'."
        }
    } catch {
        Write-Host "Error moving folder '$($file.DirectoryName)': $_"
        return "Error moving folder '$($file.DirectoryName)': $_"
    }
}
