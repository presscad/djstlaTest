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
  (command "zoom" "e")
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

(defun pl2lwpl ()
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 0 "POLYLINE")(cons 41 0))
     )
  )
  (if polyline_ss
    (progn
      (command "convert" "a" "a")
    )
  )
  (setq polyline_ss nil)
)
(defun chg_color ()
  (setq obj_ss (ssget "x" (list (cons -4 "/=") (cons 62 256))))
  (if obj_ss
    (command "change" obj_ss "" "p" "c" "bylayer" "")
  )
)

(defun c:join ()
  (setq vs_cnct 0.0001)
  (reset_layer)
  (chg_color)
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

      (l2pl layer_name)
      (a2pl layer_name)
      (cls_pl layer_name)
      (fix_pl layer_name)

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
	(if (/= layer_name "PROBLEM")
	  (progn
	    (init_layer layer_name)
	    (l2pl layer_name)
	    (a2pl layer_name)
	    (cls_pl layer_name)
	    (fix_pl layer_name)
	    (reset_layer)
	  )
	)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
    )
  )
  (command "zoom" "e")
  (reset_var var_list)
)

(defun l2pl (layer_name)
  (setq w_width 0.0001)
  (setq line_ss (ssget "X" (list (cons 0 "LINE") (cons 8 layer_name))))
  (if line_ss
    (progn
      (setq total (sslength line_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname line_ss count))
	(setq line_detail (entget ent_name))
	(if line_detail
	  (progn
	    (setq end_point (get_dt_vl 11 line_detail))
	    (setq e_p_x (car end_point))
	    (setq e_p_Y (cadr end_point))
	    (setq e_w_rd (list (+ e_p_x w_width) (- e_p_y w_width)))
	    (setq e_w_lu (list (- e_p_x w_width) (+ e_p_y w_width)))
	    (setq e_ss (ssget "c" e_w_rd e_w_lU))
	    (command "pedit" ent_name "Y" "J" e_ss "" "X")
	  )
	)
	(setq count (1+ count))
      )
    )
  )
)
(defun a2pl (layer_name)
  (setq w_width 0.0001)
  (setq arc_ss (ssget "X" (list (cons 0 "ARC") (cons 8 layer_name))))
  (if arc_ss
    (progn
      (setq total (sslength arc_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname arc_ss count))
	(setq arc_detail (entget ent_name))
	(if arc_detail
	  (progn
	    (setq center_point (get_dt_vl 10 arc_detail))
	    (setq R_var (get_dt_vl 40 arc_detail))
	    (setq end_agl (get_dt_vl 51 arc_detail))
	    (setq c_P_x (car center_point))
	    (setq c_p_Y (cadr center_point))
	    (setq e_p_x (+ c_p_x (* R_var (cos end_agl))))
	    (setq e_p_y (+ c_p_y (* R_var (sin end_agl))))
	    (setq e_w_rd (list (+ e_p_x w_width) (- e_p_y w_width)))
	    (setq e_w_lu (list (- e_p_x w_width) (+ e_p_y w_width)))
	    (setq e_ss (ssget "c" e_w_rd e_w_lU))
	    (command "pedit" ent_name "Y" "J" e_ss "" "X")
	  )
	)
	(setq count (1+ count))
      )
    )
  )
)

(defun cls_pl (layer_name)
  (setq pl_cnt 0)
  (setq wch_end T)
  (setq repeat_cnt 0)
  (while (< repeat_cnt 1)
    (setq last_cnt (join_pl layer_name wch_end))
    (if	(/= pl_cnt last_cnt)
      (setq pl_cnt last_cnt)
      (setq repeat_cnt (+ repeat_cnt 1))
    )
  )
  (setq pl_cnt 0)
  (setq wch_end nil)
  (setq repeat_cnt 0)
  (while (< repeat_cnt 1)
    (setq last_cnt (join_pl layer_name wch_end))
    (if	(/= pl_cnt last_cnt)
      (setq pl_cnt last_cnt)
      (setq repeat_cnt (+ repeat_cnt 1))
    )
  )
)

(defun join_pl (layer_name wch_end)
  (setq w_width 0.001)
  (setq	pl_ss
	 (ssget
	   "X"
	   (list (cons 0 "LWPOLYLINE") (cons 8 layer_name) (cons 41 0) (cons 70 0))
	 )
  )
  (if pl_ss
    (progn
      (setq total (sslength pl_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname pl_ss count))
	(setq pl_detail (entget ent_name))
	(if pl_detail
	  (progn
	    (if	wch_end
	      (progn
		(setq first_point (get_dt_vl 10 pl_detail))
		(setq e_p_x (car first_point))
		(setq e_p_Y (cadr first_point))
	      )
	      (progn
		(setq list_len (length pl_detail))
		(setq last_point (cdr (nth (- list_len 5) pl_detail)))
		(setq e_p_x (car last_point))
		(setq e_p_Y (cadr last_point))
	      )
	    )
	    (setq e_w_rd (list (+ e_p_x w_width) (- e_p_y w_width) 0.0))
	    (setq e_w_lu (list (- e_p_x w_width) (+ e_p_y w_width) 0.0))
	    (setq e_ss (ssget "C" e_w_rd e_w_lu))
	    (if	(not e_ss)
	      (prompt "nil")
	      (command "pedit" ent_name "J" e_ss "" "X")
	    )
	  )
	)
	(setq count (1+ count))
      )
    )
  )
)

