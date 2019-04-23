					;设置系统变量
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)
					;reset system variable
(defun reset_var (var_list)
  (setvar "osmode" (car var_list))
  (setvar "orthomode" (cadr var_list))
)
					;read value
(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
					;convert polyline to lwpolyline
(defun pl2lwpl ()
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 0 "POLYLINE"))
     )
  )
  (if polyline_ss
    (progn
      (command "convert" "a" "a")
    )
  )
  (setq polyline_ss nil)
)
(defun line_length (line_detail)
  (distance (get_dt_vl 10 line_detail)
	    (get_dt_vl 11 line_detail)
  )
)
(defun kill_dbc	(layer_name)
  (setq Deta 0.0001)
  (setq vir_eqal 0.000000001)
  (setq
    arc_ss
     (ssget "X"
	    (list (cons 0 "ARC") (cons 8 layer_name))
     )
  )
  (if arc_ss
    (progn
      (setq total (sslength arc_ss))
      (setq count 0)
      (while (< count (- total 1))
	(setq arc_name (ssname arc_ss count))
	(setq arc_detail (entget arc_name))
	(setq center_p (get_dt_vl 10 arc_detail))
	(setq arc_R (get_dt_vl 40 arc_detail))
	(setq start_agl (get_dt_vl 50 arc_detail))
	(setq end_agl (get_dt_vl 51 arc_detail))
	(setq center_X (car center_p)
	      center_y (cadr center_P)
	)
	(setq p_a
	       (list
		 (- center_x (+ arc_r deta))
		 (- center_y (+ arc_r deta))
	       )
	)
	(setq
	  p_b
	   (list
	     (+ center_x (+ arc_r deta))
	     (- center_y (+ arc_r deta))
	   )
	)
	(setq
	  p_c
	   (list
	     (+ center_x (+ arc_r deta))
	     (+ center_y (+ arc_r deta))
	   )
	)
	(setq
	  p_d
	   (list
	     (- center_x (+ arc_r deta))
	     (+ center_y (+ arc_r deta))
	   )
	)
	(setq pt_list (list p_a p_b p_c p_d))
	(setq dbc_ss (ssget "WP"
			    pt_list
			    (list (cons 0 "arc") (cons 8 Layer_name))
		     )
	)
	(if dbc_ss
	  (progn
	    (setq dbc_total (sslength dbc_ss))
	    (setq dbc_cnt 0)
	    (setq keep_flage 0)
	    (if	(> dbc_total 1)
	      (progn
		(while (<= dbc_cnt (- dbc_total 1))
		  (setq dbc_name1 (ssname dbc_ss dbc_cnt))
		  (setq dbc_detail1 (entget dbc_name1))
		  (setq center_p1 (get_dt_vl 10 dbc_detail1))
		  (setq arc_R1 (get_dt_vl 40 dbc_detail1))
		  (setq start_agl1 (get_dt_vl 50 dbc_detail1))
		  (setq end_agl1 (get_dt_vl 51 dbc_detail1))
		  (setq	center_X1 (car center_p1)
			center_y1 (cadr center_P1)
		  )
		  (if (and
			(< (abs (- arc_r arc_r1)) vir_eqal)
			(< (abs (- start_agl start_agl1)) vir_eqal)
			(< (abs (- end_agl end_agl1)) vir_eqal)
			(< (abs (- center_x center_x1)) vir_eqal)
			(< (abs (- center_y center_y1)) vir_eqal)
		      )
		    (progn
		      (if (= keep_flage 0)
			(progn
			  (setq keep_flage 1)
			)
			(progn
			  (setq
			    ed
			     (subst (cons 8 "dbl")
				    (cons 8 layer_name)
				    dbc_detail1
			     )
			  )
			  (entmod ed)
			)
		      )
		    )
		  )
		  (setq dbc_cnt (+ dbc_cnt 1))
		)
	      )
	    )
	  )
	)
	(setq count (+ count 1))
      )
    )
  )
)

