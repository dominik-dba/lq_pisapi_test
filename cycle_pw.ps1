param(
    [string]$Version = '1.1',
    [string]$Ticket = 'cycle'
)

$ErrorActionPreference = 'Stop'

$env:REF_URL = 'jdbc:oracle:thin:@pngodb.src.si:1521/pngordn'
$env:REF_USER = 'PIS_STORITVE_POS'
$env:REF_PASS = 'PIS_STORITVE_POS'
$env:TGT_URL = 'jdbc:oracle:thin:@ora26ai.src.si:1521/orclpdb'
$env:TGT_USER = 'PIS_STORITVE_POS'
$env:TGT_PASS = 'PIS_STORITVE_POS'
$env:LIQUIBASE_HOME = 'C:\Ant\liquibase\'
$env:LD_LIBRARY_PATH = 'C:\Oracle\product\instantclient_23_26;C:\Oracle\product\instantclient_23_26'

$root = $PSScriptRoot
Set-Location -Path $root

$featureBranch = "feature/PISAPI-$Version-$Ticket"
$stageBranch = "stage/$Version"
$releaseTag = "v$Version"
$artifact = "artifact/PISAPI-$Version.zip"
$script:remoteName = $null
$lbDiffFile = "lb_diff_$Version.xml"
$lbDiffSql = "lb_diff_$Version.sql"

function Invoke-External {
    param(
        [Parameter(Mandatory = $true)][string]$File,
        [Parameter()][string[]]$Args = @()
    )

    & $File @Args
    if ($LASTEXITCODE -ne 0) {
        $argText = ($Args -join ' ')
        throw "Command failed ($LASTEXITCODE): $File $argText"
    }
}

function Test-BranchExists {
    param([Parameter(Mandatory = $true)][string]$BranchName)

    & git show-ref --verify --quiet "refs/heads/$BranchName"
    return ($LASTEXITCODE -eq 0)
}

function Preflight {
    & git rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw 'ERROR: current folder is not a git repository.'
    }

    $status = & git status --porcelain
    if ($LASTEXITCODE -ne 0) {
        throw 'ERROR: failed to inspect git working tree.'
    }

    if ($status) {
        & git status --short
        throw 'ERROR: working tree is not clean. Commit or stash changes before running cycle.'
    }

    if (Test-BranchExists -BranchName $featureBranch) {
        throw "ERROR: feature branch already exists: $featureBranch"
    }

    if (Test-BranchExists -BranchName $stageBranch) {
        throw "ERROR: stage branch already exists: $stageBranch"
    }
}

function Detect-Remote {
    $configuredRemote = (& git config --get branch.main.remote 2>$null)
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($configuredRemote)) {
        $script:remoteName = $configuredRemote.Trim()
        return
    }

    $remotes = (& git remote)
    if ($LASTEXITCODE -eq 0 -and $remotes) {
        $script:remoteName = $remotes[0].Trim()
    }
}

function Pull-Main {
    Detect-Remote
    if ([string]::IsNullOrWhiteSpace($script:remoteName)) {
        Write-Host 'WARNING: no git remote configured. Skipping pull for main.'
        return
    }

    & git ls-remote --exit-code --heads $script:remoteName main *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNING: $($script:remoteName)/main does not exist yet. Skipping pull for initial remote bootstrap."
        return
    }

    & git rev-parse --abbrev-ref --symbolic-full-name '@{u}' *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "main has no upstream tracking. Using $($script:remoteName)/main and setting upstream..."
        Invoke-External -File git -Args @('pull', $script:remoteName, 'main')
        & git branch "--set-upstream-to=$($script:remoteName)/main" main *> $null
        return
    }

    Invoke-External -File git -Args @('pull')
}

