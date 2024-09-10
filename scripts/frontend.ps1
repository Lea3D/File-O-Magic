# Lade Windows Forms und Drawing (für Farben)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Funktion zum Öffnen des Folder-Browser-Dialogs
function Select-Folder {
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.ShowDialog() | Out-Null
    return $folderDialog.SelectedPath
}

# Funktion zum Umwandeln von Hex-Farben in System.Drawing.Color
function Convert-HexToColor {
    param (
        [string]$hexColor
    )

    # Entferne das '#' falls vorhanden
    $hexColor = $hexColor.TrimStart('#')

    # Überprüfe, ob der Hex-Farbwert korrekt formatiert ist
    if ($hexColor.Length -eq 6) {
        $r = [Convert]::ToInt32($hexColor.Substring(0, 2), 16)
        $g = [Convert]::ToInt32($hexColor.Substring(2, 2), 16)
        $b = [Convert]::ToInt32($hexColor.Substring(4, 2), 16)

        return [System.Drawing.Color]::FromArgb($r, $g, $b)
    } else {
        throw "Ungültige Hex-Farbe: $hexColor"
    }
}

# Funktion zum Laden des Farbpresets aus einer .cfg Datei und Konvertierung der Strings zu Farben
function Get-ColorPreset {
    param (
        [string]$presetFile
    )

    if (Test-Path $presetFile) {
        $config = Get-Content $presetFile | ForEach-Object {
            $key, $value = $_ -split '='
            
    if (-not [string]::IsNullOrEmpty($key) -and -not [string]::IsNullOrEmpty($value) -and -not $key.StartsWith("#")) {
        [PSCustomObject]@{ Key = $key.Trim(); Value = $value.Trim() }
    }
    
        }

        # Konvertiere das Preset in eine Hashtable für den schnellen Zugriff
        $colorPreset = @{}
        foreach ($item in $config) {
            try {
                # Wenn der Wert mit '#' beginnt, behandle ihn als Hex-Farbe
                if ($item.Value.StartsWith("#")) {
                    $colorPreset[$item.Key] = Convert-HexToColor -hexColor $item.Value
                } else {
                    # Versuch, den Farbwert als Namen zu konvertieren
                    $colorPreset[$item.Key] = [System.Drawing.Color]::FromName($item.Value)
                    if (-not $colorPreset[$item.Key].IsKnownColor) {
                        throw "Ungültige Farbe oder Hex-Wert: $($item.Value)"
                    }
                }
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Fehler bei der Konvertierung von $($item.Key): $($_)")
                return $null
            }
        }
        return $colorPreset
    } else {
        [System.Windows.Forms.MessageBox]::Show("Farbpreset-Datei nicht gefunden: $presetFile")
        return $null
    }
}

# Funktion zum Anwenden des Farbpresets auf die GUI
function Set-ColorPreset {
    param (
        [hashtable]$colorPreset
    )

    if ($null -ne $colorPreset) {
        # Anwenden der Farben, falls gültig
        $form.BackColor = $colorPreset['BackgroundColor']
        $form.ForeColor = $colorPreset['ForegroundColor']
        $buttonBrowseSource.BackColor = $colorPreset['ButtonBackgroundColor']
        $buttonBrowseSource.ForeColor = $colorPreset['ButtonForegroundColor']
        $buttonBrowseDestination.BackColor = $colorPreset['ButtonBackgroundColor']
        $buttonBrowseDestination.ForeColor = $colorPreset['ButtonForegroundColor']
        $buttonStart.BackColor = $colorPreset['ButtonBackgroundColor']
        $buttonStart.ForeColor = $colorPreset['ButtonForegroundColor']
        $textboxSource.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxSource.ForeColor = $colorPreset['TextboxForegroundColor']
        $textboxDestination.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxDestination.ForeColor = $colorPreset['TextboxForegroundColor']
        $textboxSearch1.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxSearch1.ForeColor = $colorPreset['TextboxForegroundColor']
        $textboxSearch2.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxSearch2.ForeColor = $colorPreset['TextboxForegroundColor']
        $textboxSearch3.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxSearch3.ForeColor = $colorPreset['TextboxForegroundColor']
        $textboxSearch4.BackColor = $colorPreset['TextboxBackgroundColor']
        $textboxSearch4.ForeColor = $colorPreset['TextboxForegroundColor']
    } else {
        [System.Windows.Forms.MessageBox]::Show("Farbpreset konnte nicht angewendet werden.")
    }
}

# Funktion zum Deaktivieren der anderen Checkboxen
function Disable-OtherCheckboxes {
    param (
        [System.Windows.Forms.CheckBox]$activeCheckbox
    )

    $checkboxes = @($checkbox1, $checkbox2, $checkbox3, $checkbox4)
    foreach ($checkbox in $checkboxes) {
        if ($checkbox -ne $activeCheckbox) {
            $checkbox.Checked = $false
        }
    }
}

# Form erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "File Transfer Tool"
$form.Width = 800
$form.Height = 800