(defun kill_dbr	(layer_name)		;check double circle
  (setq Deta 0.0001)
  (setq vir_eqal 0.000000001)
  (setq
    circle_ss
     (ssget "X"
	    (list (cons 0 "circle") (cons 8 layer_name))
     )
  )
  (if circle_ss
    (progn
      (setq total (sslength circle_ss))
      (setq count 0)
      (while (< count (- total 1))
	(setq circle_name (ssname circle_ss count))
	(setq circle_detail (entget circle_name))
	(setq center_p (get_dt_vl 10 circle_detail))
	(setq circle_R (get_dt_vl 40 circle_detail))
	(setq center_X (car center_P)
	      center_y (cadr center_P)
	)
	(setq p_a
	       (list
		 (- center_x (+ circle_r deta))
		 (- center_y (+ circle_r deta))
	       )
	)
	(setq
	  p_b
	   (list
	     (+ center_x (+ circle_r deta))
	     (- center_y (+ circle_r deta))
	   )
	)
	(setq
	  p_c
	   (list
	     (+ center_x (+ circle_r deta))
	     (+ center_y (+ circle_r deta))
	   )
	)
	(setq
	  p_d
	   (list
	     (- center_x (+ circle_r deta))
	     (+ center_y (+ circle_r deta))
	   )
	)
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbr_ss (ssget	"WP"
			pt_list
			(list (cons 0 "circle") (cons 8 Layer_name))
		 )
	)
	(if dbr_ss
	  (progn
	    (setq dbr_total (sslength dbr_ss))
	    (setq dbr_cnt 0)
	    (setq keep_flage 0)
	    (if	(> dbr_total 1)
	      (progn
		(while (<= dbr_cnt (- dbr_total 1))
		  (setq dbr_name1 (ssname dbr_ss dbr_cnt))
		  (setq dbr_detail1 (entget dbr_name1))
		  (setq center_p1 (get_dt_vl 10 dbr_detail1))
		  (setq circle_R1 (get_dt_vl 40 dbr_detail1))
		  (setq	center_X1 (car center_p1)
			center_y1 (cadr center_P1)
		  )
		  (if (and
			(< (abs (- circle_r circle_r1)) vir_eqal)
			(< (abs (- center_x center_x1)) vir_eqal)
			(< (abs (- center_y center_y1)) vir_eqal)
		      )
		    (progn
		      (if (= keep_flage 0)
			(progn
			  (setq keep_flage 1)
			)
			(progn
			  (setq
			    ed
			     (subst (cons 8 "dbl")
				    (cons 8 layer_name)
				    dbr_detail1
			     )
			  )
			  (entmod ed)
			)
		      )
		    )
		  )
		  (setq dbr_cnt (+ dbr_cnt 1))
		)
	      )
	    )
	  )
	)
	(setq count (+ count 1))
      )
    )
  )
)

					;check double line

(defun kill_dbl	(layer_name)
  (setq K_length 0.0001)
  (setq Deta 0.0001)
  (setq vir_eqal 0.000000001)
  (setq
    line_ss
     (ssget "X"
	    (list (cons 0 "LINE") (cons 8 layer_name))
     )
  )
  (if line_ss
    (progn
      (setq total (sslength line_ss))
      (setq count 0)
      (while (< count (- total 1))
	(setq line_name (ssname line_ss count))
	(setq line_detail (entget line_name))
	(setq length_val (line_length line_detail))
	(setq x0 (car (get_dt_vl 10 line_detail)))
	(setq y0 (cadr (get_dt_vl 10 line_detail)))
	(setq x1 (car (get_dt_vl 11 line_detail)))
	(setq y1 (cadr (get_dt_vl 11 line_detail)))
	(setq arf (angle (get_dt_vl 10 line_detail)
			 (get_dt_vl 11 line_detail)
		  )
	)
	(setq x0 (- x0 (* Deta (cos arf))))
	(setq y0 (- y0 (* Deta (sin arf))))
	(setq x1 (+ x1 (* Deta (cos arf))))
	(setq y1 (+ y1 (* Deta (sin arf))))
	(setq p_a
	       (list
		 (- x0 (* k_length (sin arf)))
		 (+ y0 (* k_length (cos arf)))
	       )
	)
	(setq p_b
	       (list
		 (+ x0 (* k_length (sin arf)))
		 (- y0 (* k_length (cos arf)))
	       )
	)
	(setq p_c
	       (list
		 (+ x1 (* k_length (sin arf)))
		 (- y1 (* k_length (cos arf)))
	       )
	)
	(setq p_d
	       (list
		 (- x1 (* k_length (sin arf)))
		 (+ y1 (* k_length (cos arf)))
	       )
	)
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
	(if dbl_ss
	  (progn
	    (setq dbl_total (sslength dbl_ss))
	    (setq dbl_cnt 0)
	    (setq keep_flage 0)
	    (if	(> dbl_total 1)
	      (progn
		(while (<= dbl_cnt (- dbl_total 1))
		  (setq dbl_name (ssname dbl_ss dbl_cnt))
		  (setq dbl_detail (entget dbl_name))
		  (if (and (= length_val (line_length dbl_detail))
			   (= keep_flage 0)
		      )
		    (progn
		      (setq keep_flage (+ keep_flage 1))
		      (setq
			    ed
			     (subst (cons 8 "dbl")
				    (cons 8 layer_name)
				    dbl_detail
			     )
			  )
		      (setq first_dt ed)
		    )
		    (progn
		      (if (= length_val (line_length dbl_detail))
			(progn
			  (setq keep_flage (+ keep_flage 1))
			  (setq
			    ed
			     (subst (cons 8 "dbl")
				    (cons 8 layer_name)
				    dbl_detail
			     )
			  )
			  (entmod ed)
			)
		      )
		    )
		  )
		  (setq dbl_cnt (+ dbl_cnt 1))
		)
		(if (> keep_flage 1)
		  (entmod first_dt)
		  )
	      )
	    )
	  )
	)
	(setq count (+ count 1))
      )
    )
  )
)

