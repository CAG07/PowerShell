﻿<#
.SYNOPSIS
	Gives a reply 
.DESCRIPTION
	This script gives a reply in English on the console and by text-to-speech (TTS).
.PARAMETER text
	Specifies the text to speak
.EXAMPLE
	PS> ./give-reply "Hello World"
.NOTES
	Author: Markus Fleschutz · License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

param([string]$text = "")

try {
	# print reply on the console:
	" ← $text"

	# speak by text-to-speech (TTS):
	if (!$IsLinux) {
		$TTSVoice = New-Object -ComObject SAPI.SPVoice
		foreach ($Voice in $TTSVoice.GetVoices()) {
			if ($Voice.GetDescription() -like "*- English*") { $TTSVoice.Voice = $Voice }
		}
		[void]$TTSVoice.Speak($text)
	}

	# remember last reply:
	"$text" > "$env:TEMP/last_reply.txt"
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}
