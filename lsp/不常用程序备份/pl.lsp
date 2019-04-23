
 (defun dxf (code elist)
        (cdr (assoc code elist))
  )

 (defun window_b (d x)
        (setq b (* (- d x) 0.2))
  )
 
 (defun my_zoom_for_pl (pl / window p1 p2 arrow p_ct_x p_ct_y height_y height_x height b_x b_y result answer)

        (setq window (get_window_for_pline pl))
        (setq p1 (car window))
        (setq p2 (cadr window))
        (setq p_ct_x (/ (+ (car p2) (car p1)) 2))
        (setq p_ct_y (/ (+ (cadr p2) (cadr p1)) 2))

        (setq height_y (- (cadr p2) (cadr p1)))
        (setq height_x (- (car p2) (car p1)))
        (setq b_x (window_b (car p2) (car p1)))
        (setq b_y (window_b (cadr p2) (cadr p1)))
       
        (setq height (max (+ height_x b_x) (+ height_y b_y)))
        (setq answer "N")
        (while (and (not (or (equal answer "y") (equal answer "Y"))) (> height 0.0))
               (command "zoom" "c" (list p_ct_x p_ct_y) height)
               (redraw pl 3)
               (setq answer (getstring "\n Can you see the POLYLINE clearly ? Yes/No (N): "))
               (setq height (/ height 5))
         )
   )

  (defun my_zoom_for_text (text_ent / detail p1 p2 p3 p4 t a skl flg old_a_2 old_a_3 old_a_4 l old_dst max_x max_y min_x min_y old_flg d_x d_y x y)

        (setq d_x 0.008206) ;100
        (setq d_y -0.017132) ;100

        (setq detail (entget text_ent))
        (if detail 
           (progn
              (setq p1 (dxf 10 detail))
              (setq t (dxf 1 detail))
              (setq a (dxf 50 detail))
              (setq skl (dxf 41 detail))
              (setq old_flg (dxf 71 detail))
              (setq height (dxf 40 detail))
              (setq l (* height skl (strlen t)))
           
              (if (= old_flg 0)
                 (setq flg 1)
                 (setq flg -1)
               )

              (setq p2 (list (+ (car p1) (* l flg)) (cadr p1)))
              (setq p4 (list (car p1) (+ (cadr p1) height)))
              (setq p3 (list (car p2) (cadr p4)))
              (setq old_a_2 (l1_angle_l2 p1 (list 100000 (cadr p1)) p1 p2))
              (setq old_a_3 (l1_angle_l2 p1 (list 100000 (cadr p1)) p1 p3))
              (setq old_a_4 (l1_angle_l2 p1 (list 100000 (cadr p1)) p1 p4))
              (setq old_dst (distance p1 p3))

              (setq p2 (polar p1 (+ old_a_2 a) l)
                    p3 (polar p1 (+ old_a_3 a) old_dst) 
                    p4 (polar p1 (+ old_a_4 a) height)
               )
              (setq min_x (min (car p1) (car p2) (car p3) (car p4)))
              (setq max_x (max (car p1) (car p2) (car p3) (car p4)))
              (setq min_y (min (cadr p1) (cadr p2) (cadr p3) (cadr p4)))
              (setq max_y (max (cadr p1) (cadr p2) (cadr p3) (cadr p4)))

              (setq min_x (- min_x height 1))
              (setq max_x (+ max_x height 1))
              (setq min_y (- min_y height 1))
              (setq max_y (+ max_y height 1))
              (command "zoom" "w" (list min_x min_y) (list max_x max_y))

            )
           (setq p1 nil)
         )
        p1
  )

 (defun my_zoom_for_two_line (p1 p2 p3 p4 / no_para min_x min_y max_x max_y)

        (setq min_x (min (car p1) (car p2) (car p3) (car p4))
              min_y (min (cadr p1) (cadr p2) (cadr p3) (cadr p4))
              max_x (max (car p1) (car p2) (car p3) (car p4))
              max_y (max (cadr p1) (cadr p2) (cadr p3) (cadr p4))
         )
        (my_zoom_for_line (list (list min_x min_y) (list max_x max_y)))
  )

 (defun my_zoom_for_line (line / dst center height)

        (setq center (get_mid_point line))
        (setq dst (distance (car line) (cadr line)))
        (setq height (* dst 1.68))
        (if (> height 0.0)
           (command "zoom" "c" center height)
         )
        (setq height height)
  )

 (defun get_answer (default_answer / input result)

        (if (= default_answer "YES")
           (setq input (getstring "\n Is Closing right ? Yes/No (Y): "))
           (setq input (getstring "\n Is Closing right ? Yes/No (N): "))
         )

        (if (= default_answer "Yes")
           (if (or (= input "N") (= input "n"))
              (setq result nil)
              (setq result T)
            )
           (if (or (= input "Y") (= input "y"))
              (setq result nil)
              (setq result T)
            )
         )
  )

 (defun get_mid_point (line / p1 p2 x1 y1 x2 y2 mid_x mid_y mid_point )

        (setq p1 (car line))
        (setq p2 (cadr line))
        (setq x1 (car p1))
        (setq y1 (cadr p1))
        (setq x2 (car p2))
        (setq y2 (cadr p2))
        (setq mid_x (/ (+ x1 x2) 2))
        (setq mid_y (/ (+ y1 y2) 2))
        (setq mid_point (list mid_x mid_y))
  )

 (defun get_cui_zhi_two_point (line / mid_p p1 p2 a d_x d_y mid_x mid_y two_p)

        (setq mid_p (get_mid_point line))
        (setq mid_x (car mid_p))
        (setq mid_y (cadr mid_p))

        (setq p1 (car line))
        (setq p2 (cadr line))
        (setq a (angle p1 p2))
        (setq a (+ a (/ pai 2)))

        (setq d_x (* 0.001 (cos a)))
        (setq d_y (* 0.001 (sin a)))
        (setq two_p (list (list (+ mid_x d_x) (+ mid_y d_y)) (list (- mid_x d_x) (- mid_y d_y))))
  )

 (defun l1_angle_l2 (p1 p2 p3 p4 / a a1 a2)

        (setq a1 (angle p1 p2))
        (setq a2 (angle p3 p4))
        (setq a (- a1 a2))
  )

 (defun fix_line (line_en_1 line_en_2 p1 p2 p3 p4 / new_line inter_p min_x min_y max_x max_y d1 d2 d3 d4 d5 d6 max_d)

        (setq new_line nil)
        (if (or
               (and (equal p1 p3) (equal p2 p4))
               (and (equal p1 p4) (equal p2 p3))
             )
            (progn
               ;(my_zoom_for_two_line p1 p2 p3 p4)
               ;(redraw line_en_1 3)
               ;(redraw line_en_2 3)
               ;(getint "Double line found, Romove it ?!")
               (command "line" p1 p2 "")
               (setq new_line (entlast))
             )
            (progn
               (setq inter_p (inters p1 p2 p3 p4 nil))
               (if (= inter_p nil)
                  (progn
                     (setq inter_p (inters p1 p2 p1 p3 nil))
                     (if (= inter_p nil)
                        (progn 
                           (setq d1 (distance p1 p2)
                                 d2 (distance p3 p4)
                                 d3 (distance p1 p3)
                                 d4 (distance p1 p4)
                                 d5 (distance p2 p3)
                                 d6 (distance p2 p4)
                            )
                           (setq max_d (max d3 d4 d5 d6))
                           (if (<= max_d (+ d1 d2))
                              (progn     
                                 (cond ((equal d3 max_d)
                                        (setq p1 p1 
                                              p2 p3
                                         )
                                        )
                                       ((equal d4 max_d)
                                        (setq p1 p1 
                                              p2 p4
                                         )
                                        )
                                       ((equal d5 max_d)
                                        (setq p1 p2 
                                              p2 p3
                                         )
                                        )
                                       ((equal d6 max_d)
                                        (setq p1 p2 
                                              p2 p4
                                         )
                                        )
                                       (T
                                         (getint "Fatal error found !")
                                        )
                                  )

                                 ;(my_zoom_for_two_line p1 p2 p3 p4)
                                 ;(redraw line_en_1 3)
                                 ;(redraw line_en_2 3)
                                 ;(getint "There is a relaid line on the current line, Romoved it ?!")

                                 (command "line" p1  p2 "")
                                 (setq new_line (entlast))
                               )
                            )
                         )
                      )
                   )
                )
             )
         )
        new_line
  )

 (defun not_point_line (line_en / detail p1 p2 result)

        (setq result nil)
        (if line_en
           (progn
              (setq detail (entget line_en))
              (if detail
                 (progn
                    (setq p1 (dxf 10 detail))
                    (setq p2 (dxf 11 detail))
                    (if (equal p1 p2)
                       (setq result (list nil p1 p2))
                       (setq result (list T p1 p2))
                     )
                  )
               )
            )
         )
        result
  )
 
 (defun confirm_wrong_line (cur_number line_ss total_ent / count line_en_1 line_en_2 new_line result1 result2)

        (while (< cur_number total_ent)
               (setq line_en_1 (ssname line_ss cur_number))
               (setq result1 (not_point_line line_en_1))
               (if (and result1 (equal (car result1) T))
                  (progn
                     (setq count (1+ cur_number))
                     (while (< count total_ent)
                            (setq line_en_2 (ssname line_ss count))
                            (setq result2 (not_point_line line_en_2))
                            (if (and result2 (equal (car result2) T))
                               (progn
                                   (setq new_line (fix_line line_en_1 line_en_2 (cadr result1) (caddr result1) (cadr result2) (caddr result2)))
                                   (if new_line
                                      (progn
                                         (command "erase" line_en_1 "")
                                         (ssdel line_en_1 line_ss)
                                         (command "erase" line_en_2 "")
                                         (ssdel line_en_2 line_ss)
                                         (ssadd new_line line_ss)
                                         (redraw new_line 1)
                                         (setq cur_number (1- cur_number)) ; ????
                                       )
                                    )
                                )
                             )
                            (setq count (1+ count))
                      )
                   )
                )
               (setq cur_number (1+ cur_number))
         )
  )

 (defun w_line (layer_string / line_ss first_line max_ent count)

        (setq line_ss (ssget "X" (list (cons 0 "line") (cons 8 layer_string))))
        (setq max_ent (sslength line_ss))
        (confirm_wrong_line 0 line_ss max_ent)
        (prompt "\n Searching wrong lines end !")
  )

 (defun get_first_v_of_pl ( pl / ed en x_y)
        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq ed (entget en))
        (setq x_y (dxf 10 ed))
 )

 (defun get_two_point_of_pl_line (line / v_s v_e tmp_line)

        (setq v_s (car line)
              v_e (cadr line)
         )
        (setq tmp_line (list (dxf 10 v_s) (dxf 10 v_e)))
  )

 (defun close_open_pl_directly (old_pl / ok detail)

        (setq detail (entget old_pl))
        (setq detail (subst (cons 70 1) (cons 70 0) detail))
        (entmod detail)
        (entupd old_pl)
        (redraw old_pl 3)
        (setq input (getstring "\n Is Closing right ? Yes/No (Y): "))
        (if (or (= input "N") (= input "n"))
           (progn
              (setq detail (subst (cons 70 0) (cons 70 1) detail))
              (entmod detail)
              (entupd old_pl)
              (redraw old_pl 3)
              (setq ok (list old_pl nil))
            )
           (setq ok (list old_pl T))
         )
        (setq ok ok)
  )

 (defun join_pl_to_itself (old_pl two_line / ok line1 line2 inter_point old_v1 old_v2 input detail intput)

        (setq ok (list old_pl nil))
        (setq input nil)
        (setq input (getstring "\n Close the POLYLINE directly ? Yes/No (N): "))
        (if (or (= input "Y") (= input "y"))
            (setq ok (close_open_pl_directly old_pl))
            (progn
               (setq detail (entget old_pl))
               (setq line1 (car two_line))
               (setq line2 (cadr two_line))
               (setq old_v1 (car line1))
               (setq old_v2 (car line2))
               (setq line1 (get_two_point_of_pl_line line1))
               (setq line2 (get_two_point_of_pl_line line2))
               (setq inter_point (inters (car line1) (cadr line1) (car line2) (cadr line2) nil))
               (if (/= inter_point nil)
                  (progn
                     (change_pl_vertex old_pl old_v1 inter_point)
                     (change_pl_vertex old_pl old_v2 inter_point)
                     (setq detail (subst (cons 70 1) (cons 70 0) detail))
                     (entmod detail)
                     (entupd old_pl)
                     (redraw old_pl 3)
                     (setq input (getstring "\n Is that all right ? Yes/No (Y): "))
                     (if (or (= input "N") (= input "n"))
                        (progn
                           (command "undo" "")
                           (setq ok (list old_pl nil))
                         )
                        (setq ok (list old_pl T))
                       )
                   )
                )
             )
         )
        (setq ok ok)
  )

 (defun get_nearer_vertex (v_line inter_p / v1 v2 p1 p2 dst1 dst2 found_v)

        (setq v1 (car v_line))
        (setq v2 (cadr v_line))
        (setq p1 (dxf 10 v1))
        (setq p2 (dxf 10 v2))
        (setq dst1 (distance inter_p p1))
        (setq dst2 (distance inter_p p2))
        (if (< dst1 dst2)
           (setq found_v v1)
           (setq found_v v2)
         )
  )

 (defun join_two_pl (old_pl two_line link_pl / detail ok)

        (setq detail (entget link_pl))
        (if (= 1 (dxf 70 detail))
            (setq ok (list old_pl nil))
            (setq ok (real_join_two_pl old_pl two_line link_pl))
         )
  )

 (defun real_join_two_pl (old_pl two_line link_pl / ok v_line_1 v_line_2 v_line_3 v_line_4 link_two_line p1 p2 p3 p4 p5 p6 p7 p8 one_line inter_p1 inter_p2 inter_p3 inter_p4 dst1 dst2 dst3 dst4 inter_p  vertex4 old_vertex link_old_vertex new_pl input min_dst input old_p1 old_p2 new_vtx_1 new_vtx_2)

        (setq p1 nil
              p2 nil
              p3 nil
              p4 nil
              p5 nil
              p6 nil
              p7 nil
              p8 nil
              intet_p1 nil
              inter_p2 nil
              inter_p3 nil
              inter_p4 nil
         )
        (setq ok (list old_pl nil))

        (setq v_line_1 (car two_line))
        (setq one_line (get_two_point_of_pl_line v_line_1))
        (setq p1 (car one_line))
        (setq p2 (cadr one_line))

        (setq v_line_2 (cadr two_line))
        (if v_line_2
           (progn
              (setq one_line (get_two_point_of_pl_line v_line_2))
              (setq p3 (car one_line))
              (setq p4 (cadr one_line))
            )
         )

        (setq link_two_line (get_pl_two_line link_pl))
        (setq v_line_3 (car link_two_line))
        (setq one_line (get_two_point_of_pl_line v_line_3))
        (setq p5 (car one_line))
        (setq p6 (cadr one_line))

        (setq v_line_4 (cadr link_two_line))
        (if v_line_4
           (progn
              (setq one_line (get_two_point_of_pl_line v_line_4))
              (setq p7 (car one_line))
              (setq p8 (cadr one_line))
            )
         )

        (setq inter_p1 (inters p1 p2 p5 p6 nil))
        (if p7
           (setq inter_p2 (inters p1 p2 p7 p8 nil))
         )
        (if p3
           (progn
              (setq inter_p3 (inters p3 p4 p5 p6 nil))
              (if p7
                (setq inter_p4 (inters p3 p4 p7 p8 nil))
               )
            )
         )

        (if inter_p1
           (setq dst1 (distance p1 p5))
           (setq dst1 1000000.000)
         )
        (if inter_p2
           (setq dst2 (distance p1 p7))
           (setq dst2 1000000.000)
         )
        (if inter_p3
           (setq dst3 (distance p3 p5))
           (setq dst3 1000000.000)
         )
        (if inter_p4
            (setq dst4 (distance p3 p7))
            (setq dst4 1000000.000)
         )

        (setq min_dst (min dst1 dst2 dst3 dst4))
        (cond ( (equal dst1 min_dst)
                (setq inter_p inter_p1)
                (setq old_vertex (get_nearer_vertex v_line_1 inter_p))
                (setq link_old_vertex (get_nearer_vertex v_line_3 inter_p))
                (setq old_p1 p1)
                (setq old_p2 p5)
               )
              ( (equal dst2 min_dst)
                (setq inter_p inter_p2)
                (setq old_vertex (get_nearer_vertex v_line_1 inter_p))
                (setq link_old_vertex (get_nearer_vertex v_line_4 inter_p))
                (setq old_p1 p1)
                (setq old_p2 p7)
               )
              ( (equal dst3 min_dst)
                (setq inter_p inter_p3)
                (setq old_vertex (get_nearer_vertex v_line_2 inter_p))
                (setq link_old_vertex (get_nearer_vertex v_line_3 inter_p))
                (setq old_p1 p3)
                (setq old_p2 p5)
               )
              ( (equal dst4 min_dst)
                (setq inter_p inter_p4)
                (setq old_vertex (get_nearer_vertex v_line_2 inter_p))
                (setq link_old_vertex (get_nearer_vertex v_line_4 inter_p))
                (setq old_p1 p3)
                (setq old_p2 p7)
              )
              ( T
                (getint "Fatal error found !")
               )
         )

        (if (or (equal p1 inter_p) (equal p3 inter_p))
           (progn
              (setq new_vtx_1 (change_pl_vertex old_pl old_vertex inter_p)) ; ? 
              (setq new_vtx_2 (change_pl_vertex link_pl link_old_vertex inter_p)) ; ?

              (command "pedit" old_pl "J" link_pl "" "X")
              (setq new_pl (entlast))
              (setq ok (fix_pl new_pl nil))
            )
           (progn
              (my_zoom_for_line (list old_p1 inter_p))
              (redraw old_pl 3)
              (if inter_p
                 (progn
                    (setq new_vtx_1 (change_pl_vertex old_pl old_vertex inter_p))
                    (setq new_vtx_2 (change_pl_vertex link_pl link_old_vertex inter_p))
                    ; (setq input (getstring "Is the linked two polyline ok ? No/Yes (Y): "))
                    ; (if (or (= input "N") (= input "n"))
                    ;    (progn
                    ;       (change_pl_vertex old_pl new_vtx_1 old_p1)
                    ;       (change_pl_vertex link_pl new_vtx_2 old_p2)
                    ;       (getint "restored ok ?")
                    ;        (setq ok (list old_pl nil))
                    ;       (setq have_not_done (cons link_pl have_not_done)) ; ????????
                    ;     )
                    ;    (progn
                    (command "pedit" old_pl "J" link_pl "" "X")
                    (setq new_pl (entlast))
                    (setq ok (fix_pl new_pl nil))
                    ;      )
                    ;  )
                  )
               )
            )
         )
        (setq ok ok)
  )

 (defun join_pl_with_line (old_pl two_line line / ok new_pl)
        (command "pedit" line "Y" "J" "ALL" "" "X")
        (setq new_pl (entlast))
        (setq ok (join_two_pl old_pl two_line new_pl))
  )

 (defun join_pl_with_arc (old_pl two_line arc / ok)

        (setq ok (list old_pl nil))
  )

 (defun join_pl_with_circle (old_pl two_line circl / ok)

        (setq ok (list old_pl nil))
  
  )

 (defun join_pl_with_text (old_pl two_line text / ok)

        (setq ok (list old_pl nil))
   )

 (defun link_pl_with_object (old_pl two_line ent / no_para detail name ok)

        (setq ok (list old_pl nil))
        (setq detail (entget ent))
        (setq name (dxf 0 detail))
        (cond ( (= name "POLYLINE")
                (if (equal old_pl ent)
                   (setq ok (join_pl_to_itself old_pl two_line))
                   (setq ok (join_two_pl old_pl two_line ent))
                 )
               )
              ( (= name "LINE")
                (setq ok (join_pl_with_line old_pl two_line ent))
               )
              ( (= name "ARC")
                (setq ok (join_pl_with_arc old_pl two_line ent))
               )
              ( (= name "CIRCLE")
                (setq ok (join_pl_with_circle old_pl two_line ent))
               )
              ( (= name "TEXT")
                (setq ok (join_pl_with_text old_pl two_line ent))
               )
              ( T
                (prompt "")
               )
         )
        (setq ok ok)
 )
  
 (defun select_object_to_link (old_pl two_line p1 height / link_obj ent_sel done break)

        (setq break nil)
        (setq done (list old_pl nil))
        (setq link_obj nil)
        (while (and (= link_obj nil) (= break nil)) 
               (setq link_obj (entsel "\n Select the nearest object for linking ! (Select nothing to zoom in.) "))
               (if (= link_obj nil)
                  (progn
                     (setq height (/ height 5))
                     (command "zoom" "C" p1 height)
                     (redraw old_pl 3)
                   )
                  (progn
                     (setq link_obj (car link_obj))
                     (if (= (dxf 8 (entget link_obj)) (dxf 8 (entget old_pl)))
                        (progn
                           (setq done (link_pl_with_object old_pl two_line link_obj))
                           (setq break T)
                         )
                        (progn
                           (setq link_obj nil)
                           (prompt "\n You can't select objects on other layers !")
                         )
                      )
                   )
                )
         )
        (setq done done)
  )

 (defun get_a_line_of_pline( pl / ed en1 en2 tmp_detail detail_1 detail_2 p1 p2 bulge go_on line)

        (setq go_on T)
        (setq detail_2 nil)
        (setq line nil)

        (setq ed (entget pl))
        (setq en1 (entnext (dxf -1 ed)))

        (setq en2 (entnext en1))
        (while (and go_on
                    en2
                    (setq tmp_detail (entget en2))
                    (/= "SEQEND" (DXF 0 tmp_detail))
                )
               (setq detail_2 tmp_detail)
               (setq detail_1 (entget en1))
               (setq p1 (dxf 10 detail_1))
               (setq p2 (dxf 10 detail_2))

               (setq bulge (dxf 42 detail_1))
               (if (= bulge nil)
                  (if (not (equal p1 p2))
                     (progn
                        (setq line (list p1 p2 T))
                        (setq go_on nil)
                      )
                     (progn
                        (setq en1 en2)
                        (setq en2 (entnext en2))
                      )
                   ) 

                  (if (equal bulge 0.0)
                     (if (not (equal p1 p2))
                        (progn
                           (setq line (list p1 p2 T))
                           (setq go_on nil)
                         )
                        (progn
                           (setq en1 en2)
                           (setq en2 (entnext en2))
                         )
                      )
                     (progn
                        (if (not (equal p1 p2))
                           (setq line (list p1 p2 nil))
                         )
                        (setq en1 en2)
                        (setq en2 (entnext en2))
                      )
                   )
                )
         )
        (if detail_2 
           (setq line line)
           (setq line nil)
         )
  )

 (defun fix_pl (tmp_pl old_layer / tmp_detail close two_line line1 line2 v_s v_e ok intput height dst a_line)

        (setq ok (list tmp_pl nil))
        (setq tmp_detail (entget tmp_pl))
        (if old_layer
           (setq a_line (get_a_line_of_pline tmp_pl))
           (setq a_line nil)
         )
        (if a_line
           (progn
              (setq close (dxf 70 tmp_detail))
              (if (= close 0)
                 (progn
                    (setq two_line (get_pl_two_line tmp_pl))
                    (setq line1 (car two_line)
                          line2 (cadr two_line)
                     )
                    (setq v_s (car line1))
                    (if line2
                       (setq v_e (car line2))
                       (setq v_e (cadr line1))
                     )
                    (setq dst (distance (dxf 10 v_s) (dxf 10 v_e)))
                    (if (equal dst 0.0 0.0001)
                       (progn
                          (setq tmp_detail (subst (cons 70 1) (cons 70 0) tmp_detail))
                          (entmod tmp_detail)
                          (entupd tmp_pl)
                          (setq ok (list tmp_pl T))
                        )
                       (progn
                          (setq height (my_zoom_for_line (list (dxf 10 v_s) (dxf 10 v_e))))
                          (redraw tmp_pl 3)
                          (setq ok (select_object_to_link tmp_pl two_line (dxf 10 v_s) height))
                        )
                     )
                  )
                 (setq ok (list tmp_pl T))
               )
            )
           (if old_layer
              (progn
                 ;(getint "Unuseful POLYLINE found, any key to go on.")
                 (setq tmp_detail (subst (cons 8 "PROBLEM") (cons 8 old_layer) tmp_detail))
                 (entmod tmp_detail)
                 (setq ok (list tmp_pl T))
               )
            )
         )
        ok
  )

 (defun get_unclosed_pline (layer_string / pl_ss ent_name total count result)

        (setq result (ssadd))
        (setq pl_ss (ssget "X" (list (cons 0 "POLYLINE") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (setq tmp_detail (entget ent_name))
                     (if (= (dxf 70 tmp_detail) 0)
                        (setq result (ssadd ent_name result))
                      )
                     (setq count (1+ count))
               )
            )
         )
        result
  )

 (defun all_to_pline (pl_ss / rest_pl_ss ent_name total count tmp_pl ok done name)

        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq rest_pl_ss pl_ss)
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq rest_pl_ss (ssdel ent_name rest_pl_ss))
                           (setq tmp_detail (entget ent_name))
                           (if tmp_detail 
                              (progn
                                 (setq name (dxf 0 tmp_detail))
                                 (if (= name "POLYLINE")
                                    (if (= (dxf 70 tmp_detail) 0)
                                       (command "pedit" ent_name "J" rest_pl_ss "" "X")
                                     )
                                    (command "pedit" ent_name "Y" "J" rest_pl_ss "" "X")
                                  )
                               )
                            )
                         )
                      )
                     (setq count (1+ count))
               )
            )
         )
  )

 (defun pline_to_close_pline (layer_string times / pl_ss ent_name total count tmp_pl ok done) 

        (setq pl_ss (ssget "X" (list (cons 0 "POLYLINE") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq tmp_detail (entget ent_name))
                           (if (/= tmp_detail nil ) 
                              (progn
                                 (setq ok (fix_pl ent_name layer_string))
                                 (if (= (cadr ok)  nil)
                                    (if (= times 1)
                                       (setq have_not_done (cons (car ok) have_not_done))
                                     )
                                  )
                               )   
                            )
                         )
                      )
                     (setq count (1+ count))
               )
            )
         )
  )

 (defun text_to_pline (layer_string / pl_ss ent_name total count tmp_pl text_b p1 detail ss block_ss)  

        (setq block_ss (ssadd))
        (setq pl_ss (ssget "X" (list (cons 0 "TEXT") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq p1 (my_zoom_for_text ent_name))
                           (if p1
                              (progn
                                 (command "_.WMFOUT" "TMPFIL.WMF" ent_name "")
                                 (command "_.ERASE" ent_name "")
                                 (command "_.IMPORT" "TMPFIL.WMF" p1)
                                 (setq text_b (entlast))
                                 (setq block_ss (ssadd text_b block_ss))
                               )
                            )
                         )
                      )
                     (setq count (1+ count))
               )
              (explode block_ss layer_string)
            )
         )
  )

 (defun get_four_point (v_1 v_2 / x y p1 p2 p3 p4 p5 p6 s_width e_width a line_1 line_2 pl_ss four_point)

        (setq p1 (dxf 10 v_1))
        (setq p2 (dxf 10 v_2))
        (if (not (equal p1 p2))
           (progn
              (setq s_width (dxf 40 v_1))
              (setq s_width (/ s_width 2))
              (setq e_width (dxf 41 v_1))
              (setq e_width (/ e_width  2))
              (setq a (angle p1 p2))
        
              (setq x (car p1))
              (setq y (cadr p1))
              (setq p3 (list (+ x (* (sin a) s_width)) (- y (* (cos a) s_width))))
              (setq p4 (list (- x (* (sin a) s_width)) (+ y (* (cos a) s_width))))

              (setq x (car p2))
              (setq y (cadr p2))
              (setq p5 (list (+ x (* (sin a) e_width)) (- y (* (cos a) e_width))))
              (setq p6 (list (- x (* (sin a) e_width)) (+ y (* (cos a) e_width))))
              (setq four_point (list p3 p5 p4 p6))
            )
           (setq four_point nil)
         )
  )

 (defun get_four_points_inter_v (ps_1 ps_2 / p1 p2 result)

        (setq p1 (inters (car ps_1) (cadr ps_1) (car ps_2) (cadr ps_2) nil))
        (if (= p1 nil)
           (setq p1 (cadr ps_1))
         )

        (setq p2 (inters (caddr ps_1) (cadddr ps_1) (caddr ps_2) (cadddr ps_2) nil))
        (if (= p2 nil)
           (setq p2 (cadddr ps_1))
         )
        (setq result (list p1 p2))
 )

 (defun change_width_pl_to_0_width_pl (pl / ed first_v v_1 v_2 s_width e_width points all_points total count old_points first_points pl_points pl_ss first_pl)

        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq v_1 (entget en))
        (setq s_width (dxf 40 v_1)) 
        (setq e_width (dxf 41 v_1))
        (if (or (/= s_width 0) (/= e_width 0))
           (progn
              (if (= 0 (dxf 70 ed))
                 (setq close nil)
                 (setq close T)
               )
              (setq first_v v_1)
              (setq en (entnext en))
              (while (and en
                          (setq ed (entget en))
                          (/= "SEQEND" (DXF 0 ed))
                      )
                     (setq v_2 ed)
                     (setq points (get_four_point v_1 v_2))
                     (if points
                        (setq all_points (cons points all_points))
                      )
                     (setq v_1 v_2)
                     (setq en (entnext en))
               )
              (if close
                 (progn
                    (setq points (get_four_point v_2 first_v))
                    (setq all_points (cons points all_points))
                  )
               )

              (command "erase" pl "")

              (setq total (length all_points))
              (if (= total 1)
                 (progn
                    (setq points (car all_points))
                    (command "pline" (car points) "w" 0 0 (cadr points) (cadddr points) (caddr points) "c")
                  )
                 (progn
                    (setq pl_ss (ssadd))
                    (setq first_points (car all_points))
                    (if (= close nil)
                       (progn
                          (setq pl_points (cons (list (cadr first_points) (cadddr first_points)) pl_points))
                          (command "pline" (cadr first_points) "w" 0 0 (cadddr first_points) "")
                          (setq pl_ss (ssadd (entlast) pl_ss)) 
                        )
                     )
                    (setq old_points first_points)
                    (setq count 2)
                    (while (<=  count total)
                           (setq points (nth (1- count) all_points))
                           (setq pl_points (cons (get_four_points_inter_v old_points points) pl_points))
                           (setq old_points points)
                           (setq count (1+ count))
                     )

                    (if close
                       (setq pl_points (cons (get_four_points_inter_v old_points first_points) pl_points))
                       (progn
                          (setq pl_points (cons (list (car old_points) (caddr old_points)) pl_points))
                          (command "pline"  (car old_points) "w" 0 0 (caddr old_points) "")
                          (setq pl_ss (ssadd (entlast) pl_ss)) 
                        )
                     )

                    (setq total (length pl_points))
                    (setq first_points (car pl_points))
                    (setq old_points first_points)
                    (setq count 2)
                    (while (<= count total)
                           (setq points (nth (1- count) pl_points))
                           (command "pline" (car old_points) "w" 0 0 (car points) "")
                           (setq pl_ss (ssadd (entlast) pl_ss)) 
                           (command "pline" (cadr old_points) "w" 0 0 (cadr points) "")
                           (setq pl_ss (ssadd (entlast) pl_ss)) 
                           (setq old_points points)
                           (setq count (1+ count))
                     )
                    (if close
                       (progn 
                          (command "pline" (car old_points) "w" 0 0 (car first_points) "")
                          (setq pl_ss (ssadd (entlast) pl_ss)) 
                          (command "pline" (cadr old_points) "w" 0 0 (cadr first_points) "")
                          (setq pl_ss (ssadd (entlast) pl_ss)) 
                        )
                     )
                    (setq first_pl (ssname pl_ss 0))
                    (setq pl_ss (ssdel first_pl pl_ss))
                    (command "pedit" first_pl "J" pl_ss "" "X")
                  )
               )
            )
         )
 )

 (defun change_width_pline (layer_string / pl_ss ent_name total count tmp_pl ok done detail)

        (setq pl_ss (ssget "X" (list (cons 0 "polyline") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if (and ent_name (entget ent_name))
                        (change_width_pl_to_0_width_pl ent_name)
                      )
                     (setq count (1+ count))
               )
            )
         )
  )

 (defun go_on_not_done_pl (layer_string / no_para go_on ent detail name done pl_ss total count tmp_pl line_ss arc_ss pl_ss)

        (if (/= (car have_not_done) nil)
           (progn
              (setq go_on have_not_done)
              (setq have_not_done (list nil))
              (setq ent (car go_on))
              (while ent
                     (setq go_on (cdr go_on))
                     (setq detail (entget ent))
                     (if (and detail (= (dxf 0 detail) "POLYLINE"))
                        (progn
                           (command "explode" ent)
                           (w_line layer_string)
                           (setq line_ss (ssget "X" (list (cons 0 "LINE") (cons 8 layer_string))))
                           (setq arc_ss (ssget "X" (list (cons 0 "ARC") (cons 8 layer_string))))
                           (command "select" line_ss arc_ss "")
                           (setq pl_ss (ssget "P"))
                           (all_to_pline pl_ss)
                         )
                      )
                     (setq ent (car go_on))
               )
            )
         )
  )

 (defun change_pl_vertex (pl old_vtx new_p / old_p new_vtx) ;3D_point
        (setq old_p (dxf 10 old_vtx))
        (setq old_vtx (subst (cons 10 new_p) (cons 10 old_p) old_vtx))
        (entmod old_vtx)
        (entupd pl)
        (setq new_vtx old_vtx)
  )

 (defun change_line_point (line old_p new_p / detail tmp_p) ;3D_point
        (setq detail (entget line))
        (setq tmp_p (dxf 10 detail))
        (if (equal old_p tmp_p)
           (setq detail (subst (cons 10 new_p) (cons 10 old_p) detail))
           (setq detail (subst (cons 11 new_p) (cons 11 old_p) detail))
         )
        (entmod detail)
        (entupd line)
  )

 (defun get_pl_two_line ( pl / ed en en1 en2 en3 en4 last_ed count two_line) 

        (setq count 0)
        (setq en1 nil)
        (setq en2 nil) ;It is important to prevent polyline of one point
        (setq en3 nil)
        (setq en4 nil)
        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (if (= count 0)
                  (setq en1 ed)
                  (if (= count 1)
                    (setq en2 ed)
                   )
                )
               (setq count (1+ count))
               (setq last_ed ed)
               (setq en (entnext en))
               (setq ed (entget en))
               (if (/= "SEQEND" (DXF 0 ed))
                   (progn
                      (setq en3 last_ed)
                      (setq en4 ed)
                    )
                   (prompt "")
                )
         )
        (if (< count 3)
           (setq two_line (list (list en1 en2) nil)) ;important !
           (setq two_line (list (list en1 en2) (list en4 en3)))
         )
  )

 (defun get_window_for_pline( pl / no_para ed en x_y x y min_x min_y max_x max_y)
        (setq min_x nil
              min_y nil
              max_x nil
              max_y nil
         )
        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq x_y (dxf 10 ed))
               (setq x (car x_y))
               (setq y (cadr x_y))

               (if (= min_x nil)
                   ( setq min_x x
                          max_x x
                          min_y y
                          max_y y
                     )
                    (progn
                       (if (> x max_x)
                          (setq max_x x)
                          (if (< x min_x)
                              (setq min_x x)
                              (prompt "")
                           )
                        )
                      (if (> y max_y)
                          (setq max_y y)
                          (if (< y min_y)
                              ( setq min_y y)
                              (prompt "")
                           )
                       )
                     )
                )
               (setq en (entnext en))
         )
        (setq window (list (list min_x min_y) (list max_x max_y)))
 )

 (defun point_in_pl_old (pl p / a result)

        (setq a (angle_to_pl pl p))
        (if (or (equal a 6.283185307178 0.000000000002)
                (equal a -6.283185307178 0.000000000002)
             )
            (setq result T)
            (setq result nil)
         )
  )

 (defun point_in_pl (pl p / total result)

        (setq total (get_inters_total pl p))
        (if (= 0 (rem total 2))
           (setq result nil)
           (setq result T)
         )
  )

 (defun creat_point_in_pline ( pl mode / line mid_x mid_x p1 p2 x1 y1 x2 y2 dst1 dst2 found_p in_1 in_2 ok two_p)

        (setq found_p nil)

        (setq line (get_a_line_of_pline pl))
        (setq ok (caddr line))
        (if ok
           (progn
              (setq two_p (get_cui_zhi_two_point line))
              (setq p1 (car two_p)
                    p2 (cadr two_p)
               )
              (setq in_1 (point_in_pl pl p1))
              (setq in_2 (point_in_pl pl p2))

              (if (/= in_1 in_2)
                 (if (or (= "X" mode) (= "x" mode))
                    (if (= in_2 T)
                       (setq found_p p2)
                       (setq found_p p1)
                     )
                    (if (= in_2 T) ; mode = "D" mode="d"
                       (setq found_p p1)
                       (setq found_p p2)
                     )
                  )
               )
            )
         )
        found_p
  )

 (defun check_ofst_pl (tmp_pl pl old_layer new_layer / tmp_detail now ok)

        (setq ok T)
        (setq tmp_detail (entget tmp_pl))
        (if (= (dxf 70 tmp_detail) 0)  ;the offset polyline is open !
           (progn
              (command "erase" tmp_pl "")
              (setq now (entget pl))
              (setq now (subst (cons 8 "PROBLEM") (cons 8 old_layer) now))
              (entmod now)
              (setq ok nil)
            )
           (progn
              (setq tmp_detail (subst (cons 8 new_layer) (cons 8 old_layer) tmp_detail))
              (entmod tmp_detail)
            )
         )
         (setq ok ok)
  )

 (defun offset_a_pline (old_layer new_layer pl offset_dst mode / p1 tmp_pl ok)

        (setq p1 (creat_point_in_pline pl mode))
        (if p1
           (progn
              (command "offset" offset_dst pl p1 "")
              (setq tmp_pl (entlast))
              (setq ok (check_ofst_pl tmp_pl pl old_layer new_layer))
            )
           (progn
              (my_zoom_for_pl pl)
              (setq p1 (getpoint "\n Select one point for offsetting !"))
              (command "offset" offset_dst pl p1 "")
              (setq tmp_pl (entlast))
              (setq ok (check_ofst_pl tmp_pl pl old_layer new_layer))
            )
         )
 )

 (defun ofst_pline (old_layer new_layer mode offset_dst / pl_ss ent_name max_ent count window result center radias detail tmp_detail tmp_detail ok now)

        (setq wrong 0)
        (setq pl_ss (ssget "X" (list (cons 0 "POLYLINE") (cons 8 old_layer))))
        (if (/= pl_ss nil)
            (progn
               (setq max_ent (sslength pl_ss))
               (setq count 0)
               (while (< count max_ent)
                      (setq ent_name (ssname pl_ss count))
                      (if ent_name
                         (progn
                            (setq tmp_detail (entget ent_name))
                            (if tmp_detail
                               (if (= (dxf 70 tmp_detail) 0)
                                  (progn
                                     (setq tmp_detail (subst (cons 8 "PROBLEM") (cons 8 old_layer) tmp_detail))
                                     (entmod tmp_detail)
                                   )
                                  (progn 
                                     (setq ok (offset_a_pline old_layer new_layer ent_name offset_dst mode))
                                     (if (= ok nil)
                                        (setq wrong (1+ wrong))
                                      )
                                   )
                                )
                             )
                          )
                       )
                      (setq count (1+ count))
                )
             )
         )
        (if (> wrong 0)
           (progn
              (print wrong)
              (prompt "POLYLINEs have some problems, they are removed to 'PROBLEM' layer.")
            )
         )
  )

 (defun ofst_circle (old_layer new_layer mode offset_dst / c_ss ent_name max_ent count window result center radias detail tmp_detail ok now tmp_ent) 

        (setq c_ss (ssget "X" (list (cons 0 "CIRCLE") (cons 8 old_layer))))
        (if c_ss 
           (progn
              (setq max_ent (sslength c_ss))
              (setq count 0)
              (while (< count max_ent)
                     (setq ent_name (ssname c_ss count))
                     (setq detail (entget ent_name))
                     (setq center (dxf 10 detail))
                     (if (or (= mode "X") (= mode "x")) 
                        (command "offset" offset_dst ent_name center "")
                        (progn
                           (setq radias (dxf 40 detail))
                           (command "offset" offset_dst ent_name (list (+ (car center) radias offset_dst) (cadr center)) "")
                         )
                      )
                     (setq tmp_ent (entlast))
                     (setq tmp_detail (entget tmp_ent))
                     (setq tmp_detail (subst (cons 8 new_layer) (cons 8 old_layer) tmp_detail))
                     (entmod tmp_detail)
                     (entupd tmp_ent)
                     ;(command "erase" ent_name "")
                     (setq count (1+ count))
               )
            )
         )
  )

 (defun c:ofst ( / old_layer new_layer mode dst)

        (setq old_layer (getstring nil "Input the layer to be offset: "))
        (setq new_layer (getstring nil "Input the new layer to be created: "))
        (setq mode (getstring nil "Input offsetting mode (Xiao / Da): "))
        
        (setq old_layer (strcase old_layer))
        (setq new_layer (strcase new_layer))
        (setq dst (getreal "Input distance for offset: "))
        (ofst_circle old_layer new_layer mode dst)
        (ofst_pline old_layer new_layer mode dst)
        (prompt "\n Offsetting End !")
  )

 (defun chang_pl_to_width_pl ( en w / no_para ed en x_y x y old_w)

        (setq en (dxf -1 en))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq old_w (dxf 40 ed))
               (setq ed (subst (cons 40 w) (cons 40 old_w) ed))
               (entmod ed)
               (setq old_w (dxf 41 ed))
               (setq ed (subst (cons 41 w) (cons 41 old_w) ed))
               (entmod ed)
               (setq en (entnext en))
         )
  )

 (defun pline_to_out_line(layer_string w / pl_ss ent_name total count tmp_pl ok done) 

        (setq pl_ss (ssget "X" (list (cons 0 "POLYLINE") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq tmp_detail (entget ent_name))
                           (if (/= tmp_detail nil ) 
                              (chang_pl_to_width_pl tmp_detail w)
                            )
                         )
                      )
                     (setq count (1+ count))
               )
            )
         )
  )

 (defun c:out_line (/ layer_string w pl_ss line_ss arc_ss)

        (setq layer_string (getstring nil "Input the layer to be handled: "))
        (setq layer_string (strcase layer_string))
        (setq w (getreal "Input the width of the lines: "))

        (setq pl_ss (get_unclosed_pline layer_string))
        (setq line_ss (ssget "X" (list (cons 0 "LINE") (cons 8 layer_string))))
        (setq arc_ss (ssget "X" (list (cons 0 "ARC") (cons 8 layer_string))))
        (if line_ss
           (progn
              (command "select" line_ss pl_ss "")
              (setq pl_ss (ssget "P"))
            )
         )
        (if arc_ss
           (progn
              (command "select" arc_ss pl_ss "")
              (setq pl_ss (ssget "P"))
            )
         )
        (all_to_pline pl_ss)

        (text_to_pline layer_string)
      
        (pline_to_out_line layer_string w)
        (change_width_pline layer_string)
        (prompt "\n Out_line End !")
  )

 (defun c:pl (/ layer_string pl_ss arc_ss line_ss)

        (setq layer_string (getstring nil "Input the layer to be handled: "))
        (setq layer_string (strcase layer_string))

        (change_width_pline layer_string)
        (setq pl_ss (get_unclosed_pline layer_string))
        (setq line_ss (ssget "X" (list (cons 0 "LINE") (cons 8 layer_string))))
        (setq arc_ss (ssget "X" (list (cons 0 "ARC") (cons 8 layer_string))))
        (if line_ss
           (progn
              (command "select" line_ss pl_ss "")
              (setq pl_ss (ssget "P"))
            )
         )
        (if arc_ss
           (progn
              (command "select" arc_ss pl_ss "")
              (setq pl_ss (ssget "P"))
            )
         )
        (all_to_pline pl_ss)

        (pline_to_close_pline layer_string 1)
        (go_on_not_done_pl layer_string)
        (pline_to_close_pline layer_string 2)

        (text_to_pline layer_string)
        (pline_to_close_pline layer_string 2)

        (prompt "\n Handling POLYLINE End !") 
  )

 (defun angle_to_pl (pl p / ed en p1 p2 a detail tmp_a first_p)

        (setq a 0)
        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))

        (setq detail (entget en))
        (setq p1 (dxf 10 detail)) ;First point
        (setq first_p p1)
        (setq en (entnext en))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq p2 (dxf 10 ed))
               (setq tmp_a (l1_angle_l2 p p1 p p2))
               (setq a (+ a tmp_a))
               (setq p1 p2)
               (setq en (entnext en))
         )
        (setq tmp_a (l1_angle_l2 p p2 p first_p))
        (setq a (+ a tmp_a))
 )

 (defun get_pl_perimeter (pl / ed en p1 p2  detail first_p dst)

        (setq p2 nil)
        (setq dst 0)
        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq detail (entget en))
        (setq p1 (dxf 10 detail)) ;First point
        (setq first_p p1)
        (setq en (entnext en))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq p2 (dxf 10 ed))
               (setq dst (+ dst (distance p1 p2)))
               (setq p1 p2)
               (setq en (entnext en))
         )
        (if p2
           (setq dst (+ dst (distance p2 first_p)))
         )
        (setq dst dst)
 )
  
 (defun distance_to_pline ( pl tmp_p / no_para ed en x_y x y dst)

        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq dst 0)
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq x_y (dxf 10 ed))
               (setq x (car x_y))
               (setq y (cadr x_y))
               (setq dst (+ dst (distance tmp_p (list x y)))) ;2D point.
               (setq en (entnext en))
         )
        (setq dst dst)
  )

 (defun link_list_atom_list (list1 point list2)

        (if (atom list2)
           (setq list2 (list point))
           (setq list2 (cons point list2))
         )
        (if (atom list1)
           (setq list1 list2)
           (setq list1 (append list1 list2))
         )
  )

 (defun insert_point_to_sorted_list (entname inters_list point mode / first_point pre_list not_found)

        (if (= mode "X_DIRECTION")
           (setq point (list (car point) entname)) 
           (setq point (list (cadr point) entname))
         )
        (setq pre_list nil)      
        (setq not_found T)

        (while not_found
               (if (atom inters_list)
                  (progn
                     (setq inters_list (link_list_atom_list pre_list point inters_list))
                     (setq not_found nil)
                   )
                  (progn
                     (setq first_point (car inters_list))
                     (if (< (car point) (car first_point))
                        (progn
                           (setq inters_list (link_list_atom_list pre_list point inters_list))
                           (setq not_found nil)
                         )
                        (progn
                           (setq pre_list (link_list_atom_list pre_list first_point nil))
                           (setq inters_list (cdr inters_list))
                         )
                      )
                   )
                )
         )
        inters_list
  )             
 
 (defun get_line_with_pl_inters_list (pl p3 p4 inters_list mode / ed en p1 p2 p4 detail first_p total inter_p)

        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq detail (entget en))
        (setq p1 (dxf 10 detail)) ;First point
        (setq first_p p1)

        (setq en (entnext en))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq p2 (dxf 10 ed))
               (setq inter_p (inters p1 p2 p3 p4))
               (if inter_p
                  (setq inters_list (insert_point_to_sorted_list pl inters_list inter_p mode))
                )
               (setq p1 p2)
               (setq en (entnext en))
         )
        (if p2
           (progn
              (setq inter_p (inters p2 first_p p3 p4))
              (if inter_p
                 (setq inters_list (insert_point_to_sorted_list pl inters_list inter_p mode))
               )
            )
         )
        (setq inters_list inters_list)
  )

 (defun get_line_with_all_pl_inters_list (layer_string inters_list p1 p2 mode / pl_ss ent_name total count tmp_pl)

        (setq pl_ss (ssget "X" (list (cons 0 "POLYLINE") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq tmp_detail (entget ent_name))
                           (if (/= tmp_detail nil ) 
                              (setq inters_list (get_line_with_pl_inters_list ent_name p1 p2 inters_list mode))
                            )
                         )
                      )
                     (setq count (1+ count))
               )
            )
         )
        (setq inters_list inters_list)
  )
 
 (defun c:check_width ( / p1 p2 layer_string mode layer_color)

        (setq layer_string (getstring nil " Input the layer to be handled: "))
        (setq layer_string (strcase layer_string))

        (setq p1 (getpoint "\n Select the fisrt point of line which is used to check ..."))
        (setq p2 (getpoint "\n Select the second point ..."))
        (print "Waiting ...")
        ;(setvar "orthomode" 1)
        ;(command "line")
        ;(setvar "orthomode" 0)
        (if (< (abs (- (car p1) (car p2))) (abs (- (cadr p1) (cadr p2))))
           (progn 
             (setq mode "Y_DIRECTION")
             (setq p2 (list (car p1) (cadr p2) (caddr p2)))
            )
           (progn
             (setq mode "X_DIRECTION")
             (setq p2 (list (car p2) (cadr p1) (caddr p2)))
            )
         )
        (setq inters_list (get_line_with_all_pl_inters_list layer_string nil p1 p2 mode))
        (setq layer_color (dxf 62 (tblsearch "layer" layer_string)))
        (check_inters_list inters_list "LINE_WIDTH" layer_color)
        (check_inters_list inters_list "SPACE_WIDTH" layer_color)
  )

 (defun check_inters_list (inters_list mode layer_color / first_point second_point width last_width count error_total pl_color detail)

        (setq count 0)
        (if (= mode "SPACE_WIDTH")
           (setq inters_list (cdr inters_list))
         )
        (while inters_list
               (setq first_point (car inters_list))
               (setq inters_list (cdr inters_list))
               (if inters_list
                  (progn
                     (setq second_point (car inters_list))
                     (setq inters_list (cdr inters_list))
                     (setq width (- (car second_point) (car first_point)))
                     (print width)
                     (if (>= count 1)
                        (if (> (abs (- last_width width)) 0.0001)
                           (progn
                             (setq detail (entget (cadr second_point)))
                             (setq pl_color (dxf 62 detail))
                             (if (= pl_color nil)
                                (progn
                                   (setq detail (append detail (list (cons 62 (+ layer_color 1)))))
                                   (entmod detail)
                                   (entupd (cadr second_point))
                                 )
                              )
                             (if (= pl_color layer_color)
                                (progn
                                   (setq detail (subst (cons 62 (+ layer_color 1)) (cons 62 pl_color) detail))
                                   (entmod detail)
                                   (entupd (cadr second_point))
                                 )
                              )
                             (my_zoom_for_pl (cadr second_point))
                             (if (= mode "LINE_WIDTH")
                                (getint "The POLYLINE or the two nears may be wrong in width ! ESC key to break,and any key to go on.")
                                (getint "The POLYLINE or the two nears may be wrong in space ! ESC key to break,and any key to go on.")
                              )
                            )
                         )
                      )
                     (setq last_width width)
                     (setq count (1+ count))
                   )
                )
         )
        (if (= mode "LINE_WIDTH")
           (print "The width of the line is: ")
           (print "The space of the line is: ")
         )
   )

 (defun get_inters_total (pl p3 / ed en p1 p2 p4 detail first_p total inter_p)

        (setq total 0)
        (setq p4 (list 2000.0 2000.0))

        (setq ed (entget pl))
        (setq en (entnext (dxf -1 ed)))
        (setq detail (entget en))
        (setq p1 (dxf 10 detail)) ;First point
        (setq first_p p1)
        (setq en (entnext en))
        (while (and en
                    (setq ed (entget en))
                    (/= "SEQEND" (DXF 0 ed))
                )
               (setq p2 (dxf 10 ed))
               (setq inter_p (inters p1 p2 p3 p4))
               (if inter_p
                  (setq total (1+ total))
                )
               (setq p1 p2)
               (setq en (entnext en))
         )
        (if p2
           (progn
              (setq inter_p (inters p2 first_p p3 p4))
              (if inter_p
                 (setq total (1+ total))
               )
            )
         )
        (setq total total)
 )