# Labels für Source- und Destination-Verzeichnis erstellen
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Text = "Source Directory:"
$labelSource.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($labelSource)

$labelDestination = New-Object System.Windows.Forms.Label
$labelDestination.Text = "Target Directory:"
$labelDestination.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($labelDestination)

# Textboxen für Source- und Destination-Verzeichnis erstellen (halbe Breite)
$textboxSource = New-Object System.Windows.Forms.TextBox
$textboxSource.Location = New-Object System.Drawing.Point(150, 20)
$textboxSource.Width = 300
$form.Controls.Add($textboxSource)

$textboxDestination = New-Object System.Windows.Forms.TextBox
$textboxDestination.Location = New-Object System.Drawing.Point(150, 60)
$textboxDestination.Width = 300
$form.Controls.Add($textboxDestination)

# Buttons zum Durchsuchen der Verzeichnisse
$buttonBrowseSource = New-Object System.Windows.Forms.Button
$buttonBrowseSource.Text = "Browse"
$buttonBrowseSource.Location = New-Object System.Drawing.Point(460, 20)
$buttonBrowseSource.Width = 100
$form.Controls.Add($buttonBrowseSource)

$buttonBrowseDestination = New-Object System.Windows.Forms.Button
$buttonBrowseDestination.Text = "Browse"
$buttonBrowseDestination.Location = New-Object System.Drawing.Point(460, 60)
$buttonBrowseDestination.Width = 100
$form.Controls.Add($buttonBrowseDestination)

# Labels für die Suchstrings und Operatoren
$labelSearch1 = New-Object System.Windows.Forms.Label
$labelSearch1.Text = "Search String 1:"
$labelSearch1.Location = New-Object System.Drawing.Point(10, 100)
$form.Controls.Add($labelSearch1)

$labelSearch2 = New-Object System.Windows.Forms.Label
$labelSearch2.Text = "Search String 2:"
$labelSearch2.Location = New-Object System.Drawing.Point(10, 140)
$form.Controls.Add($labelSearch2)

$labelSearch3 = New-Object System.Windows.Forms.Label
$labelSearch3.Text = "Search String 3:"
$labelSearch3.Location = New-Object System.Drawing.Point(10, 180)
$form.Controls.Add($labelSearch3)

$labelSearch4 = New-Object System.Windows.Forms.Label
$labelSearch4.Text = "Search String 4:"
$labelSearch4.Location = New-Object System.Drawing.Point(10, 220)
$form.Controls.Add($labelSearch4)

# Textboxen für die Suchstrings (halbe Breite)
$textboxSearch1 = New-Object System.Windows.Forms.TextBox
$textboxSearch1.Location = New-Object System.Drawing.Point(150, 100)
$textboxSearch1.Width = 300
$form.Controls.Add($textboxSearch1)

$textboxSearch2 = New-Object System.Windows.Forms.TextBox
$textboxSearch2.Location = New-Object System.Drawing.Point(150, 140)
$textboxSearch2.Width = 300
$form.Controls.Add($textboxSearch2)

$textboxSearch3 = New-Object System.Windows.Forms.TextBox
$textboxSearch3.Location = New-Object System.Drawing.Point(150, 180)
$textboxSearch3.Width = 300
$form.Controls.Add($textboxSearch3)

$textboxSearch4 = New-Object System.Windows.Forms.TextBox
$textboxSearch4.Location = New-Object System.Drawing.Point(150, 220)
$textboxSearch4.Width = 300
$form.Controls.Add($textboxSearch4)

# Dropdowns für die Operatoren erstellen
$dropdownOperator1 = New-Object System.Windows.Forms.ComboBox
$dropdownOperator1.Items.AddRange(@("AND", "OR", "NOT"))
$dropdownOperator1.SelectedIndex = 0
$dropdownOperator1.Location = New-Object System.Drawing.Point(460, 100)
$dropdownOperator1.Width = 100
$form.Controls.Add($dropdownOperator1)

$dropdownOperator2 = New-Object System.Windows.Forms.ComboBox
$dropdownOperator2.Items.AddRange(@("AND", "OR", "NOT"))
$dropdownOperator2.SelectedIndex = 0
$dropdownOperator2.Location = New-Object System.Drawing.Point(460, 140)
$dropdownOperator2.Width = 100
$form.Controls.Add($dropdownOperator2)

$dropdownOperator3 = New-Object System.Windows.Forms.ComboBox
$dropdownOperator3.Items.AddRange(@("AND", "OR", "NOT"))
$dropdownOperator3.SelectedIndex = 0
$dropdownOperator3.Location = New-Object System.Drawing.Point(460, 180)
$dropdownOperator3.Width = 100
$form.Controls.Add($dropdownOperator3)

# Checkboxen für die Themes
$groupBoxThemes = New-Object System.Windows.Forms.GroupBox
$groupBoxThemes.Text = "Theme"
$groupBoxThemes.Location = New-Object System.Drawing.Point(620, 10)
$groupBoxThemes.Size = New-Object System.Drawing.Size(150, 140)
$form.Controls.Add($groupBoxThemes)

