# Function to load color preset from a .cfg file
function Get-ColorPreset {
    param ([string]$presetFile)

    if (Test-Path $presetFile) {
        $config = Get-Content $presetFile | ForEach-Object {
            $key, $value = $_ -split '='
            if (-not [string]::IsNullOrEmpty($key) -and -not [string]::IsNullOrEmpty($value) -and -not $key.StartsWith("#")) {
                [PSCustomObject]@{ Key = $key.Trim(); Value = $value.Trim() }
            }
        }

        $colorPreset = @{}
        foreach ($item in $config) {
            try {
                if ($item.Value.StartsWith("#")) {
                    $colorPreset[$item.Key] = Convert-HexToColor -hexColor $item.Value
                } else {
                    $colorPreset[$item.Key] = [System.Drawing.Color]::FromName($item.Value)
                    if (-not $colorPreset[$item.Key].IsKnownColor) {
                        throw "Invalid color: $($item.Value)"
                    }
                }
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error processing $($item.Key): $($_)")
                return $null
            }
        }
        return $colorPreset
    } else {
        [System.Windows.Forms.MessageBox]::Show("Color preset file not found: $presetFile")
        return $null
    }
}

# Function to convert Hex color to System.Drawing.Color
function Convert-HexToColor {
    param ([string]$hexColor)
    
    $hexColor = $hexColor.TrimStart('#')
    if ($hexColor.Length -eq 6) {
        $r = [Convert]::ToInt32($hexColor.Substring(0, 2), 16)
        $g = [Convert]::ToInt32($hexColor.Substring(2, 2), 16)
        $b = [Convert]::ToInt32($hexColor.Substring(4, 2), 16)
        return [System.Drawing.Color]::FromArgb($r, $g, $b)
    } else {
        throw "Invalid Hex color: $hexColor"
    }
}
