
(defun c:jlapr ()
  (defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  (defun draw_edge ()
    (command "pline"
	     (list 342.1 189.172)
	     "w"
	     0
	     0
	     (list 341.1 189.172)
	     (list 341.1 204.172)
	     (list 342.1 204.172)
	     "c"
    )
    (command "pline"
	     (list 341.1 1.03272)
	     "w"
	     0
	     0
	     (list 342.1 1.03289)
	     (list 342.1 -5.9672)
	     (list 349.135 -5.9672)
	     (list 349.135 -6.9672)
	     (list 342.1 -6.9672)
	     (list 342.1 -13.9671)
	     (list 341.1 -13.9673)
	     (list 341.1 -6.9672)
	     (list 334.135 -6.9672)
	     (list 334.135 -5.9672)
	     (list 341.1 -5.9672)
	     "c"
    )
    (command "pline"
	     (list 384.0 -15.0772)
	     "w"
	     0
	     0
	     (list 382.0 -15.0772)
	     (list 382.0 208.343)
	     (list 384.0 208.343)
	     "c"
    )
    (command "pline"
	     (list -14.5 189.233)
	     "w"
	     0
	     0
	     (list -14.5 204.233)
	     (list -13.5 204.233)
	     (list -13.5 189.233)
	     "c"
    )
    (command "pline"
	     (list -13.5 1.03272)
	     "w"
	     0
	     0
	     (list -14.5 1.03289)
	     (list -14.5 -5.9672)
	     (list -21.5345 -5.9672)
	     (list -21.5347 -6.9672)
	     (list -14.5 -6.9672)
	     (list -14.5 -13.9671)
	     (list -13.5 -13.9673)
	     (list -13.5 -6.9672)
	     (list -6.53467 -6.9672)
	     (list -6.5345 -5.9672)
	     (list -13.5 -5.9672)
	     "c"
    )
    (command "pline"
	     (list -26.4 208.343)
	     "w"
	     0
	     0
	     (list -26.4 -15.0772)
	     (list -24.4 -15.0772)
	     (list -24.4 208.343)
	     "c"
    )
    (command "pline"
	     (list -26.4 -36.7972)
	     "w"
	     0
	     0
	     (list -24.4 -36.7972)
	     (list -24.4 -55.7972)
	     (list -24.4 -55.7972)
	     (list 382.0 -55.7972)
	     (list 382.0 -36.7972)
	     (list 384.0 -36.7972)
	     (list 384.0 -57.7972)
	     (list 382.0 -57.7972)
	     (list -26.4 -57.7972)
	     (list -26.4 -57.7972)
	     (list -26.4 -57.7972)
	     "c"
    )
    (command "pline"
	     (list 382.0 249.063)
	     "w"
	     0
	     0
	     (list 382.0 230.063)
	     (list 384.0 230.063)
	     (list 384.0 251.063)
	     (list -26.4 251.063)
	     (list -26.4 230.063)
	     (list -24.4 230.063)
	     (list -24.4 249.063)
	     "c"
    )
  )
  (defun to_0 ()
    (command "zoom" "E")
    (setq f16x14
	   (ssget "x"
		  (list (cons 0 "*POLYLINE") (cons 8 "0") (cons 90 4))
	   )
    )
    (if	(= (sslength F16X14) 1)
      (progn
	(setq pl_dt (entget (ssname f16x14 0)))
	(while (/= (caar pl_dt) 10)
	  (setq pl_dt (cdr pl_dt))
	)
	(setq mid_x (car (get_dt_vl 10 pl_dt)))
	(setq mid_y (cadr (get_dt_vl 10 pl_dt)))
	(setq pl_dt (cdr pl_dt))
	(while (/= (caar pl_dt) 10)
	  (setq pl_dt (cdr pl_dt))
	)
	(setq mid_x (+ mid_x (car (get_dt_vl 10 pl_dt))))
	(setq mid_y (+ mid_y (cadr (get_dt_vl 10 pl_dt))))
	(setq pl_dt (cdr pl_dt))
	(while (/= (caar pl_dt) 10)
	  (setq pl_dt (cdr pl_dt))
	)
	(setq mid_x (+ mid_x (car (get_dt_vl 10 pl_dt))))
	(setq mid_y (+ mid_y (cadr (get_dt_vl 10 pl_dt))))
	(setq pl_dt (cdr pl_dt))
	(while (/= (caar pl_dt) 10)
	  (setq pl_dt (cdr pl_dt))
	)
	(setq mid_x (+ mid_x (car (get_dt_vl 10 pl_dt))))
	(setq mid_y (+ mid_y (cadr (get_dt_vl 10 pl_dt))))
	(setq mid_x (/ mid_x 4))
	(setq mid_y (/ mid_y 4))
	(command "move" "all" "" (list mid_x mid_y) "0,0")
	(command "mirror" "all" "" "0,0" "100,0" "Y")
	(command "layer" "M" "scl" "")
	(command "zoom" "E")
	(setq scl_set (ssget "w" '(-176 -100) '(176 100)
			     )
		      )
	(if scl_set
	  (command "change" scl_set "" "p" "la" "scl" "")
	)

	(command "move" "all" "" "0,0" "163.8,95.1")
	(command "zoom" "E")
      )
      (progn
	(prompt "\ncan't find the polyline in 0 layer ")
	(exit)
      )
    )

  )

  (defun chg_txt ()
    (setq pt_lst (list
		   (list 70 -19)
		   (list 171 -19)
		   (list 171 -4)
		   (list 70 -4)
		 )
    )
    (setq
      ss_txt (ssget "WP" pt_lst (list (cons 0 "TEXT")))
    )
    (if	(= (sslength ss_txt) 1)
      (progn
	(setq txt_dt (entget (ssname ss_txt 0)))
	(setq alg_left (get_dt_vl 10 txt_dt))
	(setq alg_left (list (- (car alg_left) 10) (cadr alg_left) 0))
	(setq alg_right (get_dt_vl 11 txt_dt))
	(setq alg_right (list (+ (car alg_right) 30 ) (cadr alg_right) 0))
	(setq txt_dt (subst (cons 10 alg_left) (assoc 10 txt_dt) txt_dt))
	(setq txt_dt (subst (cons 11 alg_right) (assoc 11 txt_dt) txt_dt))
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
	(entmod txt_dt)
      )
      (PROMPT "/n请手工处理文件")
    )
  )

  (defun scale (layer_name ke)
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x"
		     (list (cons 0 "lwpolyline") (cons 8 layer_name))
	      )
    )
    (if	ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	  (setq dt nil)
	  (while pl_dt
	    (if	(/= (caar pl_dt) 10)
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
    ))
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x" (list (cons 0 "circle") (cons 8 layer_name)))
    )
    (if	ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	  (setq cx (* (cadr (assoc 10 pl_dt)) ke))
	  (if (or (< cx -192) (> cx 192))
	    (if	(> cx 0)
	      (setq cx (- cx 0.048))
	      (setq cx (+ cx 0.048))
	    )
	    (progn
	      (setq cr (cdr (assoc 40 pl_dt)))
	      (setq
		pl_dt
		 (subst (cons 40 (+ cr 0.115)) (cons 40 cr) pl_dt)
	      )
	    )
	  )
	  (setq yx (caddr (assoc 10 pl_dt)))
	  (setq
	    dt (subst (cons 10 (list cx yx 0)) (assoc 10 pl_dt) pl_dt)
	  )
	  (setq dt (subst (cons 8 "OK") (assoc 8 pl_dt) dt))
	  (entmake dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
  )
  (defun ofst (layer_name cf1 ce1)
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x"
		     (list (cons 0 "lwpolyline") (cons 8 layer_name))
	      )
    )
    (if	ss_lwpl
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
	    (if	(= (caar pl_dt) 10)
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
	    (if	(/= (caar pl_dt) 10)
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
  )
  (set_var)
  (setq	ke 0.9672
	ce 0.5000
	cf 0.3000
  )
  (command "zoom" "E")
  (to_0)
  (scale "scl" ke)
  (command "layer" "M" "ofst" "")
  (prompt "/n请选中所有单粒！")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "ofst" "")
  (ofst "ofst" (/ cf 2.0) (/ ce 2.0))
  (setq e_set (ssget "x" (list (cons 8 "0"))))
  (command "erase" e_set "" )
  (command "layer" "m" "out_dm" "color" "red" "" "")
  (prompt "/n请选外面的DUMMY！")
  (setq cells (ssget ":s"))
  (command "change" cells "" "p" "la" "out_dm" "")
  (command "layer" "m" "in_dm" "color" "green" "" "")
    (prompt "/n请选里面的DUMMY！")
  (setq cells (ssget ":s"))
  (command "change" cells "" "p" "la" "in_dm" "")
  (ofst "out_dm" (/ cf 2.0) (/ ce 2.0))
  (ofst "in_dm" (/ cf -2.0) (/ ce -2.0))
  (draw_edge)
  (command "zoom" "E")
  (chg_txt)
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "m" "0" "")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "zoom" "E")
  (getstring "程序已经对DUMMY做了补偿,不需再手工补偿,请手工运行cut及t2l!")
)
(PROMPT "\n 输入 JLAPR 运行程序。")
