;此程序将一个DWG图形转成可用LSP语言绘出的LSP程序
;装入并运行to_command.生成的文件在D盘下面-- 修改2005-1-1 Owal

 (defun getp(name_of_ent num_for / ent_list data_cp vertex_val count dt_top)
         ;(setq ent_data(entget(car(entsel"\n---please select a polyline:"))))
         (setq ent_list(entget name_of_ent))
         (setq data_cp ent_list)
         (setq vertex_val(cdr(assoc 90 data_cp)))
    
         ;(print(strcat"\n" "---There is total "(itoa vertex_val)" vertexs"))
         ;(setq num(getint"\n---please input the number of the point to see the coordinat"))

         (setq count 0)
         (while data_cp
	        (setq dt_top(car data_cp))
	        (setq data_cp(cdr data_cp))
	        (if(equal 10 (car dt_top))
		   (setq count(+ 1 count))		   
		)
	        (if (equal count num_for)
		    (progn
		        (setq p1 dt_top)
			(setq data_cp nil)
		    )
	        )	   
	 )   
    )
;-------------------------------------------------------------------------------------                   --


 (defun dxf (code elist)
        (cdr (assoc code elist))
  )
;-----------------------------------------------------------------------------------------------------------


 (defun pl_to_command (pl f_name / );vertex_num ed en p1 p2 a detail
                                    ;tmp_a first_p tmp_string)

        ;(setq ed (entget pl))
        ;(setq en (entnext (dxf -1 ed)))
        ;(setq detail (entget en))
        ;(setq p1 (dxf 10 detail)) ;First point
        (setq vertex_num(cdr(assoc 90 (entget pl))))
        (setq number 1)
   
        (getp pl 1);there is a function quoted: getp(pl num / ...)
        (setq p1 (cdr p1))
        (princ (strcat (chr 10) "        (command ") f_name)
        (princ (chr 34) f_name)
        (princ "pline" f_name)
        (princ (chr 34) f_name)
        (princ " (list " f_name)
        (princ (car p1) f_name)
        (princ " " f_name)
        (princ (cadr p1) f_name)
        (princ ") " f_name)
        (princ (chr 34) f_name)
        (princ "w" f_name)
        (princ (chr 34) f_name)
        (princ " 0 0 " f_name)

        (setq number (+ 1 number))
        (while (<= number  vertex_num)
	  
               (getp pl number)
	       (setq p1 (cdr p1))
               (princ (strcat (chr 10) "                         (list ") f_name)
               (princ (car p1) f_name)
               (princ " " f_name)
               (princ (cadr p1) f_name)
               (princ ") " f_name)
               (setq number (+ 1 number))
         )
        (if (= 1 (dxf 70 (entget pl)))
           (princ (strcat (chr 10) "                         " (chr 34) "c" (chr 34)) f_name)
           (progn
              (princ (strcat (chr 10) "                        ") f_name)
              (princ (chr 34) f_name)
              (princ (chr 34) f_name)
            )
         )
        (princ (strcat (chr 10) "         )") f_name)
 )
;-----------------------------------------------------------------------------------------------------------


 (defun c:to_command ( );/ f_name strname); / pl_ss ent_name total count tmp_detail f_name) 
           
        (setq strname (getstring nil "Input the file name you want to creat: "))
        (setq strname (strcat "d:/" strname ".lsp"))

        (setq layer_string (getstring nil "Input the layer to be handled: "))
        (setq layer_string (strcase layer_string))

        (setq pl_ss (ssget "X" (list (cons 0 "LWPOLYLINE") (cons 8 layer_string))))
        (if pl_ss
           (progn
              (setq f_name (open strname "w"))
              (princ (strcat (chr 10) " (defun draw_edge () ") f_name)
              (setq total (sslength pl_ss))
              (setq count 0)
              (while (< count total)
                     (setq ent_name (ssname pl_ss count))
                     (if ent_name
                        (progn
                           (setq tmp_detail (entget ent_name))
                           (if (/= tmp_detail nil ) 
                              (pl_to_command ent_name f_name)
                            )
                         )
                      )
                     (setq count (+ 1 count))
               )
              (princ (strcat (chr 10) "  )") f_name)
              (close f_name)
            )
         )
  )

;--------------------------------------------------------------------------------------------------------------------
