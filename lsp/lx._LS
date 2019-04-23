

(defun scale (layer_name ke)
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
	      (setq scl_x (* (cadar pl_dt) ke))
	      (setq scl_y (caddar pl_dt))
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
	(setq center (list (* ke (car center)) (cadr center)))
	(setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	(entmod pl_dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "E")

)
					;        defun scale(layer_name ke)                                                          

(defun ofst (layer_name cf1 ce1)
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
)					;      defun ofst (layer_name cf1 ce1)                                                           


(defun draw_edge ()
					;draw edge
  (command "pline"
	   (list -261.988 214.5)
	   "w"
	   0
	   0
	   (list -261.988 212.5)
	   (list -285.0 212.5)
	   (list -285.0 -212.5)
	   (list -261.988 -212.5)
	   (list -261.988 -214.5)
	   (list -287.0 -214.5)
	   (list -287.0 214.5)
	   "c"
  )
  (command "pline"
	   (list 278.984 214.5)
	   "w"
	   0
	   0
	   (list 278.984 212.5)
	   (list 302.0 212.5)
	   (list 302.0 -212.5)
	   (list 278.984 -212.5)
	   (list 278.984 -214.5)
	   (list 304.0 -214.5)
	   (list 304.0 214.5)
	   "c"
  )
  (command "pline"
	   (list -234.5 204.0)
	   "w"
	   0
	   0
	   (list -234.5 200.5)
	   (list -231.0 200.5)
	   (list -231.0 199.5)
	   (list -234.5 199.5)
	   (list -234.5 196.0)
	   (list -235.5 196.0)
	   (list -235.5 199.5)
	   (list -239.0 199.5)
	   (list -239.0 200.5)
	   (list -235.5 200.5)
	   (list -235.5 204.0)
	   "c"
  )
  (command "pline"
	   (list -234.5 -204.0)
	   "w"
	   0
	   0
	   (list -234.5 -200.5)
	   (list -231.0 -200.5)
	   (list -231.0 -199.5)
	   (list -234.5 -199.5)
	   (list -234.5 -196.0)
	   (list -235.5 -196.0)
	   (list -235.5 -199.5)
	   (list -239.0 -199.5)
	   (list -239.0 -200.5)
	   (list -235.5 -200.5)
	   (list -235.5 -204.0)
	   "c"
  )
  (command "circle" (list -277.00432775 200) 1.0 "")
  (command "circle" (list 294 200) 1.0 "")
  (command "circle" (list -277.00432775 -200) 1.0 "")
  (command "circle" (list 294 -200) 1.0 "")
  (command "circle" (list -277.00432775 175) 1.5 "")
  (command "circle" (list -277.00432775 87.5) 1.5 "")
  (command "circle" (list -277.00432775 0) 1.5 "")
  (command "circle" (list -277.00432775 -87.5) 1.5 "")
  (command "circle" (list -277.00432775 -175) 1.5 "")
  (command "circle" (list 294 175) 1.5 "")
  (command "circle" (list 294 87.5) 1.5 "")
  (command "circle" (list 294 0) 1.5 "")
  (command "circle" (list 294 -87.5) 1.5 "")
  (command "circle" (list 294 -175) 1.5 "")
)

(defun is_piapr_top ()
  (setq txt_ss (ssget "X" (list (cons 0 "text"))))
  (setq sslen (sslength txt_ss))
  (if (equal sslen 1)
    (setq txt (ssname txt_ss 0))
  )
  (if txt
    (setq txt_PI (cdr (assoc 1 (entget txt))))
  )
  (setq panduan (strlen txt_PI))
  (while (>= panduan 3)
    (setq is_txt (substr txt_PI 1 3))
    (if	(or (equal is_txt "PI-")
	    (equal is_txt "APR")
	)
      (setq ke	 0.985
	    ce1	 0.15
	    cf1	 0.15
	    flag 1
      )
    )					;endif	     

    (if	(equal is_txt "TOP")
      (setq ke	 0.985
	    ce1	 0.25
	    cf1	 0.25
	    flag 2
      )
    )					;endif


    (setq txt_PI (substr txt_PI 2))
    (setq panduan (strlen txt_PI))
  )
)
					;  (if (<= panduan 16)
					;  (progn	  
					;  (setq is_txt (substr txt_PI 12 3))
					;  (if (equal is_txt "PI-")
					;    (setq ke  0.985
					;	  ce1 0.15
					;	  cf1 0.15
					;   )
					;  )					;endif
					;  (if (equal is_txt "APR")
					;    (setq ke  0.985
					;	  ce1 0.15
					;	  cf1 0.15
					;   )
					;  )
					;endif

					;  (if (equal is_txt "TOP")
					;    (setq ke  0.985
					;	  ce1 0.25
					;	  cf1 0.25
					;   )
					;)
					;)
					;)
					;(setq is_txt (substr txt_PI 13 3))
					;(if (equal is_txt "TOP")
					;  (setq ke  0.985
					;	  ce1 0.25
					;	  cf1 0.25
					;   )
					;)

					;endif
					;)

(defun c:lx ()
  (setvar "osmode" 4)
					;(command "deldim""")
  (setq apr_ito (getpoint "/n请点选凸版左下角(有三个圆)的圆心"))
  (setvar "osmode" 0)
  (setq xc (+ (car apr_ito) 85))
  (setq yc (+ (cadr apr_ito) 175))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "mirror" "all" "" "0,0" "0,9" "y")
  (command "layer" "lock" "apr" "")
  (command "layer" "lock" "top" "")
  (command "layer" "lock" "PI" "")
  (command "erase" "all" "")
  (command "purge" "all" "" "n")
  (command "zoom" "e")
  (command "layer" "unlock" "apr" "")
  (command "layer" "unlock" "top" "")
  (command "layer" "unlock" "PI" "")
  (command "layer" "n" "scale" "")
  (setq ss (ssget "w" '(-237 -179) '(237 179)))
  (command "change" ss "" "p" "la" "scale" "")
  (is_piapr_top)
  (scale "scale" ke)
  (command "layer" "n" "ofst" "")
  (prompt "/n请选中所有单粒！")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "ofst" "")
  (ofst "ofst" cf1 ce1)
					;change text
  (setq ss_txt (ssget "x" (list (cons 0 "TEXT"))))
  (command "mirror" ss_txt "" "0,0" "0,9" "y")
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
  (draw_edge)
  (setq ss_all (ssget"w" '(-284 -212)'(284 212)))
  (command "change" ss_all "" "p" "la" "0" "")
  (command "layer" "lock""0""")
  (command "erase" "all" "")
  (command "layer""unlock""0""")
  (command "layer" "m" "0" "")
  (command "purge" "all" "" "N")
  (command "purge" "all" "" "n")
  (command "purge" "all" "" "N")
  (command "purge" "all" "" "n")
  (command "zoom" "E")
  (if (equal flag 1)
    (getstring (strcat "请确认系数是：Ke="
		       (rtos ke)
		       "; Ce="
		       (rtos (* 2 ce1))
		       "; Cf="
		       (rtos (* 2 cf1))
		       "---PI版"
	       )
    )

  )
  (if (equal flag 2)
    (getstring (strcat "请确认系数是：Ke="
		       (rtos ke)
		       "; Ce="
		       (rtos (* 2 ce1))
		       "; Cf="
		       (rtos (* 2 cf1))
		       "---TOP版"
	       )
    )
  )
  (getstring "/n请手工作cut!")
)
(PROMPT "\n 输入 lx 运行程序")



