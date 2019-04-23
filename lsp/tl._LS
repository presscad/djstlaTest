(defun draw_edge ()
  (command "pline"
	   (list 263.2 -212.0)
	   "w"
	   0
	   0
	   (list 263.2 -210.0)
	   (list 278.2 -210.0)
	   (list 278.2 210.0)
	   (list 263.2 210.0)
	   (list 263.2 212.0)
	   (list 280.2 212.0)
	   (list 280.2 -212.0)
	   "c"
  )
  (command "pline"
	   (list -216.8 212.0)
	   "w"
	   0
	   0
	   (list -216.8 210.0)
	   (list 228.2 210.0)
	   (list 228.2 212.0)
	   "c"
  )
  (command "pline"
	   (list -216.8 -210.0)
	   "w"
	   0
	   0
	   (list -216.8 -212.0)
	   (list 228.2 -212.0)
	   (list 228.2 -210.0)
	   "c"
  )
  (command "pline"
	   (list -246.8 210.0)
	   "w"
	   0
	   0
	   (list -246.8 212.0)
	   (list -263.8 212.0)
	   (list -263.8 -212.0)
	   (list -246.8 -212.0)
	   (list -246.8 -210.0)
	   (list -261.8 -210.0)
	   (list -261.8 210.0)
	   "c"
  )
  (command "pline"
	   (list 209.95 -192.5)
	   "w"
	   0
	   0
	   (list 209.95 -207.5)
	   (list 210.45 -207.5)
	   (list 210.45 -192.5)
	   "c"
  )
  (command "pline"
	   (list 200.2 -200.25)
	   "w"
	   0
	   0
	   (list 215.2 -200.25)
	   (list 215.2 -199.75)
	   (list 200.2 -199.75)
	   "c"
  )
  (command "pline"
	   (list 209.95 207.5)
	   "w"
	   0
	   0
	   (list 209.95 192.5)
	   (list 210.45 192.5)
	   (list 210.45 207.5)
	   "c"
  )
  (command "pline"
	   (list 200.2 199.75)
	   "w"
	   0
	   0
	   (list 215.2 199.75)
	   (list 215.2 200.25)
	   (list 200.2 200.25)
	   "c"
  )
  (command "pline"
	   (list -206.8 -199.75)
	   "w"
	   0
	   0
	   (list -216.8 -199.75)
	   (list -216.8 -200.25)
	   (list -206.8 -200.25)
	   "c"
  )
  (command "pline"
	   (list -206.8 200.25)
	   "w"
	   0
	   0
	   (list -216.8 200.25)
	   (list -216.8 199.75)
	   (list -206.8 199.75)
	   "c"
  )
)
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
  (setq ss_lwpl nil)
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
	(setq
	  center (list (* ke (car center)) (cadr center))
	)
	(setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	(entmod pl_dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "E")

)					;        defun scale(layer_name ke)                                                          
(defun ofst (layer_name ce1 cf1)
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
		(setq ofst_x (- ofst_x ce1))
		(setq ofst_x (+ ofst_x ce1))
	      )
	      (if (> ofst_y cy)
		(setq ofst_y (- ofst_y cf1))
		(setq ofst_y (+ ofst_y cf1))
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
(defun is_pi_top (c_txt)
  (setq txt_ss (ssname c_txt 0))
  (setq txt_apr (cdr (assoc 1 (entget txt_ss))))
  (setq txt_len (strlen txt_apr))
  (setq txt_ty (substr txt_apr (- txt_len 1) 1))
  (setq	ke
	 (cond
	   ((= txt_ty "E") 0.988)
	   ((= txt_ty "e") 0.988)
	   ((= txt_ty "T") 0.9872)
	   ((= txt_ty "t") 0.9872)
	   (t nil)
	 )
  )
)

(defun c:tl (/ apr_ld_cn xc yc txt ss ke ce cf cells ss_txt txt_dt apr_id)
  (setvar "osmode" 1)
  (setq apr_ld_cn (getpoint " \n请点选凸版ITO的左下角:"))
  (setvar "osmode" 0)
  (setq xc (+ (car apr_ld_cn) 203.2))
  (setq yc (+ (cadr apr_ld_cn) 177.8))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "layer" "on" "*" "thaw" "*" "unlock" "*" "")
  (command "layer" "n" "ok" "")
  (command "zoom" "e")
  (setq txt (ssget "w" '(0 0) '(228 -240)))
  (setq txt (ssget "P" (list (cons 0 "text"))))
  (command "zoom" "w" '(-203.2 -177.8) '(203.2 177.8))
  (setq ss (ssget "w" '(-203 -177) '(203 177)))
  (command "zoom" "e")
  (if (not txt)
    (prompt "\n没找到文字 请确认:")
    (progn
      (command "change" ss txt "" "p" "la" "ok" "")
      (command "layer" "lock" "ok" "")
      (command "clear" "")
      (command "layer" "unlock" "ok" "")
      (is_pi_top txt)
      (if (not ke)
	(prompt "\n给出的文字无法识TOP或PI 请确认:")
	(progn
	  (scale "ok" ke)
	  (if (= ke 0.988)
	    (setq ce 0.15
		  cf 0.1
	    )
	    (setq ce 0.05
		  cf 0
	    )
	  )
	  (prompt "\n请选中所有单粒！")
	  (setq cells (ssget))
	  (command "layer" "n" "ofst" "")
	  (command "change" cells "" "p" "la" "ofst" "")
	  (ofst "ofst" ce cf)
					;change text
	  (setq ss_txt (ssget "x" (list (cons 0 "TEXT"))))
	  (if (= (sslength ss_txt) 1)
	    (progn
	      (setq txt_dt (entget (ssname ss_txt 0)))
	      (setq apr_id (cdr (assoc 1 txt_dt)))
	      (setq c_date (getvar "CDATE"))
	      (setq
		apr_id (strcat apr_id " QINGYI " (itoa (fix c_date)))
	      )
	      (setq apr_id (strcase apr_id))
	      (setq
		txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt)
	      )
	      (setq txt_dt
		     (subst (cons 10 '(-4.1868 -203.503 0))
			    (assoc 10 txt_dt)
			    txt_dt
		     )
	      )
	      (entmod txt_dt)
	    )
	  )
	  (draw_edge)

	  (command "change" "all" "" "p" "la" "0" "")
	  (command "layer" "m" "0" "")
	  (command "purge" "all" "" "N")
	  (command "purge" "all" "" "n")
	  (command "purge" "all" "" "N")
	  (command "purge" "all" "" "n")
	  (command "zoom" "E")
	  (getstring
	    (strcat "2005-06-25 writen by LiJuFeng 请确认系数是：Ke="
		    (rtos ke)
		    "; Ce="
		    (rtos (* 2 ce))
		    "; Cf="
		    (rtos (* 2 cf))
	    )
	  )
  
	)
      )
    )
  )
  (alert"如有CUT关系，请手工做CUT!!!!!")
)
(PROMPT "\n 输入 tl 运行程序")


