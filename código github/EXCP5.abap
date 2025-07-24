
* Programa: ZREPO_EXCP5_ALUNO025
* Descrição: Relatório para extração e exibição de pedidos de compras via ALV com opção de inserção e visualização
* Autor: Racquel Marques Lara de Almeida
* Data: 30/05/2025



REPORT ZREPO_EXCP5_ALUNO025.

CLASS lcl_util DEFINITION LOAD.

TABLES: ztbmm_aluno025, ekko, ekpo.


TYPES: BEGIN OF ty_dados,
         ebeln         TYPE ekko-ebeln,
         bukrs         TYPE ekko-bukrs,
         aedat         TYPE ekko-aedat,
         ebelp         TYPE ekpo-ebelp,
         matnr         TYPE ekpo-matnr,
         werks         TYPE ekpo-werks,
         txz01         TYPE ekpo-txz01,
         nome_user     TYPE uname,
         data_criacao  TYPE datum,
         hora_criacao  TYPE uzeit,
         background    TYPE c LENGTH 1,
       END OF ty_dados.


DATA: gt_dados TYPE TABLE OF ty_dados,
      gs_dados TYPE ty_dados.

DATA: gt_alv   TYPE TABLE OF ztbmm_aluno025,
      gs_alv   TYPE ztbmm_aluno025.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

DATA: g_custom_container TYPE REF TO cl_gui_custom_container,
      g_grid             TYPE REF TO cl_gui_alv_grid.

DATA OK_CODE LIKE SY-UCOMM.

CLASS lcl_util DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: mostrar_dados_reuse,
                   mostrar_dados_clo.
ENDCLASS.


CLASS lcl_util IMPLEMENTATION.

  METHOD mostrar_dados_reuse.
    gs_layout-zebra = 'X'.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZTBMM_ALUNO025'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = gs_layout
        it_fieldcat        = gt_fieldcat
      TABLES
        t_outtab           = gt_alv.
  ENDMETHOD.

  METHOD mostrar_dados_clo.
    CALL SCREEN 0200.
  ENDMETHOD.

ENDCLASS.


SELECTION-SCREEN BEGIN OF BLOCK 01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_data FOR ztbmm_aluno025-aedat,
                  s_bukrs FOR ztbmm_aluno025-bukrs.
SELECTION-SCREEN END OF BLOCK 01.

SELECTION-SCREEN BEGIN OF BLOCK 02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_idados RADIOBUTTON GROUP al,
              p_vdados RADIOBUTTON GROUP al.
SELECTION-SCREEN END OF BLOCK 02.

SELECTION-SCREEN BEGIN OF BLOCK 03 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_grid RADIOBUTTON GROUP rd DEFAULT 'X',
              p_clo  RADIOBUTTON GROUP rd.
SELECTION-SCREEN END OF BLOCK 03.

START-OF-SELECTION.

  IF s_bukrs IS INITIAL OR s_data IS INITIAL.
    MESSAGE TEXT-E01 TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

  IF p_idados = 'X'.

    PERFORM extracao_dados.
    PERFORM inseri_dados.

  ELSEIF p_vdados = 'X'.

    PERFORM busca_dados.

  ENDIF.

  IF p_grid = 'X'.
    lcl_util=>mostrar_dados_reuse( ).
  ELSE.
    lcl_util=>mostrar_dados_clo( ).
  ENDIF.


FORM extracao_dados.

  SELECT a~ebeln,
         a~bukrs,
         a~aedat,
         b~ebelp,
         b~matnr,
         b~werks,
         b~txz01
    INTO TABLE @gt_dados
    FROM ekko AS a
    INNER JOIN ekpo AS b ON a~ebeln = b~ebeln
    WHERE a~aedat IN @s_data
      AND a~bukrs IN @s_bukrs.

  IF sy-subrc <> 0.
    MESSAGE TEXT-E03 TYPE 'E'.
    STOP.
  ENDIF.

ENDFORM.

FORM inseri_dados.

  TRY.

      DELETE FROM ztbmm_aluno025
        WHERE bukrs IN @s_bukrs
          AND aedat IN @s_data.

      LOOP AT gt_dados INTO gs_dados.
        CLEAR gs_alv.
        MOVE-CORRESPONDING gs_dados TO gs_alv.

        gs_alv-nome_user     = sy-uname.
        gs_alv-data_criacao  = sy-datum.
        gs_alv-hora_criacao  = sy-uzeit.
        gs_alv-mandt         = sy-mandt.

        IF sy-batch = 'X'.
          gs_alv-background = 'X'.
        ELSE.
          gs_alv-background = ''.
        ENDIF.

        INSERT ztbmm_aluno025 FROM gs_alv.
        APPEND gs_alv TO gt_alv.
      ENDLOOP.

      COMMIT WORK.
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


MODULE status_0200 OUTPUT.
  DATA: lt_fcat   TYPE lvc_t_fcat,
        ls_layout TYPE lvc_s_layo.

  IF g_custom_container IS INITIAL.
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = 'ALVGRID'.

    CREATE OBJECT g_grid
      EXPORTING
        i_parent = g_custom_container.

    ls_layout-zebra = 'X'.

    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZTBMM_ALUNO025'
        is_layout        = ls_layout
      CHANGING
        it_outtab        = gt_alv
        it_fieldcatalog  = lt_fcat.
  ENDIF.
ENDMODULE.

MODULE user_command_0200 INPUT.


  CASE OK_CODE.

    WHEN 'F_SAIR'.
      LEAVE PROGRAM.
  ENDCASE.
*  CASE sy-ucomm.
*    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
*      LEAVE PROGRAM.
*  ENDCASE.
ENDMODULE.


*FORM mostrar_dados.
*gs_layout-zebra = 'X'.
*
*    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = 'ZTBMM_ALUNO025'
*      CHANGING
*        ct_fieldcat      = gt_fieldcat
*      EXCEPTIONS
*        OTHERS           = 1.
*
*    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*      EXPORTING
*        i_callback_program = sy-repid
*        is_layout          = gs_layout
*        it_fieldcat        = gt_fieldcat
*      TABLES
*        t_outtab           = gt_alv
*      EXCEPTIONS
*        program_error      = 1
*        others             = 2.
*
*ENDFORM.
