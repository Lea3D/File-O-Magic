# Function to select a folder
function Select-Folder {
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.ShowDialog() | Out-Null
    return $folderDialog.SelectedPath
}
