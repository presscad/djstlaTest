					;设置系统变量
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)					;reset system variable
(defun reset_var (var_list)
  (setvar "osmode" (car var_list))
  (setvar "orthomode" (cadr var_list))
)				;read value
(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
					;convert polyline to lwpolyline
(defun pl2lwpl ()
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 0 "POLYLINE"))
     )
  )
  (if polyline_ss
    (progn
      (command "convert" "a" "a")
    )
  )
  (setq polyline_ss nil)
)
(defun line_length (line_detail)
  (distance (get_dt_vl 10 line_detail)
	    (get_dt_vl 11 line_detail)
  )
)					;check double line

(defun kill_dbl	(layer_name)
  (setq K_length 0.1)
  (setq Deta 0.1)
  (setq vir_eqal 0.0001)
  (setq
    line_ss
     (ssget "X"
	    (list (cons 0 "LINE") (cons 8 layer_name))
     )
  )
  (if line_ss
    (progn
      (setq minx 0)
      (setq miny 0)
      (setq maxx 0)
      (setq maxy 0)
      (while (> (sslength line_ss) 0)
	(setq line_name (ssname line_ss 0))
	(ssdel line_name line_ss)
	(setq line_detail (entget line_name))
	(setq length_val (line_length line_detail))
	(setq x0 (car (get_dt_vl 10 line_detail)))
	(setq y0 (cadr (get_dt_vl 10 line_detail)))
	(setq x1 (car (get_dt_vl 11 line_detail)))
	(setq y1 (cadr (get_dt_vl 11 line_detail)))
	(setq minx (min minx x0 x1))
	(setq miny (min miny y0 y1))
	(setq maxx (max maxx x0 x1))
	(setq maxy (max maxy y0 y1))
	(if (equal x0 x1 vir_eqal)
	  (progn
	    (if (< y1 y0)
	      (progn
	      (setq tmp y1)
	      (setq y1 y0)
	      (setq y0 tmp)
	      ))
	    (setq p_a
		   (list
		     (- x0  k_length )
		     (- y0  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ x0  k_length )
		     (- y0  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ x1  k_length)
		     (+ y1  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- x1  k_length )
		     (+ y1  k_length )
		   )
	    )
	  )
	  )


	(if (equal y0 y1 vir_eqal)
	  (progn
	    (if (< x1 x0)
	      (progn
	      (setq tmp x1)
	      (setq x1 x0)
	      (setq x0 tmp)
	      ))
	    (setq p_a
		   (list
		     (- x0  k_length )
		     (- y0  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ x1  k_length )
		     (- y0  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ x1  k_length)
		     (+ y1  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- x0  k_length )
		     (+ y1  k_length )
		   )
	    )
	  )
	  )
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
	(if dbl_ss
	  (progn
	    (setq dbl_total (sslength dbl_ss))
	    (setq dbl_cnt 0)
	    (setq keep_flage 0)
	    (if	(> dbl_total 1)
	      (progn
		(while (<= dbl_cnt (- dbl_total 1))
		  (setq dbl_name (ssname dbl_ss dbl_cnt))
		  (setq dbl_detail (entget dbl_name))
		  (if (and (= length_val (line_length dbl_detail))
			   (/= dbl_name line_name)
		      )
		    (progn
		      (setq
			ed
			 (subst	(cons 8 "dbl")
				(cons 8 layer_name)
				dbl_detail
			 )
		      )
		      (entmod ed)
		      (setq ed (subst	(cons 8 "dbl") (cons 8 layer_name) line_detail)
		      )
		      (entmod ed)		      
		    )
		    (setq dbl_cnt dbl_total)
		  )
		  (setq dbl_cnt (+ dbl_cnt 1))
		)
	      )
	    )
	  )
	)
	)

  
	    (setq p_a
		   (list
		     (- minx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ minx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ minx  k_length)
		     (+ maxy  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- minx  k_length )
		     (+ maxy  k_length )
		   )
	    )
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
      (if dbl_ss
	(command "change"  dbl_ss "" "p" "layer" "dbl" "")
	)
      
	    (setq p_a
		   (list
		     (- maxx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ maxx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ maxx  k_length)
		     (+ maxy  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- maxx  k_length )
		     (+ maxy  k_length )
		   )
	    )
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
      (if dbl_ss
	(command "change"  dbl_ss "" "p" "layer" "dbl" "")
	)

	(setq p_a
		   (list
		     (- minx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ maxx  k_length )
		     (- miny  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ maxx  k_length)
		     (+ miny  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- minx  k_length )
		     (+ miny  k_length )
		   )
	    )
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
      (if dbl_ss
	(command "change"  dbl_ss "" "p" "layer" "dbl" "")
	)


	(setq p_a
		   (list
		     (- minx  k_length )
		     (- maxy  k_length )
		   )
	    )
	    (setq p_b
		   (list
		     (+ maxx  k_length )
		     (- maxy  k_length )
		   )
	    )
	    (setq p_c
		   (list
		     (+ maxx  k_length)
		     (+ maxy  k_length)
		   )
	    )
	    (setq p_d
		   (list
		     (- minx  k_length )
		     (+ maxy  k_length )
		   )
	    )
	(setq pt_list (list p_a p_b p_c p_d))
	(setq
	  dbl_ss (ssget	"WP"
			pt_list
			(list (cons 0 "line") (cons 8 Layer_name))
		 )
	)
      (if dbl_ss
	(command "change"  dbl_ss "" "p" "layer" "dbl" "")
	)
     
      ;;;;;;
    )
  )

)
(defun c:get_ol	()  
  (setq var_list (set_var))
  ;(setq	layer_name
;	 (strcase (getstring "请键入层名(直接回车将处理所有层):"))
 ; )
  (setq layer_name "GOOD-DIE")
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (if found
      (kill_dbl layer_name)    
  )
  (command "zoom" "e" "")
  (reset_var var_list)
)				
(prompt "\n input 'dblchk' to run")

  