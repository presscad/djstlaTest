(defun del_space(str)   ;去除字符串里的空格
  (setq str_length (strlen str))
  (setq i_loop 1)
  (setq str_fi "")
  (while ( <= i_loop str_length)
    (setq sub_str (substr str i_loop 1))
    (if(/= sub_str " ")
      (setq str_fi (strcat str_fi sub_str))
    )
    (setq i_loop (+ i_loop 1))
  )
 (setq str_fi str_fi)
)

(defun draw_edge_s () 
        (command "pline" (list -101.5 -101.5) "w" 0 0 
                         (list 101.5 -101.5) 
                         (list 101.5 101.5) 
                         (list -101.5 101.5) 
                         "c"
         )
        (command "pline" (list -101.65 101.55) "w" 0 0 
                         (list -101.55 101.55) 
                         (list -101.55 101.65) 
                         (list -101.65 101.65) 
                         "c"
         )
        (command "pline" (list -101.65 -101.65) "w" 0 0 
                         (list -101.55 -101.65) 
                         (list -101.55 -101.55) 
                         (list -101.65 -101.55) 
                         "c"
         )
        (command "pline" (list 101.55 -101.65) "w" 0 0 
                         (list 101.65 -101.65) 
                         (list 101.65 -101.55) 
                         (list 101.55 -101.55) 
                         "c"
         )
        (command "pline" (list 101.55 101.55) "w" 0 0 
                         (list 101.65 101.55) 
                         (list 101.65 101.65) 
                         (list 101.55 101.65) 
                         "c"
         )
        (command "pline" (list 0.05 101.55) "w" 0 0 
                         (list 101.55 101.55) 
                         (list 101.55 -101.55) 
                         (list -101.55 -101.55) 
                         (list -101.55 101.55) 
                         (list -0.05 101.55) 
                         (list -0.05 101.45) 
                         (list -101.45 101.45) 
                         (list -101.45 -101.45) 
                         (list 101.45 -101.45) 
                         (list 101.45 101.45) 
                         (list 0.05 101.45) 
                         "c"
         )
  )

(defun draw_edge_b () 
        (command "pline" (list -152.0 -152.0) "w" 0 0 
                         (list 152.0 -152.0) 
                         (list 152.0 152.0) 
                         (list -152.0 152.0) 
                         "c"
         )
        (command "pline" (list -152.15 152.05) "w" 0 0 
                         (list -152.05 152.05) 
                         (list -152.05 152.15) 
                         (list -152.15 152.15) 
                         "c"
         )
        (command "pline" (list -152.15 -152.15) "w" 0 0 
                         (list -152.05 -152.15) 
                         (list -152.05 -152.05) 
                         (list -152.15 -152.05) 
                         "c"
         )
        (command "pline" (list 152.05 -152.15) "w" 0 0 
                         (list 152.15 -152.15) 
                         (list 152.15 -152.05) 
                         (list 152.05 -152.05) 
                         "c"
         )
        (command "pline" (list 152.05 152.05) "w" 0 0 
                         (list 152.15 152.05) 
                         (list 152.15 152.15) 
                         (list 152.05 152.15) 
                         "c"
         )
        (command "pline" (list 0.05 152.05) "w" 0 0 
                         (list 152.05 152.05) 
                         (list 152.05 -152.05) 
                         (list -152.05 -152.05) 
                         (list -152.05 152.05) 
                         (list -0.05 152.05) 
                         (list -0.05 151.95) 
                         (list -151.95 151.95) 
                         (list -151.95 -151.95) 
                         (list 151.95 -151.95) 
                         (list 151.95 151.95) 
                         (list 0.05 151.95) 
                         "c"
         )
  )



