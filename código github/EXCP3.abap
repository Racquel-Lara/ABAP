
*Autor: Racquel Marques Lara de Almeida
*Data: 22/05/2025
*Descrição: aula prática, armazenamento de dados na tabela ztbmm_aluno025
*Contato: racquellara.nutri@gmail.com
*Transação: ZEXCP3_025

"Não consegui fazer com que depois que o programa seja executado, ao inserir informações, caso não encontre, ao apertar f3(voltar)
"o programa não volta para a tela de seleção para que o usuário preencha os dados novamente, e sim sai do programa (fecha). =(

REPORT ZREPO_EXCP3_ALUNO025.

TABLES: ZTBMM_ALUNO025, ekko, ekpo.

TYPES: BEGIN OF ty_dados,
        ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         aedat TYPE ekko-aedat,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         txz01 TYPE ekpo-txz01,
         nome_user    TYPE uname,
         data_criacao TYPE datum,
         hora_criacao TYPE uzeit,
       END OF ty_dados.

DATA: gt_dados TYPE TABLE OF ty_dados,
      gs_dados TYPE ty_dados.

DATA: gt_alv   TYPE TABLE OF ztbmm_aluno025,
      gs_alv   TYPE ztbmm_aluno025.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

SELECTION-SCREEN BEGIN OF BLOCK 01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_data FOR ztbmm_aluno025-aedat,
                  s_bukrs FOR ztbmm_aluno025-bukrs.
SELECTION-SCREEN END OF BLOCK 01.

SELECTION-SCREEN BEGIN OF BLOCK 02 WITH FRAME TITLE TEXT-002.
PARAMETERS:
    p_idados RADIOBUTTON GROUP AL,
    p_vdados RADIOBUTTON GROUP AL.
SELECTION-SCREEN END OF BLOCK 02.


START-OF-SELECTION.


IF s_bukrs IS INITIAL OR s_data IS INITIAL.
   MESSAGE TEXT-E01 TYPE 'I' DISPLAY LIKE 'E'.
   STOP.


ENDIF.

IF p_idados = 'X'.

PERFORM extracao_dados.
PERFORM inseri_dados.
PERFORM mostrar_dados.

ELSEIF p_vdados = 'X'.

  PERFORM busca_dados.
  PERFORM mostrar_dados.


ENDIF.


FORM extracao_dados .

 SELECT a~ebeln,
         a~bukrs,
         a~aedat,
         b~ebelp,
         b~matnr,
         b~werks,
         b~txz01
    INTO TABLE @gt_dados
    FROM ekko AS a
    INNER JOIN ekpo AS b
    ON a~ebeln = b~ebeln
    WHERE a~aedat BETWEEN '20190101' AND '20201231'
      AND a~bukrs IN @s_bukrs.
      "AND a~aedat IN @s_data.


  IF sy-subrc <> 0.
    MESSAGE TEXT-E03 TYPE 'E'.
    STOP.

  ENDIF.
ENDFORM.

FORM inseri_dados .

TRY.

      DELETE FROM ztbmm_aluno025
      WHERE bukrs IN s_bukrs
      AND aedat IN s_data.

      LOOP AT gt_dados INTO gs_dados.

        CLEAR gs_alv.
        gs_alv-mandt         = sy-mandt.
        gs_alv-aedat         = gs_dados-aedat.
        gs_alv-ebeln         = gs_dados-ebeln.
        gs_alv-bukrs         = gs_dados-bukrs.
        gs_alv-ebelp         = gs_dados-ebelp.
        gs_alv-matnr         = gs_dados-matnr.
        gs_alv-werks         = gs_dados-werks.
        gs_alv-txz01         = gs_dados-txz01.

        gs_alv-nome_user     = sy-uname.
        gs_alv-data_criacao  = sy-datum.
        gs_alv-hora_criacao  = sy-uzeit.

        INSERT ztbmm_aluno025 FROM gs_alv.

      ENDLOOP.

      COMMIT WORK.
      gt_alv[] = gt_dados[].
      MESSAGE TEXT-E02 TYPE 'S'.
      STOP.

    CATCH cx_sy_open_sql_db.
      MESSAGE TEXT-E03 TYPE 'E'.
      STOP.

  ENDTRY.

ENDFORM.

FORM busca_dados.

SELECT *
      INTO TABLE @gt_alv
      FROM ztbmm_aluno025
      WHERE bukrs IN @s_bukrs
        AND aedat IN @s_data.

    IF sy-subrc <> 0.
      MESSAGE TEXT-E04 TYPE 'E'.
      STOP.

    ENDIF.

ENDFORM.

FORM mostrar_dados.

gs_layout-zebra = 'X'.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZTBMM_ALUNO025'
      CHANGING
        ct_fieldcat      = gt_fieldcat
      EXCEPTIONS
        OTHERS           = 1.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = gs_layout
        it_fieldcat        = gt_fieldcat
      TABLES
        t_outtab           = gt_alv
      EXCEPTIONS
        program_error      = 1
        others             = 2.


ENDFORM.
