
(defun c:chgext()
  (defun ext21 (layer_name)
  (setq
    polyline_ss
     (ssget "X"
	    (list (cons 8 layer_name)
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
	  (if (member (cons 210 '(0 0 -1)) l_dt )
	    (progn
	  	(setq
	    		l_dt1 (subst (cons 210 '(0 0 1)) (cons 210 '(0 0 -1)) l_dt)
	  	)
	  	(entmod l_dt1)
	    )
	    (progn
	      (getstring "/n有程序无法处理的图形,请重新打开图形,然后运行dci-scd.lsp中的dci,再运行此程序!")
	      (exit)	      
	      )
	    )
	  (setq cnt (1+ cnt))
	)
	(command "mirror" polyline_ss "" '(0 0) '(0 100) "y")
      )
    )  
  (setq polyline_ss nil)
)
  (setvar "OSMODE" 0)
  (setvar "ORTHOMODE" 0)
  (command "ucs" "")
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
(prompt "\n输入chgext运行")
(getstring "\n程序对 MTEXT处理会出错，如有MTEXT的延伸方向为-1，必须先将MTEXT炸为TEXT！")
  

  
  

  