(defun move_zero (/ pl_d ent_name ent cx cy center_point)
  (vl-load-com)
  (prompt "\n****请选择图形最外框:****")
  (setq ss_lw (ssget))
  (setq ss_lw (ssget "p" (list (cons 0 "lwpolyline"))))
  (if ss_lw
    (progn

      (setq pl_d (entget (ssname ss_lw 0)))
      (setq ent_name (cdr (assoc -1 pl_d)))
      (setq rec_area (vlax-curve-getarea ent_name))
      (setq cx 0)
      (setq cy 0)
      (setq cnt 0)

      (while pl_d
	(if (= (caar pl_d) 10)
	  (progn
	    (setq cx (+ (cadar pl_d) cx))
	    (setq cy (+ (caddar pl_d) cy))

	    (setq cnt (1+ cnt))
	  )
	)
	(setq pl_d (cdr pl_d))
      )
      (setq cx (/ cx cnt))
      (setq cy (/ cy cnt))
      (setq center_point (list cx cy))
    )
    (progn
      (alert (strcat "\n请先将此边框闭合！！"))
      (exit)
    )
  )

  (command "move" "all" "" center_point "0,0")
  (command "zoom" "E")
)					;将图形居中，并取最外框的面积以判断大、小版
(defun set_var ()
  (setvar "orthomode" 0)
  (setvar "osmode" 0)
  (command "-style" "standard" "黑体" "" "1" "0" "" "n"	"n" "n")
  (command "zoom" "e" "")
)
(defun scale (layer_name kx ky / ss_lwpl ss_cnt	i_loop scl_x scl_y dt
	      center)
  (command "zoom" "E")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline") (cons 8 layer_name))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq scl_x (* (cadar pl_dt) kx))
	      (setq scl_y (* (caddar pl_dt) ky))
	      (setq
		dt (append dt (list (cons 10 (list scl_x scl_y 0))))
	      )
	    )
	  )
	  (setq pl_dt (cdr pl_dt))
	)
	(entmod dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "CIRCLE") (cons 8 layer_name))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))
	(setq center (cdr (assoc 10 pl_dt)))
	(setq center (list (* kx (car center)) (* ky (cadr center))))
	(setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	(entmod pl_dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "E")

)
　
(defun sn_widen	(/	 lin	 stpoint edpoint sc_48	 back
		 s_e	 lintype sl	 el	 e1	 sl_mid
		 sl_total	 sl_el	 se_mid	 secp	 ll
		 n
		)
					(prompt "请选择单线")
  (setq ll (ssget  (list (cons 6 "DASHED")(cons 0 "line"))))
  (if (not ll)
    (exit))
  (setq lin_len (sslength ll))
  (setq n -1)
  (command "layer" "m" "tem" "")
  
  (repeat lin_len
    (setq n (+ n 1))
    (setq lin (entget (ssname ll n)))
    (setq stpoint (cdr (assoc 10 lin)))
    (setq stpoint (list (car stpoint) (cadr stpoint)))
    (setq edpoint (cdr (assoc 11 lin)))
    (setq stpoint (list (car stpoint) (cadr stpoint)))
    (setq sc_48 (assoc 48 lin))
    (if	sc_48
      (setq sc_48 (cdr sc_48))
      (setq sc_48 1)
    )
    (if	(< (cadr stpoint) (cadr edpoint))
      (progn
	(setq back stpoint)
	(setq stpoint edpoint)
	(setq edpoint back)
      )
    )
    (setq s_e (abs (distance stpoint edpoint)))
    (if
      (setq lintype (cdr (assoc 6 lin)))
       (progn
	 (setq lintype (tblsearch "ltype" lintype))
	 (setq sl (cdr (assoc 49 lintype)))
	 (setq lintype (reverse lintype))
	 (if (< sl 0)
	   (progn
	     (setq el sl)
	     (setq sl (cdr (assoc 49 lintype)))
	   )
	   (setq el (cdr (assoc 49 lintype)))
	 )
	 (setq sl (* sl sc_48))
	 (setq el (* el sc_48))		;sl >0  el <0
	 (setq sl_total (+ sl (abs el)))
	 (setq sl_el (fix (/ s_e sl_total)))
	 (setq se_mid (- s_e (- (* sl_el sl_total) sl)))
	 (setq se_mid (/ se_mid 2))
	 (setq secp (list (car stpoint) (- (cadr stpoint) se_mid)))
	 (command "line" stpoint secp "")
	 (setq stpoint (list (car stpoint)
			     (- (cadr stpoint) (+ se_mid (abs el)))
		       )
	 )
	 (while	(> sl_el 1)
	   (setq secp (list (car stpoint) (- (cadr stpoint) sl)))
	   (command "line" stpoint secp "")
	   (setq
	     stpoint (list (car stpoint) (- (cadr stpoint) sl_total))
	   )
	   (setq sl_el (- sl_el 1))
	 )
	 (command "line" stpoint edpoint "")
       )
    )
  )
  (setq tem "tem")
  (wdl tem 0.1)
  (setq ll (ssget "x" (list (cons 8 "tem"))))
  (command "change" ll "" "p" "layer" "0" "")
  (command "layer" "m" "0" "")
  (command "purge" "a" "" "n")
)




