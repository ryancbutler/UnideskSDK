Describe 'Module Metadata Validation' {      
        it 'Script fileinfo should be ok' {
            {Test-ModuleManifest ".\ctxal-sdk\ctxal-sdk.psd1" -ErrorAction Stop} | Should -Not -Throw
        }
        
        it 'Import module should be ok'{
            {Import-Module ".\ctxal-sdk\ctxal-sdk.psm1"-Force -ErrorAction Stop} | Should -Not -Throw
        }
}