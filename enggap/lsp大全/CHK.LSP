(defun c:pbl_list ()
  (setq	type_list '("3DFace" "3DPoly"	   "3DSolid"	 "Arc"
			     "Attribute"   "Circle"	 "DimAligned"
			     "DimAngular"  "DimDiametric"
			     "dimension"   "DimOrdinate" "DimRadial"
			     "DimRotated"  "Ellipse"	 "Hatch"
			     "INSERT"	   "Leader"	 "Line"
			     "MText"	   "Point"	 "Polyline"
			     "LWpolyline"  "Polymesh"	 "Pviewport"
			     "Raster"	   "Ray"	 "Region"
			     "Shape"	   "Solid"	 "Spline"
			     "Text"	   "Tolerance"	 "Trare"
			     "Xline"
			    )
  )
  (setq ss_all (ssget "x" (list (cons 8 "problem"))))
  (setq all_cnt 0)
  (if ss_all
    (setq all_cnt (sslength ss_all))
    )  
  (setq type_list_len (length type_list))
  (setq loop_i 0)
  (setq str "\n")
  (while (< loop_i type_list_len)
    (setq ent_type (nth loop_i type_list))
    (setq ent_ss (ssget "x" (list (cons 0 ent_type) (cons 8 "problem"))))
    (if	ent_ss
      (progn
	(setq ent_cnt (sslength ent_ss))
	;debug
	;(command "erase" ent_ss "" )
	(setq str_tmp (strcat str (strcat ent_type (strcat ":" (strcat (itoa ent_cnt) "\n")))))
	(setq str str_tmp)
	(setq all_cnt (- all_cnt ent_cnt))
      )
    )

    (setq loop_i (1+ loop_i))
  )
  (prompt "\n非法实体列表:")
  (prompt str)
  (if (> all_cnt 0)
    (prompt (strcat (itoa all_cnt) "\n个实体不知道！"))    
    )
)
(defun C:endchk()
  (defun get_dt_vl (item dt)
   	(cdr (assoc item dt))
  )
	(setq	ind_ss1	(ssget "x"
			       (list
				 (cons -4 "<and")
				 (cons -4 "<NOT")
				 (cons -4 "<or")
				 (cons 0 "circle")
				 (cons -4 "<and")
				 (cons 0 "polyline")
				 (cons 70 1)
				 (cons -4 "and>")
				 (cons -4 "<and")
				 (cons 0 "lwpolyline")
				 (cons 70 1)
				 (cons -4 "and>")
				 (cons -4 "or>")
				 (cons -4 "NOT>")
				 (cons -4 "<NOT")
				 (cons 8 "problem")
				 (cons -4 "NOT>")
				 (cons -4 "and>")

			       )
			)
	  )
	  (if ind_ss1
	    (progn
	      (command "layer" "m" "problem" "color" "231" "" "")
	      (setq ent_cnt (sslength ind_ss1))
	      (if
		(and (= ent_cnt 1) (= (get_dt_vl 0 (entget (ssname ind_ss1 0))) "TEXT"))
		 (getstring "\n只有一个文字为非法实体，请确认此单为一张凸版.")
			 (progn
			   (command "change"  ind_ss1	""
				    "P"	      "layer"	"problem"
				    ""
				   )
			   (getstring
			     (strcat "\n有"
				     (itoa ent_cnt)
				     "个实体非法实体，已经放在PROBLEM层,运行pbl_list查看实体类型."
			     )
			   )			   
			 )
	      )
	    )
	    (getstring "\nOK！")
	  )
  )
(prompt "\n输入ENDCHK运行检查，输入pbl_list对PROBLEM层的非法实体列表.")