(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
					;加宽
(defun wdl (lay_name width    /	       cnt_all	cnt	 l_dt
	    stt_pnt  end_pnt  agl      x0	y0	 fst_pnt
	    fth_pnt  scd_pnt  thd_pnt
	   )
  (setq ss (ssget "x" (list (cons 0 "line") (cons 8 lay_name))))
  (if ss
    (progn

      (setq cnt_all (sslength ss))
      (setq cnt 0)
      (command "layer" "M" lay_name "")
      (while (< cnt cnt_all)
	(setq l_dt (entget (ssname ss cnt)))
	(setq stt_pnt (get_dt_vl 10 l_dt))
	(setq end_pnt (get_dt_vl 11 l_dt))
	(setq agl (angle stt_pnt end_pnt))
	(setq x0 (car stt_pnt))
	(setq y0 (cadr stt_pnt))
	(setq fst_pnt (list (+ x0 (* width (sin agl)))
			    (- y0 (* width (cos agl)))
		      )
	)
	(setq fth_pnt (list (- x0 (* width (sin agl)))
			    (+ y0 (* width (cos agl)))
		      )
	)
	(setq x0 (car end_pnt))
	(setq y0 (cadr end_pnt))
	(setq scd_pnt (list (+ x0 (* width (sin agl)))
			    (- y0 (* width (cos agl)))
		      )
	)
	(setq thd_pnt (list (- x0 (* width (sin agl)))
			    (+ y0 (* width (cos agl)))
		      )
	)
	(entdel (get_dt_vl -1 l_dt))
	(command "pline" fst_pnt scd_pnt thd_pnt fth_pnt "c" "")
	(setq cnt (1+ cnt))
      )
    )
  )
  
)
　　　　　　　　　　　　　　		;收缩程序，只针对圆和闭合多义线
(defun c:sn_scale (/		   ss_txt	   ss_length
		   ss_table	   ss_con	   txt_td
		   ss_rec_txt	   rec_txt_l	   rec_txt_table
		   rec_txt_con	   rec_txt	   rec_txt_px
		   td_scal	   td_num	   md_num
		   md_scal	   px_scale_md	   px_scale_td
		   pj_scale_md	   pj_scale_td	   zhengti_scale_td
		   zhengti_scale_md		   zhipin_scale_td
		   zhipin_scale_md
		  )
  (set_var)
  (move_zero)
					;(command "move""all""" ce_point "0,0")

  (setq ss_txt (ssget "x" (list (cons 0 "text"))))
  (setq ss_length (sslength ss_txt))
  (setq str_a (list))
  (setq i_loop 0)
  (while (< i_loop ss_length)
    (setq ss_table (entget (ssname ss_txt i_loop)))
    (setq ss_con (cdr (assoc 1 ss_table)))
    (setq txt_td (substr ss_con 1 2))
    (if	(equal (strcase txt_td) "TD")
      (progn
	(setq txt_point (cdr (assoc 10 ss_table)))
	(setq txt_point_x (car txt_point))
	(setq txt_point_y (cadr txt_point))
	(setq txt_point_xr (+ txt_point_x 1))
	(setq txt_point_xl (- txt_point_x 1))
	(setq txt_point_yt (+ txt_point_y 1))
	(setq txt_point_yb (- txt_point_y 1))
	(setq ss_rec_txt
	       (ssget "c"
		      (list txt_point_xl txt_point_yb)
		      (list txt_point_xr txt_point_yt)
		      (list (cons 0 "text"))
	       )
	)
	(setq rec_txt_l (sslength ss_rec_txt))
	(setq nm 1.5)
	(while (< rec_txt_l 3)

	  (progn

	    (setq txt_point_xr (+ txt_point_x nm))
	    (setq txt_point_xl (- txt_point_x nm))
	    (setq txt_point_yt (+ txt_point_y nm))
	    (setq txt_point_yb (- txt_point_y nm))
	    (setq ss_rec_txt
		   (ssget "c"
			  (list txt_point_xl txt_point_yb)
			  (list txt_point_xr txt_point_yt)
			  (list (cons 0 "text"))
		   )
	    )
	    (setq rec_txt_l (sslength ss_rec_txt))
	    (setq nm (+ nm 0.5))
					;(alert (strcat "没有找到相应系数，请确认！"))
	  )
	)
	(setq i 0)
	(while (< i rec_txt_l)
	  (setq rec_txt_table (entget (ssname ss_rec_txt i)))
	  (setq rec_txt_con (cdr (assoc 1 rec_txt_table)))
	  (setq rec_txt_back rec_txt_con)

	  (setq rec_txt (substr rec_txt_con 1 2))

	  (if (equal (strcase rec_txt) "TD")
	    (progn
					;(setq td_num (vl-string-right-trim "%" rec_txt_con))

	      (setq td_scal (vl-string-left-trim "TD" rec_txt_con))
	      (setq td_scal (vl-string-trim " " td_scal))
	      (setq td_scal (vl-string-left-trim ":" td_scal))
	      (setq td_scal (vl-string-trim " " td_scal))
	    )
	  )
	  (if (equal (strcase rec_txt) "MD")
	    (progn
					;(setq md_num (vl-string-right-trim "%" rec_txt_con))
	      (setq md_scal (vl-string-left-trim "MD" rec_txt_con))
	      (setq md_scal (vl-string-trim " " md_scal))
	      (setq md_scal (vl-string-left-trim ":" md_scal))
	      (setq md_scal (vl-string-trim " " md_scal))
	    )
	  )
	  (setq rec_txt (substr rec_txt_back 1))
	  (setq e_num (vl-string-search "補正" rec_txt))
	  (if e_num
	    (setq txt_key rec_txt)
	  )
	  (setq i (+ i 1))

	)
	(setq txt_zhipin (vl-string-search "製品" txt_key))
	(setq txt_zhengti (vl-string-search "ワ" txt_key))

	(setq txt_px (vl-string-search "ＰＸ" txt_key))
	(if (not txt_px)              ;2006.08.11修改
	  (progn
	  (setq txt_px_key "PX補正")
	  (setq px_scale_td "0%")
	  (setq px_scale_md "0%")
	  )
	)
	(if (not txt_zhengti)
	  (progn

	    (if	(not txt_zhipin)
	      (progn

		(setq px_scale_md md_scal)
		(setq px_scale_td td_scal)
		(setq txt_px_key txt_key)

	      )

	      (progn
		(setq zhipin_scale_md md_scal)
		(setq zhipin_scale_td td_scal)
		(setq txt_zhipin_key txt_key)
		(setq flag 1)
	      )
	    )
	  )
	  (progn
	    (setq zhengti_scale_md md_scal)
	    (setq zhengti_scale_td td_scal)
	    (setq txt_zhengti_key txt_key)
	  )
	)
      )
    )
    (setq i_loop (+ i_loop 1))
  )
  　　　　　　　　			;取原始系数
  (setq str_a_pj "ＰＪマ-ク補正:TD=0% MD=0%")
  (setq txt_pj_key (substr "ＰＪマ-ク補正:TD=0%MD=0%" 1 14))
  (setq pj_scale_td "0%")
  (setq pj_scale_md "0%")
  (if (equal flag 1)
    (alert
      (strcat
	"    *****请确认<< 原始 >>系数*****"
	"\n"
	"---------------------------------------------------"
	"\n"
	txt_zhengti_key
	":"
	"TD="
	zhengti_scale_td
	" MD="
	zhengti_scale_md
	"\n"
	"---------------------------------------------------"
	"\n"
	txt_px_key
	":"
	"TD="
	px_scale_td
	" MD="
	px_scale_md
	"\n"
	"---------------------------------------------------"
	"\n"
	txt_zhipin_key
	":"
	"TD="
	zhipin_scale_td
	" MD="
	zhipin_scale_md
	"\n"
	"---------------------------------------------------"
	"\n"
	str_a_pj
	"\n"
	"---------------------------------------------------"
	"\n"
       )
    )
    (alert
      (strcat
	"   *****请确认<< 原始 >>系数*****"
	"\n"
	"--------------------------------------------------"
	"\n"
	txt_px_key
	":"
	"TD="
	px_scale_td
	" MD="
	px_scale_md
	"\n"
	"--------------------------------------------------"
	"\n"
	txt_zhengti_key
	":"
	"TD="
	zhengti_scale_td
	" MD="
	zhengti_scale_md
	"\n"
	"--------------------------------------------------"
;	"\n"
;	str_a_pj
;	"\n"
;	"--------------------------------------------------"
	"\n"
       )
    )
  )
  (del_space zhengti_scale_td)
  (setq zhengti_scale_td str_fi)
  (del_space zhengti_scale_md)
  (setq zhengti_scale_md str_fi)
  (del_space px_scale_td)
  (setq px_scale_td str_fi)
  (del_space px_scale_md)
  (setq px_scale_md str_fi)
  (setq zheng_mark_td (substr zhengti_scale_td 1 1))
  (if (equal zheng_mark_td "-")
    (progn
      (setq zhengti_scale_td (* (atof zhengti_scale_td) 0.01))
      (setq px_scale_td
	     (+	(+ (* (atof px_scale_td) 0.01) 1)
		(abs zhengti_scale_td)
	     )
      )

      (setq pj_scale_td
	     (+	(+ (* (atof pj_scale_td) 0.01) 1)
		(abs zhengti_scale_td)
	     )
      )
    )
    (progn
      (setq zhengti_scale_td (* (atof zhengti_scale_td) 0.01))
      (setq px_scale_td
	     (-	(+ (* (atof px_scale_td) 0.01) 1)
		(abs zhengti_scale_td)
	     )
      )
      (setq pj_scale_td
	     (-	(+ (* (atof pj_scale_td) 0.01) 1)
		(abs zhengti_scale_td)
	     )
      )
    )
  )
  (setq zheng_mark_md (substr zhengti_scale_md 1 1))
  (if (equal zheng_mark_md "-")
    (progn
      (setq zhengti_scale_md (* (atof zhengti_scale_md) 0.01))
      (setq px_scale_md
	     (+	(+ (* (atof px_scale_md) 0.01) 1)
		(abs zhengti_scale_md)
	     )
      )
      (setq pj_scale_md
	     (+	(+ (* (atof pj_scale_md) 0.01) 1)
		(abs zhengti_scale_md)
	     )
      )
    )
    (progn
      (setq zhengti_scale_md (* (atof zhengti_scale_md) 0.01))
      (setq px_scale_md
	     (-	(+ (* (atof px_scale_md) 0.01) 1)
		(abs zhengti_scale_md)
	     )
      )
      (setq pj_scale_md
	     (-	(+ (* (atof pj_scale_md) 0.01) 1)
		(abs zhengti_scale_md)
	     )
      )
    )
  )
  　　　　　　　　　			;计算出的最终系数
  (if (equal flag 1)
    (progn
      (setq zhipin_scale_td (* (atof zhipin_scale_td) 0.01))
      (setq zhipin_scale_md (* (atof zhipin_scale_md) 0.01))
      (alert
	(strcat
	  "   *****请确认<< 最终 >>系数*****"
	  "\n"
	  "----------------------------------------------------"
	  "\n"
	  txt_zhengti_key
	  ":"
	  "TD="
	  (rtos zhengti_scale_td 2 6)
	  " "
	  "MD="
	  (rtos zhengti_scale_md 2 6)
	  "\n"
	  "----------------------------------------------------"
	  "\n"
	  txt_px_key
	  ":"
	  "TD="
	  (rtos px_scale_td 2 6)
	  " "
	  "MD="
	  (rtos px_scale_md 2 6)
	  "\n"
	  "----------------------------------------------------"
	  "\n"
	  txt_zhipin_key
	  ":"
	  "TD="
	  (rtos zhipin_scale_td 2 6)
	  " "
	  "MD="
	  (rtos zhipin_scale_md 2 6)
	  "\n"
	  "----------------------------------------------------"
	  "\n"
	  txt_pj_key
	  ":"
	  "TD="
	  (rtos pj_scale_td 2 6)
	  " "
	  "MD="
	  (rtos pj_scale_md 2 6)
	  "\n"
	  "----------------------------------------------------"
	  "\n"
	)
      )
    )
    (alert
      (strcat
	"     *****请确认<< 最终 >>系数*****"
	"\n"
	"--------------------------------------------------------"
	"\n"
	txt_zhengti_key
	":"
	"TD="
	(rtos zhengti_scale_td 2 6)
	" "
	"MD="
	(rtos zhengti_scale_md 2 6)
	"\n"
	"--------------------------------------------------------"
	"\n"
	txt_px_key
	":"
	"TD="
	(rtos px_scale_td 2 6)
	" "
	"MD="
	(rtos px_scale_md 2 6)
	"\n"
	"--------------------------------------------------------"
	"\n"
;	txt_pj_key
;	":"
;	"TD="
;;	(rtos pj_scale_td 2 6)
;	" "
;	"MD="
;	(rtos pj_scale_md 2 6)
;	"\n"
;	"--------------------------------------------------------"
;	"\n"
      )
    )
  )
  (if (> rec_area 50000)
    (progn

      (setq ss_px1
	     (ssget "c"
		    (list -2.25 122.25)
		    (list 2.05 117.95)
		    (list (cons -4 "<and")
			  (cons 0 "CIRCLE")
			  (cons 40 0.25)
			  (cons -4 "and>")
		    )
	     )
      )


      (setq ss_px2
	     (ssget "c"
		    (list -2.25 -122.25)
		    (list 2.05 -117.95)
		    (list (cons -4 "<and")
			  (cons 0 "CIRCLE")
			  (cons 40 0.25)
			  (cons -4 "and>")
		    )
	     )
      )
      (if (or (not ss_px1)
	      (not ss_px2)
	  )

	(progn
	  (alert (strcat "\n没有找到PX图形，请手工选PX图形！！"))
	  (setq ss_px1 (ssget))
	  (command "zoom" "e" "")
	)
      )
      (command "layer" "n" "px_sc" "")
      (command "layer" "n" "pj_sc" "")
      (command "change" ss_px1 "" "p" "la" "px_sc" "")
      (command "change" ss_px2 "" "p" "la" "px_sc" "")
      (command "layer" "n" "F" "")
      (command "layer" "M" "F" "")
      (command "erase" ss_lw "" )
      (draw_edge_b)
      (sn_widen)
    )
    (progn
      (setq ss_px1
	     (ssget "c"
		    (list -74.5 -35)
		    (list -72 -90)
		    (list (cons -4 "<and")
			  (cons 0 "CIRCLE")
			  (cons 40 0.25)
			  (cons -4 "and>")
		    )
	     )
      )
      (setq ss_px2
	     (ssget "c"
		    (list 73 -15)
		    (list 74.1 -90)
		    (list

		      (cons 0 "lwpolyline")
		    )
	     )
      )
					;(if ss_px2
					;(command "pedit""m" ss_px2 """y""j""0"""))
      (command "layer" "n" "px_sc" "")
      (command "change" ss_px1 "" "p" "la" "px_sc" "")
      (if (and ss_px1 ss_px2)
	(command "change" ss_px2 "" "p" "la" "px_sc" "")
	(progn
	  ;(setq	ss_px3
	;	 (ssget	"c"
	;		(list 73 -35)
	;		(list 74.1 -60)
	;		(list
;
	;		  (cons 0 "line")
	;		)
	;	 )
	 ; )
	  (if ss_px1
	    
	    (progn
	      (alert (strcat "\n请将PX图形闭合！！"))
	      (exit)
	    )
	   
          (alert"请确认没有PX图形！")
	  )
	)
      )

      (setq ss_pj1
	     (ssget "c"
		    (list -80 1.5)
		    (list -75 -2.2)
		    (list (cons -4 "<and")
			  (cons 0 "CIRCLE")
			  (cons 40 0.15)
			  (cons -4 "and>")
		    )
	     )
      )
      (setq ss_pj2
	     (ssget "c"
		    (list 80 1.5)
		    (list 75 -2.2)
		    (list (cons -4 "<and")
			  (cons 0 "CIRCLE")
			  (cons 40 0.15)
			  (cons -4 "and>")
		    )
	     )
      )
      (if (or (not ss_pj1)
	      (not ss_pj2)
	  )

	(progn
	  (alert (strcat "\n没有找到PJ图形，请手工选PJ图形！！"))
	  (setq ss_pj1 (ssget))
	  (command "zoom" "e" "")
	)
      )
      (command "layer" "n" "pj_sc" "")
      (command "change" ss_pj1 "" "p" "la" "pj_sc" "")
      (command "change" ss_pj2 "" "p" "la" "pj_sc" "")
      (command "layer" "n" "F" "")
      (command "layer" "M" "F" "")
      (command "erase" ss_lw "" )
     (draw_edge_s)

    )
  )					;判断大小版，并取出PX、PJ要收缩的图形
  (setq key (getstring "****请输入箭头方向(X/Y<X>)："))
  (if (/= (strcase key) "Y")
    (progn
      (scale "px_sc" px_scale_md px_scale_td)
      (scale "pj_sc" pj_scale_md pj_scale_td)
    )
    (progn
      (scale "px_sc" px_scale_td px_scale_md)
      (scale "pj_sc" pj_scale_td pj_scale_md)
    )
  )
  　　　　　　				;对PX、PJ进行收缩
  (setq px_ent (ssget "x" (list (cons 8 "px_sc"))))
  (if px_ent
    (setq px_ent_num (sslength px_ent))
    (setq px_ent_num 0)
  )
  (setq pj_ent (ssget "x" (list (cons 8 "pj_sc"))))
  (if pj_ent
    (setq pj_ent_num (sslength pj_ent))
    (setq pj_ent_num 0)
  )
  (alert (strcat "已有 "
		 (itoa px_ent_num)
		 " 个实体进行<< PX >>收缩"
		 "\n"
		 "----------------------------------------"
		 "\n"
		 "已有 "
		 (itoa pj_ent_num)
		 " 个实体进行<< PJ >>收缩"
	 )
  )
  
)

　					;END　SN_SCALE
(prompt "\n****运行前先将图形最外框和PX图形闭合！****")

(prompt "\n*******输入SN_SCALE运行程序！*******")


