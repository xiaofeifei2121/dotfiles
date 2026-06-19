function npm-proxy-on {
    npm config set proxy $script:ProxyHttp
    npm config set https-proxy $script:ProxyHttp
    Write-Host "npm proxy enabled (port: $script:ProxyPort)"
}

function npm-proxy-off {
    npm config delete proxy 2>$null
    npm config delete https-proxy 2>$null
    Write-Host "npm proxy disabled"
}

function npm-cn {
    npm config set registry https://registry.npmmirror.com
    npm config delete proxy 2>$null
    npm config delete https-proxy 2>$null
    Write-Host "npm registry switched to npmmirror"
}

function npm-official {
    npm config set registry https://registry.npmjs.org
    Write-Host "npm registry switched to official"
}

function npm-auto {
    Write-Host "Checking network..."
    try {
        Invoke-WebRequest https://registry.npmjs.org -TimeoutSec 8 -UseBasicParsing | Out-Null
        npm-official
    } catch {
        npm-cn
    }
}