(defun fix_pl (layer_name)
  (setq	pl_ss
	 (ssget
	   "X"
	   (list (cons 0 "LWPOLYLINE") (cons 8 layer_name) (cons 41 0) (cons 70 0))
	 )
  )
  (while
    pl_ss
     (setq total (sslength pl_ss))
     (setq count 0)
     (while (< count total)
       (setq ent_name (ssname pl_ss count))
       (setq pl_detail (entget ent_name))
       (if pl_detail
	 (progn
	   (setq first_point (get_dt_vl 10 pl_detail))
	   (setq first_bulge (get_dt_vl 42 pl_detail))
	   (setq f_p_x (car first_point))
	   (setq f_p_Y (cadr first_point))
	   (setq list_len (length pl_detail))
	   (setq last_point (cdr (nth (- list_len 5) pl_detail)))
	   (setq last_bulge (cdr (nth (- list_len 6) pl_detail)))
	   (setq l_p_x (car last_point))
	   (setq l_p_Y (cadr last_point))
	   (if (and (> (distance first_point last_point) 0.0001)
		    (< (distance first_point last_point) 0.1))
	     (progn

	       (setq
		 z_w_rd	(list
			  (+ (max f_P_x l_p_x) (abs (- f_p_x l_p_x)))
			  (- (min f_P_y l_p_y) (abs (- f_p_y l_p_y)))
			)
	       )
	       (setq
		 z_w_lu	(list
			  (- (min f_P_x l_p_x) (abs (- f_p_x l_p_x)))
			  (+ (max f_P_y l_p_y) (abs (- f_p_y l_p_y)))
			)
	       )
	     )
	     (progn
	       (setq z_w_rd (list
			      (+ f_P_x 0.001)
			      (- f_P_y 0.001)
			    )
	       )
	       (setq z_w_lu (list
			      (- f_P_x 0.001)
			      (+ f_P_y 0.001)
			    )
	       )
	     )
	   )
	   (setq layer_color
		  (get_dt_vl 62 (tblsearch "layer" layer_name))
	   )
	   (if (<= layer_color 8)
	     (setq
	       ed (append pl_detail (list (cons 62 (+ layer_color 1))))
	     )
	     (setq ed
		    (append pl_detail (list (cons 62 (- 256 layer_color))))
	     )
	   )
	   (entmod ed)
	   (command "zoom" "w" z_w_rd z_w_lu)
	   (prompt
	     "\n 不能闭合：加线（A），延长（L），删除（E），放入PROMBLEM层（P）连接（J）？"
	   )
	   (setq action (strcase (getstring)))
	   (while (and
		    (/= action "A")
		    (/= action "L")
		    (/= action "E")
		    (/= action "P")
		    (/= action "J")
		  )
	     (if (= action "")
	       (z_tow_pt first_point last_point)
	     )
	     (prompt
	       "\n 不能闭合：加线（A），延长（L），删除（E），放入PROMBLEM层（P）连接（J）？"
	     )
	     (setq action (strcase (getstring)))
	   )
	   (cond
	     ((= action "A")
	      (command "pedit" ent_name "C" "X")
	      (prompt "\n是否正确?取消操作键入（C）")
	      (setq OK_STR (strcase (getstring)))
	      (if (= ok_str "C")
		(progn
		  (command "u")
		  (setq ok_str nil)
		  )		
	      )
	     )
	     ((= action "L")
	      (progn
		(setq lst_scd_point (cdr (nth (- list_len 9) pl_detail)))
		(setq scd_point
		       (get_dt_vl
			 10
			 (cdr
			   (member (cons 10 first_point) pl_detail)
			 )
		       )
		)
		(pl_join_single
		  	first_point
			scd_point
			first_bulge
			last_point
			lst_scd_point
			last_bulge
			pl_detail
			      )
	      )
	     )
	     ((= action "E")
	      (progn
		(command "erase" ent_name "")
		(prompt "\n是否正确?取消操作键入（C）")
		(setq OK_STR (strcase (getstring)))
		(if (= ok_str "C")
		  (progn
		  (command "u")
		  (setq ok_str nil)
		  )
		)
	      )
	     )
	     ((= action "P")
	      (progn
		(setq ed (subst	(cons 8 "PROBLEM")
				(cons 8 layer_name)
				pl_detail
			 )
		)
		(entmod ed)
	      )
	     )
	     ((= action "J")
	      (progn
		(prompt "\n请先取一条线！")
		(setq pl_ss1 (ssget))
		(setq ent_name1 (ssname pl_ss1 0))
		(setq pl_detail1 (entget ent_name1))
		(if pl_detail1
		  (progn
		    (setq lst_scd_point
			   (cdr (nth (- list_len 9) pl_detail))
		    )
		    (setq
		      scd_point	(get_dt_vl
				  10
				  (cdr (member (cons 10 first_point)
					       pl_detail
				       )
				  )
				)
		    )
		    (setq first_point1 (get_dt_vl 10 pl_detail1))
		    (setq first_bulge1 (get_dt_vl 42 pl_detail1))
		    (setq list_len1 (length pl_detail1))
		    (setq last_point1
			   (cdr	(nth (- list_len1 5) pl_detail1)
			   )
		    )
		    (setq last_bulge1
			   (cdr (nth (- list_len1 2) pl_detail1))
		    )
		    (setq lst_scd_point1
			   (cdr	(nth (- list_len1 9)
				     pl_detail1
				)
			   )
		    )
		    (setq scd_point1
			   (get_dt_vl
			     10
			     (cdr (member (cons 10 first_point1)
					  pl_detail1
				  )
			     )
			   )
		    )
		  )
		)			;if
		(setq d1 (distance first_point first_point1))
		(setq d2 (distance first_point last_point1))
		(setq d3 (distance last_point first_point1))
		(setq d4 (distance last_point last_point1))
		(setq d0 (min d1 d2 d3 d4))
		(cond
		  ((= d0 d1)
		   (z_tow_pt first_point first_point1)
		   (pl_join
		     first_point     scd_point	     first_bulge
		     first_point1    scd_point1	     first_bulge1
		     pl_detail	     pl_detail1
		    )
		  )
		  ((= d0 d2)
		   (z_tow_pt first_point last_point1)
		   (pl_join
		     first_point      scd_point	       first_bulge
		     last_point1      lst_scd_point1   last_bulge1
		     pl_detail	      pl_detail1
		    )
		   
		  )
		  ((= d0 d3)
		   (z_tow_pt last_point first_point1)
		   (pl_join
		     last_point	      lst_scd_point    last_bulge
		     first_point1     scd_point1       first_bulge1
		     pl_detail	      pl_detail1
		    )
		  )
		  ((= d0 d4)
		   (z_tow_pt last_point last_point1)
		   (pl_join
		     last_point	      lst_scd_point    last_bulge
		     last_point1      lst_scd_point1   last_bulge1
		     pl_detail	      pl_detail1
		    )
		  )
		)
	      )
	     )
	     (T nil)
	   )
	 )
       )
       (command "change" ent_name "" "p" "c" "bylayer" "")
       (setq count (1+ count))
     )
     (setq pl_ss
	    (ssget
	      "X"
	      (list (cons 0 "LWPOLYLINE") (cons 8 layer_name)(cons 41 0) (cons 70 0))
	    )
     )
  )

)
;;将两条线从指定的端点延长取交点
(defun pl_join (pa1 pa2 bga pb1 pb2 bgb pda pdb)
  ;;两条端点的线都为直线

  (if (and (= bga 0)
	   (= bgb 0)
      )
    (progn
      (setq pl_inter (inters pa1 pa2 pb1 pb2 nil))
      (setq enta (get_dt_vl -1 pda))
      (setq entb (get_dt_vl -1 pdb))
      (command "explode" enta "")
      (command "explode" entb "")
      (setq line_a (ssget pa1))
      (setq line_b (ssget pb1))
      (if (= (get_dt_vl 5 (entget (ssname line_a 0)))
	     (get_dt_vl 5 (entget (ssname line_b 0)))
	  )
	    (setq line_b (get_scd_obj pb1 line_a))
      )
      (if (= (get_dt_vl 5 (entget (ssname line_a 0)))
	     (get_dt_vl 5 (entget (ssname line_b 0)))
	  )
	    (setq line_b (get_scd_obj pb1 line_a))
      )
      (if (= (sslength line_a) 1)
	(progn
	  (setq line_a_detail (entget (ssname line_a 0)))
	  (setq st_line_a (get_dt_vl 10 line_a_detail))
	  (setq ed_line_a (get_dt_vl 11 line_a_detail))
;;change the end point to inter point
	  (if (and
		(= (car st_line_a) (car pa1))
		(= (cadr st_line_a) (cadr pa1))
	      )
	    (progn
	      (setq line_a_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	    (progn
	      (setq line_a_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	  )
	)
      )
      (if (= (sslength line_b) 1)
	(progn

	  (setq line_b_detail (entget (ssname line_b 0)))
	  (setq st_line_b (get_dt_vl 10 line_b_detail))
	  (setq ed_line_b (get_dt_vl 11 line_b_detail))
	  (if (and
		(= (car st_line_b) (car pb1))
		(= (cadr st_line_b) (cadr pb1))
	      )
	    (progn
	      (setq line_b_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_b)                            
			    line_b_detail
		     )
	      )
	      (entmod line_b_detail)
	    )
	    (progn
	      (setq line_b_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_b)
			    line_b_detail
		     )
	      )
	      (entmod line_b_detail)
	    )
	  )
	  
	)

      )
      (command "pedit" line_a "Y" "J" "all" "" "X")
    )
  )
    ;;两条端点的线都为弧
  (if (and (/= bga 0)
	   (/= bgb 0)
      )
    (progn
      (setq enta (get_dt_vl -1 pda))
      (setq entb (get_dt_vl -1 pdb))
      (command "explode" enta "")
      (command "explode" entb "")
      (setq arc_a (ssget pa1));;the arc in the polyline a first point
      (setq arc_b (ssget pb1));;the arc in the polyline b first point

      (if (= (get_dt_vl 5 (entget (ssname arc_a 0)))
	     (get_dt_vl 5 (entget (ssname arc_b 0)))
	  )
	    (setq arc_b (get_scd_obj pb1 arc_a))
	  )
      
      (if (= (sslength arc_a) 1);; only one entity cross the point
	(progn
	  (setq arc_a_detail (entget (ssname arc_a 0)))
	  (setq ra (get_dt_vl 40 arc_a_detail));;get radius
	  (setq ctr_a (get_dt_vl 10 arc_a_detail));;get centre 
	  (setq st_agl_a (get_dt_vl 50 arc_a_detail)) ;;get start angle
	  (setq ed_agl_a (get_dt_vl 51 arc_a_detail));;get end angle
	)
      )
      (setq xac (car ctr_a));;arc a centre coordinate x
      (setq yac (cadr ctr_a));;arc a centre coordinate y
	;;get the value of b
      (if (= (sslength arc_b) 1) 
	(progn
	  (setq arc_b_detail (entget (ssname arc_b 0)))
	  (setq rb (get_dt_vl 40 arc_b_detail))
	  (setq ctr_b (get_dt_vl 10 arc_b_detail))
	  (setq st_agl_b (get_dt_vl 50 arc_b_detail))
	  (setq ed_agl_b (get_dt_vl 51 arc_b_detail))
	)
      )
      (setq xbc (car ctr_b))
      (setq ybc (cadr ctr_b))

      (setq ctr_dst (distance ctr_a ctr_b));;the distance centre to centre
      (setq agl_cc (angle ctr_a ctr_b));; angle of line throw the tow centre
	;;get angle between the tow line centre a to centre b and centre a to interpoint
      (setq
	agl_a_cos (/ (- (+ (* ra ra) (* ctr_dst ctr_dst)) (* rb rb))
		     (* 2 (* ra ctr_dst))
		  )
      )
      (if (> (abs agl_a_cos) 0)
	(setq agl_a (atan (sqrt (- (/ 1 (* agl_a_cos agl_a_cos)) 1))))
	(prompt "\n No inter point")
      )
      ;;get tow inter points
      (if (> agl_a 0)
	(progn
	  (setq agl_a0   (+ agl_a agl_cc))
	  (setq inter1_x (+ xac (* ra (cos agl_a0))))
	  (setq inter1_y (+ yac (* ra (sin agl_a0))))
	  (setq agl_a1   (- agl_cc agl_a))
	  (setq inter2_x (+ xac (* ra (cos agl_a1))))
	  (setq inter2_y (+ yac (* ra (sin agl_a1))))
	)
      )
      ;;judge which inter point is right 
      (if (< (distance (list inter1_x inter1_y) pa1)
	     (distance (list inter2_x inter2_y) pa1)
	  )
	(setq pl_inter (list inter1_x inter1_y))
	(setq pl_inter (list inter2_x inter2_y))

      )
      ;;change the arc A to the inter point
      (setq chg_a_agl (angle ctr_a pl_inter))
      (if (< (abs (- chg_a_agl st_agl_a))
	     (abs (- chg_a_agl ed_agl_a))
	  )
	(progn

	  (setq	arc_a_detail
		 (subst	(cons 50 chg_a_agl)
			(cons 50 st_agl_a)
			arc_a_detail
		 )
	  )
	  (entmod arc_a_detail)
	)
	(progn
	  (setq	arc_a_detail
		 (subst	(cons 51 chg_a_agl)
			(cons 51 ed_agl_a)
			arc_a_detail
		 )
	  )
	  (entmod arc_a_detail)
	)
      )
      ;;change the arc B to the inter point      
      (setq chg_b_agl (angle ctr_b pl_inter))
      (if (< (abs (- chg_b_agl st_agl_b))
	     (abs (- chg_b_agl ed_agl_b))
	  )
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 50 chg_b_agl)
			(cons 50 st_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 51 chg_b_agl)
			(cons 51 ed_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
      )
      (command "pedit" arc_a "Y" "J" "all" "" "X");;join
    )
  )
    ;;两条端点的线一条为直线、一条为弧
  (if (and (= bga 0)
	   (/= bgb 0)
      )
    (progn
      (setq enta (get_dt_vl -1 pda))
      (setq entb (get_dt_vl -1 pdb))
      (command "explode" enta "")
      (command "explode" entb "")
      (setq line_a (ssget pa1))
      (setq arc_b (ssget pb1))
      (if (= (get_dt_vl 5 (entget (ssname line_a 0)))
	     (get_dt_vl 5 (entget (ssname arc_b 0)))
	  )
	(progn
	  (if (= (get_dt_vl 0 (entget (ssname line_a 0))) "LINE")
	    (setq arc_b (get_scd_obj pb1 line_a))
	    (setq line_a (get_scd_obj pa1 arc_b))
	  )
	)
      )
      (if (= (sslength line_a) 1)
	(progn
	  (setq line_a_detail (entget (ssname line_a 0)))
	  (setq st_line_a (get_dt_vl 10 line_a_detail))
	  (setq ed_line_a (get_dt_vl 11 line_a_detail))
	)
      )
      (if (= (sslength arc_b) 1)
	(progn
	  (setq arc_b_detail (entget (ssname arc_b 0)))
	  (setq rb (get_dt_vl 40 arc_b_detail))
	  (setq ctr_b (get_dt_vl 10 arc_b_detail))
	  (setq st_agl_b (get_dt_vl 50 arc_b_detail))
	  (setq ed_agl_b (get_dt_vl 51 arc_b_detail))
	)
      )
      (setq line_length (distance st_line_a ed_line_a))
      (setq dist_st_ctr (distance st_line_a ctr_b))
      (setq dist_ed_ctr (distance ed_line_a ctr_b))
      (setq p (/ (+ (+ line_length dist_st_ctr) dist_ed_ctr) 2))
      (setq s (sqrt (* p (* (* (- p line_length) (- p dist_st_ctr)) (- p dist_ed_ctr)))))
      (setq h (/ (* s 2) line_length))
      (setq hlf_dist (sqrt (- (* rb rb) (* h h))))
      (setq ctr_b_x (car ctr_b))
      (setq ctr_b_y (cadr ctr_b))
      (if (/= (- (car ed_line_a) (car st_line_a)) 0)
      	(setq a_arf  (atan (/ (- (cadr ed_line_a) (cadr st_line_a)) (- (car ed_line_a) (car st_line_a))) ))
	(setq a_arf (/ pi 2))
	)
      (setq h_x (- ctr_b_x (* (cos (+ a_arf (/ pi 2))) h)))
      (setq h_y (- ctr_b_y (* (sin (+ a_arf (/ pi 2))) h)))
      (setq inter_1_x (+ h_x (* (cos  a_arf) hlf_dist)))
      (setq inter_1_y (+ h_y (* (sin  a_arf) hlf_dist)))
      (setq inter_2_x (- h_x (* (cos  a_arf) hlf_dist)))
      (setq inter_2_y (- h_y (* (sin  a_arf) hlf_dist)))
      (setq inter_1 (list inter_1_x inter_1_y))
      (setq inter_2 (list inter_2_x inter_2_y))
      (if (< (+ (distance inter_1 pa1) (distance inter_1 pb1))
	     (+ (distance inter_2 pa1) (distance inter_2 pb1))
	     )
	(setq pl_inter inter_1)
	(setq pl_inter inter_2)
	)
      (if (= (sslength line_a) 1)
	(progn
	  (if (and
		(= (car st_line_a) (car pa1))
		(= (cadr st_line_a) (cadr pa1))
	      )
	    (progn
	      (setq line_a_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	    (progn
	      (setq line_a_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	  )
	)
      )

      (setq chg_b_agl (angle ctr_b pl_inter))
      (if (< (abs (- chg_b_agl st_agl_b))
	     (abs (- chg_b_agl ed_agl_b))
	  )
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 50 chg_b_agl)
			(cons 50 st_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 51 chg_b_agl)
			(cons 51 ed_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
      )
      (command "pedit" line_a "Y" "J" "all" "" "X")
    )
  )
      ;;两条端点的线一条为直线、一条为弧

  (if (and (/= bga 0)
	   (= bgb 0)
      )
    (pl_join pb1 pb2 bgb pa1 pa2 bga pdb pda)
    )
  (chg_color)
)


;;一条多义线两端延长闭合
(defun pl_join_single (pa1 pa2 bga pb1 pb2 bgb pda)
    ;;两条端点的线为直线

  (if (and (= bga 0)
	   (= bgb 0)
      )
    (progn
      (setq pl_inter (inters pa1 pa2 pb1 pb2 nil))
      (setq enta (get_dt_vl -1 pda))
      (command "explode" enta "")
      (setq line_a (ssget pa1))
      (setq line_b (ssget pb1))
      (if (= (get_dt_vl 5 (entget (ssname line_a 0)))
	     (get_dt_vl 5 (entget (ssname line_b 0)))
	  )
	    (setq line_b (get_scd_obj pb1 line_a))
      )
      
      (if (= (sslength line_a) 1)
	(progn
	  (setq line_a_detail (entget (ssname line_a 0)))
	  (setq st_line_a (get_dt_vl 10 line_a_detail))
	  (setq ed_line_a (get_dt_vl 11 line_a_detail))
	  (if (and
		(= (car st_line_a) (car pa1))
		(= (cadr st_line_a) (cadr pa1))
	      )
	    (progn
	      (setq line_a_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	    (progn
	      (setq line_a_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	  )
	)
      )
      (if (= (sslength line_b) 1)
	(progn

	  (setq line_b_detail (entget (ssname line_b 0)))
	  (setq st_line_b (get_dt_vl 10 line_b_detail))
	  (setq ed_line_b (get_dt_vl 11 line_b_detail))
	  (if (and
		(= (car st_line_b) (car pb1))
		(= (cadr st_line_b) (cadr pb1))
	      )
	    (progn
	      (setq line_b_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_b)
			    line_b_detail
		     )
	      )
	      (entmod line_b_detail)
	    )
	    (progn
	      (setq line_b_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_b)
			    line_b_detail
		     )
	      )
	      (entmod line_b_detail)
	    )
	  )
	  
	)

      )
      (command "pedit" line_a "Y" "J" "all" "" "X")
    )
  )
      ;;两条端点的线为弧

  (if (and (/= bga 0)
	   (/= bgb 0)
      )
    (progn
      (setq enta (get_dt_vl -1 pda))
      (command "explode" enta "")
      (setq arc_a (ssget pa1))
      (setq arc_b (ssget pb1))
      
      (if (= (get_dt_vl 5 (entget (ssname arc_a 0)))
	     (get_dt_vl 5 (entget (ssname arc_b 0)))
	  )
	(setq arc_b (get_scd_obj pb1 arc_a))
      )
      
      (if (= (sslength arc_a) 1)
	(progn
	  (setq arc_a_detail (entget (ssname arc_a 0)))
	  (setq ra (get_dt_vl 40 arc_a_detail))
	  (setq ctr_a (get_dt_vl 10 arc_a_detail))
	  (setq st_agl_a (get_dt_vl 50 arc_a_detail))
	  (setq ed_agl_a (get_dt_vl 51 arc_a_detail))
	)
      )
      (setq xac (car ctr_a))
      (setq yac (cadr ctr_a))

      (if (= (sslength arc_b) 1)
	(progn
	  (setq arc_b_detail (entget (ssname arc_b 0)))
	  (setq rb (get_dt_vl 40 arc_b_detail))
	  (setq ctr_b (get_dt_vl 10 arc_b_detail))
	  (setq st_agl_b (get_dt_vl 50 arc_b_detail))
	  (setq ed_agl_b (get_dt_vl 51 arc_b_detail))
	)
      )
      (setq xbc (car ctr_b))
      (setq ybc (cadr ctr_b))

      (setq ctr_dst (distance ctr_a ctr_b))
      (setq agl_cc (angle ctr_a ctr_b))
      (setq
	agl_a_cos (/ (- (+ (* ra ra) (* ctr_dst ctr_dst)) (* rb rb))
		     (* 2 (* ra ctr_dst))
		  )
      )
      (if (> (abs agl_a_cos) 0)
	(setq agl_a (atan (sqrt (- (/ 1 (* agl_a_cos agl_a_cos)) 1))))
	(prompt "\n No inter point")
      )
      (if (> agl_a 0)
	(progn
	  (setq agl_a0 (+ agl_a agl_cc))
	  (setq inter1_x (+ xac (* ra (cos agl_a0))))
	  (setq inter1_y (+ yac (* ra (sin agl_a0))))
	  (setq agl_a1 (- agl_cc agl_a))
	  (setq inter2_x (+ xac (* ra (cos agl_a1))))
	  (setq inter2_y (+ yac (* ra (sin agl_a1))))
	)
      )
      (if (< (distance (list inter1_x inter1_y) pa1)
	     (distance (list inter2_x inter2_y) pa1)
	  )
	(setq pl_inter (list inter1_x inter1_y))
	(setq pl_inter (list inter2_x inter2_y))

      )
      (setq chg_a_agl (angle ctr_a pl_inter))
      (if (< (abs (- chg_a_agl st_agl_a))
	     (abs (- chg_a_agl ed_agl_a))
	  )
	(progn

	  (setq	arc_a_detail
		 (subst	(cons 50 chg_a_agl)
			(cons 50 st_agl_a)
			arc_a_detail
		 )
	  )
	  (entmod arc_a_detail)
	)
	(progn
	  (setq	arc_a_detail
		 (subst	(cons 51 chg_a_agl)
			(cons 51 ed_agl_a)
			arc_a_detail
		 )
	  )
	  (entmod arc_a_detail)
	)
      )
      (setq chg_b_agl (angle ctr_b pl_inter))
      (if (< (abs (- chg_b_agl st_agl_b))
	     (abs (- chg_b_agl ed_agl_b))
	  )
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 50 chg_b_agl)
			(cons 50 st_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 51 chg_b_agl)
			(cons 51 ed_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
      )
      (command "pedit" arc_a "Y" "J" "all" "" "X")
    )
  )
    ;;两条端点的线一条为直线、一条为弧

  (if (and (= bga 0)
	   (/= bgb 0)
      )
    (progn
      (setq enta (get_dt_vl -1 pda))
      (command "explode" enta "")
      (setq line_a (ssget pa1))
      (setq arc_b (ssget pb1))
      (if (= (get_dt_vl 5 (entget (ssname line_a 0)))
	     (get_dt_vl 5 (entget (ssname arc_b 0)))
	  )
	(progn
	  (if (= (get_dt_vl 0 (entget (ssname line_a 0))) "LINE")
	    (setq arc_b (get_scd_obj pb1 line_a))
	    (setq line_a (get_scd_obj pa1 arc_b))
	  )
	)
      )
      (if (= (sslength line_a) 1)
	(progn
	  (setq line_a_detail (entget (ssname line_a 0)))
	  (setq st_line_a (get_dt_vl 10 line_a_detail))
	  (setq ed_line_a (get_dt_vl 11 line_a_detail))
	)
      )
      (if (= (sslength arc_b) 1)
	(progn
	  (setq arc_b_detail (entget (ssname arc_b 0)))
	  (setq rb (get_dt_vl 40 arc_b_detail))
	  (setq ctr_b (get_dt_vl 10 arc_b_detail))
	  (setq st_agl_b (get_dt_vl 50 arc_b_detail))
	  (setq ed_agl_b (get_dt_vl 51 arc_b_detail))
	)
      )
      (setq line_length (distance st_line_a ed_line_a))
      (setq dist_st_ctr (distance st_line_a ctr_b))
      (setq dist_ed_ctr (distance ed_line_a ctr_b))
      (setq p (/ (+ (+ line_length dist_st_ctr) dist_ed_ctr) 2))
      (setq s (sqrt (* p (* (* (- p line_length) (- p dist_st_ctr)) (- p dist_ed_ctr)))))
      (setq h (/ (* s 2) line_length))
      (setq hlf_dist (sqrt (- (* rb rb) (* h h))))
      (setq ctr_b_x (car ctr_b))
      (setq ctr_b_y (cadr ctr_b))
      (setq a_arf  (atan (/ (- (cadr ed_line_a) (cadr st_line_a)) (- (car ed_line_a) (car st_line_a))) ))
      (setq h_x (- ctr_b_x (* (cos (+ a_arf (/ pi 2))) h)))
      (setq h_y (- ctr_b_y (* (sin (+ a_arf (/ pi 2))) h)))
      (setq inter_1_x (+ h_x (* (cos  a_arf) hlf_dist)))
      (setq inter_1_y (+ h_y (* (sin  a_arf) hlf_dist)))
      (setq inter_2_x (- h_x (* (cos  a_arf) hlf_dist)))
      (setq inter_2_y (- h_y (* (sin  a_arf) hlf_dist)))
      (setq inter_1 (list inter_1_x inter_1_y))
      (setq inter_2 (list inter_2_x inter_2_y))
      (if (< (+ (distance inter_1 pa1) (distance inter_1 pb1))
	     (+ (distance inter_2 pa1) (distance inter_2 pb1))
	     )
	(setq pl_inter inter_1)
	(setq pl_inter inter_2)
	)
      (if (= (sslength line_a) 1)
	(progn
	  (if (and
		(= (car st_line_a) (car pa1))
		(= (cadr st_line_a) (cadr pa1))
	      )
	    (progn
	      (setq line_a_detail
		     (subst (cons 10 pl_inter)
			    (cons 10 st_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	    (progn
	      (setq line_a_detail
		     (subst (cons 11 pl_inter)
			    (cons 11 ed_line_a)
			    line_a_detail
		     )
	      )
	      (entmod line_a_detail)
	    )
	  )
	)
      )

      (setq chg_b_agl (angle ctr_b pl_inter))
      (if (< (abs (- chg_b_agl st_agl_b))
	     (abs (- chg_b_agl ed_agl_b))
	  )
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 50 chg_b_agl)
			(cons 50 st_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
	(progn
	  (setq	arc_b_detail
		 (subst	(cons 51 chg_b_agl)
			(cons 51 ed_agl_b)
			arc_b_detail
		 )
	  )
	  (entmod arc_b_detail)
	)
      )
      (command "pedit" line_a "Y" "J" "all" "" "X")
    )
  )
    ;;两条端点的线一条为直线、一条为弧

  (if (and (/= bga 0)
	   (= bgb 0)
      )
     ;;自调用
    (pl_join_single pb1 pb2 bgb pa1 pa2 bga pda) 
    )
  (chg_color)
)

(defun z_tow_pt	(pt1 pt2)
  (setq min_zoom_size 0.0001)
  (setq
    zoom_w_ld (list (- (- (min (car pt1) (car pt2)) min_zoom_size)
		       (abs (- (car pt1) (car pt2)))
		    )
		    (- (- (min (cadr pt1) (cadr pt2)) min_zoom_size)
		       (abs (- (cadr pt1) (cadr pt2)))
		    )
	      )
  )
  (setq
    zoom_w_ur (list (+ (+ (max (car pt1) (car pt2)) min_zoom_size)
		       (abs (- (car pt1) (car pt2)))
		    )
		    (+ (+ (max (cadr pt1) (cadr pt2)) min_zoom_size)
		       (abs (- (cadr pt1) (cadr pt2)))
		    )
	      )
  )
  (command "zoom" "w" zoom_w_ld zoom_w_ur)
  (prompt "如果看不清两线端点请按回车我键，其它键将续")
  (setq z_var (getstring))
  (while (= z_var "")
    (command "regen")
    (command "zoom" "2x")
    (prompt "如果看不清两线端点请按回车我键，其它键将续")
    (setq z_var (getstring))
  )
 
)
(defun get_scd_obj (pb1 ss_obj)
  (setq ss_rd (list (- (car pb1) 0.0001) (- (cadr pb1) 0.0001)))
  (setq ss_ru (list (+ (car pb1) 0.0001) (- (cadr pb1) 0.0001)))
  (setq ss_lu (list (+ (car pb1) 0.0001) (+ (cadr pb1) 0.0001)))
  (setq ss_ld (list (- (car pb1) 0.0001) (+ (cadr pb1) 0.0001)))
  (setq pt_list (list ss_rd ss_ru ss_lu ss_ld))
  (setq arc_b (ssget "CP" pt_list))
  (setq ss_cnt (sslength arc_b))
  (setq i_loop 0)
  (setq ss_tmp (ssadd))
  (while (< i_loop ss_cnt)
    (setq arc_tmp (entget (ssname arc_b i_loop)))
    (if	(/= (get_dt_vl 5 arc_tmp)
	    (get_dt_vl 5 (entget (ssname ss_obj 0)))
	)
        (progn
	(ssadd (ssname arc_b i_loop) ss_tmp)
	(setq  i_loop ss_cnt)
	)
    )
    (setq i_loop (1+ i_loop))
  )
  (if (/= ss_tmp nil)
    (setq arc_b ss_tmp)
    (progn
      (command "change" ss_obj "" "p" "c" "220" "")
      (prompt "\n 程序只能先定铁红色的这个对像，请点取另一个")
      (setq arc_b (ssget (getpoint)))
    )
  )
)
(defun c:to_0 ()
  (reset_layer)
;;;  (chg_color)
  (pl2lwpl)
  (setq
    pl_ss
     (ssget "x"
	    (list (cons 0 "LWPOLYLINE") (cons 41 0)
	    )
     )
  )
  (if pl_ss
    (progn
      (setq total (sslength pl_ss))
      (setq count 0)
      (setq x_min (cadr (assoc 10 (entget (ssname pl_ss 0)))))
      (setq y_min (caddr (assoc 10 (entget (ssname pl_ss 0)))))
      (setq x_max x_min)
      (setq y_max y_min)
      (while (< count total)
	(setq pl_detail (entget (ssname pl_ss count)))
	(setq dt pl_detail)
	(while dt
	  (if (= (caar dt) 10)
	    (progn
	      (setq v_point (get_dt_vl 10 dt))
	      (setq x_min (min x_min (car v_point)))
	      (setq x_max (max x_max (car v_point)))
	      (setq y_min (min y_min (cadr v_point)))
	      (setq y_max (max y_max (cadr v_point)))
	    )
	  )
	  (setq dt (cdr dt))
	)
	(setq count (1+ count))
      )
    )
  )
  (setq mid_x (+ x_min (/ (- x_max x_min) 2)))
  (setq mid_y (+ y_min (/ (- y_max y_min) 2)))
  (setq mid_p (list mid_x mid_y))
  (command "move"
	   "all"
	   ""
	   mid_p
	   "0,0"
  )
)
