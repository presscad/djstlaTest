					;(defun C:CELLS()
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)
(defun C:kh ()

  (set_var)				;设置系数
  (prompt "\n 请选中全部单粒 ")
  (setq s (ssget))
  (setq num (sslength s))
  (setq count 1)
  (vl-load-com)
  (setq pl_name (ssname s 0))
  (setq ent_obj (vlax-ename->vla-object pl_name))
  (vla-getboundingbox ent_obj 'ld 'ru)
  (setq ld (vlax-safearray->list ld))
  (setq ru (vlax-safearray->list ru))
  (setq max_x (car ru))
  (setq max_y (cadr ru))
  (setq min_x (car ld))
  (setq min_y (cadr ld))
  (setq count (1+ count))
  (vlax-release-object ent_obj)
  (while (< count num)
    (setq pl_name (ssname s count))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'ru)
    (setq ld (vlax-safearray->list ld))
    (setq ru (vlax-safearray->list ru))
    (setq max_x (max (car ru) max_x))
    (setq max_y (max (cadr ru) max_y))
    (setq min_x (min (car ld) min_x))
    (setq min_y (min (cadr ld) min_y))
    (setq count (1+ count))
    (vlax-release-object ent_obj)
  )
  (setq	mid_pt (list (/ (+ max_x min_x) 2)
		     (/ (+ max_y min_y) 2)
		     0
	       )
  )
  (command "move" s "" mid_pt "0,0")
  (setq layer_name "")
  (while (not (tblsearch "layer" layer_name))
    (setq layer_name (getstring "请输入层名:"))
  )
  (setq
    s_lwpl (ssget "x"
		  (list (cons 0 "lwpolyline") (cons 8 layer_name))
	   )
  )
  (if s_lwpl
    (progn
      (setq s_cnt (sslength s_lwpl))
      (setq i_loop 0)
      (while (< i_loop s_cnt)
	(setq pl_dt (entget (ssname s_lwpl i_loop)))
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq scl_x (cadar pl_dt))
	      (setq scl_y (* (caddar pl_dt) 0.986))
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
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline") (cons 8 layer_name))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (setq pl_dt nil)
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
		(setq ofst_x (- ofst_x 0.075))
		(setq ofst_x (+ ofst_x 0.075))
	      )
	      (if (> ofst_y cy)
		(setq ofst_y (- ofst_y 0.075))
		(setq ofst_y (+ ofst_y 0.075))
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
  (setq dt (subst (cons 8 "0") (assoc 8 dt) dt))
  (setq
    a_lwpl (ssget "x"
		  (list (cons 0 "lwpolyline") (cons 8 layer_name))
	   )
  )
  (setq num (sslength a_lwpl))
  (setq count 0)
  (setq max_x 0.0)
  (setq max_y 0.0)
  (setq min_x 0.0)
  (setq min_y 0.0)
  (vl-load-com)
  (while (< count num)
    (setq pl_name (ssname s count))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'rd)
    (setq ld (vlax-safearray->list ld))
    (setq rd (vlax-safearray->list rd))
    (setq max_x (max (car rd) max_x))
    (setq max_y (max (cadr rd) max_y))
    (setq min_x (min (car ld) min_x))
    (setq min_y (min (cadr ld) min_y))
    (setq count (1+ count))
  )
  (vlax-release-object ent_obj)
  (setq max_xa (+ max_x 5))
  (setq max_ya (+ max_y 5))
  (setq min_xa (- min_x 5))
  (setq min_ya (- min_y 5))
  (setq max_xb (+ max_xa 8))
  (setq max_yb (+ max_ya 8))
  (setq min_xb (- min_xa 8))
  (setq min_yb (- min_ya 8))
  (if (> max_xb 174.4)
    (progn
      (command "pline"
	       (list min_xb 4)
	       "w"
	       0
	       0
	       (list min_xb max_yb)
	       (list max_xb max_yb)
	       (list max_xb 4)
	       (list max_xa 4)
	       (list max_xa max_ya)
	       (list min_xa max_ya)
	       (list min_xa 4)
	       "c"
      )
      (command "pline"
	       (list min_xb -4)
	       "w"
	       0
	       0
	       (list min_xb min_yb)
	       (list max_xb min_yb)
	       (list max_xb -4)
	       (list max_xa -4)
	       (list max_xa min_ya)
	       (list min_xa min_ya)
	       (list min_xa -4)
	       "c"
      )
    )
    (command "pline"
	     (list min_xb 0)
	     "w"
	     0
	     0
	     (list min_xb max_yb)
	     (list max_xb max_yb)
	     (list max_xb min_yb)
	     (list min_xb min_yb)
	     (list min_xb 0)
	     (list min_xa 0)
	     (list min_xa min_ya)
	     (list max_xa min_ya)
	     (list max_xa max_ya)
	     (list min_xa max_ya)
	     (list min_xa 0)
	     "c"
    )
  )
  (command "pline"
	   (list 185.0 201.0)
	   "w"
	   0
	   0
	   (list 189.0 201.0)
	   (list 189.0 197.0)
	   (list 191.0 197.0)
	   (list 191.0 201.0)
	   (list 195.0 201.0)
	   (list 195.0 203.0)
	   (list 191.0 203.0)
	   (list 191.0 207.0)
	   (list 189.0 207.0)
	   (list 189.0 203.0)
	   (list 185.0 203.0)
	   "c"
  )
  (command "pline"
	   (list -195.0 201.0)
	   "w"
	   0
	   0
	   (list -191.0 201.0)
	   (list -191.0 197.0)
	   (list -189.0 197.0)
	   (list -189.0 201.0)
	   (list -185.0 201.0)
	   (list -185.0 203.0)
	   (list -189.0 203.0)
	   (list -189.0 207.0)
	   (list -191.0 207.0)
	   (list -191.0 203.0)
	   (list -195.0 203.0)
	   "c"
  )
  (command "pline"
	   (list -203.0 256.5)
	   "w"
	   0
	   0
	   (list 203.0 256.5)
	   (list 203.0 261.5)
	   (list -203.0 261.5)
	   "c"
  )
  (command "pline"
	   (list 185.0 -4.0)
	   "w"
	   0
	   0
	   (list 189.0 -4.0)
	   (list 189.0 -8.0)
	   (list 191.0 -8.0)
	   (list 191.0 -4.0)
	   (list 195.0 -4.0)
	   (list 195.0 -2.0)
	   (list 191.0 -2.0)
	   (list 191.0 2.0)
	   (list 189.0 2.0)
	   (list 189.0 -2.0)
	   (list 185.0 -2.0)
	   "c"
  )
  (command "pline"
	   (list 185.0 -209.0)
	   "w"
	   0
	   0
	   (list 189.0 -209.0)
	   (list 189.0 -213.0)
	   (list 191.0 -213.0)
	   (list 191.0 -209.0)
	   (list 195.0 -209.0)
	   (list 195.0 -207.0)
	   (list 191.0 -207.0)
	   (list 191.0 -203.0)
	   (list 189.0 -203.0)
	   (list 189.0 -207.0)
	   (list 185.0 -207.0)
	   "c"
  )
  (command "pline"
	   (list -195.0 -4.0)
	   "w"
	   0
	   0
	   (list -191.0 -4.0)
	   (list -191.0 -8.0)
	   (list -189.0 -8.0)
	   (list -189.0 -4.0)
	   (list -185.0 -4.0)
	   (list -185.0 -2.0)
	   (list -189.0 -2.0)
	   (list -189.0 2.0)
	   (list -191.0 2.0)
	   (list -191.0 -2.0)
	   (list -195.0 -2.0)
	   "c"
  )
  (command "pline"
	   (list -195.0 -209.0)
	   "w"
	   0
	   0
	   (list -191.0 -209.0)
	   (list -191.0 -213.0)
	   (list -189.0 -213.0)
	   (list -189.0 -209.0)
	   (list -185.0 -209.0)
	   (list -185.0 -207.0)
	   (list -189.0 -207.0)
	   (list -189.0 -203.0)
	   (list -191.0 -203.0)
	   (list -191.0 -207.0)
	   (list -195.0 -207.0)
	   "c"
  )
  (command "pline"
	   (list -203.0 -261.5)
	   "w"
	   0
	   0
	   (list 203.0 -261.5)
	   (list 203.0 -256.5)
	   (list -203.0 -256.5)
	   "c"
  )
  (command "circle"
	   (list -175.8 -0.4)
	   0.175
  )
  (command "circle"
	   (list -175.8 0.4)
	   0.3
  )
  (command "circle"
	   (list -175.8 0.4)
	   0.4
  )
  (command "circle"
	   (list 175.8 -0.4)
	   0.3
  )
  (command "circle"
	   (list 175.8 -0.4)
	   0.4
  )
  (command "circle"
	   (list 175.8 0.4)
	   0.175
  )
  (prompt "\n 请选中要处理的文字 ")
  (setq ss_txt (ssget))
;;;  (command "-style" "txt" "txt" "6.0" "1.0" "" "y" "" "")
;;;  (setq txt (strcase (getstring T "请输入产品型号: ")))
;;;  (setq txt (strcat txt " QINGYI " (itoa (Fix (getvar "CDATE")))))
;;;  (setq text (strcase txt))
;;;  (command "text" (list -134.1416) 0 text)
  (if (= (sslength ss_txt) 1)
    (progn
      (setq txt_dt (entget (ssname ss_txt 0)))
      (setq txt_dt (subst (cons 8 "0") (assoc 8 txt_dt) txt_dt))
;;;      (setq txt_dt (subst (cons 40 6.0) (assoc 40 txt_dt) txt_dt))
      (setq apr_id (cdr (assoc 1 txt_dt)))
      (setq c_date (getvar "CDATE"))
      (setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
      (setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
      (setq txt_dt
	     (append txt_dt (list (cons 11 (list 2.3584 229.3931 0))))
      )
      (entmod txt_dt)
    )
  )
  (terpri)
)
(prompt
  "\n 请先将所有单粒闭合!并使图形的Y方向为印刷方向!再运行kh!"
)
