(defun C:dL ()
  (setq
   lwpl
     (ssget "x"
	    (list (cons 0 "lwpolyline") (cons 41 0.0) (cons 70 1))
     )
  )
  (command "erase" lwpl)

)