(defun xp_err (s)                     ; If an error (such as CTRL-C) occurs
  ;; while this command is active...
  (if (/= s "Function cancelled") 
    (princ (strcat "\nError: " s))
  ) 
  (if xp_oce (setvar "cmdecho" xp_oce)) ; restore old cmdecho value
  (setq *error* olderr)               ; restore old *error* handler
  (princ)
) 

;;; ---------------------------- COMMON FUNCTION -----------------------------;

(defun xp_val (n e f) 
  (if f ; if f then e is an entity list.
    (cdr (assoc n e))
    (cdr (assoc n (entget e)))
  )
) 

;;; ------------------------- GET ENTITY TO EXPLODE --------------------------;
;;; ---------------------------- MAIN PROGRAM --------------------------------;

(defun explode ( ss lyr / oce ohl e0 en e1 s0) 

  (setq xp_oer *error* 
        *error* xp_err)
  (setq xp_oce (getvar "cmdecho"))    ; save value of cmdecho
  (graphscr)

  (if ss
    (progn
      ;; Sort out any entities not explodeable...
      (setq ss (xp_sxe)) ; DLine_Sort_Xplodable_Entities
    
      ;; XPlode Individually or Globally?
    
      (if (> (sslength ss) 0)
        (progn
          (if (> (sslength ss) 1)
            (progn
              (initget "Individually Globally")
              (setq ans "Globally")
            )
            (setq ans "Globally")
          )
        
        
          (cond
            ((= ans "Individually")
              (setq sslen (sslength ss)
                    j    0
              )
              (while (< j sslen)
                (setq temp  (ssname ss j)
                      prmpt T
                )
        
                (redraw temp 3)
                (setq typ "LAyer")
                (xp_xpe temp typ lyr)
                (redraw temp 4)
                (setq j (1+ j))
              )
            )
            (T
              (setq sslen (sslength ss)
                    j     0
                    ans   "Globally"
                    prmpt T
              )
              (setq typ "LAyer")
              (while (< j sslen)
                (setq temp (ssname ss j))

                (xp_xpe temp typ lyr)
                (setq j (1+ j))
              )
            )
          )
        )
      )
    )
  )
  
  (if xp_oce (setvar "cmdecho" xp_oce)) ; restore old cmdecho value
  (setq *error* xp_err)               ; restore old *error* handler
  (prin1)
) 
;;;
;;; Sort out all of the entities which can be exploded from the selection
;;; set.  Also ensure that block insertions have equal X, Y and Z scale factors.
;;;
;;; xp_sxe == DLine_Sort_Xplodable_Entities
;;;
(defun xp_sxe (/ temp bad)

  (setq sslen (sslength ss)
        j     0
        ss1   (ssadd)
  )
  (while (< j sslen)
    (setq temp (ssname ss j))
    (setq j (1+ j))
    (if (member (xp_val 0 temp nil) '("DIMENSION" "POLYLINE" "MLINE" 
                                      "3DSOLID" "REGION" "BODY"))
      (ssadd temp ss1)
      (progn
        ;; If it is an INSERT but not a MINSERT or XREF, add it.
        (if (member (xp_val 0 temp nil) '("INSERT"))
          (cond 
            ( (= 4 (logand 4 (cdr (assoc 70 (tblsearch "block" (cdr (assoc 2 (entget temp))))))))
            )
            ( (< 1 (cdr (assoc 70 (entget temp)))) )
            ( (< 1 (cdr (assoc 71 (entget temp)))) )
            ( T (ssadd temp ss1))
          )
        )
      )
    )
  )
  (setq sslen (sslength ss)
        bad (sslength ss1)
  )
  (princ "\n")
  (princ sslen)
  (princ " objects found. ")
  (if (> (- sslen bad) 0)
    (progn
      (princ (- sslen bad))
      (princ " invalid. ")
    )
  )
  ss1
)
;;;
;;; Set the type of explode to do.
;;;
;;; xp_gxt == XPlode_Get_Xplode_Type
;;;
(defun xp_gxt (/ temp)
  
  (initget "All Color LAyer LType Inherit Explode")
  (setq temp (getkword
    "\n\nAll/Color/LAyer/LType/Inherit from parent block/<Explode>: "))

  (if (or (= temp "") (null temp))
    (setq temp "Explode")
  )
  temp
)
;;;
;;; Do the explosion of an entity.
;;;
;;; xp_xpe == XPlode_XPlode_Entity
;;;
(defun xp_xpe (ent typ lyr /  )
  (cond 
    ((= typ "All")
      (if prmpt
        (progn
          (setq color (xp_scn))
          (setq ltype (xp_slt))
          (setq layer (xp_sla))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nObjects ")
            (princ "\nObject ")
          )
          (princ (strcat "exploded with color of " 
                         (if (= (type color) 'INT) (itoa color) (en_loc_type color)) ", "
                         "linetype of " (en_loc_type ltype) ", "
                         "and layer " layer "."))
        )
      )
    )
    ((= typ "Color")
      (if prmpt
        (progn
          (setq color (xp_scn))
          (setq ltype (getvar "celtype"))
          (setq layer (getvar "clayer"))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nObjects ")
            (princ "\nObject ")
          )
          (princ (strcat "exploded with color of " 
                         (if (= (type color) 'INT) (itoa color) color) ".")) 
        )
      )
    )
    ((= 
    typ "LAyer")
      
      (if prmpt
        (progn
          (setq color (getvar "cecolor"))
          (setq ltype (getvar "celtype"))
          (setq layer lyr) ;(xp_sla))
          (setq prmpt nil)
        )
      )

      (xp_xfa)

      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nObjects ")
            (princ "\nObject ")
          )
          (princ (strcat "exploded onto layer " layer ".")) 
        )
      )
    )
    ((= typ "LType")
      (if prmpt
        (progn
          (setq color (getvar "cecolor"))
          (setq ltype (xp_slt))
          (setq layer (getvar "clayer"))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nObjects ")
            (princ "\nObject ")
          )
	  ; localization fix 
          (princ (strcat "exploded with linetype of "
                  (en_loc_type ltype) ".")) 
        )
      )
    )
    ((= typ "Inherit")
      (xp_iap ent)
    )
    (T
      (command "_.EXPLODE" (xp_val -1 ent nil))  ; explode
    )
  )
)
;;;
;;; Force the color, linetype and layer attributes after exploding.
;;;
;;; xp_xea == XPlode_Xplode_Force_All
;;;
(defun xp_xfa ()

  (setq e0 (entlast))
  (setq en (entnext e0))
  (while (not (null en))              ; find the last entity              
    (setq e0 en)
    (setq en (entnext e0))
  ) 

  (command "_.EXPLODE" (xp_val -1 ent nil))  ; explode


  (setq s0 (ssadd))
  
  (while (entnext e0) 
    (ssadd (setq e0 (entnext e0))
           s0
    )
  )
  (command "_.CHPROP" s0 ""             ; change entities to the proper layer
           "_C"  color                 ; color, and linetype, regardless
           "_LT" ltype                 ; of their extrusion direction
           "_LA" layer
           ""
  )
)
;;;
;;; Inherit attributes (if BYBLOCK) from parent.
;;;
;;; xp_iap == XPlode_Inherit_Attributes_from_Parent
;;;
(defun xp_iap (t1 / t1cl t1lt t1ly s0ly s0lt s0cl t0e)
  (setq yyy t1)
  (setq t0 (entlast))
  (setq tn (entnext t0))
  (while (not (null tn))              ; find the last entity              
    (setq t0 tn)
    (setq tn (entnext t0))
  ) 
      
  (setq t1cl (xp_val 62 t1 nil))      ; record the attributes of the block
  (setq t1lt (xp_val 6  t1 nil))
  (setq t1ly (xp_val 8  t1 nil))
  (command "_.EXPLODE" (xp_val -1 ent nil))  ; explode
  (setq s0ly (ssadd))                 ; create nil selection sets for layer
  (setq s0lt (ssadd))                 ; linetype and color changes
  (setq s0cl (ssadd))
  (setq t0 (entnext t0))
  (while t0                           ; can exploded entities
    (setq t0e (entget t0))            ; and build selection sets
    
    (if (=  (xp_val 62 t0e T) "BYBLOCK") (ssadd t0 s0cl))
    (if (=  (xp_val 6  t0e T) "BYBLOCK") (ssadd t0 s0lt))
    (if (=  (xp_val 8  t0e T) "0")       (ssadd t0 s0ly))
    (setq t0 (entnext t0))
  )
  (if (> (sslength s0cl) 0)           ; is selection set non-nil...
      (command "_.CHPROP" s0cl ""       ; Change exploded entities with color
               "_CO" t1cl "")          ; BYBLOCK to color of old block
  )
  (if (> (sslength s0lt) 0)
      (command "_.CHPROP" s0lt ""       ; Change exploded entities with linetype
               "_LT" t1lt "")          ; BYBLOCK to linetype of old block
  )
  (if (> (sslength s0ly) 0)
      (command "_.CHPROP" s0ly ""       ; Change exploded entities with linetype
               "_LA" t1ly "")          ; BYBLOCK to linetype of old block
  )
  (if (or (= ans "Individually") (= j (1- sslen)))
    (progn
      (if (and (> sslen 1) (= ans "Globally"))
        (princ "\nObjects ")
        (princ "\nObject ")
      )
      (princ "exploded.") 
    )
  )
)

