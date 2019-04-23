(defun c:typelist ()
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
  (setq ss_all (ssget "x"))
  (setq all_cnt 0)
  (if ss_all
    (setq all_cnt (sslength ss_all))
    )  
  (setq type_list_len (length type_list))
  (setq loop_i 0)
  (setq str "\n")
  (while (< loop_i type_list_len)
    (setq ent_type (nth loop_i type_list))
    (setq ent_ss (ssget "x" (list (cons 0 ent_type))))
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
  (prompt "\nEntity list")
  (prompt str)
  (if (> all_cnt 0)
    (prompt (strcat (itoa all_cnt) "\n个实体不知道，请用E_PASS查看！"))
    (prompt "\nOK")
    )
)
(defun c:E_PASS ()
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
  (setq ss_all (ssget "x"))
  (setq all_cnt 0)
  (if ss_all
    (setq all_cnt (sslength ss_all))
    )  
  (setq type_list_len (length type_list))
  (setq loop_i 0)
  (setq str "\n")
  (while (< loop_i type_list_len)
    (setq ent_type (nth loop_i type_list))
    (setq ent_ss (ssget "x" (list (cons 0 ent_type))))
    (if	ent_ss
      (progn
	(setq ent_cnt (sslength ent_ss))
	;debug
	(command "erase" ent_ss "" )
	(setq str_tmp (strcat str (strcat ent_type (strcat ":" (strcat (itoa ent_cnt) "\n")))))
	(setq str str_tmp)
	(setq all_cnt (- all_cnt ent_cnt))
      )
    )

    (setq loop_i (1+ loop_i))
  )
  (prompt "\n剩余不知类型实体，请用LIST检查看")
)
