SELECT FROM /dmo/flight AS a
     INNER JOIN /dmo/connection AS c
        ON a~carrier_id = c~carrier_id
       AND a~connection_id = c~connection_id

     INNER JOIN /dmo/airport AS b
      ON c~airport_from_id = b~airport_id

     INNER JOIN /dmo/airport AS d
     ON c~airport_to_id = d~airport_id

        FIELDS
               a~carrier_id,
               a~connection_id,
               c~airport_from_id,
               b~name AS Aeroporto_Partida,
               c~airport_to_id,
               d~name AS Aeroporto_chegada,
               a~flight_date AS date,
               a~seats_max - a~seats_occupied AS seats_avaliable

     ORDER BY a~carrier_id ASCENDING


           INTO TABLE @DATA(result_flight).

    IF sy-subrc = 0.

      TYPES: BEGIN OF ts_display,
               carrier_id        TYPE /dmo/carrier_id,
               connection_id     TYPE /dmo/connection_id,
               aeroporto_partida TYPE /dmo/airport_name,
               aeroporto_chegada TYPE /dmo/airport_name,
               seats_avaliable   TYPE i,
               data_formatada    TYPE c LENGTH 10,
             END OF ts_display.

      DATA lt_display TYPE STANDARD TABLE OF ts_display.
      DATA ls_display LIKE LINE OF lt_display.

      LOOP AT result_flight INTO DATA(ls_flight).
        MOVE-CORRESPONDING ls_flight TO ls_display.
        ls_display-data_formatada = |{ ls_flight-date+6(2) }-{ ls_flight-date+4(2) }-{ ls_flight-date(4) }|.
        APPEND ls_display TO lt_display.
        CLEAR ls_display.

      ENDLOOP.

      out->write(
       EXPORTING
       data = lt_display
       name = 'RESULTADO DOS VOOS'
       ).

    ENDIF.
