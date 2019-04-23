
(defun drawcircle(x y /)
  (command "circle" (list x y) 27.4)
  (command "circle" (list x y) 37.5)
 )



;get the extent of one polyline;
(defun getext(objpl / scl_x scl_y min_x min_y max_x max_y flagn)
          (setq min_x 0 min_y 0 max_x 0 max_y 0 flagn 1)
  
          (setq pl_dt (entget objpl))

  	 ;get the number of the vertexs
  	;(setq cnt (cdr (assoc 90 pl_dt)))
  
	  (while pl_dt
	    (if	(= (caar pl_dt) 10)	      
	      (progn
		(setq scl_x (cadar pl_dt))
		(setq scl_y (caddar pl_dt))

		(if( = flagn 1)
		  (progn
		    (setq min_x scl_x  min_y scl_y  max_x scl_x  max_y scl_y)
		    (setq flagn (+ flagn 1))
		    )
		  (progn
		    (if (> scl_x max_x) (setq max_x scl_x))
		    (if (> scl_y max_y) (setq max_y scl_y))
		    (if (< scl_x min_x) (setq min_x scl_x))
		    (if (< scl_y min_y) (setq min_y scl_y))
		    )
		  )
	      ) ;progn	      
	    )
	    (setq pl_dt (cdr pl_dt))
	  )

  	;cal the center point
  	(setq scl_x (/ (+ min_x max_x) 2))
  	(setq scl_y (/ (+ min_y max_y) 2))

  	;draw circle
  	(drawcircle scl_x scl_y)

)


(defun selectss( / ss_lwpl ss_cnt i_loop plobj)
  (PROMPT "\n Please select the polyline")
  (setq ss_lwpl (ssget))
  (if ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq plobj (ssname ss_lwpl i_loop))
	  (getext plobj)
	  (setq i_loop (+ 1 i_loop))
	)
      )
    )
  )

(defun c:dc123()
  (selectss)
  )







