(defun ofst_pnt	(p x_ofst y_ofst)
  (setq x_val (car p))
  (setq y_val (cadr p))
  (list
    (+ x_val x_ofst)
    (+ y_val y_ofst)
  )
)
(defun chk_box (x_size y_size)
  (setq half_x_size (/ x_size 2))
  (setq half_y_size (/ y_size 2))
  (setq	rgt_up_cnr  (ofst_pnt (list 0 0) half_x_size half_y_size)
	lft_dwn_cnr (ofst_pnt (list 0 0) (- half_x_size) (- half_y_size))
  )
  (setq ss_ld lft_dwn_cnr)
  (setq ss_ru (ofst_pnt lft_dwn_cnr 10 y_size))
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在左边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ld lft_dwn_cnr)
  (setq ss_ru (ofst_pnt lft_dwn_cnr x_size 10))
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在下边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ru (ofst_pnt rgt_up_cnr (- x_size) -10))
  (setq ss_ld rgt_up_cnr)
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在上边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ru (ofst_pnt rgt_up_cnr -10 (- y_size)))
  (setq ss_ld rgt_up_cnr)
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在上边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (command "layer" "M" "F" "")

)
(defun chk_dev_pst (left_down right_up)
  (setq nothing_ss (ssget "C" left_down right_up))
  (if nothing_ss
    (setq result nil)
    (setq result T)
  )
)
(defun get_dev_pst_x (xsize ysize dist_to_frm hlf_dev_high)
  (setq	left_down (ofst_pnt (list (+ (- (/ xsize 2)) dist_to_frm) 0)
			    0
			    (- hlf_dev_high)
		  )
  )
  (setq	right_up (ofst_pnt (list (+ (- (/ xsize 2)) dist_to_frm) 0)
			   9
			   hlf_dev_high
		 )
  )
  (setq half_high (- (fix (/ ysize 2)) 10))
  (setq n_loop 0)
  (setq ok_rst "N")
  (if (chk_dev_pst left_down right_up)
    (setq ok_rst "U")
  )
  (while (and (< n_loop half_high) (= ok_rst "N"))
    (if	(chk_dev_pst
	  (ofst_pnt left_down 0 n_loop)
	  (ofst_pnt right_up 0 n_loop)
	)
      (setq ok_rst "U")
      (if (chk_dev_pst
	    (ofst_pnt left_down 0 (- n_loop))
	    (ofst_pnt right_up 0 (- n_loop))
	  )
	(setq ok_rst "D")
      )
    )
    (setq n_loop (+ n_loop 2))
  )
  (if (= ok_rst "U")
    (setq dev_pst (ofst_pnt left_down 0 n_loop))
  )
  (if (= ok_rst "D")
    (setq dev_pst (ofst_pnt left_down 0 (- n_loop)))
  )
  (if (= ok_rst "N")
    (setq dev_pst nil)
  )
  (setq dev_pst dev_pst)
)