$checkbox1 = New-Object System.Windows.Forms.CheckBox
$checkbox1.Text = "1"
$checkbox1.Location = New-Object System.Drawing.Point(20, 30)
$groupBoxThemes.Controls.Add($checkbox1)

$checkbox2 = New-Object System.Windows.Forms.CheckBox
$checkbox2.Text = "2"
$checkbox2.Location = New-Object System.Drawing.Point(20, 60)
$groupBoxThemes.Controls.Add($checkbox2)

$checkbox3 = New-Object System.Windows.Forms.CheckBox
$checkbox3.Text = "3"
$checkbox3.Location = New-Object System.Drawing.Point(20, 90)
$groupBoxThemes.Controls.Add($checkbox3)

$checkbox4 = New-Object System.Windows.Forms.CheckBox
$checkbox4.Text = "4"
$checkbox4.Location = New-Object System.Drawing.Point(20, 120)
$groupBoxThemes.Controls.Add($checkbox4)

# Sicherstellen, dass immer nur eine Checkbox aktiviert ist
function Disable-OtherCheckboxes {
    param (
        [System.Windows.Forms.CheckBox]$activeCheckbox
    )

    $checkboxes = @($checkbox1, $checkbox2, $checkbox3, $checkbox4)
    foreach ($checkbox in $checkboxes) {
        if ($checkbox -ne $activeCheckbox) {
            $checkbox.Checked = $false
        }
    }
}

# Event-Handler für die Checkboxen
$checkbox1.Add_CheckedChanged({
    if ($checkbox1.Checked) {
        Disable-OtherCheckboxes -activeCheckbox $checkbox1
        $presetFile = ".\color_preset_1.cfg"
        $colorPreset = Get-ColorPreset -presetFile $presetFile
        Set-ColorPreset -colorPreset $colorPreset
    }
})

$checkbox2.Add_CheckedChanged({
    if ($checkbox2.Checked) {
        Disable-OtherCheckboxes -activeCheckbox $checkbox2
        $presetFile = ".\color_preset_2.cfg"
        $colorPreset = Get-ColorPreset -presetFile $presetFile
        Set-ColorPreset -colorPreset $colorPreset
    }
})

$checkbox3.Add_CheckedChanged({
    if ($checkbox3.Checked) {
        Disable-OtherCheckboxes -activeCheckbox $checkbox3
        $presetFile = ".\color_preset_3.cfg"
        $colorPreset = Get-ColorPreset -presetFile $presetFile
        Set-ColorPreset -colorPreset $colorPreset
    }
})

$checkbox4.Add_CheckedChanged({
    if ($checkbox4.Checked) {
        Disable-OtherCheckboxes -activeCheckbox $checkbox4
        $presetFile = ".\color_preset_4.cfg"
        $colorPreset = Get-ColorPreset -presetFile $presetFile
        Set-ColorPreset -colorPreset $colorPreset
    }
})

# Start-Button
$buttonStart = New-Object System.Windows.Forms.Button
$buttonStart.Text = "Start"
$buttonStart.Location = New-Object System.Drawing.Point(150, 340)
$buttonStart.Width = 100
$form.Controls.Add($buttonStart)

# Log Textbox
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Location = New-Object System.Drawing.Point(150, 380)
$logBox.Width = 550
$logBox.Height = 350
$form.Controls.Add($logBox)

# Event-Handler für die Buttons
$buttonBrowseSource.Add_Click({
    $textboxSource.Text = Select-Folder
})

$buttonBrowseDestination.Add_Click({
    $textboxDestination.Text = Select-Folder
})

$buttonStart.Add_Click({
    if ($textboxSource.Text -eq "" -or $textboxDestination.Text -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Please select both source and destination directories.")
    } else {
        $logBox.AppendText("Starting file transfer...`r`n")
        $sourcePath = $textboxSource.Text
        $destinationPath = $textboxDestination.Text

        $searchString1 = $textboxSearch1.Text
        $searchString2 = $textboxSearch2.Text
        $searchString3 = $textboxSearch3.Text
        $searchString4 = $textboxSearch4.Text

        $operator1 = $dropdownOperator1.SelectedItem
        $operator2 = $dropdownOperator2.SelectedItem
        $operator3 = $dropdownOperator3.SelectedItem

        # Aufruf des Backend-Skripts zur Durchführung des Dateivorgangs
        $backendScript = ".\backend.ps1"
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$backendScript`" -SourcePath `"$sourcePath`" -DestinationPath `"$destinationPath`" -SearchString1 `"$searchString1`" -SearchString2 `"$searchString2`" -SearchString3 `"$searchString3`" -SearchString4 `"$searchString4`" -Operator1 `"$operator1`" -Operator2 `"$operator2`" -Operator3 `"$operator3`"" -Wait
        $logBox.AppendText("File transfer completed.`r`n")
    }
})

# Form anzeigen
$form.ShowDialog()