(defun init_layer (layer_name)
  (command "layer"    "T"	 layer_name "ON"       layer_name
	   "U"	      layer_name "M"	    layer_name ""
	  )
  (setq layer_detail (tblnext "LAYER" T))
  (while layer_detail
    (setq l_name (get_dt_vl 2 layer_detail))
    (if	(and (/= l_name layer_name)
	     (/= l_name "DBL")
	)
      (command "layer" "F" l_name "")
    )
    (setq layer_detail (tblnext "LAYER"))
  )
  (command "layer" "F" "DBL" "")
  (command "zoom" "e" "")
  (command "layer" "T" "DBL" "")
)
(defun reset_layer ()
  (setq layer_detail (tblnext "LAYER" T))
  (setq layer_name (get_dt_vl 2 layer_detail))
  (while layer_detail
    (command "layer" "T" layer_name "")
    (setq layer_detail (tblnext "LAYER"))
    (setq layer_name (get_dt_vl 2 layer_detail))
  )
  (command "layer" "M" "0" "")
)

(defun c:del_cut	()
  (reset_layer)
  (pl2lwpl)
  (setq var_list (set_var))
  (setq	layer_name
	 (strcase (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (if found
    (progn
      (init_layer layer_name)
      ;(kdc_check layer_name)
      ;kdo_check layer_name)
      (kill_dbl layer_name)
      ;(kill_dbc layer_name)
      ;(kill_dbr layer_name)
      (reset_layer)
    )
    (progn
      (setq layer_name_lst nil)
      (setq layer_name (cdadr (tblnext "LAYER" T)))
      (while layer_name
	(setq layer_name_lst
	       (append layer_name_lst (list layer_name))
	)
	(setq layer_name (cdadr (tblnext "LAYER")))
      )
      (setq I_th 0)
      (setq layer_name (nth i_th layer_name_lst))
      (while layer_name
	(if (/= layer_name "DBL")
	  (progn
	    (init_layer layer_name)
	    ;(kdc_check layer_name)
	    ;(kdo_check layer_name)
	    (kill_dbl layer_name)
	    ;(kill_dbc layer_name)
	    ;(kill_dbr layer_name)
	    (reset_layer)
	  )
	)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
    )
  )
  (command "zoom" "e" "")
  (reset_var var_list)
)
					;将无重线的POLYLINE放入dbl_tmp, 有重线的POLYLINE EXPLODE
(defun kdo_check (layer_name)

  (setq
    pl_ss
     (ssget "X"
	    (list (cons 0 "lwPOLYLINE")
		  (cons 8 layer_name)
		  (cons 41 0.0)
		  (cons 70 0)
	    )
     )
  )
  (if pl_ss
    (progn
      (setq total (sslength pl_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname pl_ss count))
	(setq pl_detail (entget ent_name))
					;(setq num )
	(setq No_th 12)
	(setq num (get_dt_vl 90 pl_detail))
	(setq v_list nil)
	(if (= (cdr (nth 7 pl_detail)) "AcDbPolyline")
	  (progn
	    (setq No_th 13)
	  )
	)
					;get vitrex list
	(repeat	num
	  (setq	v_piont	(list
			  (list	(cdr (nth No_th pl_detail))
				(nth (+ No_th 3) pl_detail)
			  )
			)
	  )
	  (setq v_list (append v_list v_piont))
	  (setq No_th (+ No_th 4))
	)
					;judge double line
	(setq this_pnt (car (car v_list)))
	(setq bulge1 (cdar (cdar v_list)))
	(setq next_pnt (car (nth 1 v_list)))
	(setq bulge2 (cdadr (nth 1 v_list)))
	(setq 3ird_pnt (car (nth 2 v_list)))
	(setq bulge3 (cdadr (nth 2 v_list)))
	(setq Ptr 2)
					;(setq flage 0)
	(if (= num 2)
	  (progn
	    (command "explode" ent_name "")
					;(setq flage 1)
	  )
	)
	(repeat	(- num 2)
	  (setq agl1 (angle this_pnt next_pnt))
	  (setq agl2 (angle next_pnt 3ird_pnt))
	  (if (and (< (abs (- (abs (- agl1 agl2)) pi)) vir_eqal)
		   (< (abs (+ bulge2 bulge1)) vir_eqal)
	      )
	    (progn
	      (command "explode" ent_name "")
					;(setq flage 1)
	    )
	  )
	  (setq Ptr (+ Ptr 1))
	  (setq this_pnt next_pnt)
	  (setq bulge1 bulge2)
	  (setq next_pnt 3ird_pnt)
	  (setq bulge2 bulge3)
	  (setq 3ird_pnt (car (nth Ptr v_list)))
	  (setq bulge3 (cdadr (nth Ptr v_list)))
	)
					;(if (= flage 0)
					; (progn
					;    (setq ed (subst (cons 8 "dbl_tmp")
					;		    (cons 8 (CDR (NTH 5 pl_detail)))
					;		    pl_detail
					;	     )
					;    )
					;    (entmod ed)
					;  )
					;)
					;add loop var
	(setq count (+ count 1))
      )
    )
  )
  (setq pl_ss nil)
)
(defun kdc_check (layer_name)		; 将闭合的POLYLINE中的重线挑出放入DBL层

  (setq
    pl_ss
     (ssget "X"
	    (list (cons 0 "lwPOLYLINE")
		  (cons 8 layer_name)
		  (cons 41 0.0)
		  (cons 70 1)
	    )
     )
  )
  (if pl_ss
    (progn
      (setq total (sslength pl_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname pl_ss count))
	(setq pl_detail (entget ent_name))
					;(setq num )
	(setq No_th 12)
	(setq num (get_dt_vl 90 pl_detail))
	(setq v_list nil)
	(if (= (cdr (nth 7 pl_detail)) "AcDbPolyline")
	  (progn
	    (setq No_th 13)
	  )
	)
					;get vitrex list
	(repeat	num
	  (setq	v_piont	(list
			  (list	(cdr (nth No_th pl_detail))
				(nth (+ No_th 3) pl_detail)
			  )
			)
	  )
	  (setq v_list (append v_list v_piont))
	  (setq No_th (+ No_th 4))
	)
					;judge double line
	(setq this_pnt (car (car v_list)))
	(setq p1 this_pnt)
	(setq bulge1 (cdar (cdar v_list)))
	(setq b1 bulge1)
	(setq next_pnt (car (nth 1 v_list)))
	(setq p2 next_pnt)
	(setq bulge2 (cdadr (nth 1 v_list)))
	(setq b2 bulge2)
	(setq 3ird_pnt (car (nth 2 v_list)))
	(setq bulge3 (cdadr (nth 2 v_list)))
	(setq Ptr 2)
					;(setq flage 0)
	(if (= num 2)
	  (progn
	    (command "explode" ent_name "")
					;(setq flage 1)
	  )
	)
	(repeat	(- num 2)
	  (setq agl1 (angle this_pnt next_pnt))
	  (setq agl2 (angle next_pnt 3ird_pnt))
	  (if (and (< (abs (- (abs (- agl1 agl2)) pi)) vir_eqal)
		   (< (abs (+ bulge2 bulge1)) vir_eqal)
	      )
	    (progn
	      (command "explode" ent_name "")

	    )
	  )
	  (setq Ptr (+ Ptr 1))
	  (setq this_pnt next_pnt)
	  (setq bulge1 bulge2)
	  (setq next_pnt 3ird_pnt)
	  (setq bulge2 bulge3)
	  (setq 3ird_pnt (car (nth Ptr v_list)))
	  (setq bulge3 (cdadr (nth Ptr v_list)))
	)
	(setq 3ird_pnt p1)
	(setq bulge3 b1)
	(setq agl1 (angle this_pnt next_pnt))
	(setq agl2 (angle next_pnt 3ird_pnt))
	(if (and (< (abs (- (abs (- agl1 agl2)) pi)) vir_eqal)
		 (< (abs (+ bulge2 bulge1)) vir_eqal)
	    )
	  (progn
	    (command "explode" ent_name "")

	  )
	)
	(setq this_pnt next_pnt)
	(setq bulge1 bulge2)
	(setq next_pnt 3ird_pnt)
	(setq bulge2 bulge3)
	(setq 3ird_pnt p2)
	(setq bulge3 b2)
	(setq agl1 (angle this_pnt next_pnt))
	(setq agl2 (angle next_pnt 3ird_pnt))
	(if (and (< (abs (- (abs (- agl1 agl2)) pi)) vir_eqal)
		 (< (abs (+ bulge2 bulge1)) vir_eqal)
	    )
	  (progn
	    (command "explode" ent_name "")

	  )
	)
	(setq count (+ count 1))
      )
    )
  )
  (setq pl_ss nil)
)
(prompt "\n input 'del_cut' to run")
