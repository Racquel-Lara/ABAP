
*** Programa: ZREPO_EXCP4_ALUNO025
*** Descrição: REPORT PARA CRIAÇÃO DE DOCUMENTO
*** Autor: Racquel Marques Lara de Almeida
*** Data: 23/05/2025


REPORT ZREPO_EXCP4_ALUNO025.

"-Tela de seleção: informe o pedido e a empresa!
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_belnr TYPE ekko-ebeln,  " Pedido
            p_bukrs TYPE ekko-bukrs.  " Empresa
SELECTION-SCREEN END OF BLOCK b1.

"--Variáveis principais: dados do pedido e estruturas da BAPI
DATA: ls_ekko TYPE ekko,                          " Cabeçalho do pedido
      lt_ekpo  TYPE TABLE OF ekpo,                 " Itens do pedido
      ls_ekpo   TYPE ekpo,                          " Um item
      ls_gm_code TYPE bapi2017_gm_code,             " Código da movimentação
      ls_gm_head TYPE bapi2017_gm_head_01,          " Cabeçalho da movimentação
      ls_gm_item TYPE bapi2017_gm_item_create,      " Um item da movimentação
      lt_gm_item TYPE TABLE OF bapi2017_gm_item_create, " Todos os itens para a BAPI
      ls_headret TYPE bapi2017_gm_head_ret,         " Retorno do cabeçalho
      lt_return TYPE TABLE OF bapiret2.            " Mensagens da BAPI

"--- Bora processar!
START-OF-SELECTION.
  PERFORM validar_entrada.         "  Valida se os parâmetros foram informados
  PERFORM selecionar_ekko.         "  Busca o cabeçalho do pedido
  PERFORM selecionar_ekpo.         "  Bsca os itens do pedido
  PERFORM preparar_bapi.           " Prepara as estruturas para a BAPI
  PERFORM chamar_bapi.             "  Chama a BAPI para criar movimentação
  PERFORM validar_retorno_bapi.    "  Mostra o resultado

"Checa se os parâmetros foram informados
FORM validar_entrada.
  IF p_bukrs IS INITIAL OR p_belnr IS INITIAL.
    MESSAGE 'Parâmetros obrigatórios não preenchidos.' TYPE 'I' DISPLAY LIKE 'E'.
    STOP. " Sem parâmetros, sem negócio!
  ENDIF.
ENDFORM.

"-Busca o cabeçalho do pedido
FORM selecionar_ekko.
  SELECT SINGLE * INTO ls_ekko FROM ekko
    WHERE bukrs = p_bukrs AND ebeln = p_belnr.
  IF sy-subrc <> 0.
    MESSAGE 'Pedido não encontrado.' TYPE 'E'.
  ENDIF.
ENDFORM.

"Busca os itens do pedido
FORM selecionar_ekpo.
  SELECT * INTO TABLE lt_ekpo FROM ekpo WHERE ebeln = ls_ekko-ebeln.
  IF lt_ekpo IS INITIAL.
    MESSAGE 'Não há itens para o pedido informado.' TYPE 'E'.
  ENDIF.
ENDFORM.

"-- Prepara cada item para a movimentação
FORM preparar_bapi.
  ls_gm_code-gm_code = '01'.           " Código: 01 = entrada de mercadoria
  ls_gm_head-doc_date = sy-datum.      " Data do documento: hoje
  ls_gm_head-pstng_date = sy-datum.    " Data de lançamento: hoje

  LOOP AT lt_ekpo INTO ls_ekpo.
    CLEAR ls_gm_item.
    "  Mapeia cada campo da EKPO para a estrutura da BAPI"
    ls_gm_item-material   = ls_ekpo-matnr.
    ls_gm_item-plant      = ls_ekpo-werks.
    ls_gm_item-stge_loc   = ls_ekpo-lgort.
    ls_gm_item-move_type  = '101'.          " Entrada padrão
    ls_gm_item-vendor     = ls_ekko-lifnr.
    ls_gm_item-entry_qnt  = ls_ekpo-menge.
    ls_gm_item-entry_uom  = ls_ekpo-meins.
    ls_gm_item-po_pr_qnt  = ls_ekpo-menge.
    ls_gm_item-po_number  = ls_ekko-ebeln.
    ls_gm_item-po_item    = ls_ekpo-ebelp.
    ls_gm_item-mvt_ind    = 'B'.            " Ligado ao pedido de compras

    APPEND ls_gm_item TO lt_gm_item.        " Adiciona o item para a BAPI
  ENDLOOP.
ENDFORM.

" Chama a BAPI para criar a movimentação
FORM chamar_bapi.
  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header = ls_gm_head
      goodsmvt_code   = ls_gm_code
    IMPORTING
      goodsmvt_headret = ls_headret
    TABLES
      goodsmvt_item = lt_gm_item
      return        = lt_return.
ENDFORM.

"--- Analisa o retorno e informa o usuário
FORM validar_retorno_bapi.
  DATA ls_return TYPE bapiret2.

  READ TABLE lt_return WITH KEY type = 'E' INTO ls_return.
  IF sy-subrc = 0.
    MESSAGE ls_return-message TYPE 'I' DISPLAY LIKE 'E'. " Deu erro!
  ELSEIF ls_headret-mat_doc IS NOT INITIAL.
    MESSAGE |Documento criado: { ls_headret-mat_doc }| TYPE 'I' DISPLAY LIKE 'S'. "  Sucesso!
  ELSE.
    MESSAGE 'Nenhuma movimentação realizada e sem erro retornado.' TYPE 'I' DISPLAY LIKE 'E'. " Situação indefinida
  ENDIF.
ENDFORM.
