﻿$ErrorActionPreference = 'Stop'

Install-VsCodeExtension -extensionId 'puppet.puppet-vscode@1.5.4'

Write-Warning "If installed, you'll need to uninstall the old 'jpogran.puppet-vscode' puppet extension manually."
