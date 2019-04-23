
(defun c:wl2ol ()
  ;change the polyline to lwpolyline
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
  ;init the system var
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)  
;get_dt_vl
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  ;此程序处理两端宽度不同的弧时会有误差，有待进行分段处理，由于此类情况还见过，暂不完善此功能.
;change the layer lay_name wide line to out line
  
  (defun wdl (lay_name cir_add)
    (Setq FLTR (list
		 (cons 0 "lwpolyline")
		 (cons 8 lay_name)
		 (cons -4 "<OR")
		 (cons -4 "<NOT")
		 (cons 40 0)
		 (cons -4 "NOT>")
		 (cons -4 "<NOT")
		 (cons 40 0)
		 (cons -4 "NOT>")
		 (cons -4 "OR>")
	       )
    )
    (setq ss (ssget "x" FLTR))
    (if	(/= ss nil)
      (progn
	(setq cnt_all (sslength ss))
	(setq cnt 0)
	(command "layer" "M" lay_name "")
	(while (< cnt cnt_all)
	  (setq ent_name (ssname ss cnt))
	  (setq l_dt (entget ent_name))
	  (if (>= (get_dt_vl 90 l_dt) 2)
	    (progn
	      (setq stt_pnt (get_dt_vl 10 l_dt))
	      (setq l_dt (cdr (member (cons 10 stt_pnt) l_dt)))
	      (setq stt_swd (/ (get_dt_vl 40 l_dt) 2))
	      (setq stt_ewd (/ (get_dt_vl 41 l_dt) 2))
	      (setq stt_blg (get_dt_vl 42 l_dt))
	      (setq end_pnt (get_dt_vl 10 l_dt))
	      (setq l_dt (cdr (member (cons 10 end_pnt) l_dt)))
	      (setq end_swd (/ (get_dt_vl 40 l_dt) 2))
	      (setq end_ewd (/ (get_dt_vl 41 l_dt) 2))
	      (setq end_blg (get_dt_vl 42 l_dt))
	      (if (= stt_blg 0)
		(progn
		  (setq agl (angle stt_pnt end_pnt))
		  (setq x0 (car stt_pnt))
		  (setq y0 (cadr stt_pnt))
		  (setq	fst_pnt	(list (+ x0 (* stt_swd (sin agl)))
				      (- y0 (* stt_swd (cos agl)))
				)
		  )
		  (setq	fth_pnt	(list (- x0 (* stt_swd (sin agl)))
				      (+ y0 (* stt_swd (cos agl)))
				)
		  )
		  (setq x0 (car end_pnt))
		  (setq y0 (cadr end_pnt))
		  (setq	scd_pnt	(list (+ x0 (* stt_ewd (sin agl)))
				      (- y0 (* stt_ewd (cos agl)))
				)
		  )
		  (setq	thd_pnt	(list (- x0 (* stt_ewd (sin agl)))
				      (+ y0 (* stt_ewd (cos agl)))
				)
		  )
		  (if (= cir_add "Y")
		  (command "pline" fst_pnt scd_pnt "a" thd_pnt "l" fth_pnt "a" "cl"  "")
		  (command "pline" fst_pnt scd_pnt thd_pnt fth_pnt "close"  "")
		    )

		)
		(progn
		  (setq agl (angle stt_pnt end_pnt))
		  (setq x0 (car stt_pnt))
		  (setq y0 (cadr stt_pnt))
		  (setq x1 (car end_pnt))
		  (setq y1 (cadr end_pnt))
		  (if (> stt_blg 0)
		    (setq alf (+ agl (/ pi 2)))
		    (setq alf (+ (+ agl (/ pi 2)) pi))
		  )
		  (setq dist (distance stt_pnt end_pnt))
		  (setq rad (abs (/ (* dist (+ stt_blg (/ 1 stt_blg))) 4)))
		  (setq high (abs (/ (* stt_blg dist) 2)))
		  (setq dist_cm (- rad high))
		  (setq x_m (/ (+ x0 x1) 2))
		  (setq y_m (/ (+ y0 y1) 2))
		  (setq c_x (+ x_m (* (cos alf) dist_cm)))
		  (setq c_y (+ y_m (* (sin alf) dist_cm)))
		  (setq cent_pnt (list c_x c_y))
		  (setq stt_agl (angle cent_pnt stt_pnt))
		  (setq end_agl (angle cent_pnt end_pnt))

		  (setq
		    fst_pnt (list
			      (+ c_x (* (cos stt_agl) (- rad stt_swd)))
			      (+ c_y (* (sin stt_agl) (- rad stt_swd)))
			    )
		    scd_pnt (list
			      (+ c_x (* (cos stt_agl) (+ rad stt_swd)))
			      (+ c_y (* (sin stt_agl) (+ rad stt_swd)))
			    )
		    thd_pnt (list
			      (+ c_x (* (cos end_agl) (- rad stt_ewd)))
			      (+ c_y (* (sin end_agl) (- rad stt_ewd)))
			    )
		    fth_pnt (list
			      (+ c_x (* (cos end_agl) (+ rad stt_ewd)))
			      (+ c_y (* (sin end_agl) (+ rad stt_ewd)))
			    )
		  )
		  (cond
		      ((and (> stt_agl end_agl) (> stt_blg 0.0))
		       (setq arc_mid_agl
			      (+ (/ (+ stt_agl end_agl) 2) pi)
		       )
		      )
		      ((and (> stt_agl end_agl) (< stt_blg 0.0))
		       (setq arc_mid_agl (/ (+ stt_agl end_agl) 2))
		      )
		      ((and (< stt_agl end_agl) (> stt_blg 0.0))
		       (setq arc_mid_agl (/ (+ stt_agl end_agl) 2))
		      )
		      ((and (< stt_agl end_agl) (< stt_blg 0.0))
		       (setq arc_mid_agl
			      (+ (/ (+ stt_agl end_agl) 2) pi)
		       )
		      )
		    )
		  (setq arc_mid_wid (/ (+ stt_swd stt_ewd) 2))
		  (setq	arc_mid_pnt1
				     (list (+ c_x
					      (* (cos arc_mid_agl) (- rad arc_mid_wid))
					   )
					   (+ c_y
					      (* (sin arc_mid_agl) (- rad arc_mid_wid))
					   )
				     )
			arc_mid_pnt2
				     (list (+ c_x
					      (* (cos arc_mid_agl) (+ rad arc_mid_wid))
					   )
					   (+ c_y
					      (* (sin arc_mid_agl) (+ rad arc_mid_wid))
					   )
				     )

		  )
		  (if (= cir_add "Y")
		      (command "pline"  fst_pnt "a" "s" arc_mid_pnt1 thd_pnt fth_pnt "s" arc_mid_pnt2 scd_pnt "close")
		      (command "pline"  fst_pnt "a" "s" arc_mid_pnt1 thd_pnt "l" fth_pnt "a" "s" arc_mid_pnt2 scd_pnt "l" "close")
		    )
		)
	      )

	      (setq stt_pnt end_pnt)
	      (setq stt_swd end_swd)
	      (setq stt_ewd end_ewd)
	      (setq stt_blg end_blg)

	      (while (setq end_pnt (get_dt_vl 10 l_dt))
		(setq l_dt (cdr (member (cons 10 end_pnt) l_dt)))
		(setq end_swd (/ (get_dt_vl 40 l_dt) 2))
		(setq end_ewd (/ (get_dt_vl 41 l_dt) 2))
		(setq end_blg (get_dt_vl 42 l_dt))
		(if (= stt_blg 0)
		  (progn
		    (setq agl (angle stt_pnt end_pnt))
		    (setq x0 (car stt_pnt))
		    (setq y0 (cadr stt_pnt))
		    (setq fst_pnt (list	(+ x0 (* stt_swd (sin agl)))
					(- y0 (* stt_swd (cos agl)))
				  )
		    )
		    (setq fth_pnt (list	(- x0 (* stt_swd (sin agl)))
					(+ y0 (* stt_swd (cos agl)))
				  )
		    )
		    (setq x0 (car end_pnt))
		    (setq y0 (cadr end_pnt))
		    (setq scd_pnt (list	(+ x0 (* stt_ewd (sin agl)))
					(- y0 (* stt_ewd (cos agl)))
				  )
		    )
		    (setq thd_pnt (list	(- x0 (* stt_ewd (sin agl)))
					(+ y0 (* stt_ewd (cos agl)))
				  )
		    )
		    (if (= cir_add "Y")
		  (command "pline" fst_pnt scd_pnt "a" thd_pnt "l" fth_pnt "a" "cl"  "")
		  (command "pline" fst_pnt scd_pnt thd_pnt fth_pnt "close"  "")
		    )

		  )
		  (progn
		    (setq agl (angle stt_pnt end_pnt))
		    (setq x0 (car stt_pnt))
		    (setq y0 (cadr stt_pnt))
		    (setq x1 (car end_pnt))
		    (setq y1 (cadr end_pnt))
		    (if	(> stt_blg 0)
		      (setq alf (+ agl (/ pi 2)))
		      (setq alf (+ (+ agl (/ pi 2)) pi))
		    )
		    (setq dist (distance stt_pnt end_pnt))
		    (setq
		      rad
		       (abs (/ (* dist (+ stt_blg (/ 1 stt_blg))) 4))
		    )
		    (setq high (abs (/ (* stt_blg dist) 2)))
		    (setq dist_cm (- rad high))
		    (setq x_m (/ (+ x0 x1) 2))
		    (setq y_m (/ (+ y0 y1) 2))
		    (setq c_x (+ x_m (* (cos alf) dist_cm)))
		    (setq c_y (+ y_m (* (sin alf) dist_cm)))
		    (setq cent_pnt (list c_x c_y))
		    (setq stt_agl (angle cent_pnt stt_pnt))
		    (setq end_agl (angle cent_pnt end_pnt))
		    (setq
		      fst_pnt (list
				(+ c_x
				   (* (cos stt_agl) (- rad stt_swd))
				)
				(+ c_y
				   (* (sin stt_agl) (- rad stt_swd))
				)
			      )
		      scd_pnt (list
				(+ c_x
				   (* (cos stt_agl) (+ rad stt_swd))
				)
				(+ c_y
				   (* (sin stt_agl) (+ rad stt_swd))
				)
			      )
		      thd_pnt (list
				(+ c_x
				   (* (cos end_agl) (- rad stt_ewd))
				)
				(+ c_y
				   (* (sin end_agl) (- rad stt_ewd))
				)
			      )
		      fth_pnt (list
				(+ c_x
				   (* (cos end_agl) (+ rad stt_ewd))
				)
				(+ c_y
				   (* (sin end_agl) (+ rad stt_ewd))
				)
			      )
		    )

		    (cond
		      ((and (> stt_agl end_agl) (> stt_blg 0.0))
		       (setq arc_mid_agl
			      (+ (/ (+ stt_agl end_agl) 2) pi)
		       )
		      )
		      ((and (> stt_agl end_agl) (< stt_blg 0.0))
		       (setq arc_mid_agl (/ (+ stt_agl end_agl) 2))
		      )
		      ((and (< stt_agl end_agl) (> stt_blg 0.0))
		       (setq arc_mid_agl (/ (+ stt_agl end_agl) 2))
		      )
		      ((and (< stt_agl end_agl) (< stt_blg 0.0))
		       (setq arc_mid_agl
			      (+ (/ (+ stt_agl end_agl) 2) pi)
		       )
		      )
		    )
		    (setq arc_mid_wid (/ (+ stt_swd stt_ewd) 2))
		    (setq arc_mid_pnt1
				       (list (+	c_x
						(* (cos arc_mid_agl) (- rad arc_mid_wid))
					     )
					     (+	c_y
						(* (sin arc_mid_agl) (- rad arc_mid_wid))
					     )
				       )
			  arc_mid_pnt2
				       (list (+	c_x
						(* (cos arc_mid_agl) (+ rad arc_mid_wid))
					     )
					     (+	c_y
						(* (sin arc_mid_agl) (+ rad arc_mid_wid))
					     )
				       )

		    )

		  (if (= cir_add "Y")
		      (command "pline"  fst_pnt "a" "s" arc_mid_pnt1 thd_pnt fth_pnt "s" arc_mid_pnt2 scd_pnt "close")
		      (command "pline"  fst_pnt "a" "s" arc_mid_pnt1 thd_pnt "l" fth_pnt "a" "s" arc_mid_pnt2 scd_pnt "l" "close")
		    )
		    ;(if (= cir_add "Y")		      
	;	    (progn
	;	      (command "arc" fst_pnt "c" stt_pnt scd_pnt)
	;	      (command "arc" thd_pnt "c" end_pnt fth_pnt)
	;	    )
	;	    (progn
	;	      (entmake
	;		(list (cons 0 "line")
	;		      (cons 10 fst_pnt)
	;		      (cons 11 scd_pnt)
	;		)
	;	      )
	;	      (entmake
	;		(list (cons 0 "line")
	;		      (cons 10 thd_pnt)
	;		      (cons 11 fth_pnt)
	;		)
		 ;     )
		 ;   )
		 ; )
		 ;   (command "arc" fst_pnt arc_mid_pnt1 thd_pnt)
		 ;   (command "arc" scd_pnt arc_mid_pnt2 fth_pnt)
		 ;   (setq ent_sel
		;	   (ssget "CP"
		;		  (list fst_pnt scd_pnt fth_pnt thd_pnt)
		;	   )
		    ;)
		    ;(command "Pedit" "L" "Y" "J" ent_sel "" "")
	    
		  )
		)

		(setq stt_pnt end_pnt)
		(setq stt_swd end_swd)
		(setq stt_ewd end_ewd)
		(setq stt_blg end_blg)
	      )
	    )
	  )
	  (entdel ent_name)
	  (setq cnt (1+ cnt))
	)
      )
    )
  )

  (setvar "plinewid" 0)
  (set_var)
  (pl2lwpl)
  (setq cir_add (getstring "/是否在线端加圆头Y/N(Y)"))
  (setq cir_add (strcase cir_add))
  (if (= cir_add "")
    (setq cir_add "Y")
  )
  (setq	layer_name
	 (strcase (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (if found
    (progn
      (wdl layer_name cir_add)
    )
    (progn
      (setq layer_name_lst nil)
      (setq layer_name (cdadr (tblnext "LAYER" T)))
      (while layer_name
	(setq layer_name_lst
	       (append layer_name_lst (list layer_name))
	)
	(setq layer_name (cdadr (tblnext "LAYER")))
      )
      (setq I_th 0)
      (setq layer_name (nth i_th layer_name_lst))
      (while layer_name
	(if (/= layer_name "PROBLEM")
	  (progn
	    (wdl layer_name cir_add)
	  )
	)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
    )
  )
  (command "zoom" "e")
)
(getstring  "此程序处理宽度多义线，执行命令wl2ol，它只处理有宽度的LWPOLYLINE，对其它图形无影响!")

