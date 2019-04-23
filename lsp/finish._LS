;Programed at 2004.05.24 for the purpose of array unit_cell 



(defun cp_unit (layername xdist ydist)
  (setq ss (ssget "x" (list (cons 8 layername))))
  (setq left_right (list xdist 0))
  (setq up_down (list 0 ydist))
  (setq lr_ud (list xdist ydist))

  (command "copy" ss "" "0,0" left_right)
  (command "copy" ss "" "0,0" up_down)
  (command "copy" ss "" "0,0" lr_ud)
  (setq ss nil)
)




(defun is_a (layernamea)		;The first function to check is it layer A or B
  (setq flag1 nil)
  (setq layernamea (strcase layernamea t))
  (setq slen (strlen layernamea))
  (setq itr_a 1)

  (while (<= itr_a slen)
    (setq stra (substr layernamea itr_a 1))
    (if	(equal stra "a")
      (setq flag1 t)
    )
    (setq itr_a (+ itr_a 1))
  )
  (if flag1
    (cp_unit layernamea x_distA y_distA)
  )

)


(defun is_b (layernameb)		;The first function to check is it layer A or B
  (setq flag2 nil)
  (setq layernameb (strcase layernameb t))
  (setq slen (strlen layernameb))
  (setq itr_b 1)

  (while (<= itr_b slen)
    (setq strb (substr layernameb itr_b 1))
    (if	(equal strb "b")
      (setq flag2 t)
    )
    (setq itr_b (+ itr_b 1))
  )
  (if flag2
    (cp_unit layernameb x_distB y_distB)
  )
)






(princ"\n--------目的是排版单粒至四周,请敲命令af运行程序-----------")
(defun c:af ( / old_osnap old_ortho x_num y_num x_num y_num x_step y_step
	        x_numA x_numB y_numA y_numB x_distA y_distA x_distB y_distB)
  
  
  (setq old_osnap(getvar"osmode"))
  (setvar "osmode"0)
  (setq old_ortho(getvar"orthomode"))
  (setvar"orthomode"0)
  
  (setq x_num (getreal "\n 请输入X方向排版个数"))
  (setq y_num (getreal "\n 请输入Y方向排版个数"))
  (setq x_num(- x_num 1))
  (setq y_num(- y_num 1))
  
  (setq x_step (getreal "\n 请输入X方向排版步距"))
  (setq y_step (getreal "\n 请输入Y方向排版步距"))
  (if (< (fix x_num) x_num)
    (progn (setq x_numA (+ (fix x_num) 1))
	   (setq x_numB (fix x_num))
    )
    (progn (setq x_numA x_num)
	   (setq x_numB x_num)
    )
  )
  (if (< (fix y_num) y_num)
    (progn (setq y_numA (+ (fix y_num) 1))
	   (setq y_numB (fix y_num))
    )
    (progn (setq y_numA y_num)
	   (setq y_numB y_num)
    )
  )
  (setq x_distA (* x_numA x_step))
  (setq y_distA (* y_numA y_step))
  (setq x_distB (* x_numB x_step))
  (setq y_distB (* y_numB y_step))	;get the dist of A layer or B layer  


  (setq table_data (tblnext "layer" t))
  (setq layer_data (assoc 2 table_data))
  (setq layername (cdr layer_data))
  (is_a layername)
  (is_b layername)
  (while (setq table_data (tblnext "layer"))

    (setq layer_data (assoc 2 table_data))
    (setq layername (cdr layer_data))
    (is_a layername)
    (is_b layername)
  )  
  (setvar "osmode" old_osnap)  
  (setvar"orthomode" old_ortho)

  (setq abc"---------------------------------------------------------------\n")
  (setq a_xstring(strcat "A单粒排版是：" (itoa (fix x_numA)) "*" (rtos x_step) " = " (rtos x_distA)"\n"))
  (setq a_ystring(strcat "                        " (itoa (fix y_numA)) "*" (rtos y_step) " = " (rtos y_distA)"\n"))
  (setq b_xstring(strcat "B单粒排版是：" (itoa (fix x_numB)) "*" (rtos x_step) " = " (rtos x_distB)"\n"))
  (setq b_ystring(strcat "                        " (itoa (fix y_numB)) "*" (rtos y_step) " = " (rtos y_distB)"\n"))
  (setq all_string(strcat a_xstring abc a_ystring abc b_xstring abc b_ystring))
  (alert all_string)
  
  
  
)









