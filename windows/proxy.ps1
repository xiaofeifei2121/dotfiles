# v2rayN proxy control. Update this if your mixed port changes.
$script:ProxyPort = 10808
$script:ProxyHttp = "http://127.0.0.1:$script:ProxyPort"
$script:ProxySocks = "socks5://127.0.0.1:$script:ProxyPort"

function proxy-on {
    $env:HTTP_PROXY = $script:ProxyHttp
    $env:HTTPS_PROXY = $script:ProxyHttp
    $env:ALL_PROXY = $script:ProxySocks
    Write-Host "Terminal proxy enabled (port: $script:ProxyPort)" -ForegroundColor Green
}

function proxy-off {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
    Write-Host "Terminal proxy disabled"
}

function proxy-gh-on {
    git config --global http.https://github.com.proxy $script:ProxyHttp
    Write-Host "GitHub proxy enabled (port: $script:ProxyPort)"
}

function proxy-git-on {
    git config --global http.proxy $script:ProxyHttp
    Write-Host "Global Git proxy enabled (port: $script:ProxyPort)"
}

function proxy-git-off {
    git config --global --unset-all http.proxy 2>$null
    git config --global --unset-all http.https://github.com.proxy 2>$null
    Write-Host "Git proxy disabled"
}

function proxy-git-show {
    $result = git config --global --list | Select-String proxy
    if ($result) {
        $result
    } else {
        Write-Host "Not set"
    }
}

function proxy-all-on {
    proxy-on
    npm-proxy-on
    proxy-gh-on
    Write-Host "All proxies enabled"
}

function proxy-all-off {
    proxy-off
    npm-proxy-off
    proxy-git-off
    Write-Host "All proxies disabled"
}

function proxy-state {
    $npmProxy = npm config get proxy 2>$null
    if (-not $npmProxy -or $npmProxy -eq "null") {
        $npmProxy = "Not set"
    }

    $term = if ($env:HTTP_PROXY) { $env:HTTP_PROXY } else { "Not set" }

    $gitProxy = git config --global --list | Select-String proxy
    if (-not $gitProxy) {
        $gitProxy = "Not set"
    }

    Write-Host "============================="
    Write-Host "Terminal:     $term"
    Write-Host "npm proxy:    $npmProxy"
    Write-Host "npm registry: $(npm config get registry)"
    Write-Host "Git:          $gitProxy"
    Write-Host "============================="
}
