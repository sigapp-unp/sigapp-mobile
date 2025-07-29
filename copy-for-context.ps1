param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Files
)

if (-not $Files) {
    Write-Error "Debe especificar al menos un archivo. Uso: .\copy-for-chatgpt.ps1 <archivo1> <archivo2> ..."
    exit 1
}

# Función para obtener la ruta común más cercana con depuración completa
function Get-CommonPath {
    param([string[]]$Paths)
    Write-Debug "[DEBUG] Paths originales:"; $Paths | ForEach-Object { Write-Debug "  '$_'" }

    if ($Paths.Count -eq 0) { return "" }

    # Normalizar rutas y dividir en segmentos
    $splitPaths = @()
    foreach ($p in $Paths) {
        Write-Debug "[DEBUG] Procesando ruta: '$p'"
        $normalized = $p.Replace('/', '\\')
        Write-Debug "[DEBUG] Normalized: '$normalized'"
        $dir = [IO.Path]::GetDirectoryName($normalized)
        Write-Debug "[DEBUG] Directorio padre: '$dir'"
        $segments = $dir.Split('\\')
        Write-Debug "[DEBUG] Segmentos: $($segments -join ', ')"
        $splitPaths += ,$segments
    }

    # Calcular segmentos comunes
    $commonSegments = $splitPaths[0]
    Write-Debug "[DEBUG] Inicial commonSegments: $($commonSegments -join ', ')"
    for ($i = 1; $i -lt $splitPaths.Count; $i++) {
        $current = $splitPaths[$i]
        $temp = @()
        $minCount = [Math]::Min($commonSegments.Count, $current.Count)
        Write-Debug "[DEBUG] Comparando con conjunto ${i}: $($current -join ', ')"
        for ($j = 0; $j -lt $minCount; $j++) {
            if ($commonSegments[$j] -ieq $current[$j]) {
                $temp += $commonSegments[$j]
            } else {
                break
            }
        }
        $commonSegments = $temp
        Write-Debug "[DEBUG] commonSegments tras iter ${i}: $($commonSegments -join ', ')"
        if ($commonSegments.Count -eq 0) { break }
    }

    if ($commonSegments.Count -gt 0) {
        $commonPath = ($commonSegments -join '\\')
        Write-Debug "[DEBUG] Ruta común calculada: '$commonPath'"
        return $commonPath
    }
    Write-Warning "[WARN] No hay segmentos comunes"
    return ""
}

# Construir el texto a copiar
$stringBuilder = New-Object System.Text.StringBuilder

# Debug: mostrar lista de archivos
Write-Debug "[DEBUG] Archivos a procesar:"; $Files | ForEach-Object { Write-Debug "  $_" }

foreach ($file in $Files) {
    Write-Debug "[DEBUG] Leyendo archivo: '$file'"
    if (-not (Test-Path $file)) {
        Write-Warning "Archivo no encontrado: $file"
        continue
    }
    $stringBuilder.AppendLine($file) | Out-Null
    $stringBuilder.AppendLine('```') | Out-Null
    $content = Get-Content -Raw -LiteralPath $file
    $stringBuilder.AppendLine($content) | Out-Null
    $stringBuilder.AppendLine('```') | Out-Null
    $stringBuilder.AppendLine() | Out-Null
}

# Calcular ruta común y salida de tree con debug inteligente
$commonPath = Get-CommonPath -Paths $Files
if ($commonPath) {
    # Usar ASCII para evitar caracteres extendidos y /F para mostrar ficheros
    $treeCommand = "tree /A `"$commonPath`" /F"
    Write-Debug "[DEBUG] Comando tree construido: $treeCommand"
    $stringBuilder.AppendLine("Comando ejecutado: $treeCommand") | Out-Null

    # Ejecutar tree y capturar output
    if (Get-Command tree -ErrorAction SilentlyContinue) {
        $rawOutput = tree /A $commonPath /F | Out-String
    } else {
        $rawOutput = cmd /c "tree /A `"$commonPath`" /F" | Out-String
    }
    Write-Debug "[DEBUG] Línea de tree cruda: primero 20 líneas"; ($rawOutput -split "`r?`n")[0..19] | ForEach-Object { Write-Debug "$_" }

    # Truncar salida si es muy extensa
    $rawLines = $rawOutput -split "`r?`n"
    $maxLines = 200
    if ($rawLines.Count -gt $maxLines) {
        Write-Warning "Salida de tree truncada a $maxLines líneas de $($rawLines.Count)"
        $displayLines = $rawLines[0..($maxLines - 1)] + ("... [Salida truncada: total $($rawLines.Count) líneas]")
    } else {
        $displayLines = $rawLines
    }

    # Agregar a stringBuilder
    $stringBuilder.AppendLine('```') | Out-Null
    $displayLines | ForEach-Object { $stringBuilder.AppendLine($_) | Out-Null }
    $stringBuilder.AppendLine('```') | Out-Null
} else {
    Write-Warning "No se pudo determinar una ruta común para los archivos proporcionados. Quizá sea algo como 'lib\\grade_simulator'"
}

# Copiar al portapapeles
if (Get-Command Set-Clipboard -ErrorAction SilentlyContinue) {
    $stringBuilder.ToString() | Set-Clipboard
} else {
    $stringBuilder.ToString() | clip
}

Write-Host "Contenido copiado al portapapeles." -ForegroundColor Green