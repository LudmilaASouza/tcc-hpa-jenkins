# Limpa o console para começar
Clear-Host
Write-Host "--- Iniciando Ambiente TCC em Segundo Plano ---" -ForegroundColor Cyan

# Função para iniciar o serviço em background com loop de resiliência
function Start-ServiceBG {
    param($Name, $Command)
    
    Start-Job -Name $Name -ScriptBlock {
        param($SvcName, $SvcCmd)
        while($true) {
            # Executa o comando e joga o log para um arquivo temporário se quiser debugar depois
            Invoke-Expression $SvcCmd
            Start-Sleep -Seconds 2
        }
    } -ArgumentList $Name, $Command
    
    Write-Host "[ OK ] Servidor de monitoramento para $Name iniciado." -ForegroundColor Green
}

# 1. Prometheus
Start-ServiceBG "Prometheus" "kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring"

# 2. Grafana
Start-ServiceBG "Grafana" "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"

# 3. K8s Proxy
Start-ServiceBG "K8s Proxy" "kubectl proxy --address=0.0.0.0 --accept-hosts=.*"

# 4. App Svc (k6)
Start-ServiceBG "k6" "kubectl port-forward svc/app-teste-svc 8888:80 -n tcc-jenkins"

Write-Host "`nTodos os serviços estão rodando em segundo plano." -ForegroundColor Cyan
Write-Host "Comandos úteis para você usar agora:" -ForegroundColor White
Write-Host "  Get-Job               -> Lista se os serviços estão 'Running'"
Write-Host "  Receive-Job -Name X   -> Mostra o log do serviço X (ex: Prometheus)"
Write-Host "  Stop-Job * -> Para todos os serviços"
Write-Host "--------------------------------------------------`n"

# Loop para manter a janela principal aberta e mostrando o status
while($true) {
    $data = Get-Date -Format "HH:mm:ss"
    $jobs = Get-Job | Select-Object Name, State
    Clear-Host
    Write-Host "--- MONITOR DE SERVICOS TCC ($data) ---" -ForegroundColor Cyan
    $jobs | Out-String
    Write-Host "`n(Pressione Ctrl+C para encerrar este monitor)" -ForegroundColor Gray
    Start-Sleep -Seconds 5
}