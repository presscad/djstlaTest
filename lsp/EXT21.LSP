
(defun ext21 (layer_name)
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 0 "POLYLINE"))	    
     )
  )
  (if polyline_ss
    (progn
      (command "convert" "P" "A")
    )
  )	 
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 0 "LWPOLYLINE")
		  (cons 8 layer_name)
	  	(cons 210  '(0 0 -1)))
     )
  )
  (if	(/= polyline_ss nil)
      (progn
	(setq cnt_all (sslength polyline_ss))
	(setq cnt 0)
	(while (< cnt cnt_all)
	  (setq ent_name (ssname polyline_ss cnt))
	  (setq l_dt (entget ent_name))
	  (setq l_dt (subst (cons 210 '(0 0 1)) (cons 210 '(0 0 -1)) l_dt))	  
	  (entmod l_dt)
	  (setq cnt (1+ cnt))
	)
      )
    )
  (command "mirror" polyline_ss "" '(0 0) '(0 100) "y")
  (setq polyline_ss nil)
)
(defun c:chgext()
  (setvar "OSMODE" 0)
  (setvar "ORTHOMODE" 0)
  (setq	layer_name
	 (strcase (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (if found
    (ext21 layer_name)
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
	  (ext21 layer_name)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
    )
  )
  (command "zoom" "e")
) 

  

  
  

  