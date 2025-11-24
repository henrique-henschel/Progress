// Função que inicializa a grid:
function iniciarGrid() {
    $("#gridConsulta").kendoGrid({
        sortable: true,
        filterable: true,
        navigatable: true,
        height: "400px",
        width: "100%",
        selectable: "row",
        resizable: { rows: true },
        toolbar: [
            {
                name: "exportarExcel",
                text: "Exportar Excel"
            },
            "search"
        ],
        scrollable: true,
        columnVirtualization: true,
        columns: [
            // Campos da temp-table...
        ],

        excel: {
            fileName: "placeholder.xlsx",  // será substituído antes da exportação
            allPages: true
        },

        excelExport: function (e) {
            // Intercepta o evento antes da exportação para renomear dinamicamente
            var competencia = obterCompetencia(); // função utilitária abaixo

            if (!competencia) {
                e.preventDefault();
                kendo.alert("Informe uma competência válida antes de exportar.");
                return;
            }

            var mes = competencia.getMonth() + 1;
            var ano = competencia.getFullYear();

            var nomeArquivo =
                "NomeArquivo" +
                String(mes).padStart(2, "0") +
                "_" +
                ano +
                ".xlsx";

            e.workbook.fileName = nomeArquivo;
        }
    });

    // Vincula o clique do botão customizado
    $("#gridConsulta")
        .data("kendoGrid")
        .element
        .find(".k-grid-exportarExcel")
        .on("click", function () {
            var grid = $("#gridConsulta").data("kendoGrid");
            grid.saveAsExcel();
        });
}

// Função utilitária para obter e validar a competência
function obterCompetencia() {
    // Exemplo: campo do tipo kendoDatePicker com id #campoCompetencia
    var valor = $("#campoCompetencia").val();

    if (!valor) return null;

    var data = kendo.parseDate(valor, ["MM/yyyy", "MM-yy", "MM/yyyy"]);

    if (!data || isNaN(data.getTime())) return null;

    return data;
}
