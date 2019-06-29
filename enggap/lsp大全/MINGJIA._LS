;last modified in 20030808
;Add Dummy data input and draw
;check the cell center.



(defun C:mingjia()
  (defun dm (ke1)
  (defun draw_box(p1 p2)
    (setq p3 (list (car p2) (cadr p1)))
    (setq p4 (list (car p1) (cadr p2)))
    (command "pline" p1 p3 p2 p4 "c")
    )  
  (setq
    tl_XD (getreal
	    "\n请输入左上角ＤＵＭＭＹ到左ＩＴＯ边的距离：＜９．０＞"
	  )
  )
  (if (not tl_xd)
    (setq tl_xd 9.0)
  )
  (setq
    tl_YD (getreal
	    "\n请输入左上角ＤＵＭＭＹ到上ＩＴＯ边的距离：＜１．０＞"
	  )
  )
  (if (not tl_yd)
    (setq tl_yd 1.0)
  )
  (setq
    tl_WD (getreal "\n请输入左上角ＤＵＭＭＹ的宽度：＜１０６．０＞")
  )
  (if (not tl_wd)
    (setq tl_wd 106.0)
  )
  (initget 7)
  (setq tl_HI (getreal "\n请输入左上角ＤＵＭＭＹ的高度："))
  (initget "Yes No")
  (setq
    answer (getkword "上端左右的ＤＵＭＭＹ对称吗？（ＹＥＳ／ＮＯ）")
  )
  (if (= answer "Yes")
    (setq tr_xd	tl_xd
	  tr_yd	tl_yd
	  tr_wd	tl_wd
	  tr_hi	tl_hi
    )
    (progn
      (setq tr_XD
	     (getreal
	       "\n请输入右上角ＤＵＭＭＹ到左ＩＴＯ边的距离：＜９．０＞"
	     )
      )
      (if (not tr_xd)
	(setq tr_xd 9.0)
      )
      (setq tr_YD
	     (getreal
	       "\n请输入右上角ＤＵＭＭＹ到上ＩＴＯ边的距离：＜１．０＞"
	     )
      )
      (if (not tr_yd)
	(setq tr_yd 1.0)
      )
      (setq tr_WD
	     (getreal "\n请输入右上角ＤＵＭＭＹ的宽度：＜１０６．０＞")
      )
      (if (not tr_wd)
	(setq tr_wd 106.0)
      )
      (setq tr_HI (getreal (strcat "\n请输入右上角ＤＵＭＭＹ的高度："
				   "＜"
				   (rtos tl_hi)
				   "＞"
			   )
		  )
      )
      (if (not tr_hi)
	(setq tr_hi tl_hi)
      )
    )
  )
  (initget "Yes No")
  (setq
    answer (getkword "上下两端的ＤＵＭＭＹ对称吗？（ＹＥＳ／ＮＯ）")
  )
  (if (= answer "Yes")
    (setq dl_xd	tl_xd
	  dl_yd	tl_yd
	  dl_wd	tl_wd
	  dl_hi	tl_hi
	  dr_xd	tr_xd
	  dr_yd	tr_yd
	  dr_wd	tr_wd
	  dr_hi	tr_hi
    )
    (progn
					;down dummy data

      (setq
	dl_XD
	 (getreal
	   "\n请输入左下角ＤＵＭＭＹ到左ＩＴＯ边的距离：＜９．０＞"
	 )
      )
      (if (not dl_xd)
	(setq dl_xd 9.0)
      )
      (setq
	dl_YD
	 (getreal
	   "\n请输入左下角ＤＵＭＭＹ到下ＩＴＯ边的距离：＜１．０＞"
	 )
      )
      (if (not dl_yd)
	(setq dl_yd 1.0)
      )
      (setq
	dl_WD
	 (getreal "\n请输入左下角ＤＵＭＭＹ的宽度：＜１０６．０＞")
      )
      (if (not dl_wd)
	(setq dl_wd 106.0)
      )
      (initget 7)
      (setq dl_HI (getreal "\n请输入左下角ＤＵＭＭＹ的高度："))
      (initget "Yes No")
      (setq answer
	     (getkword "下端左右的ＤＵＭＭＹ对称吗？（ＹＥＳ／ＮＯ）")
      )
      (if (= answer "Yes")
	(setq dr_xd dl_xd
	      dr_yd dl_yd
	      dr_wd dl_wd
	      dr_hi dl_hi
	)
	(progn
	  (setq	dr_XD
		 (getreal
		   "\n请输入右下角ＤＵＭＭＹ到右ＩＴＯ边的距离：＜９．０＞"
		 )
	  )
	  (if (not dr_xd)
	    (setq dr_xd 9.0)
	  )
	  (setq	dr_YD
		 (getreal
		   "\n请输入右下角ＤＵＭＭＹ到下ＩＴＯ边的距离：＜１．０＞"
		 )
	  )
	  (if (not dr_yd)
	    (setq dr_yd 1.0)
	  )
	  (setq	dr_WD
		 (getreal "\n请输入右下角ＤＵＭＭＹ的宽度：＜１０６．０＞")
	  )
	  (if (not dr_wd)
	    (setq dr_wd 106.0)
	  )
	  (setq
	    dr_HI (getreal (strcat "\n请输入右下角ＤＵＭＭＹ的高度："
				   "＜"
				   (rtos dl_hi)
				   "＞"
			   )
		  )
	  )
	  (if (not dr_hi)
	    (setq dr_hi dl_hi)
	  )
	)
      )
    )
  )

  (setq
    lll_XD (getreal
	     "\n请输入左边ＤＵＭＭＹ到左ＩＴＯ边的距离：＜１．０＞"
	   )
  )
  (if (not lll_xd)
    (setq lll_xd 1.0)
  )
  (setq
    lll_YD (getreal
	     "\n请输入左边ＤＵＭＭＹ到上ＩＴＯ边的距离：＜１４．０＞"
	   )
  )
  (if (not lll_yd)
    (setq lll_yd 14.0)
  )
  (initget 7)
  (setq
    lll_WD (getreal "\n请输入左边ＤＵＭＭＹ的宽度：")
  )
  (setq lll_HI (getreal "\n请输入左边ＤＵＭＭＹ的高度：＜３７８．４＞"))
  (if (not lll_hi)
    (setq lll_hi 378.4)
  )
  (initget "Yes No")
  (setq	answer
	 (getkword "左右两边的ＤＵＭＭＹ对称吗？（ＹＥＳ／ＮＯ）")
  )
  (if (= answer "Yes")
    (setq rrr_Yd lll_yd
	  rrr_xd lll_xd
	  rrr_wd lll_wd
	  rrr_hi lll_hi
    )
    (progn
      (setq
	rrr_XD
	 (getreal
	   "\n请输入右边ＤＵＭＭＹ到右ＩＴＯ边的距离：＜１．０＞"
	 )
      )
      (if (not rrr_xd)
	(setq rrr_xd 1.0)
      )
      (setq
	rrr_YD
	 (getreal
	   "\n请输入右边ＤＵＭＭＹ到上ＩＴＯ边的距离：＜１４．０＞"
	 )
      )
      (if (not rrr_yd)
	(setq rrr_yd 14.0)
      )
      (setq
	rrr_WD	 (getreal (strcat
			    "\n请输入右边ＤＵＭＭＹ的宽度："
			    "＜"
			    (rtos lll_wd)
			    "＞"
			  )
		 ))
      (if (not rrr_wd)
	(setq rrr_wd lll_wd)
	)
	(setq rrr_hi
	       (getreal	"\n请输入右边ＤＵＭＭＹ的高度：＜３７８．４＞"
	       )
	)
		 (if (not rrr_hi)
		   (setq rrr_hi 378.4)
		 )

    )
  )
  (setq
    ITO_wd (getreal
	     "\n请输入ＩＴＯ的宽度：＜３５５．６＞"
	   )
  )
  (if (not ITO_wd)
    (setq ITO_wd 355.6)
  )
  (setq
    ITO_hi (getreal
	     "\n请输入ＩＴＯ高度：＜４０６．４＞"
	   )
  )
  (if (not ITO_hi)
    (setq ITO_hi 406.4)
  )
  (prompt "\n数据检查:")
  (prompt "\n图形名称	高		宽		X向距离		Y向距离	")
  (prompt (strcat "\n左上ＤＭ	"
		  (rtos tl_hi)
		  "	"
		  (rtos tl_wd)
		  "	"
		  (rtos tl_xd)
		  "	"
		  (rtos tl_yd)
	  )
  )
   (setq p1 (list (+ (- (/ ito_wd 2)) tl_xd) (* (- (/ ito_hi 2) tl_hi tl_yd) ke1) ) )
   (setq p2 (list (+ (- (/ ito_wd 2)) tl_xd tl_wd) (* (- (/ ito_hi 2) tl_yd) ke1) ) )
  (draw_box p1 p2)
  (prompt (strcat "\n右上ＤＭ	"
		  (rtos tr_hi)
		  "	"
		  (rtos tr_wd)
		  "	"
		  (rtos tr_xd)
		  "	"
		  (rtos tr_yd)
	  )
  )
   (setq p1 (list (- (/ ito_wd 2) tr_xd tr_wd) (* (- (/ ito_hi 2) tr_hi tr_yd) ke1) ) )
   (setq p2 (list (- (/ ito_wd 2) tr_xd ) (* (- (/ ito_hi 2) tr_yd) ke1) ) )
  (draw_box p1 p2)
  
  (prompt (strcat "\n左下ＤＭ	"
		  (rtos dl_hi)
		  "	"
		  (rtos dl_wd)
		  "	"
		  (rtos dl_xd)
		  "	"
		  (rtos dl_yd)
	  )
  )
   (setq p1 (list (+ (- (/ ito_wd 2)) dl_xd) (* (+ ( -(/ ito_hi 2)) dl_yd) ke1) ) )
   (setq p2 (list (+ (- (/ ito_wd 2)) dl_xd dl_wd) (* (+ (- (/ ito_hi 2)) dl_yd dl_hi) ke1) ) )
  (draw_box p1 p2)  
  (prompt (strcat "\n右下ＤＭ	"
		  (rtos dr_hi)
		  "	"
		  (rtos dr_wd)
		  "	"
		  (rtos dr_xd)
		  "	"
		  (rtos dr_yd)
	  )
  )
   (setq p1 (list (- (/ ito_wd 2) dr_xd dr_wd) (* (+ ( -(/ ito_hi 2)) dr_yd) ke1) ) )
   (setq p2 (list (- (/ ito_wd 2) dr_xd) (* (+ (- (/ ito_hi 2)) dr_yd dr_hi) ke1) ) )
  (draw_box p1 p2)  
  (prompt (strcat "\n左边ＤＭ	"
		  (rtos lll_hi)
		  "	"
		  (rtos lll_wd)
		  "	"
		  (rtos lll_xd)
		  "	"
		  (rtos lll_yd)
	  )
  )
   (setq p1 (list (+ (- (/ ito_wd 2)) lll_xd) (* (-  (/ ito_hi 2) lll_hi lll_yd) ke1) ) )
   (setq p2 (list (+ (- (/ ito_wd 2)) lll_xd lll_wd) (* (- (/ ito_hi 2) lll_yd) ke1) ) )
  (draw_box p1 p2) 
 
  (prompt (strcat "\n右边ＤＭ	"
		  (rtos rrr_hi)
		  "	"
		  (rtos rrr_wd)
		  "	"
		  (rtos rrr_xd)
		  "	"
		  (rtos rrr_yd)
	  )
  )
   (setq p1 (list (- (/ ito_wd 2) rrr_xd rrr_wd) (* (-  (/ ito_hi 2) rrr_hi rrr_yd) ke1) ) )
   (setq p2 (list (- (/ ito_wd 2) rrr_xd) (* (- (/ ito_hi 2) rrr_yd) ke1) ) )
   (draw_box p1 p2)  
  (prompt (strcat "\nＩＴＯ尺寸宽："
		  (rtos ito_wd)
		  "ＩＴＯ尺寸高："
		  (rtos ito_hi)
	  )
  )
  (SETQ RESULT (LIST ITO_WD ITO_HI))
)
  (defun df () 
        (command "pline" (list -175.05 -193.035) "w" 0 0 
                         (list -175.05 -193.773) 
                         (list -174.55 -193.773) 
                         (list -174.55 -193.035) 
                         (list -173.8 -193.035) 
                         (list -173.8 -192.544) 
                         (list -174.55 -192.544) 
                         (list -174.55 -191.807) 
                         (list -175.05 -191.807) 
                         (list -175.05 -192.544) 
                         (list -175.8 -192.544) 
                         (list -175.8 -193.035) 
                         "c"
         )
        (command "pline" (list -175.05 -197.949) "w" 0 0 
                         (list -175.05 -198.686) 
                         (list -174.55 -198.686) 
                         (list -174.55 -197.949) 
                         (list -173.8 -197.949) 
                         (list -173.8 -197.458) 
                         (list -174.55 -197.458) 
                         (list -174.55 -196.721) 
                         (list -175.05 -196.721) 
                         (list -175.05 -197.458) 
                         (list -175.8 -197.458) 
                         (list -175.8 -197.949) 
                         "c"
         )
        (command "pline" (list 175.05 -193.035) "w" 0 0 
                         (list 175.05 -193.773) 
                         (list 174.55 -193.773) 
                         (list 174.55 -193.035) 
                         (list 173.8 -193.035) 
                         (list 173.8 -192.544) 
                         (list 174.55 -192.544) 
                         (list 174.55 -191.807) 
                         (list 175.05 -191.807) 
                         (list 175.05 -192.544) 
                         (list 175.8 -192.544) 
                         (list 175.8 -193.035) 
                         "c"
         )
        (command "pline" (list 175.05 -197.949) "w" 0 0 
                         (list 175.05 -198.686) 
                         (list 174.55 -198.686) 
                         (list 174.55 -197.949) 
                         (list 173.8 -197.949) 
                         (list 173.8 -197.458) 
                         (list 174.55 -197.458) 
                         (list 174.55 -196.721) 
                         (list 175.05 -196.721) 
                         (list 175.05 -197.458) 
                         (list 175.8 -197.458) 
                         (list 175.8 -197.949) 
                         "c"
         )
        (command "pline" (list -175.05 197.949) "w" 0 0 
                         (list -175.05 198.686) 
                         (list -174.55 198.686) 
                         (list -174.55 197.949) 
                         (list -173.8 197.949) 
                         (list -173.8 197.458) 
                         (list -174.55 197.458) 
                         (list -174.55 196.721) 
                         (list -175.05 196.721) 
                         (list -175.05 197.458) 
                         (list -175.8 197.458) 
                         (list -175.8 197.949) 
                         "c"
         )
        (command "pline" (list -175.05 193.035) "w" 0 0 
                         (list -175.05 193.773) 
                         (list -174.55 193.773) 
                         (list -174.55 193.035) 
                         (list -173.8 193.035) 
                         (list -173.8 192.544) 
                         (list -174.55 192.544) 
                         (list -174.55 191.807) 
                         (list -175.05 191.807) 
                         (list -175.05 192.544) 
                         (list -175.8 192.544) 
                         (list -175.8 193.035) 
                         "c"
         )
        (command "pline" (list 175.05 197.949) "w" 0 0 
                         (list 175.05 198.686) 
                         (list 174.55 198.686) 
                         (list 174.55 197.949) 
                         (list 173.8 197.949) 
                         (list 173.8 197.458) 
                         (list 174.55 197.458) 
                         (list 174.55 196.721) 
                         (list 175.05 196.721) 
                         (list 175.05 197.458) 
                         (list 175.8 197.458) 
                         (list 175.8 197.949) 
                         "c"
         )
        (command "pline" (list 175.05 193.035) "w" 0 0 
                         (list 175.05 193.773) 
                         (list 174.55 193.773) 
                         (list 174.55 193.035) 
                         (list 173.8 193.035) 
                         (list 173.8 192.544) 
                         (list 174.55 192.544) 
                         (list 174.55 191.807) 
                         (list 175.05 191.807) 
                         (list 175.05 192.544) 
                         (list 175.8 192.544) 
                         (list 175.8 193.035) 
                         "c"
         )
        (command "pline" (list -215.0 -274.0) "w" 0 0 
                         (list 215.0 -274.0) 
                         (list 215.0 -273.9) 
                         (list -215.0 -273.9) 
                         "c"
         )
        (command "pline" (list -215.0 -272.0) "w" 0 0 
                         (list 215.0 -272.0) 
                         (list 215.0 -271.9) 
                         (list -215.0 -271.9) 
                         "c"
         )
        (command "pline" (list -215.0 -270.0) "w" 0 0 
                         (list 215.0 -270.0) 
                         (list 215.0 -269.9) 
                         (list -215.0 -269.9) 
                         "c"
         )
        (command "pline" (list -215.0 -268.0) "w" 0 0 
                         (list 215.0 -268.0) 
                         (list 215.0 -267.9) 
                         (list -215.0 -267.9) 
                         "c"
         )
        (command "pline" (list -215.0 -266.0) "w" 0 0 
                         (list 215.0 -266.0) 
                         (list 215.0 -265.9) 
                         (list -215.0 -265.9) 
                         "c"
         )
        (command "pline" (list -215.0 -264.0) "w" 0 0 
                         (list 215.0 -264.0) 
                         (list 215.0 -263.9) 
                         (list -215.0 -263.9) 
                         "c"
         )
        (command "pline" (list -215.0 -262.0) "w" 0 0 
                         (list 215.0 -262.0) 
                         (list 215.0 -261.9) 
                         (list -215.0 -261.9) 
                         "c"
         )
        (command "pline" (list -215.0 -260.0) "w" 0 0 
                         (list 215.0 -260.0) 
                         (list 215.0 -259.9) 
                         (list -215.0 -259.9) 
                         "c"
         )
        (command "pline" (list -215.0 -258.0) "w" 0 0 
                         (list 215.0 -258.0) 
                         (list 215.0 -257.9) 
                         (list -215.0 -257.9) 
                         "c"
         )
        (command "pline" (list -215.0 -256.0) "w" 0 0 
                         (list 215.0 -256.0) 
                         (list 215.0 -255.9) 
                         (list -215.0 -255.9) 
                         "c"
         )
        (command "pline" (list -215.0 -254.0) "w" 0 0 
                         (list 215.0 -254.0) 
                         (list 215.0 -253.9) 
                         (list -215.0 -253.9) 
                         "c"
         )
        (command "pline" (list -215.0 -252.0) "w" 0 0 
                         (list 215.0 -252.0) 
                         (list 215.0 -251.9) 
                         (list -215.0 -251.9) 
                         "c"
         )
        (command "pline" (list -215.0 -250.0) "w" 0 0 
                         (list 215.0 -250.0) 
                         (list 215.0 -249.9) 
                         (list -215.0 -249.9) 
                         "c"
         )
        (command "pline" (list -215.0 245.0) "w" 0 0 
                         (list 215.0 245.0) 
                         (list 215.0 244.9) 
                         (list -215.0 244.9) 
                         "c"
         )
        (command "pline" (list -215.0 247.0) "w" 0 0 
                         (list 215.0 247.0) 
                         (list 215.0 246.9) 
                         (list -215.0 246.9) 
                         "c"
         )
        (command "pline" (list -215.0 249.0) "w" 0 0 
                         (list 215.0 249.0) 
                         (list 215.0 248.9) 
                         (list -215.0 248.9) 
                         "c"
         )
        (command "pline" (list -215.0 251.0) "w" 0 0 
                         (list 215.0 251.0) 
                         (list 215.0 250.9) 
                         (list -215.0 250.9) 
                         "c"
         )
        (command "pline" (list -215.0 253.0) "w" 0 0 
                         (list 215.0 253.0) 
                         (list 215.0 252.9) 
                         (list -215.0 252.9) 
                         "c"
         )
        (command "pline" (list -215.0 255.0) "w" 0 0 
                         (list 215.0 255.0) 
                         (list 215.0 254.9) 
                         (list -215.0 254.9) 
                         "c"
         )
        (command "pline" (list -215.0 257.0) "w" 0 0 
                         (list 215.0 257.0) 
                         (list 215.0 256.9) 
                         (list -215.0 256.9) 
                         "c"
         )
        (command "pline" (list -215.0 259.0) "w" 0 0 
                         (list 215.0 259.0) 
                         (list 215.0 258.9) 
                         (list -215.0 258.9) 
                         "c"
         )
        (command "pline" (list -215.0 261.0) "w" 0 0 
                         (list 215.0 261.0) 
                         (list 215.0 260.9) 
                         (list -215.0 260.9) 
                         "c"
         )
        (command "pline" (list -215.0 263.0) "w" 0 0 
                         (list 215.0 263.0) 
                         (list 215.0 262.9) 
                         (list -215.0 262.9) 
                         "c"
         )
        (command "pline" (list -215.0 265.0) "w" 0 0 
                         (list 215.0 265.0) 
                         (list 215.0 264.9) 
                         (list -215.0 264.9) 
                         "c"
         )
        (command "pline" (list -215.0 267.0) "w" 0 0 
                         (list 215.0 267.0) 
                         (list 215.0 266.9) 
                         (list -215.0 266.9) 
                         "c"
         )
        (command "pline" (list -215.0 269.0) "w" 0 0 
                         (list 215.0 269.0) 
                         (list 215.0 268.9) 
                         (list -215.0 268.9) 
                         "c"
         )
        (command "pline" (list 200.1 199.0) "w" 0 0 
                         (list 199.9 199.0) 
                         (list 199.9 208.9) 
                         (list 192.5 208.9) 
                         (list 192.5 209.1) 
                         (list 199.9 209.1) 
                         (list 199.9 214.0) 
                         (list 200.1 214.0) 
                         (list 200.1 209.1) 
                         (list 207.5 209.1) 
                         (list 207.5 208.9) 
                         (list 200.1 208.9) 
                         "c"
         )
        (command "pline" (list -200.1 -214.0) "w" 0 0 
                         (list -199.9 -214.0) 
                         (list -199.9 -224.0) 
                         (list -200.1 -224.0) 
                         "c"
         )
        (command "pline" (list -200.1 5.0) "w" 0 0 
                         (list -199.9 5.0) 
                         (list -199.9 -5.0) 
                         (list -200.1 -5.0) 
                         "c"
         )
        (command "pline" (list 199.9 5.0) "w" 0 0 
                         (list 200.1 5.0) 
                         (list 200.1 -5.0) 
                         (list 199.9 -5.0) 
                         "c"
         )
        (command "pline" (list 215.0 -274.0) "w" 0 0 
                         (list 205.0 -274.0) 
                         (list 205.0 -276.0) 
                         (list 217.0 -276.0) 
                         (list 217.0 -264.0) 
                         (list 215.0 -264.0) 
                         "c"
         )
        (command "pline" (list -215.0 -274.0) "w" 0 0 
                         (list -205.0 -274.0) 
                         (list -205.0 -276.0) 
                         (list -217.0 -276.0) 
                         (list -217.0 -264.0) 
                         (list -215.0 -264.0) 
                         "c"
         )
        (command "pline" (list 199.9 -214.0) "w" 0 0 
                         (list 200.1 -214.0) 
                         (list 200.1 -224.0) 
                         (list 199.9 -224.0) 
                         "c"
         )
        (command "pline" (list 215.0 269.0) "w" 0 0 
                         (list 205.0 269.0) 
                         (list 205.0 271.0) 
                         (list 217.0 271.0) 
                         (list 217.0 259.0) 
                         (list 215.0 259.0) 
                         "c"
         )
        (command "pline" (list -215.0 269.0) "w" 0 0 
                         (list -205.0 269.0) 
                         (list -205.0 271.0) 
                         (list -217.0 271.0) 
                         (list -217.0 259.0) 
                         (list -215.0 259.0) 
                         "c"
         )
        (command "pline" (list -199.9 199.0) "w" 0 0 
                         (list -200.1 199.0) 
                         (list -200.1 208.9) 
                         (list -207.5 208.9) 
                         (list -207.5 209.1) 
                         (list -200.1 209.1) 
                         (list -200.1 214.0) 
                         (list -199.9 214.0) 
                         (list -199.9 209.1) 
                         (list -192.5 209.1) 
                         (list -192.5 208.9) 
                         (list -199.9 208.9) 
                         "c"
         )
  )
(defun chk_total (e g h n str_drct)
	  (setq et_input1 (getreal (strcat " 请输入" str_drct "方向起始值：" )))
	  (setq et_input (getreal (strcat " 请输入" str_drct "方向结束值：" )))
	  (setq et_inputr (- et_input et_input1))
	  (if (= (rem n 2) 1)
	    (setq et_cul (+ (* e n)
			    (* g (/ (- n 1) 2))
			    (* h (/ (- n 1) 2))
			 )
	    )
	    (setq et_cul (+ (* e n)
			    (* g (/ n 2))
			    (* h (- (/ n 2) 1))
			 )
	    )
	  )
	  (if (not (equal et_inputr et_cul 0.001))
	    (progn
	      (getstring (strcat "输入的" str_drct "T与计算出的" str_drct "Total不同请确认！"))
	      (quit)
	    )
	  )
  (setq result (list et_input1 et_input))
	)
  ;输入数据
  (getstring "请注意箭头方向指各+号方向!")
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq et_res (chk_total e_input g_input h_input en_pi "E"))
  (setq et_bg (car et_res))
  (setq et_ed (cadr et_res))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq ft_res (chk_total f_input i_input j_input fn_pi "F"))
  (setq ft_bg (car ft_res))
  (setq ft_ed (cadr ft_res))  
  (setq r_input (getreal "Please input R: "))
  ;(setq ke1 0.9870
;	ce1 0.3800
;	kf1 0.0008
;	cf1 0.3200)					;设置系数---- 做废2005-1-6owal
(setq ke1 0.9872
	ce1 0.3500
	kf1 0.000
	cf1 0.3500)
  
 (getstring (strcat "请确认系数是：Ke=" (rtos ke1) "; Ce=" (rtos ce1) "; Kf=" (rtos kf1)  "; Cf=" (rtos cf1)))
  ;公式计算
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (if (< r_input 0.001)
      (setq r_pi 0.001)
      (setq r_pi r_input)
  )		;半径不能为0
  ;如果EN为奇数则,对g,h进行值交换。
  (if (/= (- (/ en_pi 2.0) (/ en_pi 2)) 0)
    (progn
      (setq tmp g_pi)
      (setq g_pi h_pi)
      (setq h_pi tmp)
      )
    )
