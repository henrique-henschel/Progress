/*
File: ttdefs.i
Include: temp-tables definitions for Products, Sellers, Companies.
*/
/* ttdefs.i */
/* Use this include in model and view files */
/* -- START OF INCLUDE -- */

DEFINE TEMP-TABLE ttCompany
    FIELD company-id    AS INTEGER    FORMAT "->>>9"
    FIELD company-name  AS CHARACTER  FORMAT "x(40)"
    FIELD company-addr  AS CHARACTER  FORMAT "x(60)"
    INDEX pkCompany IS PRIMARY company-id.
.

DEFINE TEMP-TABLE ttSeller
    FIELD seller-id     AS INTEGER    FORMAT "->>>9"
    FIELD seller-name   AS CHARACTER  FORMAT "x(40)"
    FIELD seller-phone  AS CHARACTER  FORMAT "x(20)"
    INDEX pkSeller IS PRIMARY seller-id.
.

DEFINE TEMP-TABLE ttProduct
    FIELD product-id    AS INTEGER    FORMAT "->>>9"
    FIELD product-name  AS CHARACTER  FORMAT "x(60)"
    FIELD sku           AS CHARACTER  FORMAT "x(20)"
    FIELD price         AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD qty           AS INTEGER    FORMAT "->>>9"
    FIELD seller-id     AS INTEGER    FORMAT "->>>9"
    FIELD company-id    AS INTEGER    FORMAT "->>>9"
    INDEX pkProduct IS PRIMARY product-id.
    INDEX idxSeller seller-id.
    INDEX idxCompany company-id.
.

/* -- END OF INCLUDE -- */

/*
File: model.p
Contains all data operations: load CSV, save CSV, CRUD actions, report generation.
*/
/* model.p */
/* procedural, no POO */

/* include temp-tables */
{ttdefs.i}

/* File names. Adjust as desired. These are assumed to exist in the current working directory. */
DEF VAR cProductsFile   AS CHARACTER NO-UNDO INIT "products.csv".
DEF VAR cSellersFile    AS CHARACTER NO-UNDO INIT "sellers.csv".
DEF VAR cCompaniesFile  AS CHARACTER NO-UNDO INIT "companies.csv".
DEF VAR cReportFile     AS CHARACTER NO-UNDO INIT "report_products.csv".

DEF VAR iTmp             AS INTEGER NO-UNDO.
DEF VAR cLine            AS CHARACTER NO-UNDO.
DEF VAR cFld1 cFld2 cFld3 cFld4 cFld5 cFld6 cFld7 AS CHARACTER NO-UNDO.

/* -------------------- Helpers -------------------- */
FUNCTION next-product-id RETURNS INTEGER ( ):
    DEF TEMP-TABLE ttTmp NO-UNDO LIKE ttProduct.
    DEF VAR iMax AS INTEGER NO-UNDO.
    iMax = 0.
    FOR EACH ttProduct NO-LOCK:
        IF ttProduct.product-id > iMax THEN iMax = ttProduct.product-id.
    END.
    RETURN iMax + 1.
END.

/* -------------------- Load CSVs -------------------- */
PROCEDURE load-companies:
    DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i1 AS INTEGER NO-UNDO.

    /* Clear existing */
    FOR EACH ttCompany: DELETE.

    IF NOT SEARCH(pcFile) THEN RETURN.

    INPUT FROM VALUE(pcFile).
    /* try to skip header if exists */
    /* read whole lines and PARSE by comma to be generous with commas */
    DO WHILE TRUE:
        cLine = "".
        /* READ-STATEMENT for full line */
        /* Use IMPORT UNFORMATTED to read lines; if EOF then leave */
        /* safer to use INPUT THROUGH? We'll use IMPORT UNFORMATTED with DELIMITER '\n' */
        IMPORT UNFORMATTED cLine.
        IF EOF(INPUT) AND cLine = "" THEN LEAVE.
        IF cLine = "" THEN NEXT.
        /* split by comma */
        RUN parse-csv-line (INPUT cLine, OUTPUT c1, OUTPUT c2, OUTPUT c3) NO-ERROR.
        /* If first field is not numeric treat as header and skip */
        i1 = INTEGER(c1) NO-ERROR.
        IF i1 = 0 AND c1 <> "0" THEN NEXT.
        CREATE ttCompany.
        ASSIGN
            ttCompany.company-id = i1
            ttCompany.company-name = c2
            ttCompany.company-addr = c3.
    END.
    INPUT CLOSE.
