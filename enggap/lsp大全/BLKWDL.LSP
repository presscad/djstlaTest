(defun C:blkWDL	()
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  (defun ofst_pnt (pst X_size Y_size)
    (setq pst (list (+ (car pst) X_size)
		    (+ (cadr pst) y_size)
	      )
    )
    (setq pst pst)
  )

  (setq
    ss
     (ssget "x"
	    (list (cons 0 "insert")(cons 8 "3"))
     )
  )
  (if ss
    (progn
      (setq cnt_all (sslength ss))
      (setq cnt 0)
      (while (< cnt cnt_all)
	(setq ent_name (ssname ss cnt))
	(setq l_dt (entget ent_name))
	(setq blk_name (get_dt_vl 2 l_dt))
	(if (= blk_name "SQUARE")
	  (progn
	    (setq ist_pnt (get_dt_vl 10 l_dt))
	    (setq x_scal (/ (get_dt_vl 41 l_dt) 2.0))
	    (setq y_scal (/ (get_dt_vl 42 l_dt) 2.0))
	    (setq p1 (ofst_pnt ist_pnt (- x_scal) (- y_scal)))
	    (setq p2 (ofst_pnt ist_pnt x_scal (- y_scal)))
	    (setq p3 (ofst_pnt ist_pnt x_scal y_scal))
	    (setq p4 (ofst_pnt ist_pnt (- x_scal) y_scal))
	    (command "pline" p1 p2 p3 p4 "close" "")
	  )
	)
	(setq cnt (1+ cnt))
	(entdel ent_name)
      )
    )
  )




)