;;;
;;; Set the color for the exploded entities.
;;;
;;; xp_scn == XPlode_Set_Color_Number
;;;
(defun xp_scn ()
  (setq arg 257)
  (while (> arg 256)
    (initget 2 "Red Yellow Green Cyan Blue Magenta White BYLayer BYBlock")
    (setq arg (getint (strcat
      "\n\nNew color for exploded objects."
      "\nRed/Yellow/Green/Cyan/Blue/Magenta/White/BYLayer/BYBlock <"
      (if (= (type (getvar "cecolor")) 'INT)
        (itoa (getvar "cecolor")) 
        (en_loc_type (getvar "cecolor")) ;display the translated term 
      ) 
      ">: ")))
    (cond
      ((= arg "BYBlock") (setq arg 0))
      ((= arg "Red")     (setq arg 1))
      ((= arg "Yellow")  (setq arg 2))
      ((= arg "Green")   (setq arg 3))
      ((= arg "Cyan")    (setq arg 4))
      ((= arg "Blue")    (setq arg 5))
      ((= arg "Magenta") (setq arg 6))
      ((= arg "White")   (setq arg 7))
      ((= arg "BYLayer") (setq arg 256))
      (T
        (if (= (type arg) 'INT)
          (if (> arg 255)
            (progn
              (princ "\nColor number out of range 1 - 255. ")
              (setq arg 257) ; kludge
            )
          )
          (setq arg (if (= (type (setq arg (getvar "cecolor"))) 'INT)
                      (getvar "cecolor") 
                      (cond
                        ((= arg "BYBLOCK") (setq arg 0))
                        ((= arg "BYLAYER") (setq arg 256))
                      )
                    )
          )
        )
      )
    )
  )
  (cond
    ((= arg 0) (setq arg "BYBLOCK"))
    ((= arg 256) (setq arg "BYLAYER"))
  )

  arg
)
;;;
;;; Set the linetype from the loaded linetypes.
;;;
;;; xp_slt == XPlode_Set_Line_Type
;;;
(defun xp_slt (/ temp)
  (while (null temp)
    (initget 1)
    (setq temp (strcase (getstring (strcat 
    "\nEnter new linetype name. <" (en_loc_type(getvar "celtype")) "> : ") )))
    ; Strip the underscore away
    (if (equal "_" (substr temp 1 1)) (setq temp (substr temp 2)))
    (if (or (= temp "") (null temp))
      (setq temp (en_loc_type (getvar "celtype")))
      (if (not (or (tblsearch "ltype" (loc_en_type temp)) 
                   (= temp "BYBLOCK") 
                   (= temp "BYLAYER")
                   (= temp "CONTINUOUS")
          ))
        (progn
          (princ "\nInvalid linetype name.")
          (setq temp nil)
        )
      )
    )
  )
  temp
)

;;;
;;; Set a layer if it exists.
;;;
;;; xp_sla == XPlode_Set_LAyer
;;;
(defun xp_sla (/ temp)
  (while (null temp)
    (initget 1)
    (setq temp (getstring (strcat
      "\n\nXPlode onto what layer? <" (getvar "clayer") ">: ")))
    (if (or (= temp "") (null temp))
      (setq temp (getvar "clayer"))
      (if (not (tblsearch "layer" temp))
        (progn
          (princ "\nInvalid layer name. ")
          (setq temp nil)
        )
      )
    )
  )
  temp
)

;; Localization fix
;; the function returns the translated and UPPERCASED name
;;
(defun en_loc_type (type / trans)
  (setq trans type)
  
  (if (= (strcase trans) "BYLAYER") (setq trans (strcase "BYLayer"))
      (if (= (strcase trans) "BYBLOCK") (setq trans (strcase "BYBlock")))
  )
  trans
)

;; Localization fix
;; The function returns the english no localized term
;;
(defun loc_en_type (type / trans )
  (setq trans type)
  (if (= (strcase type) (strcase "BYLayer"))
      (setq trans ;|MSG0|;"BYLAYER")
      (if (= (strcase type) (strcase "BYBlock"))
          (setq trans ;|MSG0|;"BYBLOCK")
      )
  )
  trans
)

 (setq wrong 0
       pai 3.141592653589
       have_not_done (list nil)
       global_inters_list nil
       global_check_point1 nil
       global_check_point2 nil
       layer_list nil
  )
 (setvar "snapmode" 0) ;Turn snap off
 (setvar "orthomode" 0) ;Turn ? off
 (setvar "cmdecho" 0) ;Turn cmdecho off

