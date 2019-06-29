;--------------------------------------------------

  (defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )
;--------------------------------------------------
(defun chkline(ss_ent )     ;检测要收缩的图形有没有未闭合的单线
  (setq ss_ent(ssget"p"(list(cons 0 "line"))))
  (if ss_ent
    (progn
    (alert "要收缩的图形有未闭合的单线，请先将单线闭合!")
    (exit)
    )
  )
)
;--------------------------------------------------

		          
;--------------------------------------------------
  (defun c:apr_scale ()
    (set_var)
    (command "zoom" "E")
    (initget 1 "S O A ALL")
    (setq ss_key (getkword "\n请选择选图形的方式：\nSelect object/One layer/<All>"))
    (if	(and(/= (strcase ss_key) "A")
	   (/= (strcase ss_key) "ALL")
	)
      (progn
	(if (equal (strcase ss_key) "S")
	  (progn
	  (setq ss_lwpl(ssget))
	  )  
	  (progn
	    (setq layer_name "")
	    (while (not (tblsearch "layer" layer_name))
	      (progn
		(setq layer_name (getstring "\n请输入层名:"))
		(setq ss_circle (ssget "x" (list(cons 0 "circle")(cons 8 layer_name))))
		(setq ss_lwpl (ssget "x"(list
					  (cons -4 "<or")
					  (cons 0 "lwpolyline")
					  (cons 0 "line")
					  (cons -4 "or>")
					  (cons 8 layer_name))))
		
	      )
	    )
	  )
	)
      )
	
      (progn
	(setq ss_circle (ssget "x"(list(cons 0 "circle"))))
      	(setq ss_lwpl (ssget "x"(list
					  (cons -4 "<or")
					  (cons 0 "lwpolyline")
					  (cons 0 "line")
					  (cons -4 "or>")
					  )))
      	
      )
   )

    
    (chkline ss_lwpl)
    ;(initget 7)
    
    ;(initget 0)
    
    (setq x_scl (getreal "请输入X方向收缩的系数:"))
    (setq y_scl (getreal "请输入Y方向收缩的系数:"))
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
		(setq scl_x (* (cadar pl_dt) x_scl))
		(setq scl_y (* (caddar pl_dt) y_scl))
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
  (if (/= (strcase ss_key) "S")
      (if ss_circle
      (progn
	(setq ss_cnt (sslength ss_circle))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_circle i_loop)))
	  (setq center (cdr (assoc 10 pl_dt)))
	  (setq center (list (* x_scl (car center)) (* y_scl (cadr center))))	  
	  (setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	  (entmod pl_dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
     
  )
    (command "zoom" "E")
 )


;-----------------------------------------------------------------


  (defun c:apr_ofst ()
    (set_var)
    (command "zoom" "E")
    (initget 1 "S O A ALL")
    (setq ss_key (getkword "\n请选择选图形的方式：\nSelect object/One layer/<All>"))
    (if	(and(/= (strcase ss_key) "A")
	   (/= (strcase ss_key) "ALL")
	)
      (progn
	(if (equal (strcase ss_key) "S")
	  (progn
	  (setq ss_lwpl(ssget))
	  )  
	  (progn
	    (setq layer_name "")
	    (while (not (tblsearch "layer" layer_name))
	      (progn
		(setq layer_name (getstring "\n请输入层名:"))
		
		(setq ss_circle (ssget "x" (list(cons 0 "circle")(cons 8 layer_name))))
		(setq ss_lwpl (ssget "x"(list
					  (cons -4 "<or")
					  (cons 0 "lwpolyline")
					  (cons 0 "line")
					  (cons -4 "or>")
					  (cons 8 layer_name))))
	      )
	    )
	  )
	)
      )
	
      (progn
      	
      	(setq ss_circle (ssget "x"(list(cons 0 "circle"))))
	(setq ss_lwpl (ssget "x"(list
					  (cons -4 "<or")
					  (cons 0 "lwpolyline")
					  (cons 0 "line")
					  (cons -4 "or>")
					  )))
      )
   )

    
    (chkline ss_lwpl)
    ;(initget 7)
    (setq x_cpt (getreal "请输入X方向收缩补偿:"))
    (setq x_cpt (/ x_cpt 2.0))
    (setq y_cpt (getreal "请输入Y方向收缩补偿:"))
    (setq y_cpt (/ y_cpt 2.0))
    (if	ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	  (if (=(cdr(assoc 0 pl_dt)) "LWPOLYLINE")
	    (progn
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
		  (setq ofst_x (- ofst_x x_cpt))
		  (setq ofst_x (+ ofst_x x_cpt))
		)
		(if (> ofst_y cy)
		  (setq ofst_y (- ofst_y y_cpt))
		  (setq ofst_y (+ ofst_y y_cpt))
		)
		(setq dt
		       (append dt (list (cons 10 (list ofst_x ofst_y 0))))
		)
	      )
	    )
	    (setq pl_dt (cdr pl_dt))
	  )
	  ))
	  (entmod dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
    
    (if (equal (strcase ss_key) "S")
      (setq ss_circle (ssget "p" (list(cons 0 "circle"))))
      )
      
	
      ;(progn
	(setq r_new(/(+ x_cpt y_cpt) 2))
    	
    	(if	ss_circle
      	(progn
	   (setq ss_cnt (sslength ss_circle))
	   (setq i_loop 0)
	   (while (< i_loop ss_cnt)
	  	(setq pl_dt (entget (ssname ss_circle i_loop)))
	  	(setq c_r (cdr (assoc 40 pl_dt)))
	  	(setq c_r (- c_r r_new))	  
	  	(setq pl_dt (subst (cons 40 c_r) (assoc 40 pl_dt) pl_dt))
	  	(entmod pl_dt)
	  	(setq i_loop (1+ i_loop))
	   )
        )
      ;)
    ;)
  )
    
   
    (command "zoom" "E")
  )
 
(PROMPT "\n 输入 apr_scale/apr_ofst 运行程序。")

;-------------------------------------------------------------------------------

