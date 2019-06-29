;--------------------------------------------------

  (defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )
;--------------------------------------------------
(defun chkline(ss_ent )     ;���Ҫ������ͼ����û��δ�պϵĵ���
  (setq ss_ent(ssget"p"(list(cons 0 "line"))))
  (if ss_ent
    (progn
    (alert "Ҫ������ͼ����δ�պϵĵ��ߣ����Ƚ����߱պ�!")
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
    (setq ss_key (getkword "\n��ѡ��ѡͼ�εķ�ʽ��\nSelect object/One layer/<All>"))
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
		(setq layer_name (getstring "\n���������:"))
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
    
    (setq x_scl (getreal "������X����������ϵ��:"))
    (setq y_scl (getreal "������Y����������ϵ��:"))
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
    (setq ss_key (getkword "\n��ѡ��ѡͼ�εķ�ʽ��\nSelect object/One layer/<All>"))
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
		(setq layer_name (getstring "\n���������:"))
		
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
    (setq x_cpt (getreal "������X������������:"))
    (setq x_cpt (/ x_cpt 2.0))
    (setq y_cpt (getreal "������Y������������:"))
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
 
(PROMPT "\n ���� apr_scale/apr_ofst ���г���")

;-------------------------------------------------------------------------------

