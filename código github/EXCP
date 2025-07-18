*&---------------------------------------------------------------------*
*& Report ZREPO_EXCP_ALUNO025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREPO_EXCP_ALUNO025.

TABLES: bkpf.

CONSTANTS:c_mes TYPE string VALUE 'Nenhum dado encontrado.'.

SELECTION-SCREEN BEGIN OF BLOCK 01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs,
                  s_belnr FOR bkpf-belnr,
                  s_gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF BLOCK 01.

DATA: gt_bkpf TYPE TABLE OF bkpf,
     gs_bkpf TYPE bkpf.

START-OF-SELECTION.

  SELECT * INTO TABLE @gt_bkpf
    FROM bkpf
    WHERE bukrs IN @s_bukrs
      AND belnr IN @s_belnr
      AND gjahr IN @s_gjahr.

  IF sy-subrc = 0.
    LOOP AT gt_bkpf INTO gs_bkpf.
      WRITE: / gs_bkpf-bukrs, gs_bkpf-belnr, gs_bkpf-gjahr.
    ENDLOOP.
  ELSE.
    MESSAGE c_mes TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
