(defun draw_edge_new ()
  (command "pline"
	   (list 232.0 -280.0)
	   "w"
	   0
	   0
	   (list 232.0 280.0)
	   (list 230.0 280.0)
	   (list 230.0 -280.0)
	   "c"
  )
  (command "pline"
	   (list -230.0 -280.0)
	   "w"
	   0
	   0
	   (list -230.0 280.0)
	   (list -232.0 280.0)
	   (list -232.0 -280.0)
	   "c"
  )
  (command "pline"
	   (list -230.0 -310.0)
	   "w"
	   0
	   0
	   (list -230.0 -325.0)
	   (list 230.0 -325.0)
	   (list 230.0 -310.0)
	   (list 232.0 -310.0)
	   (list 232.0 -327.0)
	   (list -232.0 -327.0)
	   (list -232.0 -310.0)
	   "c"
  )
  (command "pline"
	   (list 232.0 310.0)
	   "w"
	   0
	   0
	   (list 232.0 327.0)
	   (list -232.0 327.0)
	   (list -232.0 310.0)
	   (list -230.0 310.0)
	   (list -230.0 325.0)
	   (list 230.0 325.0)
	   (list 230.0 310.0)
	   "c"
  )
  (command "circle" "-225.0000,-319.0000" 1)
  (command "circle" "-200.0000,-319.0000" 1.5)
  (command "circle" "-125.0000,-319.0000" 1)
  (command "circle" "-100.0000,-319.0000" 1.5)
  (command "circle" "-75.0000,-319.0000" 1)
  (command "circle" "0.0000,-319.0000" 1.5)
  (command "circle" "75.0000,-319.0000" 1)
  (command "circle" "100.0000,-319.0000" 1.5)
  (command "circle" "125.0000,-319.0000" 1)
  (command "circle" "200.0000,-319.0000" 1.5)
  (command "circle" "225.0000,-319.0000" 1)
  (command "circle" "-225.0000,319.0000" 1)
  (command "circle" "-200.0000,319.0000" 1.5)
  (command "circle" "-125.0000,319.0000" 1)
  (command "circle" "-100.0000,319.0000" 1.5)
  (command "circle" "-75.0000,319.0000" 1)
  (command "circle" "0.0000,319.0000" 1.5)
  (command "circle" "75.0000,319.0000" 1)
  (command "circle" "100.0000,319.0000" 1.5)
  (command "circle" "125.0000,319.0000" 1)
  (command "circle" "200.0000,319.0000" 1.5)
  (command "circle" "225.0000,319.0000" 1)
)
(defun draw_edge_old ()
  (command "pline"
	   (list 199.5000 235.0000)
	   "w"
	   0
	   0
	   (list 199.5000 282.0000)
	   (list -199.5000 282.0000)
	   (list -199.5000 235.0000)
	   (list -197.5000 235.0000)
	   (list -197.5000 280.0000)
	   (list 197.5000 280.0000)
	   (list 197.5000 235.0000)
	   "c"
  )
  (command "pline"
	   (list -199.5000 -205.0000)
	   "w"
	   0
	   0

	   (list -197.5000 -205.0000)
	   (list -197.5000 205.0000)
	   (list -199.5000 205.0000)
	   "c"
  )
  (command "pline"
	   (list 197.5000 -205.0000)
	   "w"
	   0
	   0
	   (list 199.5000 -205.0000)
	   (list 199.5000 205.0000)
	   (list 197.5000 205.0000)
	   "c"
  )
  (command "pline"
	   (list 199.5000 -235.0000)
	   "w"
	   0
	   0
	   (list 199.5000 -282.0000)
	   (list -199.5000 -282.0000)
	   (list -199.5000 -235.0000)
	   (list -197.5000 -235.0000)
	   (list -197.5000 -280.0000)
	   (list 197.5000 -280.0000)
	   (list 197.5000 -235.0000)
	   "c"
  )
  (command "circle" "-185,272" "1")
  (command "circle" "-157.5, 272" "1.5")
  (command "circle" "-52.5,272" "1.5")
  (command "circle" "52.5,272" "1.5")
  (command "circle" "157.5,272" "1.5")
  (command "circle" "185,272" "1")
  (command "circle" "-185,-272" "1")
  (command "circle" "-157.5, -272" "1.5")
  (command "circle" "-52.5,-272" "1.5")
  (command "circle" "52.5,-272" "1.5")
  (command "circle" "157.5,-272" "1.5")
  (command "circle" "185,-272" "1")
)					;边框
(defun scale
       (layer_name ke / ss_lwpl dt ss_cnt i_loop pl_dt scl_x scl_y)
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
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
	      (setq scl_x (cadar pl_dt))
	      (setq scl_y (* (caddar pl_dt) ke))
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
  (command "zoom" "E")

)					;        defun scale(layer_name ke)                                                          