(defun get_dev_pst_y (xsize ysize dist_to_frm hlf_dev_high)
  (setq	left_down (ofst_pnt (list 0 (- (/ ysize 2) dist_to_frm))
			    (- hlf_dev_high)
			    -9
		  )
  )
  (setq	right_up (ofst_pnt (list 0 (- (/ ysize 2) dist_to_frm))
			   hlf_dev_high
			   0
		 )
  )
  (setq half_high (- (fix (/ xsize 2)) 10))
  (setq n_loop 0)
  (setq ok_rst "N")
  (if (chk_dev_pst left_down right_up)
    (setq ok_rst "R")
  )
  (while (and (< n_loop half_high) (= ok_rst "N"))
    (if	(chk_dev_pst
	  (ofst_pnt left_down n_loop 0)
	  (ofst_pnt right_up n_loop 0)
	)
      (setq ok_rst "R")
      (if (chk_dev_pst
	    (ofst_pnt left_down (- n_loop) 0)
	    (ofst_pnt right_up (- n_loop) 0)
	  )
	(setq ok_rst "L")
      )
    )
    (setq n_loop (+ n_loop 2))
  )
  (if (= ok_rst "R")
    (setq dev_pst (ofst_pnt left_down n_loop 0))
  )
  (if (= ok_rst "L")
    (setq dev_pst (ofst_pnt left_down (- n_loop) 0))
  )
  (if (= ok_rst "N")
    (setq dev_pst nil)
  )
  (setq dev_pst dev_pst)
)
(defun dev (xsize ysize m10)
  (initget 1 "A B")
  (setq machine (getkword "\n请选机型800(A)/800(B)?:"))
  (if (>= ysize xsize)
    (progn
  	(initget 1 "Yes No")
  	(setq mirror (getkword "\n图形是否镜像(Yes/No)?"))
      )
    (setq mirror "No")
   )
  (initget 6)
  (setq dev_num (getint "请输入要加的显影标的区数:"))
  (if (> dev_num 16)
    (progn
      (prompt "\n显影区数目太多,我无法正常工作!")
      (exit)
      )
    )  
  (initget 0)
  (if m10
    (if	(>= y_size x_size)
      (progn
	(setq left_pst (get_dev_pst_x xsize ysize 8 17))
	(setq right_pst (get_dev_pst_x xsize ysize (- xsize 17) 17))
	(if (and left_pst right_pst)
	  (progn
	    (draw_dev left_pst "Y" xsize ysize dev_num machine mirror)
	    (draw_dev right_pst "Y" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请手工忝加"
	  )
	)
      )
      (progn
	(setq up_pst (get_dev_pst_y xsize ysize 8 17))
	(setq down_pst (get_dev_pst_y xsize ysize (- ysize 17) 17))
	(if (and up_pst down_pst)
	  (progn
	    (draw_dev up_pst "X" xsize ysize dev_num machine mirror)
	    (draw_dev down_pst "X" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
    )
    (if	(>= y_size x_size)
      (progn
	(setq frm_dist 8)
	(setq left_pst (get_dev_pst_x xsize ysize frm_dist 17))
	(setq right_pst	(get_dev_pst_x
			  xsize
			  ysize
			  (- xsize (+ frm_dist 9))
			  17
			)
	)
	(while (and (not (and left_pst right_pst)) (> frm_dist 2))
	  (setq frm_dist (- frm_dist 2))
	  (setq left_pst (get_dev_pst_x xsize ysize frm_dist 17))
	  (setq	right_pst (get_dev_pst_x
			    xsize
			    ysize
			    (- xsize (+ frm_dist 9))
			    17
			  )
	  )
	)
	(if (and left_pst right_pst)
	  (progn
	    (draw_dev left_pst "Y" xsize ysize dev_num machine mirror)
	    (draw_dev right_pst "Y" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
      (progn
	(setq frm_dist 8)
	(setq up_pst (get_dev_pst_y xsize ysize frm_dist 17))
	(setq down_pst (get_dev_pst_y
			 xsize
			 ysize
			 (- ysize (+ frm_dist 9))
			 17
		       )
	)
	(while (and (not (and up_pst down_pst)) (> frm_dist 2))
	  (setq frm_dist (- frm_dist 2))
	  (setq up_pst (get_dev_pst_y xsize ysize frm_dist 17))
	  (setq	down_pst (get_dev_pst_y
			   xsize
			   ysize
			   (- ysize (+ frm_dist 9))
			   17
			 )
	  )
	)
	(if (and up_pst down_pst)
	  (progn
	    (draw_dev up_pst "X" xsize ysize dev_num machine mirror)
	    (draw_dev down_pst "X" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
    )
  )
)
(defun draw_dev	(position direction xsize ysize dev_num machine mirror)
  (setq base_high 0.399875)
  (setq line_num 300)
  (if (= machine "A")
    (setq increase_width 0.000125)
    (if	(= machine "B")
      (setq increase_width 0.0001)
      (prompt "\n请选择正确的机型!")
    )
  )
  (setq bg_blk (* (/ dev_num 4) 4))
  (setq dev_num (- dev_num bg_blk))
  (if (> bg_blk 0)
    (setq bg_blk (- bg_blk (- 4 dev_num)))
  )
  (setq bg_wid (* bg_blk 2 increase_width))
  (if (or (> bg_blk 0) (= dev_num 0))
    (setq dev_num 4)
  )
  (setq line_patch (* 0.01 (/ increase_width 0.000125)))
  (setq step_len (* line_num 2 line_patch))
  (setq step_len (fix (+ step_len 2)))
  (if (= direction "Y")
    (progn
      (setq y_pst (cadr position))
      (setq diff (+ (/ ysize 2) 0.15))
      (setq diff (- diff (fix diff)))
      (setq diff (- base_high diff))
      (setq position (list (car position) (+ (fix y_pst) diff)))
      (setq position (ofst_pnt position 2 2))
      (setq i_loop 1)
      (while (<= i_loop dev_num)
	(setq p1 (ofst_pnt position 0 (* (- i_loop 1) step_len))
	      P2 (ofst_pnt position 5 (* (- i_loop 1) step_len))
	      p3 (ofst_pnt position
			   5
			   (+ bg_wid
			      (* i_loop 2.0 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
		 )
	      p4 (ofst_pnt position
			   0
			   (+ bg_wid
			      (* i_loop 2.0 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
		 )
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" line_num "1" line_patch)
	(setq p1 (ofst_pnt
		   position
		   0
		   (+ (* (- i_loop 1) step_len) (* line_num line_patch))
		 )
	      P2 (ofst_pnt
		   position
		   5
		   (+ (* (- i_loop 1) step_len) (* line_num line_patch))
		 )
	      p3 (ofst_pnt position
			   5
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
		 )
	      p4 (ofst_pnt position
			   0
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
		 )
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" line_num "1" line_patch)
	(setq i_loop (1+ i_loop))
      )
    )
    (progn
      (setq x_pst (car position))
      (setq diff (+ (/ xsize 2) 0.15))
      (setq diff (- diff (fix diff)))
      (setq diff (- base_high diff))
      (setq position (list (+ (fix x_pst) diff) (cadr position)))
      (setq position (ofst_pnt position 2.0 2.0))
      (setq i_loop 1)
      (while (<= i_loop dev_num)
	(setq p1 (ofst_pnt position (* (- i_loop 1) step_len) 0)
	      P2 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
			   0
		 )
	      p3 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
			   5
		 )
	      p4 (ofst_pnt position (* (- i_loop 1) step_len) 5)
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" "1" line_num line_patch)
	(setq p1 (ofst_pnt
		   position
		   (+ (* line_num line_patch) (* (- i_loop 1) step_len))
		   0
		 )
	      P2 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
			   0
		 )
	      p3 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
			   5
		 )
	      p4 (ofst_pnt
		   position
		   (+ (* line_num line_patch)
		      (* (- i_loop 1) step_len)
		   )
		   5
		 )
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" "1" line_num line_patch)
	(setq i_loop (1+ i_loop))
      )
    )
  )
)
(defun drw_box (xsize ysize)
  (setq	p1 (list (- (/ xsize 2)) (- (/ ysize 2)))
	p2 (list (/ xsize 2) (- (/ ysize 2)))
	p3 (list (/ xsize 2) (/ ysize 2))
	p4 (list (- (/ xsize 2)) (/ ysize 2))
  )
  (command "pline"
	   (ofst_pnt p1 -0.05 -0.05)
	   (ofst_pnt p2 0.05 -0.05)
	   (ofst_pnt p3 0.05 0.05)
	   (list 0.1 (+ (/ ysize 2) 0.05))
	   (list 0.1 (- (/ ysize 2) 0.05))
	   (ofst_pnt p3 -0.05 -0.05)
	   (ofst_pnt p2 -0.05 0.05)
	   (ofst_pnt p1 0.05 0.05)
	   (ofst_pnt p4 0.05 -0.05)
	   (list -0.1 (- (/ ysize 2) 0.05))
	   (list -0.1 (+ (/ ysize 2) 0.05))
	   (ofst_pnt p4 -0.05 0.05)
	   "c"
  )
  (command "pline"
	   (ofst_pnt p1 -0.15 -0.15)
	   (ofst_pnt p1 -0.05 -0.15)
	   (ofst_pnt p1 -0.05 -0.05)
	   (ofst_pnt p1 -0.15 -0.05)
	   "c"
  )
  (command "array"
	   "L"
	   ""
	   "R"
	   "2"
	   "2"
	   (+ ysize 0.2)
	   (+ xsize 0.2)
  )
)
(defun chk_mtr (xsize ysize thick)
  (defun match (xsize ysize thick mtr)
    (if	(> xsize ysize)
      (progn
	(setq tmp xsize)
	(setq xsize ysize)
	(setq ysize tmp)
      )
    )
    (setq mtr_x (car mtr))
    (setq mtr_y (cadr mtr))
    (setq mtr_thick (caddr mtr))
    (if	(and (= thick mtr_thick)
	     (or (and
		   (and (< (- mtr_x xsize) 20) (>= (- mtr_x xsize) 0))
		   (>= mtr_y ysize)
		 )
		 (and
		   (and (< (- mtr_y ysize) 20) (>= (- mtr_y ysize) 0))
		   (>= mtr_x xsize)
		 )
	     )
	)
      (progn
	(getstring (strcat "\n这块将使用版材尺寸为:"
			   (rtos mtr_x)
			   "X"
			   (rtos mtr_y)
			   "X"
			   (rtos mtr_thick)
		   )
	)
	(setq mt T)
      )
      (setq mt nil)
    )
    (setq mt mt)
  )
  (setq	mtr_list (list '(400 400 3)
		       '(450 550 3)
		       '(450 470 3)
		       '(508.4 609.6 4.8)
		 )
  )
  (setq n (length mtr_list))
  (setq m 0)
  (setq mtr (nth m mtr_list))
  (setq mch (match xsize ysize thick mtr))
  (while (and (not mch) (< m n))
    (setq m (1+ m))
    (setq mtr (nth m mtr_list))
    (setq mch (match xsize ysize thick mtr))
  )
  (if mch
    (chk_box x_size y_size)
  )
  (setq mch mch)
)
(defun c:cbk ()
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (setvar "plinewid" 0)
  (setq frm_wid 0.1)
  (setq x_size (getreal "\n请输入X方向的尺寸:"))
  (setq y_size (getreal "\n请输入Y方向的尺寸:"))
  (setq thick (getreal "\n请输入版材厚度(3/4.8):"))
  (command "zoom"
	   "w"
	   (list (- (- (/ x_size 2)) 10) (- (- (/ y_size 2)) 10))
	   (list (+ (/ x_size 2) 10) (+ (/ y_size 2) 10))
  )
  (setq m10 (chk_mtr x_size y_size thick))
  (command "layer" "M" "F" "")
  (dev x_size y_size m10)
  (drw_box x_size y_size)
)