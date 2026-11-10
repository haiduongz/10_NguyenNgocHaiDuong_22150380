# GitHub push helper — Windows PowerShell
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$repoUrl = 'https://github.com/haiduongz/Du_an_quan_ly_dat_phong_khach_san.git'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Chua cai Git. Cai Git for Windows, mo lai VS Code, chay lai script.'
}
if (-not (Test-Path 'pom.xml')) { throw 'Khong tim thay pom.xml. Kiem tra thu muc du an.' }

if (-not (Test-Path '.git')) { git init -b main }
$remote = @(git remote)
if ($LASTEXITCODE -ne 0) { throw 'Khong kiem tra duoc git remote.' }
if ($remote -notcontains 'origin') {
    git remote add origin $repoUrl
} else {
    $current = git remote get-url origin
    if ($current.Trim() -ne $repoUrl) {
        throw "Remote origin dang tro den '$current'. Khong thay doi tu dong. Hay kiem tra de tranh day nham repository."
    }
}
git add .
if ($LASTEXITCODE -ne 0) { throw 'git add that bai.' }
$changes = git diff --cached --name-only
if ($changes) {
    git commit -m 'Initial commit: Hotel booking system with 6 design patterns'
    if ($LASTEXITCODE -ne 0) { throw 'git commit that bai. Hay cau hinh git user.name va user.email.' }
}
$branch = (git branch --show-current).Trim()
if ($branch -ne 'main') { throw "Nhanh hien tai la '$branch', khong phai main. Khong push tu dong de tranh sai nhanh." }
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    throw 'git push that bai. Kiem tra repository da duoc tao tai github.com/new va dang nhap GitHub khi duoc yeu cau.'
}
Write-Host "Thanh cong: https://github.com/haiduongz/Du_an_quan_ly_dat_phong_khach_san" -ForegroundColor Green