END PROCEDURE.

PROCEDURE load-sellers:
    DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i1 AS INTEGER NO-UNDO.

    FOR EACH ttSeller: DELETE.
    IF NOT SEARCH(pcFile) THEN RETURN.
    INPUT FROM VALUE(pcFile).
    DO WHILE TRUE:
        cLine = "".
        IMPORT UNFORMATTED cLine.
        IF EOF(INPUT) AND cLine = "" THEN LEAVE.
        IF cLine = "" THEN NEXT.
        RUN parse-csv-line (INPUT cLine, OUTPUT c1, OUTPUT c2, OUTPUT c3) NO-ERROR.
        i1 = INTEGER(c1) NO-ERROR.
        IF i1 = 0 AND c1 <> "0" THEN NEXT.
        CREATE ttSeller.
        ASSIGN
            ttSeller.seller-id = i1
            ttSeller.seller-name = c2
            ttSeller.seller-phone = c3.
    END.
    INPUT CLOSE.
END PROCEDURE.

PROCEDURE load-products:
    DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c1 c2 c3 c4 c5 c6 c7 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i1 i5 i6 i7 AS INTEGER NO-UNDO.
    DEFINE VARIABLE d4 AS DECIMAL NO-UNDO.

    FOR EACH ttProduct: DELETE.
    IF NOT SEARCH(pcFile) THEN RETURN.

    INPUT FROM VALUE(pcFile).
    DO WHILE TRUE:
        cLine = "".
        IMPORT UNFORMATTED cLine.
        IF EOF(INPUT) AND cLine = "" THEN LEAVE.
        IF cLine = "" THEN NEXT.
        RUN parse-csv-line (INPUT cLine, OUTPUT c1, OUTPUT c2, OUTPUT c3, OUTPUT c4, OUTPUT c5, OUTPUT c6, OUTPUT c7) NO-ERROR.
        i1 = INTEGER(c1) NO-ERROR.
        IF i1 = 0 AND c1 <> "0" THEN NEXT.
        d4 = DECIMAL(c4) NO-ERROR.
        i5 = INTEGER(c5) NO-ERROR.
        i6 = INTEGER(c6) NO-ERROR.
        i7 = INTEGER(c7) NO-ERROR.
        CREATE ttProduct.
        ASSIGN
            ttProduct.product-id   = i1
            ttProduct.product-name = c2
            ttProduct.sku          = c3
            ttProduct.price        = d4
            ttProduct.qty          = i5
            ttProduct.seller-id    = i6
            ttProduct.company-id   = i7.
    END.
    INPUT CLOSE.
END PROCEDURE.

/* utility to parse a CSV line into up to 7 fields. Simple parser, no full RFC4180 compliance. */
PROCEDURE parse-csv-line:
    DEFINE INPUT  PARAMETER pcLine AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p1 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p2 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p3 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p4 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p5 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p6 AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p7 AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i      AS INTEGER NO-UNDO.
    DEFINE VARIABLE n      AS INTEGER NO-UNDO.
    DEFINE VARIABLE token  AS CHARACTER NO-UNDO.

    p1 = "". p2 = "". p3 = "". p4 = "". p5 = "". p6 = "". p7 = "".

    i = 1.
    n = 1.
    token = "".

    DO i = 1 TO LENGTH(pcLine):
        IF SUBSTRING(pcLine, i, 1) = '"' THEN DO:
            /* quoted field: read until next quote */
            i = i + 1.
            DO WHILE i <= LENGTH(pcLine) AND SUBSTRING(pcLine, i, 1) <> '"':
                token = token + SUBSTRING(pcLine, i, 1).
                i = i + 1.
            END.
            /* skip closing quote */
            /* next should be comma or end */
        END.
        ELSE IF SUBSTRING(pcLine, i, 1) = ',' THEN DO:
            /* assign token to field n */
            CASE n:
                WHEN 1 THEN p1 = token.
                WHEN 2 THEN p2 = token.
                WHEN 3 THEN p3 = token.
                WHEN 4 THEN p4 = token.
                WHEN 5 THEN p5 = token.
                WHEN 6 THEN p6 = token.
                WHEN 7 THEN p7 = token.
            END CASE.
            n = n + 1.
            token = "".
        END.
        ELSE DO:
            token = token + SUBSTRING(pcLine, i, 1).
        END.
    END.
    /* last token */
    CASE n:
        WHEN 1 THEN p1 = token.
        WHEN 2 THEN p2 = token.
        WHEN 3 THEN p3 = token.
        WHEN 4 THEN p4 = token.
        WHEN 5 THEN p5 = token.
        WHEN 6 THEN p6 = token.
        WHEN 7 THEN p7 = token.
    END CASE.
