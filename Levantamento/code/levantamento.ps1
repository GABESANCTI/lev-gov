#Esse Script n gera o pop up, deixei ele assim só
#pra copiar e colar as informações pelo proprio terminal :D
# Obtém o nome do computador
$computerName = $env:COMPUTERNAME

# Obtém o número de série do computador
$computerSerialNumber = (Get-WmiObject Win32_BIOS).SerialNumber

# Obtém o modelo e a marca (fabricante) do computador
$computerSystem = Get-WmiObject Win32_ComputerSystem
$computerModel = $computerSystem.Model
$computerBrand = $computerSystem.Manufacturer

# Recupera informações do monitor a partir do WMI
$monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

# Inicializa a string de saída
$output = "Nome do Computador: $computerName`n"
$output += "Marca do Computador: $computerBrand`n"
$output += "Modelo do Computador: $computerModel`n"
$output += "Número de Série do Computador: $computerSerialNumber`n`n"

# Inicializa o contador para o número de monitores
$monitorCount = 0

# Função para limpar os arrays de bytes (remover valores nulos e cortar espaços em excesso)
function Convert-FromByteArray {
    param ($byteArray)
    [System.Text.Encoding]::ASCII.GetString($byteArray) -replace '\0', ''
}

# Loop através de cada monitor e extrai o número de série (Deixei limitado a 6 monitores em razão dos paineis que utilizam aqui)


foreach ($monitor in $monitors) {
    if ($monitorCount -ge 6) {
        break
    }
    $serialNumber = Convert-FromByteArray $monitor.SerialNumberID
    $userFriendlyName = Convert-FromByteArray $monitor.UserFriendlyName
    $output += "Monitor $($monitorCount + 1):`n"
    $output += "    Modelo: $userFriendlyName`n"
    $output += "    Número de Série: $serialNumber`n`n"

    $monitorCount++
}


# Trata o caso onde nenhum monitor é encontrado(as vezes buga c notebook e tals, ainda n sei o pq)

if ($monitorCount -eq 0) {
    $output += "Nenhum monitor detectado.`n"
}


# Exibe o resultado no terminal
Write-Host $output