(defun ofst (layer_name	       cf1	ce1	 /	  ss_lwpl
	     ss_cnt   i_loop   pl_dt	cx	 xy	  cnt
	     dt	      pl_dt    ofst_x	ofst_y
	    )
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (command "zoom" "E")
  (setq	ss_lwpl
	 (ssget "x" (list (cons 0 "lwpolyline") (cons 8 layer_name)))
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))
	(setq cx 0)
	(setq cy 0)
	(setq cnt 0)
	(setq dt pl_dt)
	(while pl_dt
	  (if (= (caar pl_dt) 10)
	    (progn
	      (setq cx (+ (cadar pl_dt) cx))
	      (setq cy (+ (caddar pl_dt) cy))
	      (setq cnt (1+ cnt))
	    )
	  )
	  (setq pl_dt (cdr pl_dt))
	)
	(setq cx (/ cx cnt))
	(setq cy (/ cy cnt))
	(setq pl_dt dt)
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq ofst_x (cadar pl_dt))
	      (setq ofst_y (caddar pl_dt))
	      (if (> ofst_x cx)
		(setq ofst_x (- ofst_x cf1))
		(setq ofst_x (+ ofst_x cf1))
	      )
	      (if (> ofst_y cy)
		(setq ofst_y (- ofst_y ce1))
		(setq ofst_y (+ ofst_y ce1))
	      )
	      (setq dt
		     (append dt (list (cons 10 (list ofst_x ofst_y 0))))
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
)					;      function()
(defun a_cell ( / s_array_txt s_array_txt_len m txt_table txt_con txt_sub_len aa e_num s_num x_num x_step
	       x_y scell x_num y_num x_step y_step)
  (prompt "/n请选择排版说明文字：")
  (setq s_array_txt (ssget))
  (setq s_array_txt_len (sslength s_array_txt))
  (setq m 0)
  (while (< m s_array_txt_len)
    (progn
      (setq txt_table (entget (ssname s_array_txt m)))
      (setq txt_con (cdr (assoc 1 txt_table)))
      (setq txt_sub_len (strlen txt_con))
      (setq aa (vl-string-search ")" txt_con))
      (if (not aa)
	(progn
	  (setq x_y (substr txt_con 1 1))
	  (if (equal (strcase x_y) "X")
	    (progn
	      (setq e_num (vl-string-search "=" txt_con))
	      (setq s_num (vl-string-search "*" txt_con))
	      (setq x_num (substr txt_con (+ s_num 2)))
	      (setq x_step (substr txt_con
				   (+ e_num 2)
				   (- (- s_num e_num) 1)
			   )
	      )
	    )
	  )
	  (if (equal (strcase x_y) "Y")
	    (progn
	      (setq e_num (vl-string-search "=" txt_con))
	      (setq s_num (vl-string-search "*" txt_con))
	      (setq y_num (substr txt_con (+ s_num 2)))
	      (setq y_step
		     (substr txt_con (+ e_num 2) (- (- s_num e_num) 1))
	      )
	    )
	  )
	)
	
	(progn
	  (setq x_y (substr txt_con 1 1))
	  (if (equal (strcase x_y) "X")
	    (progn
	      (setq e_num (vl-string-search "=" txt_con))
	      (setq s_num (vl-string-search ")" txt_con))
	      (setq x_num (substr txt_con (+ s_num 2)))
	      (setq x_step (substr txt_con
				   (+ e_num 2)
				   (- (- s_num e_num) 1)
			   )
	      )
	    )
	  )
	  (if (equal (strcase x_y) "Y")
	    (progn
	      (setq e_num (vl-string-search ")" txt_con))
	      (setq s_num (vl-string-search "*" txt_con))
	      (setq y_num (substr txt_con (+ s_num 2)))
	      (setq y_step
		     (substr txt_con (+ e_num 2) (- (- s_num e_num) 1))
	      )
	    )
	  )
	)
      )
    )
    (setq m (+ m 1))
  )
  (prompt "/n请选择要排版的单粒：")
  (setq scell (ssget))
  (command "array" scell "" "" y_num x_num y_step x_step "")
)
(defun is_top_pi (/ txt t_table t_p id_c)
  (setq txt (ssget "x" (list (cons 0 "text"))))
  (setq t_table (entget (ssname txt 0)))
  (setq t_p (cdr (assoc 1 t_table)))
  (setq id_c (substr t_p 1 1))
)
(defun s_ent_old (/ ss sc)		;选取所有有效图形放到OK层---旧机
  (command "layer" "n" "ok" "")
  (command "zoom" "e")
  (setq ss (ssget "w" '(-197.5 -204) '(197.5 204)))
  (command "change" ss "" "p" "la" "ok" "")
  (command "layer" "lock" "ok" "")
  (command "erase" "all" "")
  (command "layer" "unlock" "ok" "")
  (command "zoom" "e")
  (command "purge" "la" "" "N")
  (command "layer" "n" "scl" "")
  (setq sc (ssget "c" '(-177.8 -203.2) '(177.8 203.2)))
  (command "change" sc "" "p" "la" "scl" "")
)
(defun s_ent_new (/ ss sc)		;选取所有有效图形放到OK层--新机
  (command "layer" "n" "ok" "")
  (command "zoom" "e")
  (setq ss (ssget "w" '(-230 -275) '(230 275)))
  (command "change" ss "" "p" "la" "ok" "")
  (command "layer" "lock" "ok" "")
  (command "erase" "all" "")
  (command "layer" "unlock" "ok" "")
  (command "zoom" "e")
  (command "purge" "la" "" "N")
  (command "layer" "n" "scl" "")
  (setq sc (ssget "c" '(-185 -235) '(185 235)))
  (command "change" sc "" "p" "la" "scl" "")
)
(defun m_ent_old (/ apr_ld_cn xc yc)	;移动图形中心到零点---旧机
  (setvar "osmode" 2)
  (setq apr_ld_cn (getpoint "\n请点选凸版左下角十字号最左边中心点:"))
  (setvar "osmode" 0)
  (setq xc (+ (car apr_ld_cn) 196.5))
  (setq yc (+ (cadr apr_ld_cn) 190))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "zoom" "e")
)
(defun m_ent_new (/ apr_ld_cn apr_ld_cn xc yc)
					;移动图形中心到零点---新机
  (setvar "osmode" 2)
  (setq
    apr_ld_cn (getpoint
		"\n请点选凸版左边－－最下－－十字号－－最左边中心点:"
	      )
  )
  (setvar "osmode" 0)
  (setq xc (+ (car apr_ld_cn) 215))
  (setq yc (+ (cadr apr_ld_cn) 260))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "zoom" "e")
)
(defun c:byd (/ flag is_new_old get_str id_c)
  (a_cell)
  (setq get_str (getstring "是否要旋转？<保证长方向为Y方向>"))
  (if (= (strcase get_str) "Y")
    (command "rotate" "all" "" "0,0" 90)
  )
  (command "zoom" "e")
  (setq	is_new_old
	 (strcase
	   (getstring "\n请问是新机还是旧机器？<New/Old/Enter>:")
	 )
  )
  (if (= (strcase is_new_old) "N")
    (progn
      (m_ent_new)
      (s_ent_new)
      (setq id_c (is_top_pi))
      (if (= (strcase id_c) "P")
	(setq ke  0.9885
	      ce1 0.125
	      cf1 0.125
	)
	(setq ke  0.9893
	      ce1 0.25
	      cf1 0.175
	)
      )
    )
    (progn
      (m_ent_old)
      (s_ent_old)
      (setq g_st (getstring "\n 是液体版吗?YES/NO (N)："))
      (if (/= (strcase g_st) "Y")
	(progn (setq ke	 0.9782
		     ce1 0.175
		     cf1 0.15
	       )
	)
	(progn
	  (setq id_c (is_top_pi))
	  (if (= (strcase id_c) "P")
	    (setq ke   0.9784
		  ce1  0.175
		  cf1  0.15
		  flag 1
	    )
	    (setq ke  0.9784
		  ce1 0.25
		  cf1 0.25
	    )
	  )

	)
      )
    )
  )
  (setq gt (getstring "\n单粒和箭头是否要镜像?  YES/NO(Y):"))
  (if (/= (strcase gt) "N")
    (progn
      (setq s_mi (ssget "w" '(-208 -258) '(208 258)))
      (command "mirror" s_mi "" "0,0" "9,0" "y")
      (setq ttxt (ssget "x" (list (cons 0 "text"))))
      (command "mirror" ttxt "" "0,0" "9,0" "y")
    )
  )
  (scale "scl" ke)
  (command "layer" "n" "ofst" "")
  (prompt "\n请选中所有单粒！")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "ofst" "")
  (ofst "ofst" cf1 ce1)
					;change text
  (setq ss_txt (ssget "x" (list (cons 0 "TEXT"))))
  (if (= (sslength ss_txt) 1)
    (progn
      (setq txt_dt (entget (ssname ss_txt 0)))
      (setq apr_id (cdr (assoc 1 txt_dt)))
      (setq c_date (getvar "CDATE"))
      (setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
      (setq apr_id (strcase apr_id))
      (setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
      (setq txt_dt
	     (subst (cons 10 '(-500 -500 0)) (assoc 8 txt_dt) txt_dt)
      )
      (entmod txt_dt)
    )
  )
  (if (= is_new_old "N")
    (draw_edge_new)
    (draw_edge_old)
  )
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "lock" "0" "")
  (command "layer" "m" "0" "")
  (command "erase" "all" "")
  (command "layer" "unlock" "0" "")
  (command "zoom" "e")
  (command "purge" "la" "" "N")

  (getstring
    (strcat "2005-03-31 modified by XifengCheng　！请确认系数是：Ke="
	    (rtos ke)
	    "; Ce="
	    (rtos (* 2 ce1))
	    "; Cf="
	    (rtos (* 2 cf1))
    )
  )
  (if (= is_new_old "N")
    (setq ma (getstring "--------此版为新机--------"))
    (setq ma (getstring "--------此版为旧机--------"))
  )
  ;(if (= id_c "P")
   ; (setq p_t (getstring "--------此版为PI版--------"))
   ; (setq p_t (getstring "--------此版为TOP版--------"))
  ;)
)					;程序结束
(PROMPT "\n-----------输入 byd 运行程序！---------")
(prompt "\n---------请把排版数据移到有用层！---------")
(prompt
  "\n---运行程序前请先整理层：0层清除，只保留有效层即可！---"
)