END PROCEDURE.

/* -------------------- Save Products to CSV -------------------- */
PROCEDURE save-products-to-csv:
    DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
    OUTPUT TO VALUE(pcFile).
    /* header */
    PUT UNFORMATTED "product-id,product-name,sku,price,qty,seller-id,company-id" SKIP.
    FOR EACH ttProduct NO-LOCK:
        PUT UNFORMATTED STRING(ttProduct.product-id) "," ttProduct.product-name "," ttProduct.sku "," STRING(ttProduct.price) "," STRING(ttProduct.qty) "," STRING(ttProduct.seller-id) "," STRING(ttProduct.company-id) SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

/* -------------------- CRUD on Products -------------------- */
PROCEDURE add-product:
    DEFINE INPUT PARAMETER pcName    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcSKU     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pdPrice   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER piQty     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piSeller  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piCompany AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iNewId AS INTEGER NO-UNDO.

    iNewId = next-product-id().
    CREATE ttProduct.
    ASSIGN
        ttProduct.product-id = iNewId
        ttProduct.product-name = pcName
        ttProduct.sku = pcSKU
        ttProduct.price = pdPrice
        ttProduct.qty = piQty
        ttProduct.seller-id = piSeller
        ttProduct.company-id = piCompany.
END PROCEDURE.

PROCEDURE edit-product:
    DEFINE INPUT PARAMETER piId      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pcName    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcSKU     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pdPrice   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER piQty     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piSeller  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piCompany AS INTEGER   NO-UNDO.

    FOR EACH ttProduct WHERE ttProduct.product-id = piId EXCLUSIVE-LOCK:
        ASSIGN
            ttProduct.product-name = pcName
            ttProduct.sku = pcSKU
            ttProduct.price = pdPrice
            ttProduct.qty = piQty
            ttProduct.seller-id = piSeller
            ttProduct.company-id = piCompany.
    END.
END PROCEDURE.

PROCEDURE delete-product:
    DEFINE INPUT PARAMETER piId AS INTEGER NO-UNDO.
    FOR EACH ttProduct WHERE ttProduct.product-id = piId EXCLUSIVE-LOCK:
        DELETE ttProduct.
    END.
END PROCEDURE.

/* -------------------- Report generation -------------------- */
PROCEDURE generate-report:
    DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
    OUTPUT TO VALUE(pcFile).
    PUT UNFORMATTED "product-id,product-name,sku,price,qty,seller-name,company-name" SKIP.
    FOR EACH ttProduct NO-LOCK:
        DEFINE VARIABLE cSeller AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cCompany AS CHARACTER NO-UNDO.
        FIND ttSeller WHERE ttSeller.seller-id = ttProduct.seller-id NO-LOCK NO-ERROR.
        IF AVAILABLE(ttSeller) THEN cSeller = ttSeller.seller-name ELSE cSeller = "".
        FIND ttCompany WHERE ttCompany.company-id = ttProduct.company-id NO-LOCK NO-ERROR.
        IF AVAILABLE(ttCompany) THEN cCompany = ttCompany.company-name ELSE cCompany = "".
        PUT UNFORMATTED STRING(ttProduct.product-id) "," ttProduct.product-name "," ttProduct.sku "," STRING(ttProduct.price) "," STRING(ttProduct.qty) "," cSeller "," cCompany SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

/* -------------------- Convenience: count products -------------------- */
FUNCTION products-count RETURNS INTEGER ():
    DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
    iCnt = 0.
    FOR EACH ttProduct NO-LOCK:
        iCnt = iCnt + 1.
    END.
    RETURN iCnt.
END FUNCTION.

/* -------------------- End of model.p -------------------- */

/*
File: view.p
Main interface. Terminal/CLI with frames. Uses the model procedures to load data and perform CRUD.
Notes: Some terminal key behaviors vary by platform. This program uses numbered selection by default.
If you run in an environment that supports GUI frames and WAIT-FOR events, you may adapt input handling to arrow keys.
*/
/* view.p */

