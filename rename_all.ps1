$directories = @(
    "Wedding-Films",
    "Pre-Wedding",
    "Maternity-Baby",
    "Haldi-Mehndi",
    "Family-Lifestyle",
    "Engagement",
    "Corporate-Events",
    "Commercial-Shoots",
    "Birthdays"
)

$basePath = "C:\Users\Himanshu Chaurasiya\Downloads\wedding-images"

foreach ($dir in $directories) {
    $fullPath = Join-Path $basePath $dir
    if (Test-Path $fullPath) {
        Write-Host "Processing $dir..."
        
        # Step 1: Rename all files to a temporary GUID based name to avoid collisions
        $files = Get-ChildItem -Path $fullPath -File
        foreach ($file in $files) {
            # Skip if it is .gitkeep
            if ($file.Name -eq ".gitkeep") { continue }
            
            $tempName = [Guid]::NewGuid().ToString() + $file.Extension
            Rename-Item -Path $file.FullName -NewName $tempName
        }

        # Step 2: Rename them to simple sequential names
        # We re-fetch to ensure we have the temp files, and sort them so the order is deterministic (or random, depending on file system)
        # Since the user didn't specify an order, random/system order is fine, but we'll sort by name to be stable
        $filesInfo = Get-ChildItem -Path $fullPath -File | Where-Object { $_.Name -ne ".gitkeep" }
        $count = 1
        
        foreach ($file in $filesInfo) {
            $newName = "image-$count" + $file.Extension
            $newFullPath = Join-Path $fullPath $newName
            Rename-Item -Path $file.FullName -NewName $newName
            $count++
        }
        Write-Host "Done with $dir. Renamed $($count - 1) files."
    } else {
        Write-Host "Directory not found: $dir"
    }
}
