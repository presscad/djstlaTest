(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)

(defun arc2ccl (layer_name)
  (setq w_width 0.0001)
  (setq arc_ss (ssget "X" (list (cons 0 "ARC") (cons 8 layer_name))))
  (if arc_ss
    (progn
      (setq total (sslength arc_ss))
      (setq count 0)
      (while (< count total)
	(setq ent_name (ssname arc_ss count))
	(setq arc_detail (entget ent_name))
	(if arc_detail
	  (progn
	    (setq center_point (get_dt_vl 10 arc_detail))
	    (setq R_var (get_dt_vl 40 arc_detail))
	    (setq end_agl (get_dt_vl 51 arc_detail))
	    (setq c_P_x (car center_point))
	    (setq c_p_Y (cadr center_point))
	    (setq e_p_x (+ c_p_x (* R_var (cos end_agl))))
	    (setq e_p_y (+ c_p_y (* R_var (sin end_agl))))
	    (setq e_w_rd (list (+ e_p_x w_width) (- e_p_y w_width)))
	    (setq e_w_lu (list (- e_p_x w_width) (+ e_p_y w_width)))
	    (setq e_ss (ssget "c" e_w_rd e_w_lU))
	    (if e_ss
	      (progn
		(if (= (sslength e_ss) 4)
		  (progn
			(setq subcnt (sslength e_ss))
			(while (> (sslength e_ss) 0)
			  (setq del_arc (ssname e_ss 0))
			  (ssdel del_arc e_ss)
			  (ssdel del_arc arc_ss)
			  )
		)
			
		))
	    (command "pedit" ent_name "Y" "J" e_ss "" "X")
	  )
	)
	(setq count (1+ count))
      )
    )
  )
)