{ttdefs.i}
/* include model routines (we placed them in same file above when building project) */
{model.p}

/* Program variables */
DEF VAR cCmd AS CHARACTER NO-UNDO.
DEF VAR iSel AS INTEGER NO-UNDO.
DEF VAR iId AS INTEGER NO-UNDO.
DEF VAR cTmp AS CHARACTER NO-UNDO.
DEF VAR cYesNo AS CHARACTER NO-UNDO.

/* load static tables first */
RUN load-companies (cCompaniesFile).
RUN load-sellers (cSellersFile).
RUN load-products (cProductsFile).

/* If no products, prompt to add */
IF products-count() = 0 THEN DO:
    VIEW-AS ALERT-BOX "Nenhum produto cadastrado." INFO BUTTONS OK.
    /* ask user if they want to add */
    DISPLAY "Deseja cadastrar um novo produto? (S/N)" WITH NO-LABEL.
    UPDATE cYesNo WITH FRAME fAsk.
    IF UPPER(ENTRY(1, cYesNo)) <> "S" THEN DO:
        /* save any potential empty file and exit */
        RUN save-products-to-csv (cProductsFile).
        QUIT.
    END.
    /* go to add flow */
    RUN ui-add-product.
END.

/* Main loop */
DO WHILE TRUE:
    RUN show-products-list.
    /* show menu */
    DISPLAY
        "Comandos: A - Adicionar | E - Editar | D - Excluir | R - Relatório | Q - Sair" WITH NO-LABEL.
    /* get command */
    UPDATE cCmd WITH FRAME fCmd.
    cCmd = TRIM(cCmd).
    IF cCmd = "" THEN NEXT.
    CASE UPPER(cCmd):
        WHEN "A" THEN RUN ui-add-product.
        WHEN "E" THEN RUN ui-edit-product.
        WHEN "D" THEN RUN ui-delete-product.
        WHEN "R" THEN DO:
            RUN generate-report (cReportFile).
            MESSAGE "Relatório gerado em " cReportFile VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        WHEN "Q" THEN DO:
            RUN save-products-to-csv (cProductsFile).
            MESSAGE "Saindo e salvando..." VIEW-AS ALERT-BOX INFO BUTTONS OK.
            QUIT.
        OTHERWISE DO:
            MESSAGE "Comando inválido." VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END CASE.
END.

/* -------------------- UI helpers -------------------- */
PROCEDURE show-products-list:
    /* displays all products elegantly with fields vertical in columns */
    DEFINE VARIABLE r    AS INTEGER NO-UNDO.
    DEFINE VARIABLE line AS CHARACTER NO-UNDO.

    /* Clear screen area - not portable; we simply print separators */
    PUT UNFORMATTED "\n================================ PRODUCTS =================================" SKIP.
    r = 0.
    FOR EACH ttProduct NO-LOCK BY ttProduct.product-id:
        r = r + 1.
        PUT UNFORMATTED "[" r "]"  "ID:" ttProduct.product-id SKIP.
        PUT UNFORMATTED "    Nome    : " ttProduct.product-name SKIP.
        PUT UNFORMATTED "    SKU     : " ttProduct.sku SKIP.
        PUT UNFORMATTED "    Preço   : " STRING(ttProduct.price) SKIP.
        PUT UNFORMATTED "    Estoque : " STRING(ttProduct.qty) SKIP.
        /* resolve seller and company names */
        FIND ttSeller WHERE ttSeller.seller-id = ttProduct.seller-id NO-LOCK NO-ERROR.
        FIND ttCompany WHERE ttCompany.company-id = ttProduct.company-id NO-LOCK NO-ERROR.
        PUT UNFORMATTED "    Vendedor : " (IF AVAILABLE(ttSeller) THEN ttSeller.seller-name ELSE "-") SKIP.
        PUT UNFORMATTED "    Empresa  : " (IF AVAILABLE(ttCompany) THEN ttCompany.company-name ELSE "-") SKIP.
        PUT UNFORMATTED "------------------------------------------------------------------------" SKIP.
    END.
    PUT UNFORMATTED "" SKIP.
END PROCEDURE.

