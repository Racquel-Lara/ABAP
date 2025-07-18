
*Autor: Racquel Marques Lara de Almeida
*Data: 09/05/2025
*Descrição: aula prática, construção de calculadora
*Contato: racquellara.nutri@gmail.com
* Transação: ZIMC_025


REPORT ZREPO_IMC_ALUNO025.

DATA: gv_racquel TYPE p DECIMALS 2,
      op_texto  TYPE string.

CONSTANTS:                        "Fiz uma nova variável para conseguir mostrar a o resultado por mensagem e tela.
      gv_baixo TYPE p DECIMALS 2 VALUE '18.4',       " Tive que fazer variáveis para cada valor máx de IMC, porque o código não aceita nem ponto e nem vírgula.
      gv_normal TYPE p DECIMALS 2 VALUE '24.9',
      gv_sobre TYPE p DECIMALS 2 VALUE '29.9',
      gv_graui TYPE p DECIMALS 2 VALUE '34.9',
      gv_grauii TYPE p DECIMALS 2 VALUE '39.9',
      gv_grauiii TYPE p DECIMALS 2 VALUE '40'.

SELECTION-SCREEN BEGIN OF BLOCK 01 WITH FRAME TITLE TEXT-001.

PARAMETERS:
  p_alt  TYPE p DECIMALS 2 DEFAULT 0,
  p_pes  TYPE p DECIMALS 2 DEFAULT 0.

SELECTION-SCREEN BEGIN OF BLOCK 02 WITH FRAME TITLE TEXT-002.

PARAMETERS:
       p_tela RADIOBUTTON GROUP al,
       p_mes RADIOBUTTON GROUP AL.
SELECTION-SCREEN END OF BLOCK 02.
SELECTION-SCREEN END OF BLOCK 01.

START-OF-SELECTION.

  IF p_alt IS NOT INITIAL AND p_pes IS NOT INITIAL.

      PERFORM calcula_imc.

      IF gv_racquel <= gv_baixo.
         op_texto = |Seu IMC É: { gv_racquel } - Abaixo do peso|.

      ELSEIF gv_racquel > gv_baixo AND gv_racquel <= gv_normal.
        op_texto = |Seu IMC É: { gv_racquel } - Peso normal|.

      ELSEIF gv_racquel > gv_normal AND gv_racquel <= gv_sobre.
       op_texto = |Seu IMC É: { gv_racquel } - Sobrepeso|.

      ELSEIF gv_racquel > gv_sobre AND gv_racquel <= gv_graui.
       op_texto = |Seu IMC É: { gv_racquel } - Obesidade grau I|.


      ELSEIF gv_racquel > gv_graui AND gv_racquel <= gv_grauii.
        op_texto = |Seu IMC É: { gv_racquel } - Obesidade grau II|.

      ELSEIF gv_racquel > gv_grauiii.
        op_texto = |Seu IMC É: { gv_racquel } - Obesidade grau III|.
    ENDIF.

 IF p_tela = 'X'.
      WRITE: op_texto.
    ELSEIF p_mes = 'X'.
      MESSAGE op_texto TYPE 'I'.
    ENDIF.

 ELSE.
    WRITE: 'Informe sua altura e peso para o cálculo de IMC.'.
 ENDIF.

FORM calcula_imc .
 gv_racquel = p_pes / ( p_alt * p_alt ).
ENDFORM.
