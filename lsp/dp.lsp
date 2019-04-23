(defun C:dp ()
  (setq
    pl
     (ssget "x"
	    (list (cons 0 "polyline") (cons 41 0.0) (cons 70 1))
     )
  )
  (command "erase" pl)

)