PROCEDURE ui-add-product:
    DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSKU     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPrice   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE iQty     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSeller  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iCompany AS INTEGER   NO-UNDO.

    /* simple form input */
    DISPLAY "--- Cadastro de novo produto ---" WITH NO-LABEL.
    DISPLAY "Nome:" "SKU:" "Preço:" "Quantidade:" "ID Vendedor:" "ID Empresa:" WITH NO-LABEL.
    UPDATE cName cSKU dPrice iQty iSeller iCompany WITH FRAME fAdd.

    /* create */
    RUN add-product (INPUT cName, INPUT cSKU, INPUT dPrice, INPUT iQty, INPUT iSeller, INPUT iCompany).
    MESSAGE "Produto cadastrado." VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE ui-edit-product:
    DEFINE VARIABLE iIndex   AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount   AS INTEGER NO-UNDO.
    DEFINE VARIABLE piId     AS INTEGER NO-UNDO.
    DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSKU     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPrice   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE iQty     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSeller  AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCompany AS INTEGER NO-UNDO.

    iCount = products-count().
    IF iCount = 0 THEN DO: MESSAGE "Nenhum produto para editar." VIEW-AS ALERT-BOX INFO BUTTONS OK. RETURN. END.

    /* ask user to enter the list number shown */
    DISPLAY "Digite o número [n] do registro a editar (conforme listagem):" WITH NO-LABEL.
    UPDATE iIndex WITH FRAME fSel.
    IF iIndex < 1 OR iIndex > iCount THEN DO: MESSAGE "Índice inválido." VIEW-AS ALERT-BOX INFO BUTTONS OK. RETURN. END.

    /* locate nth product by ordering by product-id */
    DEFINE VARIABLE n AS INTEGER NO-UNDO.
    n = 0.
    FOR EACH ttProduct NO-LOCK BY ttProduct.product-id:
        n = n + 1.
        IF n = iIndex THEN DO:
            piId = ttProduct.product-id.
            cName = ttProduct.product-name.
            cSKU  = ttProduct.sku.
            dPrice = ttProduct.price.
            iQty = ttProduct.qty.
            iSeller = ttProduct.seller-id.
            iCompany = ttProduct.company-id.
            LEAVE.
        END.
    END.

    /* show edit form (pre-filled) */
    DISPLAY "--- Editar produto ID " piId "---" WITH NO-LABEL.
    DISPLAY "Nome:" "SKU:" "Preço:" "Quantidade:" "ID Vendedor:" "ID Empresa:" WITH NO-LABEL.
    UPDATE cName cSKU dPrice iQty iSeller iCompany WITH FRAME fEdit.
    RUN edit-product (INPUT piId, INPUT cName, INPUT cSKU, INPUT dPrice, INPUT iQty, INPUT iSeller, INPUT iCompany).
    MESSAGE "Produto atualizado." VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE ui-delete-product:
    DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE piId   AS INTEGER NO-UNDO.
    DEFINE VARIABLE n AS INTEGER NO-UNDO.

    iCount = products-count().
    IF iCount = 0 THEN DO: MESSAGE "Nenhum produto para excluir." VIEW-AS ALERT-BOX INFO BUTTONS OK. RETURN. END.

    DISPLAY "Digite o número [n] do registro a excluir (conforme listagem):" WITH NO-LABEL.
    UPDATE iIndex WITH FRAME fDelSel.
    IF iIndex < 1 OR iIndex > iCount THEN DO: MESSAGE "Índice inválido." VIEW-AS ALERT-BOX INFO BUTTONS OK. RETURN. END.

    n = 0.
    FOR EACH ttProduct NO-LOCK BY ttProduct.product-id:
        n = n + 1.
        IF n = iIndex THEN DO:
            piId = ttProduct.product-id.
            LEAVE.
        END.
    END.

    /* confirm deletion */
    MESSAGE "Confirma exclusão do produto ID " piId VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.
    IF LAST-EVENT:BUTTON-VALUE = "YES" THEN DO:
        RUN delete-product (INPUT piId).
        MESSAGE "Produto excluído." VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END PROCEDURE.

/* End of view.p */

/* README NOTES
- Arquivos CSV esperados: products.csv, sellers.csv, companies.csv na pasta corrente.
- O parser CSV é simples e cobre campos entre aspas e sem aspas.
- Navegação por setas em terminal bruto pode variar entre distribuições e versões do Progress.
  Este exemplo usa seleção por número e comandos letter-based no menu para garantir portabilidade.
- Ajuste campos, tamanhos de character e formatos conforme necessário.
*/