;设置图形边界
  (command "limits" (list -500 -500) (list 500 500))
  (command "zoom" "a")
;设置CELL放置的中心
  (setq	glass_x	0
	glass_y	0
  )
;求双粒排版的步距
   (setq x_pitch (+ f_pi f_pi i_pi j_pi))
   (setq y_pitch (+ e_pi e_pi g_pi h_pi))

;求E_TOTAL,F_TOTAL
  (if (or (= en_pi 1) (= fn_pi 1))
    (progn
      (prompt "\n程序不能处理一行或一列的情况，请将EN或FN改为3,然后将多余的删除!")
      (exit)
    )
    (progn
      (cond ((and (= 0 (rem en_pi (fix (/ en_pi 2))))
		  (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;en与fn都是偶数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 0 (rem en_pi (fix (/ en_pi 2))))
		  (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;en是偶数，fn是奇数
	     (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi (fix (/ en_pi 2))))
		  (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;fn是偶数，en是奇数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi (fix (/ en_pi 2))))
		  (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;en与fn都是奇数
	     (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
		   etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	     )
	    )
      )
    )
  )
 ;求左下角第一粒的左下角座标  
  (setq	origin_x (- glass_x (/ ftotal_pi 2))
	origin_y (- glass_y (/ etotal_pi 2))
  )
;初始化循环变量
  (setq loop_e 0)
  (setq loop_f 0)
  (repeat en_pi
    ;印刷方向
    (repeat fn_pi
      ;非印刷方向

      ;求八个顶点与四个倒角的半径
      (setq p1 (list (+ r_pi origin_x) (+ 0 origin_y))
	    p2 (list (+ (- f_pi r_pi) origin_x) (+ 0 origin_y))
	    p3 (list (+ f_pi origin_x) (+ r_pi origin_y))
	    p4 (list (+ f_pi origin_x) (+ (- e_pi r_pi) origin_y))
	    p5 (list (+ (- f_pi r_pi) origin_x) (+ e_pi origin_y))
	    p6 (list (+ r_pi origin_x) (+ e_pi origin_y))
	    p7 (list (+ 0 origin_x) (+ (- e_pi r_pi) origin_y))
	    p8 (list (+ 0 origin_x) (+ r_pi origin_y))
	    o1 (list (+ r_pi origin_x) (+ r_pi origin_y))
	    o2 (list (+ (- f_pi r_pi) origin_x) (+ r_pi origin_y))
	    o3 (list (+ (- f_pi r_pi) origin_x) (+ (- e_pi r_pi) origin_y))
	    o4 (list (+ r_pi origin_x) (+ (- e_pi r_pi) origin_y))
      )
      ;划单粒
      (command "pline"	   p1	 "w"   0     0	   p2 ;down edge
	       "a"   "r"   r_pi	 p3	;down right conner
	       "l"   p4			;right edge
	       "a"   "r"   r_pi	 p5	;upon right conner
	       "l"   p6			;upon edge
	       "a"   "r"   r_pi	 p7	;upon left conner
	       "l"   p8			;left edge
	       "a"   "r"   r_pi	 p1	;down left conner
	       "close"
	      )
      (setq loop_f (1+ loop_f))
      (setq
	gap_f (+ (* i_pi (* (- (/ loop_f 2.0) (/ loop_f 2)) 2))
		 (* j_pi
		    (* (- (/ (+ loop_f 1) 2.0) (/ (+ loop_f 1) 2)) 2)
		 )
	      )
      )
      (setq origin_x (+ origin_x (+ gap_f f_pi)))
    )
    (setq loop_f 0)
    (setq loop_e (1+ loop_e))
    (setq gap_e
	   (+ (* g_pi (* (- (/ loop_e 2.0) (/ loop_e 2)) 2))
	      (* h_pi (* (- (/ (+ loop_e 1) 2.0) (/ (+ loop_e 1) 2)) 2))
	   )
    )
    (setq origin_y (+ origin_y (+ gap_e e_pi)))
    (setq origin_x (- glass_x (/ ftotal_pi 2)))
  )
  (setq txt (getstring "输入客户的MODEL号与日期:" T))
  (setq txt (strcat txt " QINGYI " (itoa  (Fix (getvar "CDATE")))))
  (setq txt (strcase txt))
  (command "text" "-130,227" "6.5" "0" txt)
  (setq ito_size (dm ke1))
  (SETQ ito_wd (car ito_size))
  (setq ito_hi (cadr ito_size))
  (if (not (and (equal et_bg (- ito_hi et_ed) 0.001) (equal ft_bg (- ito_wd ft_ed) 0.001)))
    (getstring "\n请确认单料图形不居中,程序生产图形可能是错误的!")
    )  
  (command "mirror" "all" "" '(0 0) '(0 100) "Y")
  (df)
  ;标识输入  
)
(prompt "\nInput Mingjia to run.")
