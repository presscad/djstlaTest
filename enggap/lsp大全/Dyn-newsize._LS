
(defun c:dynn ()
    (defun frm () 
        (command "pline" (list 172.8 177.8) "w" 0 0 
                         (list -174.8 177.8) 
                         (list -174.8 177.8) 
                         (list -177.8 174.8) 
                         (list -177.8 -174.8) 
                         (list -174.8 -177.8) 
                         (list 174.8 -177.8) 
                         (list 177.8 -174.8) 
                         (list 177.8 174.8) 
                         (list 174.8 177.8) 
                         (list 172.8 177.8) 
                         (list 172.8 172.8) 
                         (list 172.8 -172.8) 
                         (list 172.8 -172.8) 
                         (list -172.8 -172.8) 
                         (list -172.8 172.8) 
                         (list 172.8 172.8) 
                         (list 172.8 172.8) 
                         "c"
         )
        (command "pline" (list 177.85 177.85) "w" 0 0 
                         (list 177.95 177.85) 
                         (list 177.95 177.95) 
                         (list 177.85 177.95) 
                         "c"
         )
        (command "pline" (list 0.05 177.85) "w" 0 0 
                         (list 177.85 177.85) 
                         (list 177.85 -177.85) 
                         (list -177.85 -177.85) 
                         (list -177.85 177.85) 
                         (list -0.05 177.85) 
                         (list -0.05 177.75) 
                         (list -177.75 177.75) 
                         (list -177.75 -177.75) 
                         (list 177.75 -177.75) 
                         (list 177.75 177.75) 
                         (list 0.05 177.75) 
                         "c"
         )
        (command "pline" (list -177.95 177.85) "w" 0 0 
                         (list -177.85 177.85) 
                         (list -177.85 177.95) 
                         (list -177.95 177.95) 
                         "c"
         )
        (command "pline" (list -177.95 -177.95) "w" 0 0 
                         (list -177.85 -177.95) 
                         (list -177.85 -177.85) 
                         (list -177.95 -177.85) 
                         "c"
         )
        (command "pline" (list 177.85 -177.95) "w" 0 0 
                         (list 177.95 -177.95) 
                         (list 177.95 -177.85) 
                         (list 177.85 -177.85) 
                         "c"
         )
        (command "zoom" "e" "")
     )  

  (defun ext21 (layer_name)
    (setq
      polyline_ss
       (ssget "X"
	      (list (cons 0 "POLYLINE"))
       )
    )
    (if	polyline_ss
      (progn
	(command "convert" "P" "A")
      )
    )
    (setq
      polyline_ss
       (ssget "X"
	      (list (cons 0 "LWPOLYLINE")
		    (cons 8 layer_name)
		    (cons 210 '(0 0 -1))
	      )
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
      )
    )
    (command "mirror" polyline_ss "" '(0 0) '(0 100) "y")
    (setq polyline_ss nil)
  )
  (setvar "OSMODE" 0)
  (setvar "ORTHOMODE" 0)
  (setvar "PLINEWID" 0)
  (setvar "THICKNESS" 0)
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
  (command "scale" "all" "" '(0 0) 25.4)
  (command "zoom" "e")
  (setvar "OSMODE" 0)
  (command "zoom" "e")
  (command "layer" "n" "F" "")
  (command "change" "all" "" "P" "LA" "F" "COLOR" "BYLAYER" "")
  (command "layer" "s" "F" "")
  (command "purge" "aLL" "" "N")
  (command "purge" "aLL" "" "N")
  (setq ss_point (ssget "x" (list (cons 0 "point"))))
  (command "erase" ss_point "")
  (setvar "OSMODE" 2)
  (setq mid (getpoint "\请点取边框左边的中点:"))
  (command "move" "all" "" mid "-177.8,0")
  (command "zoom" "e" "")
  (setvar "OSMODE" 0)
  (frm)
  (alert "注意:图形中有厚度的线!判断SET号是否正确!")
)
(prompt "\先将块炸开,再运行程序dynn！")



