
(defun c:gdsapr	()
  (defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )
  (defun draw_edge ()
    (command "layer" "m" "OK" "")
    (command "pline"
	     (list -234.6 -199.5)
	     "w"
	     0
	     0
	     (list -283.5 -199.5)
	     (list -283.5 -152.867)
	     (list -281.5 -152.867)
	     (list -281.5 -197.5)
	     (list -234.6 -197.5)
	     "c"
    )
    (command "pline"
	     (list -281.5 152.566)
	     "w"
	     0
	     0
	     (list -281.5 197.5)
	     (list -234.6 197.5)
	     (list -234.6 199.5)
	     (list -283.5 199.5)
	     (list -283.5 152.566)
	     "c"
    )
    (command "pline"
	     (list 225.8 -197.5)
	     "w"
	     0
	     0
	     (list 276.5 -197.5)
	     (list 276.5 -152.867)
	     (list 278.5 -152.867)
	     (list 278.5 -199.5)
	     (list 225.8 -199.5)
	     "c"
    )
    (command "pline"
	     (list 276.5 152.566)
	     "w"
	     0
	     0
	     (list 276.5 197.5)
	     (list 225.8 197.5)
	     (list 225.8 199.5)
	     (list 278.5 199.5)
	     (list 278.5 152.566)
	     "c"
    )
    (command "pline"
	     (list 188.0 190.0)
	     "w"
	     0
	     0
	     (list 188.7 190.5)
	     (list 202.3 190.5)
	     (list 203.0 190.0)
	     (list 202.3 189.5)
	     (list 188.7 189.5)
	     "c"
    )
    (command "pline"
	     (list -196.0 196.8)
	     "w"
	     0
	     0
	     (list -196.0 190.5)
	     (list -202.3 190.5)
	     (list -203.0 190.0)
	     (list -202.3 189.5)
	     (list -196.0 189.5)
	     (list -196.0 183.2)
	     (list -195.5 182.5)
	     (list -195.0 183.2)
	     (list -195.0 189.5)
	     (list -188.7 189.5)
	     (list -188.0 190.0)
	     (list -188.7 190.5)
	     (list -195.0 190.5)
	     (list -195.0 196.8)
	     (list -195.5 197.5)
	     "c"
    )
    (command "pline"
	     (list 188.0 -190.0)
	     "w"
	     0
	     0
	     (list 188.7 -190.5)
	     (list 202.3 -190.5)
	     (list 203.0 -190.0)
	     (list 202.3 -189.5)
	     (list 188.7 -189.5)
	     "c"
    )
    (command "pline"
	     (list -196.0 -196.8)
	     "w"
	     0
	     0
	     (list -196.0 -190.5)
	     (list -202.3 -190.5)
	     (list -203.0 -190.0)
	     (list -202.3 -189.5)
	     (list -196.0 -189.5)
	     (list -196.0 -183.2)
	     (list -195.5 -182.5)
	     (list -195.0 -183.2)
	     (list -195.0 -189.5)
	     (list -188.7 -189.5)
	     (list -188.0 -190.0)
	     (list -188.7 -190.5)
	     (list -195.0 -190.5)
	     (list -195.0 -196.8)
	     (list -195.5 -197.5)
	     "c"
    )
  )
  (defun to_0 ()
    (command "zoom" "E")
    (setq
      4c (ssget	"x"
		(list (cons 0 "CIRCLE") (cons 8 "2") (cons 40 2.0))
	 )
    )
    (if	(= (sslength 4c) 4)
      (progn
	(setq i_loop 0)
	(setq xc 0)
	(setq yc 0)
	(repeat	4
	  (setq circle_dt (entget (ssname 4c i_loop)))
	  (setq xc (+ xc (car (cdr (assoc 10 circle_dt)))))
	  (setq yc (+ yc (cadr (cdr (assoc 10 circle_dt)))))
	  (setq i_loop (1+ i_loop))
	)
	(setq xc (/ xc 4))
	(setq yc (/ yc 4))
      )
    )
    (command "move" "all" "" (list xc yc) "0,0")
  )

  (defun chg_txt ()
    (setq
      4c (ssget	"x"
		(list (cons 0 "CIRCLE") (cons 8 "2") (cons 40 2.0))
	 )
    )
    (if	(= (sslength 4c) 4)
      (progn
	(setq i_loop 0)
	(setq xc 0)
	(setq yc 0)
	(repeat	4
	  (setq circle_dt (entget (ssname 4c i_loop)))
	  (setq xc (+ xc (car (cdr (assoc 10 circle_dt)))))
	  (setq yc (+ yc (cadr (cdr (assoc 10 circle_dt)))))
	  (setq i_loop (1+ i_loop))
	)
	(setq xc (/ xc 4))
	(setq yc (/ yc 4))
      )
    )
    (setq pt_lst (list
		   (list (- xc 250) (- yc 200))
		   (list (+ xc 250) (- yc 200))
		   (list (+ xc 250) (+ yc 200))
		   (list (- xc 250) (+ yc 200))
		 )
    )
    (command "zoom" "E")
    (setq
      ss_txt (ssget "WP" pt_lst (list (cons 0 "TEXT") (cons 8 "1")))
    )
    (if	(= (sslength ss_txt) 1)
      (progn
	(setq txt_dt (entget (ssname ss_txt 0)))
	(setq txt_dt (subst (cons 8 "OK") (assoc 8 txt_dt) txt_dt))
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
	(setq txt_dt (subst (cons 41 1) (assoc 41 txt_dt) txt_dt))
	(setq txt_dt (subst (cons 40 10) (assoc 40 txt_dt) txt_dt))
	(entmake txt_dt)
      )
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
		(setq scl_x (* (cadar pl_dt) ke))
		(setq scl_y (caddar pl_dt))
		(setq
		  dt (append dt (list (cons 10 (list scl_x scl_y 0))))
		)
	      )
	    )
	    (setq pl_dt (cdr pl_dt))
	  )
	  (setq dt (subst (cons 8 "OK") (cons 8 layer_name) dt))
	  (entmake dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
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
	   (if (> cx 0)
	     (setq cx (- cx 0.048))
	     (setq cx (+ cx 0.048))
	   )
	   (progn
	     (setq cr (cdr (assoc 40 pl_dt)))
	     (setq
	       pl_dt (subst (cons 40 (+ cr 0.115)) (cons 40 cr) pl_dt)
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
  (defun ofst (layer_name ce)
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
		  (setq ofst_x (- ofst_x ce))
		  (setq ofst_x (+ ofst_x ce))
		)
		(if (> ofst_y cy)
		  (setq ofst_y (- ofst_y ce))
		  (setq ofst_y (+ ofst_y ce))
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
  (setq	ke 0.97800
	ce 0.23000
  )
  (command "zoom" "E")
  (setq	4c (ssget "x"
		  (list (cons 0 "CIRCLE") (cons 8 "1") (cons 40 2.0))
	   )
  )
  (if 4c
    (command "change" 4c "" "p" "la" "2" "")
    (progn
      ("\n 不能发现1层的4个半径为2mm圆，如在其它层发现，请手工将其放入一层。")
      (exit)
    )
  )
  (chg_txt)
  (command "layer" "M" "0" "F" "2" "F" "5" "F" "OK" "")
  (command "erase" "all" "")
  (command "layer" "T" "2" "T" "5" "T" "OK" "")
  (to_0)
  (command "zoom" "E")
  (scale "5" ke)
  (ofst "OK" (/ ce 2))
  (scale "2" ke)
  (draw_edge)
  (command "zoom" "E")
  (command "layer" "M" "0" "F" "OK" "")
  (command "erase" "all" "")
  (command "layer" "M" "0" "T" "OK" "")
  (command "change" "all" "" "p" "la" "0" "")
  (command "purge"     "all" ""	   "N"	)
  (command "purge"     "all" ""	   "N"  )
  (command "purge" "all" "" "n" )
  (command "purge" "all" "" "n")
  (command "zoom" "E")
  (setq	4c (ssget "x"
		  (list (cons 0 "CIRCLE"))
	   )
  )
  (if 4c
    (progn
      (command "layer" "N" "0C" "")
      (command "change" 4c "" "p" "la" "0c" "")
    )
    (progn
      ("\n Can't find the 4 circle")
      (exit)
    )
  )
)
(PROMPT "\n 输入 GDSAPR 运行程序。")
