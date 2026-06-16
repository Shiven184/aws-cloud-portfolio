# Configurations
$BUCKET_NAME = "my-portfolio-site-485141928127-website"
$PROJECTS = @(
    "project-1-cloudfront",
    "project-2-serverless-api",
    "project-3-three-tier-app",
    "project-4-cicd-pipeline",
    "project-5-terraform",
    "project-6-cost-optimizer"
)

Write-Host "Checking AWS CLI installation..." -ForegroundColor Cyan
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Error "AWS CLI is not installed or not in PATH. Please install it and configure it using 'aws configure' first."
    return
}

Write-Host "Creating screenshot folders in S3 bucket: $BUCKET_NAME..." -ForegroundColor Cyan

# Create a temporary empty file to use as a placeholder to force S3 folder creation
$TempFile = New-TemporaryFile
"Placeholder for folder structure" | Out-File $TempFile -Encoding utf8

foreach ($Project in $PROJECTS) {
    $S3Path = "s3://$BUCKET_NAME/screenshots/$Project/placeholder.txt"
    Write-Host "Creating folder structure for: $Project..." -ForegroundColor Yellow
    
    # Upload placeholder file to establish the folder prefix path
    aws s3 cp $TempFile $S3Path --quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully verified: screenshots/$Project/" -ForegroundColor Green
    } else {
        Write-Host "Failed to create folder structure for $Project. Check your AWS permissions." -ForegroundColor Red
    }
}

Remove-Item $TempFile
Write-Host "`nAll folder pathways initialized! You can now upload your 01.png to 05.png files into these directories via the AWS Console." -ForegroundColor Green