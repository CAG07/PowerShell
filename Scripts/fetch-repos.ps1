﻿<#
.SYNOPSIS
	Fetches updates for all Git repositories in a folder (including submodules)
.DESCRIPTION
	fetch-repos.ps1 [<ParentDir>]
.EXAMPLE
	PS> ./fetch-repos C:\MyRepos
.NOTES
	Author: Markus Fleschutz · License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

param([string]$ParentDir = "$PWD")

try {
	$StopWatch = [system.diagnostics.stopwatch]::startNew()

	if (-not(test-path "$ParentDir" -pathType container)) { throw "Can't access directory: $ParentDir" }

	$Null = (git --version)
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	$Folders = (get-childItem "$ParentDir" -attributes Directory)
	$FolderCount = $Folders.Count
	$ParentDirName = (get-item "$ParentDir").Name
	"Found $FolderCount subfolders in 📂$ParentDirName..."

	[int]$Step = 1
	foreach ($Folder in $Folders) {
		$FolderName = (get-item "$Folder").Name
		"⏳ Step $Step/$($FolderCount): Fetching 📂$FolderName..."

		& git -C "$Folder" fetch --all --recurse-submodules --prune --prune-tags --force
		if ($lastExitCode -ne "0") { throw "'git fetch' in $Folder failed" }

		$Step++
	}

	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ fetched $FolderCount Git repositories at 📂$ParentDirName in $Elapsed sec"
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}
