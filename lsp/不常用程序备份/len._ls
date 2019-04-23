



(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
(defun c:len ()
  (setq	layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )

  (setq width "")
  (while (= width "")
    (setq width (getstring (strcat "输入 " layer_name "层的增加长度:")))
    (if	(<= (setq width (atof width)) 0)
      (setq width "")
    )
  )  
    
  (setq ss (ssget "x" (list (cons 0 "line") (cons 8 layer_name ))))
  (if ss
    (progn
      (setq cnt_all (sslength ss))
      (setq cnt 0)
      (command "layer" "M" layer_name "")
      (while (< cnt cnt_all)
	(setq l_dt (entget (ssname ss cnt)))
	(setq first_pnt (get_dt_vl 10 l_dt))
	(setq last_pnt (get_dt_vl 10 (reverse l_dt)))
	(command "zoom" "W"
		 	(list
			   (+ (car first_pnt) (* width 2))
			   (+ (cadr first_pnt) (* width 2))
			 )
		 	(list
			   (- (car first_pnt) (* width 2))
			   (- (cadr first_pnt) (* width 2))
			   )
		 )
	(command "lengthen" "de" width first_pnt "")
		(command "zoom" "W"
		 	(list
			   (+ (car last_pnt) (* width 2))
			   (+ (cadr last_pnt) (* width 2))
			 )
		 	(list
			   (- (car last_pnt) (* width 2))
			   (- (cadr last_pnt) (* width 2))
			   )
		 )
	(command "lengthen" "de" width last_pnt "")			   
	(setq cnt (1+ cnt))
      )
    )
  )
)
(prompt "\Enter 'len' to run!")