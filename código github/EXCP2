*&---------------------------------------------------------------------*
*& Report ZREPO_EXCP2_ALUNO025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREPO_EXCP2_ALUNO025.

TABLES: bkpf, bseg.

CONSTANTS:c_mes TYPE string VALUE 'Nenhum dado encontrado.'.

SELECTION-SCREEN BEGIN OF BLOCK 01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs,
                  s_belnr FOR bkpf-belnr,
                  s_gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF BLOCK 01.

TYPES: BEGIN OF ty_res,
   bukrs TYPE bkpf-bukrs,
   belnr TYPE bkpf-belnr,
   buzei TYPE bseg-buzei,
   gjahr TYPE bkpf-gjahr,
   blart TYPE bkpf-blart,
   bldat TYPE bkpf-bldat,
   budat TYPE bkpf-budat,
   koart TYPE bseg-koart,
   shkzg TYPE bseg-shkzg,
       END OF ty_res.

DATA: gt_res TYPE TABLE OF ty_res,
      gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.


START-OF-SELECTION.

   PERFORM selecdados.
  PERFORM prepalv.
  PERFORM mresult.



FORM selecdados.
  clear gt_res.
  SELECT a~bukrs a~belnr b~buzei a~gjahr AS sljahr
         a~blart a~bldat a~budat b~koart b~shkzg  INTO TABLE gt_res
    FROM bkpf AS a
    INNER JOIN bseg AS b
    ON a~bukrs = b~bukrs
    AND a~belnr = b~belnr
    AND a~gjahr = b~gjahr
   WHERE a~bukrs IN s_bukrs
     AND a~belnr IN s_belnr
     AND a~gjahr IN s_gjahr.

  IF sy-subrc NE 0.
    MESSAGE 'Nenhum documento foi encontrado' TYPE 'I' DISPLAY LIKE 'E'.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.


FORM prepalv.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.


  PERFORM montar_fieldcat USING:
  'BUKRS' 'Emp' 'Emp' 'Emp' 'X' 10,
  'BELNR' 'Doc' 'Doc' 'Doc' 'X' 15,
  'BUZEI' 'Trans' 'Trans' 'Trans' ' ' 10,
  'SLJAHR' 'Exerc' 'Exerc' 'Exerc' 'X' 8,
  'BLART' 'Tipo' 'Tipo' 'Tipo' ' ' 5,
  'BLDAT' 'Data' 'Data' 'Data' ' ' 10,
  'BUDAT' 'Post' 'Post' 'Post' ' ' 10,
  'KOART' 'Conta' 'Conta' 'Conta' ' ' 5,
  'SHKZG' 'D/C' 'D/C' 'D/C' ' ' 4.
ENDFORM.


FORM montar_fieldcat USING p_fieldname p_short p_medium p_long p_key p_outputlen.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname  = p_fieldname.
  gs_fieldcat-seltext_s  = p_short.
  gs_fieldcat-seltext_m  = p_medium.
  gs_fieldcat-seltext_l  = p_long.
  gs_fieldcat-key        = p_key.
  gs_fieldcat-outputlen  = p_outputlen.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.


FORM mresult.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      is_layout              = gs_layout
      it_fieldcat            = gt_fieldcat
    TABLES
      t_outtab               = gt_res
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