try {
    Write-Host 'USAGE: cycle_pw.ps1 [-Version 1.5] [-Ticket cycle]'

    Invoke-External -File git -Args @('checkout', 'main')
    Invoke-External -File git -Args @('add', '.')
    Invoke-External -File git -Args @('commit', '-m', 'NC')
    Invoke-External -File git -Args @('push')

    Set-Location -Path $root

    Preflight

    Write-Host '=========================================================='
    Write-Host "NEXT CYCLE RUNBOOK - VERSION $Version"
    Write-Host "Feature branch: $featureBranch"
    Write-Host "Stage branch:   $stageBranch"
    Write-Host '=========================================================='
    Write-Host

    Write-Host '[1/9] Create feature branch from main'
    Invoke-External -File git -Args @('push')

    Pull-Main

    Invoke-External -File git -Args @('checkout', '-b', $featureBranch)

    Write-Host
    Write-Host 'Apply your schema/object changes in DEV now.'
    [void](Read-Host 'Press Enter to continue')

    Write-Host '=========================================================='
    Write-Host 'EXPORT'
    Write-Host '=========================================================='

    Write-Host '[2/9] PROJECT export from DEV'
    Invoke-External -File C:\Ant\sqlcl2026\bin\sql.exe -Args @('-thin', '-name', 'dev', '@src/scripts/during/next_cycle_project_export.sql')
    Write-Host

    Write-Host '[3/9] Commit feature changes and merge to main'
    Invoke-External -File git -Args @('add', '.')
    Invoke-External -File git -Args @('commit', '-m', "Feature ${Ticket}: export project changes")

    Invoke-External -File git -Args @('checkout', '-b', $stageBranch)

    Write-Host '=========================================================='
    Write-Host 'STAGE'
    Write-Host '=========================================================='

    Write-Host '[4/9] PROJECT stage and commit release changelog'
    Invoke-External -File C:\Ant\sqlcl2026\bin\sql.exe -Args @('-thin', '-name', 'dev', '@src/scripts/during/next_cycle_project_stage.sql')

    Invoke-External -File git -Args @('log', '--oneline', '--decorate', '--graph', '-n', '10')

    Invoke-External -File git -Args @('add', '.')
    Invoke-External -File git -Args @('commit', '-m', "Prepare release changelog $Version")

    Write-Host '=========================================================='
    Write-Host 'RELEASE, GEN ARTIFACT'
    Write-Host '=========================================================='

    Write-Host '[5/9] PROJECT release and artifact generation'
    Invoke-External -File C:\Ant\sqlcl2026\bin\sql.exe -Args @('-thin', '-name', 'dev', '@src/scripts/during/next_cycle_project_release.sql', $Version)

    Write-Host '[6/9] Freeze release in git'
    Invoke-External -File git -Args @('restore', '.dbtools/project.config.json')
    Invoke-External -File git -Args @('add', '-A', 'dist/releases')
    Invoke-External -File git -Args @('commit', '-m', "Release $Version")
    Invoke-External -File git -Args @('status')
    Invoke-External -File git -Args @('diff', '--name-status')

    Invoke-External -File git -Args @('commit', '-m', '"Freeze release $Version baseline"')

    Invoke-External -File git -Args @('checkout', 'main')
    Invoke-External -File git -Args @('merge', '--no-ff', $stageBranch, '-m', "Merge $stageBranch to main")

    Invoke-External -File git -Args @('tag', $releaseTag)
    Invoke-External -File git -Args @('push', '-u', 'origin', 'main', "stage/$Version", '--tags')

    Write-Host '[7/9] Optional incremental deploy to PROD (no reset)'
    Write-Host 'If PROD already has previous version, this deploy applies only new changesets.'
    [void](Read-Host 'Press Enter to continue')

    Write-Host '[8/9] Merge stage to main'

    Invoke-External -File git -Args @('checkout', 'main')
    Invoke-External -File git -Args @('merge', '--no-ff', $stageBranch, '-m', "Merge $stageBranch to main")

    Write-Host '[9/9] Final commit/tag push (manual review first)'

    Write-Host 'NOTE:'
    Write-Host 'Deploy using SQLcl Project artifact:'
    Write-Host "  C:\Ant\sqlcl2026\bin\sql.exe -thin -name prod @src/scripts/during/next_cycle_project_deploy.sql $Version"

    Write-Host 'No LB diff/update-sql path is used in this incremental cycle script.'
    Write-Host 'Review branch state and push when ready:'
    if (-not [string]::IsNullOrWhiteSpace($script:remoteName)) {
        Write-Host "  git push -u $($script:remoteName) main $stageBranch --tags"
    }
    else {
        Write-Host '  git push -u <your-remote> main <stage-branch> --tags'
    }

    Write-Host
    Write-Host 'SUCCESS: next cycle flow completed.'
    exit 0
}
catch {
    $exitCode = if ($LASTEXITCODE -ne 0) { $LASTEXITCODE } else { 1 }
    Write-Host
    Write-Host "ERROR: $($_.Exception.Message)"
    Write-Host "Stop point kept for investigation. Exit code: $exitCode"
    exit $exitCode
}
