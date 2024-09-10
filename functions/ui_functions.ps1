# Function to disable other checkboxes
function Disable-OtherCheckboxes {
    param ([System.Windows.Forms.CheckBox]$activeCheckbox)

    $checkboxes = @($checkbox1, $checkbox2, $checkbox3, $checkbox4)
    foreach ($checkbox in $checkboxes) {
        if ($checkbox -ne $activeCheckbox) {
            $checkbox.Checked = $false
        }
    }
}

# Function to set colors on the form and controls
function Set-ColorPreset {
    param ([hashtable]$colorPreset)

    if ($null -ne $colorPreset) {
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
    } else {
        [System.Windows.Forms.MessageBox]::Show("Color preset could not be applied.")
    }
}
