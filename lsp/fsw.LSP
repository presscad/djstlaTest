

(defun set_var ()
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
)

(defun c:fsw (/ graphic_ty cell_all )
  (setq graphic_ty (reference))
  (setq cell_all (cell_select))		;���ص���
  (set_var)
  (if cell_all
    (progn
      (vl-load-com)
      (cell_array cell_all graphic_ty)
      (alert "\n        �Ƿ�Ҫ�Ӽ�ͷ!     \n        ����logoû��!       ")
    )
  )
  (princ)
)


(defun cell_array (cell	doc_ty	    /		emulsion    emulsion_big
			se_cell	    lef_rit	a_is	    se_cut
			doc_ty_size doc_ty_ty	cell_p	    cell_ld
			cell_rd	    cell_di_x	cell_di_y   all_row_di
			all_clu_di  rec		rec_le	    rows
			colums	    colums_fin	cut_cell    clow_dis
			row_dis	    mid_di	cell_cell   mid_clum
			mid_le_c    lef_rit	cent_cell   fi_p_x
			fi_p_y	    se_p_x	se_p_y	    fi_p
			se_p	    rec_le_x	rec_len	    rec_ri
			rec_ri_x    lef_clu	right_clu   cutline_x
			cut_bod_name		cut_name    bod_name
			cutline_mid cutline	txt_in	    txt_widen
			eight_x	    eight_y	eight_mid   ht_txt
		        txt_space   txt_lef     txt_3_len
		       )
;-----------------------------------------------------------------------------------------------------------
					;�˴���Ҫ������ʼ��һЩ����,�Ҽ���������Ŀ���
  (setq emulsion nil)			;������ȡ�Ƿ�Ϊemulsion
  (setq emulsion_big nil)		;��������Ƿ�Ϊemulsion���
  (setq se_cell nil)			;�����ж��Ƿ��еڶ�������
  (setq lef_rit nil)			;��������emulsion�м��ʱ�����ҵ���������=ʱ����
  (setq a_is nil)			;�������Ƿ�ΪA��
  (setq se_cut nil)			;�������ж��Ƿ��еڶ���cut_line�ߺ�888
  (setq doc_ty_size (substr doc_ty 1 1))
  (setq doc_ty_ty (substr doc_ty 2 1))
  (setq cell_p (getbound cell))
  (setq cell_ld (car cell_p))		;���������½�
  (setq cell_rd (cadr cell_p))		;���������½�
  (setq cell_di_x (- (car cell_rd) (car cell_ld))) ;������X����ľ���
  (setq cell_di_y (- (cadr cell_rd) (cadr cell_ld))) ;������Y����ľ���
  (setq all_row_di cell_di_y)
  (setq all_clu_di cell_di_x)		;��ʼ���ܵĿ���
  (setq rec (entlast))
  (command "layer" "n" "ref" "")
  (command "change" rec "" "p" "la" "ref" "")
  (setq rec_le (ssget "X" (list (cons 8 "ref"))))
  (if (or (= doc_ty_ty "3") (= doc_ty_ty "4"))
    (progn
      (setq emulsion T)
      (if (= doc_ty_size "1")
	(setq emulsion_big T)
      )
    )
    (setq emulsion nil)
  )
  (if (or (= doc_ty_ty "1") (= doc_ty_ty "3"))
    (setq a_is T)
  )
  (setq txt_3
       (ssget "X"
	      '(
		(-4 . "<OR")
		(1 . "##")
		(1 . "# #")
		(-4 . "OR>")
	       )
       )
 );�õ�##������������!!
  (setq rows 1 colums 1)
  (setq row_dis 1 clow_dis 1)
  (setq txt_lef 0 txt_space 0);Ϊ�˼����ֶ���ʼ!
  

  ;-----------------------------------------------------------------------------------------------------------
  ;�˴�������������,cut_line���뵥���ľ���	
  (setq rows (getint"�����뵥��������"))
  (setq colums (getint "�����뵥��������"))
  (if (> rows 1)
    (progn
      (setq row_dis (getreal "�������о�"))
      (setq all_row_di (+ (* (- rows 1) row_dis) cell_di_y))
    )
  )					;if

  (if emulsion
    (if	(> colums 1)
      (setq clow_dis (getreal "�������о�"))
    )					;�ɰ�
    (if	(> colums 2)
      (setq clow_dis (getreal "�������о�"))
    )					;����
  )
  (setq colums_fin colums)
  ;;��ʼ�����յ�������Ҫ��������filme�����м���eulsion���������Ҹ�����=��
  (setq cut_cell (getreal "������cut_line���뵥���ľ���"))

  ;-----------------------------------------------------------------------------------------------------------
  ;�˴���Ҫ�Ǹ������ͷּ������X,Y������ܳ�������Ҫ�Ű������,
  ;�Լ�����lef_rit��ֵ(������emulsion�м�����Ǵ��ڼ������������м���)
  (if emulsion
    (if	(> colums 1)
      (progn
	(initget " Yes    No")
	(setq mid_di (getkword "\n�м䵥���Ƿ��м��(Yes/<No>):"))
	(if (or (= mid_di "") (= mid_di nil))
	  (setq mid_di "No")
	)				;if
	(if (= mid_di "Yes")
	  (progn
	    (setq cell_cell (getreal "�������м䵥���ľ���"))
	    (initget " Yes    No")
	    (setq mid_clum (getkword
			     "\n�Ƿ����м������֮���м��(Yes/<No>):"
			   )
	    )
	    (if	(or (= mid_clum "") (= mid_clum nil)(= mid_clum "No"))
	      (progn
		(setq mid_clum "No")
		(initget 7)
		(setq mid_le_c (getint "\n��������ߵ�����"))
		(setq txt_lef mid_le_c)
		(setq txt_space (+ cell_cell cell_di_x))
		(setq lef_rit T)
	      )				;progn
	      (progn
		(setq mid_clum "Yes")
		(setq mid_le_c (/ colums 2))
		(setq txt_lef mid_le_c)
		(setq txt_space (+ cell_cell cell_di_x))
	      )
	    )				;if
	    (setq all_clu_di
		   (+ (* (- colums 2) clow_dis) (* cell_di_x 2) cell_cell)
	    )
	    (setq colums_fin  (/ colums 2)) ;�����һ�ߵĵ����ĸ���
	  )				;progn
	  (setq all_clu_di (+ (* (- colums 1) clow_dis) cell_di_x))
	)				;if
      )					;progn 
    )
    ;;�ɰ�
    (if	(> colums 1)
      (progn
	(setq cent_cell (getreal "�����������뵥���ľ���"))
	(setq all_clu_di
	       (+ (* (- (/ colums 2) 1) clow_dis)
		  cell_di_x
		  cent_cell
	       )
	)				;Ϊ����һ�ߵľ���
	(setq colums_fin (/ colums 2))
	(setq txt_lef colums_fin)
        (setq txt_space (+ (* 2 cent_cell) cell_di_x cut_cell))
      )
    )					;����					
  )					;if�˴�����emulsion��filme������ܵ��о����о�


  ;-----------------------------------------------------------------------------------------------------------
  ;�˴���Ҫ�������һ(�ڶ�)�����������½�,���ڴ˸���mid_cut(��emulsion����2��cut_line)��
  ;se_cell(��2������), ���е�����λ
  (if emulsion
    (progn
      (setq fi_p_x (/ all_clu_di 2))
      (setq fi_p_y (/ all_row_di 2))
      (setq fi_p_x (- 0 fi_p_x))
      (setq fi_p_y (- 0 fi_p_y))
      (setq fi_p (list fi_p_x fi_p_y))
      (if (= mid_di "Yes")
	(progn
	  (setq se_cell T)		;��2������
	  (initget " Yes    No")
	  (setq
	    mid_cut (getkword "\n�Ƿ����м仹��cut_line��(Yes/<No>):")
	  )
	  (if (or (= mid_cut "") (= mid_cut nil))
	    (setq mid_cut "No")
	  )
	  (if (= mid_cut "Yes")
	    (setq se_cut T)		;��2��cut_line��!
	  )
	  (setq se_p_x (* (- mid_le_c 1) clow_dis))
	  (setq se_p_x (+ se_p_x cell_di_x))
	  (setq se_p_x (+ se_p_x fi_p_x cell_cell))
	  (setq se_p_y fi_p_y)
	  (setq se_p (list se_p_x se_p_y))
	)				;progn
      )					;if
    )					;progn   emulsion
    (progn
      (setq se_cell T)			;��2������!
      (setq se_cut T)			;��2��cut_line��!
      (setq fi_p_x (- 0 all_clu_di))
      (setq fi_p_y (/ all_row_di 2))
      (setq fi_p_y (- 0 fi_p_y))
      (setq fi_p (list fi_p_x fi_p_y))
      (setq se_p_x (+ cent_cell cut_cell))
      (setq se_p_y fi_p_y)
      (setq se_p (list se_p_x se_p_y))
    )
  )					;�������һ�����������½Ƕ�λ��,��Ҫ�ڶ���ʱҲ�������,���ҵó��Ƿ���2��cut_line��
  (command "move" "all" "" cell_ld fi_p) ;��λ��һ������
  (if se_cell
    (command "copy" "all" "" fi_p se_p)
  )					;if


  ;-----------------------------------------------------------------------------------------------------------
  ;�˴����Ű�REC
  (setq rec (ssget "X" (list (cons 8 "ref"))))
  (setq rec_len (sslength rec))
  (if (> rec_len 1)
    (progn
      (setq rec_le (ssname rec_le 0))
      (setq rec_le_x (cadr (assoc 10 (entget rec_le))))
      (setq rec_ri (ssname rec 0))
      (setq rec_ri_x (cadr (assoc 10 (entget rec_ri))))
      (if (= rec_le_x rec_ri_x)
	(setq rec_ri (ssname rec 1))
      )
    )
  )					;�˴��ֵõ����ҵ�2��REC(����2��RECʱ)
  (if lef_rit
    (progn
      (setq lef_clu mid_le_c)
      (setq right_clu (- colums lef_clu))
      (if (and (> rows 1) (> lef_clu 1))
	(command "array" rec_le	"" "r" rows lef_clu row_dis clow_dis)
	(if (> rows 1)
	  (command "array" rec_le "" "r" rows 1 row_dis)
	  (if (> lef_clu 1)
	    (command "array" rec "" "r" 1 lef_clu clow_dis)
	  )
	)
      )					;��ߵ�REC�Ű�
      (if (and (> rows 1) (> right_clu 1))
	(command "array" rec_ri	"" "r" rows right_clu row_dis clow_dis)
	(if (> rows 1)
	  (command "array" rec_ri "" "r" rows 1 row_dis)
	  (if (> lef_clu 1)
	    (command "array" rec_ri "" "r" 1 right_clu clow_dis)
	  )
	)
      )					;�ұߵ�REC�Ű�
    )					;progn
    (progn
      (if (and (> rows 1) (> colums_fin 1))
	(command "array" rec ""	"r" rows colums_fin row_dis clow_dis)
	(if (> rows 1)
	  (command "array" rec "" "r" rows 1 row_dis)
	  (if (> colums_fin 1)
	    (command "array" rec "" "r" 1 colums_fin clow_dis)
	  )
	)
      )
    )					;progn
  )					;�˴���Ҫ��Ϊ���Ű�REC

  (command "zoom" "e")
  (command "zoom" "0.5e")
  ;-----------------------------------------------------------------------------------------------------------
  ;��cut_line��
  (setq cutline_x (- fi_p_x cut_cell))
  (setq cut_bod_name (file_name doc_ty))
  (setq cut_name (car cut_bod_name))
  (setq bod_name (cadr cut_bod_name))
  (setq cutline_mid (find_cut cut_name))
  (setq cutline (entlast))
  (command "move"
	   cutline
	   ""
	   cutline_mid
	   (list cutline_x 0)
  )
  (if se_cut
    (command "copy" cutline "" fi_p se_p)
  )
  (setq cutline (ssget "X" (list (cons 0 "insert"))))
  (command "EXPLODE" cutline)
  (if se_cut
    (command "EXPLODE" cutline)		;����ը2����Ϊ�˽������2��cut_lineը��,Ϊ�˸��õĵõ�888�����ĵ�
  )					;����cut_line���ѼӺ�!


  ;-----------------------------------------------------------------------------------------------------------
  ;�˴��ȼ�888���ټ�����
  (if a_is
    (progn
      (setq txt_in (list (- fi_p_x 4) (+ fi_p_y 4))) ;���ֵĲ����
      (setq txt_widen (- all_row_di 45)) ;���ֵĿ���
      (setq eight_x (- fi_p_x 5))
      (setq eight_y (- -20 fi_p_y))
      (setq eight_mid (find_eight))
      (setq eight_name (entlast))
      (command "move"
	       eight_name
	       ""
	       eight_mid
	       (list eight_x eight_y)
      )
      (if se_cut
	(command "copy" eight_name "" fi_p se_p)
      )
      (command "explode" (entlast))
      (setq ht_txt (getreal "\n���������ֵĸ߶�:"))
      (a_txt txt_in txt_widen ht_txt)
      (if (not emulsion)
	(progn
	  (setq txt_in (list (- se_p_x 4) (+ fi_p_y 4)))
	  (a_txt txt_in txt_widen ht_txt)
	)
      )
    )
  )					;����A���888�������ѼӺ�!


  ;-----------------------------------------------------------------------------------------------------------
  ;��Բ,emulsion�ӱ�����ѯ���Ƿ�Ҫ��ģ��!��emulsionҪ�ƶ�;�ӱ߿��ļ�
  (make_circle)				
  (if emulsion
    (bod fi_p_x cut_cell doc_ty_size)
  )					;emulsion�ӱ���!
 (set_var)
 (if txt_3
   (progn
     (setq txt_3_len (sslength txt_3))
     (if (< txt_3_len 3)
       (progn
	 (initget " Yes    No")
	 (setq txt_add (getkword "\n�Ƿ�Ҫ������:(Yes/<No>):"))
	 (if (= txt_add "Yes")
	   (txt_num txt_3 rows colums row_dis clow_dis txt_lef txt_space)
					;txt_3Ϊ##�ŵ�ѡ��txt_lef�����ֵ���ߵĸ���
	 )
       )
     )
   )
 )					;txt_space Ϊ���+��������
    
  (if emulsion_big
    (command "move" "all" "" (list 0 0) (list (/ cut_cell 2) 0))
  )					;
  (find_bod bod_name)
  (command "explode" (entlast))
  (command "explode" (ssget "X" (list (cons 0 "insert"))))
)


					
;-----------------------------------------------------------------------------------------------------------
;Ϊ�ɰ滭��������,x_dir ����Ϊ���������½�
;CUT ΪCUT_LINE�뵥���ľ���!seg�Ǵ��С��ķ���ֵ
(defun bod (x_dir      cut	  seg	     /		move_seg
	    bod_fi_lef bod_se_ri  bod_bod    bod_x	bod_y
	    bod_se_lef
	   )
  (set_var)
  (if (= seg "1")
    (progn
      (setq move_seg (/ cut 2))
      (setq bod_fi_lef (list (- -391.392 move_seg) -225))
      (setq bod_se_ri (list (- 391.392 move_seg) 225))
    )
    (progn
      (setq bod_fi_lef (list -304.75 -225))
      (setq bod_se_ri (list 304.75 225))
    )
  )
  (setq bod_bod (getreal "���������cut_line�ľ���"))
  (setq bod_x (- x_dir bod_bod cut))
  (setq bod_y 225)
  (setq bod_fi_ri (list bod_x bod_y))
  (command "rectang" bod_fi_lef bod_fi_ri)
  (setq bod_x (- bod_bod x_dir))
  (setq bod_se_lef (list bod_x -225))
  (command "rectang" bod_se_lef bod_se_ri)
)

;-----------------------------------------------------------------------------------------------------------
;��Բ!��������ڵݹ�ĵ�����Ҫ��Ϊ�˼��ж���ֱ����Բ
(defun make_circle (/ ci_inser ci_inser_x ci_inser_y ci_dot ci_li re_cir)
  (setvar "osmode" 1)
  (setq ci_inser (getpoint "\n��ָ��Բ��λ��<enter���һ��˳�>:"))
  (if ci_inser
    (progn
      (setq ci_r (getreal "\n������Բ��ֱ��:"))
      (setq ci_r (/ ci_r 2))
      (setq ci_li
	     (list (cons 0 "CIRCLE") (cons 8 "circle") (cons 40 ci_r))
      )
      (while ci_inser
	(setvar "osmode" 0)
	(setq ci_inser_x (getreal "\n������X�����ƫ��ֵ:"))
	(setq ci_inser_y (getreal "\n������y�����ƫ��ֵ:"))
	(setq ci_inser_x (+ (car ci_inser) ci_inser_x))
	(setq ci_inser_y (+ (cadr ci_inser) ci_inser_y))
	(setq ci_inser (list ci_inser_x ci_inser_y))
	(setq ci_dot (list (cons 10 ci_inser)))
	(setq ci_li (append ci_li ci_dot))
	(entmake ci_li)
	(setvar "osmode" 1)
	(setq ci_inser (getpoint "\n��ָ��Բ��λ��<enter���һ��˳�>:"))
      )
      (initget " Yes    No")
      (setq re_cir (getkword "\n�Ƿ���Ҫ��Բ:(Yes/<No>):"))
      (if (or (= re_cir "") (= re_cir nil))
	(setq re_cir "No")
      )
      (if (= re_cir "Yes")
	(make_circle)
      )
    )
  )
)




;-----------------------------------------------------------------------------------------------------------
;������
(defun a_txt (txt_ins	txt_dis	  txt_ht    /	      txt
	      txt_list	txt_box	  txt_x	    txt_sc    
	      txt_list
	     )
  (setq txt (getstring T "\n������ӵ�����:"))
  (setq txt_list (list (cons 1 txt) (cons 40 5)))
  (setq txt_box (textbox txt_list))
  (setq txt_x (di txt_box "x"))
  (setq txt_sc (/ txt_dis txt_x))
					;(setq txt_ro 1.570796)			
  (setq	txt_list (append (list (cons 0 "text"))
			 txt_list
			 (list (cons 10 txt_ins))
			 (list (cons 8 "0"))
			 (list (cons 40 txt_ht))
			 (list (cons 41 txt_sc))
			 (list (cons 50 1.570796))
		 )
  )
  (entmake txt_list)
)

									
;-----------------------------------------------------------------------------------------------------------
;find_bod ����filename (Ҳ���ǰ������)���ӱ߿�
;������ָ�����ļ�����û�ҵ���Ҫ�����ѡ��
(defun find_bod	(filename )
  (setq filename (findfile filename))
  (if (not filename)
    (setq filename (getfiled "ѡȡ�߿�ͼ��" "d:/" "dwg" 8))
  )
  (command "insert" filename (list 0 0) "" "" "")
)
					
;-----------------------------------------------------------------------------------------------------------
;cut_mid �ó�ͼ�������м��,��ɾ����getbound���Ŀ�
(defun cut_mid (/ cut_en cut_li cut_x_di cut_y_di cut_mid_x)
  (setq cut_en (ssget "X" (list (cons 0 "insert"))))
  (setq cut_li (getbound cut_en))
  (command "erase" (entlast) "")
  (setq cut_x_di (/ (di cut_li "x") 2))
  (setq cut_y_di (/ (di cut_li "y") 2))
  (setq	cut_mid_x (list	(+ (caar cut_li) cut_x_di)
			(+ (cadar cut_li) cut_y_di)
		  )
  )
)

;-----------------------------------------------------------------------------------------------------------
;��888���������ĵ�
(defun find_eight (/ mid filename)
  (setq filename "D:\\fsw\\888.dwg")
  (setq filename (findfile filename))
  (if (not filename)
    (setq filename (getfiled "ѡȡ888ͼ��" "d:/" "DWG" 8))
  )
  (command "insert" filename (list 0 0) "" "" "")
  (setq mid (cut_mid))
)


;-----------------------------------------------------------------------------------------------------------
;��cut_line���������ĵ�
(defun find_cut	(filename / mid)
  (setq filename (findfile filename))
  (if (not filename)
    (setq filename (getfiled "ѡȡcut_lineͼ��" "d:/" "dwg" 8))
  )
  (command "insert" filename (list 0 0) "" "" "")
  (setq mid (cut_mid))
)


					
;-----------------------------------------------------------------------------------------------------------
; di  ��:������ɵ��б���X,����Y����ľ���,�һ᷵����
(defun di (box x_y)
  (if (= x_y "x")
    (setq box (abs (- (caadr box) (caar box))))
    (setq box (abs (- (cadadr box) (cadar box))))
  )
)

;-----------------------------------------------------------------------------------------------------------
;���ݰ����ͷ���cut_name �� bod_name
(defun file_name (ty / cut_name bod_name name)
  (setq ty_fi (substr ty 1 1))
  (setq ty_se (substr ty 2 1))
  (if (and (or (= ty_fi "1") (= ty_fi "2"))
	   (or (= ty_se "3") (= ty_se "4"))
      )
    (progn
      (if (= ty_fi "1")
	(if (= ty_se "3")
	  (progn
	    (setq cut_name "D:\\fsw\\cuta.dwg")
	    (setq bod_name "D:\\fsw\\EA_BIG.dwg")
	  )				;EA_BIG
	  (progn
	    (setq cut_name "D:\\fsw\\cutb.dwg")
	    (setq bod_name "D:\\fsw\\EB_BIG.dwg")
	  )				;EB_BIG
	)				;3ΪA
	(if (= ty_se "3")
	  (progn
	    (setq cut_name "D:\\fsw\\cuta.dwg")
	    (setq bod_name "D:\\fsw\\EA_SMA.dwg")
	  )				;EA_SMA
	  (progn
	    (setq cut_name "D:\\fsw\\cutb.dwg")
	    (setq bod_name "D:\\fsw\\EB_SMA.dwg")
	  )				;EB_SMA
	)
      )
    )					;�ɰ�
    (progn
      (if (= ty_fi "1")
	(if (= ty_se "1")
	  (progn
	    (setq cut_name "D:\\fsw\\cuta.dwg")
	    (setq bod_name "D:\\fsw\\FLA_BIG.dwg")
	  )				;FLA_BIG.dwg
	  (progn
	    (setq cut_name "D:\\fsw\\cutb.dwg")
	    (setq bod_name "D:\\fsw\\FLB_BIG.dwg")
	  )				;FLB_BIG.dwg
	)				;3ΪA
	(if (= ty_se "1")
	  (progn
	    (setq cut_name "D:\\fsw\\cuta.dwg")
	    (setq bod_name "D:\\fsw\\FLA_SMA.dwg")
	  )				;FLA_SMA.dwg
	  (progn
	    (setq cut_name "D:\\fsw\\cutb.dwg")
	    (setq bod_name "D:\\fsw\\FLB_SMA.dwg")
	  )				;FLB_SMA.dwg
	)
      )					;����
    )
  )
  (setq name (list cut_name bod_name))
)

					
					
;-----------------------------------------------------------------------------------------------------------
;reference ����ʶ��������,	big_smallΪ1ʱ��� 2ΪС��
;key_ty 1Ϊfilm_a 2Ϊfilm_b 3Ϊemulsion_a 4Ϊemulsion_b
;���ķ���ֵΪ big_small�� key_ty ���б�
(defun reference (/ big_small key_ty key_b_ty)
  (initget "1  2")
  (setq	big_small
	 (getkword
	   "\n-----���(1)/С��<2>-----"
	 )
  )
  (if (or (= big_small "") (= big_small nil))
    (setq big_small "2")
  )
  (initget "1  2 3 4")
  (setq	key_ty
	 (getkword
	   "\n-----film_a(1)/film_b(2)/emulsion_a(3)/emulsion_b<4>-----"
	 )
  )
  (if (or (= key_ty "") (= key_ty nil))
    (setq key_ty "4")
  )
  (setq key_b_ty (strcat big_small key_ty))
)

					
;-----------------------------------------------------------------------------------------------------------
; cell_select ����������ѡ��ʽ���ͼ����������λ
(defun cell_select (/ key layer_name cell_all)
  (initget "Select  One All ")
  (setq	key
	 (getkword
	   "\n��ѡ�����Ķ�λ��ʽ:\nSelect Objects/One layer/<All layer>"
	 )
  )
  (if (= key "One")
    (progn
      (setq layer_name
	     (strcase (getstring "��������:"))
      )
      (while (or (not (setq found (tblsearch "LAYER" layer_name)))
		 (= layer_name "")
	     )
	(setq layer_name (getstring "��������:"))
      )
      (setq cell_all (ssget "X" (list (cons 8 layer_name))))
    )
  )
  (if (= key "Select")
    (setq cell_all (ssget))
  )
  (if (or (= key "All") (= key nil))
    (setq cell_all (ssget "x"))
  )
  (setq cell_all cell_all)
)



;-----------------------------------------------------------------------------------------------------------
; getbound ȡ��ͼ�ε������,���������Ŀ�,  �������½Ǻ����½ǵ��б�ֵ
(defun getbound	(ss_all	  /	   ss_len   count    pl_name  ent_obj
		 ld	  rd	   max_x    min_x    max_y    min_y
		 ld_rd
		)
  (setq ss_len (sslength ss_all))
  (setq count 1)
  (setq pl_name (ssname ss_all 0))
  (setq ent_obj (vlax-ename->vla-object pl_name))
  (vla-getboundingbox ent_obj 'ld 'rd)
  (setq ld (vlax-safearray->list ld))
  (setq rd (vlax-safearray->list rd))
  (setq max_x (car rd))
  (setq min_x (car ld))
  (setq max_y (cadr rd))
  (setq min_y (cadr ld))
  (repeat (- ss_len 1)
    (setq pl_name (ssname ss_all count))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'rd)
    (setq ld (vlax-safearray->list ld))
    (setq rd (vlax-safearray->list rd))
    (setq max_x (max (car rd) max_x))
    (setq min_x (min (car ld) min_x))
    (setq max_y (max (cadr rd) max_y))
    (setq min_y (min (cadr ld) min_y))
    (setq count (1+ count))
  )
  (setq rd (list max_x max_y))
  (setq ld (list min_x min_y))
  (command "rectang" ld rd)
  (setq ld_rd (list ld rd))
)


;-----------------------------------------------------------------------------------------------------------
;�˴�������
(defun txt_num (txt_3	   rows	    colums   row_dis  clow_dis txt_lef
		  txt_space	    /	     ssdown   ssup     ssd_ent
		  do_po	   up_po    d_x	     u_x      ssd_li   ssu_li
		  md_txt   mid	    row	     colu     row_di   colu_di
		  lf_txt   ri_txt   txt_dow  txt_up
		 )
  (setq txt_len (sslength txt_3))
  (setq txt_doub nil)
  (setq txt_le_len 1)
  (if (= txt_len 2)
    (progn
      (setq txt_doub T)
      (setq txt_fi_in (entget (ssname txt_3 0)))
      (setq txt_fi_in (cdr (assoc 10 txt_fi_in)))
      (setq txt_fi_x (car txt_fi_in))
      (setq txt_fi_y (cadr txt_fi_in))
      (setq txt_se_in (entget (ssname txt_3 1)))
      (setq txt_se_in (cdr (assoc 10 txt_se_in)))
      (setq txt_se_x (car txt_se_in))
      (setq txt_se_y (cadr txt_se_in))
      (if (< txt_fi_y txt_se_y)
	(progn
	  (setq ssdo_name (ssname txt_3 0))
	  (setq ssup_name (ssname txt_3 1))
	)
	(progn
	  (setq ssdo_name (ssname txt_3 1))
	  (setq ssup_name (ssname txt_3 0))
	)
      )
    )
    (setq ssdo_name (ssname txt_3 0))
  )

  (setq dis_space (getreal "\n������Ͽ��Ŀ���:"))
  (command "layer" "m" "txt" "")
  (setq ssd_ent (entget ssdo_name))
  (setq do_po (cdr (assoc 10 ssd_ent)))
  (setq d_x (car do_po))
  (setq	ssd_li (list (cons 0 "text")
		     (assoc 40 ssd_ent)
		     (assoc 50 ssd_ent)
		     (assoc 71 ssd_ent)
		     (cons 8 "txt")
	       )
  )

  (if txt_doub
    (progn
      (setq ssu_ent (entget ssup_name))
      (setq up_po (cdr (assoc 10 ssu_ent)))
      (setq u_x (car up_po))
      (setq ssu_li (list (cons 0 "text")
			 (assoc 40 ssu_ent)
			 (assoc 50 ssu_ent)
			 (assoc 71 ssu_ent)
			 (cons 8 "txt")
		   )
      )
    )
  )
  (if (= (substr (cdr (assoc 1 ssd_ent)) 2 1) " ")
    (setq md_txt t)
    (setq md_txt nil)
  )

  (setq lf_txt 0)
  (repeat colums
    (setq lf_txt (+ lf_txt 1))
    (setq mid 0)
    (setq d_y (cadr do_po))
    (if	txt_doub
      (setq u_y (cadr up_po))
    )
    (setq ri_txt 64)
    (repeat rows
      (setq ri_txt (+ ri_txt 1))
      (if (> ri_txt 90)
	(progn (setq ri_txt 65
		     mid 1
	       )
	)
      )
      (setq txt_dow (list 10 d_x d_y))
      (maketxt ssd_li lf_txt ri_txt txt_dow mid md_txt)
      (setq d_y (+ d_y row_dis))
      (if txt_doub
	(progn
	  (setq ri_txt (+ ri_txt 1))
	  (if (> ri_txt 90)
	    (progn (setq ri_txt	65
			 mid 1
		   )
	    )
	  )
	  (setq txt_up (list 10 u_x u_y))
	  (maketxt ssu_li lf_txt ri_txt txt_up mid md_txt)
	  (setq u_y (+ u_y row_dis))
	)
      )
    )
    (if	txt_doub
      (if (= txt_le_len txt_lef)
	(setq u_x (+ u_x txt_space))
	(setq u_x (+ u_x clow_dis))
      )
    )
    (if	(= txt_le_len txt_lef)
      (setq d_x (+ d_x txt_space))
      (setq d_x (+ d_x clow_dis))
    )
    (setq txt_le_len (+ txt_le_len 1))
  )
  (fsw_mak dis_space)
  (princ)
)




(defun getdetail (item ent / atome)
  (setq atome (cdr (assoc item ent)))
)

(defun rect (txt    /	   n	  txt_10 txt10_x       txt10_y
	     txt_40 txt_41 txt_1  fi	 se	txt_len	      txt_width
	     cont   cont_x sp	  kx	 ky	tt     bot    x1
	     x2	    x3	   x4	  y3	 y4
	    )
  (setq n 0)
  (setq txt_10 (getdetail 10 txt))
  (setq txt10_x (car txt_10))
  (setq txt10_y (cadr txt_10))
  (setq txt_40 (getdetail 40 txt))
  (setq txt_41 (getdetail 41 txt))
  (setq txt_1 (getdetail 1 txt))
  (setq txt_len (strlen txt_1))
  (setq txt_width (* txt_41 txt_40))
  (setq cont 0.666667)
  (setq cont_x (* cont txt_40 txt_41))
  (setq sp (/ (- txt_width cont_x) 2))
  (setq x1 (- txt10_x sp))
  (command "layer" "m" "tem" "")
  (while (> txt_len 0)
    (setq cont 0.666667)
    (setq n (+ n 1))
    (setq tt (substr txt_1 n 1))
    (if	(or (= tt "<") (= tt ">") (= tt "0") (= tt "?"))
      (setq cont 0.5)
    )
    (if	(or (= tt ".") (= tt "!"))
      (setq cont 0)
    )
    (if	(or (= tt "1") (= tt "(") (= tt ")") (= tt "I"))
      (setq cont 0.3333)
    )
    (if	(or (= tt "W") (= tt "V"))
      (setq cont 1)
    )
    (if	(or (= tt "'") (= tt ","))
      (setq cont 0.1667)
    )
    (setq cont_x (* cont txt_40 txt_41))
    (setq kx nil)
    (if	(= tt "A")
      (setq kx	0.55
	    ky	0.5
	    bot	0
      )
    )
    (if	(= tt "4")
      (setq kx	0.54
	    ky	0.45
	    bot	0
      )
    )
    (if	(= tt "D")
      (setq kx	0.5
	    ky	0.625
	    bot	sp
      )
    )
    (if	(or (= tt "R") (= tt "P") (= tt "9"))
      (setq kx	0.75
	    ky	0.5
	    bot	0
      )
    )
    (if	(= tt "6")
      (setq kx	0.25
	    ky	0.5
	    bot	sp
      )
    )
    (if	(or (= tt "O") (= tt "Q") (= tt "0"))
      (setq kx	0.5
	    ky	0.5
	    bot	sp
      )
    )
    (if	(= tt "B")
      (setq kx	0.25
	    ky	0.625
	    bot	sp
      )
    )
    (if	(= tt "8")
      (setq kx	0.25
	    ky	0.5
	    bot	sp
      )
    )
    (setq txt_len (- txt_len 1))
    (setq x2 (+ x1 cont_x sp sp))
    (if	kx
      (progn
	(setq y1 (- (* txt_40 kx) barmid))
	(setq y1 (+ y1 txt10_y))

	(setq y2 (+ y1 bar))
	(setq fi (list x1 y1))
	(setq sc (list x2 y2))
	(command "RECTANG" fi sc)
	(if (or (= tt "B") (= tt "8"))
	  (progn
	    (setq y1 (- (* txt_40 0.75) barmid))
	    (setq y1 (+ y1 txt10_y))
	    (setq x2 (+ x1 cont_x sp sp))
	    (setq y2 (+ y1 bar))
	    (setq fi (list x1 y1))
	    (setq sc (list x2 y2))
	    (command "RECTANG" fi sc)
	  )
	)
	(setq x3 (- (* cont_x ky) barmid))
	(setq x3 (+ x1 x3 sp))
	(setq x4 (+ x3 bar))
	(if (or (= tt "P") (= tt "R") (= tt "9"))
	  (setq y3 (- (+ txt10_y (* txt_40 0.5)) SP))
	  (setq y3 (- txt10_y bot))
	)
	(if (= tt "6")
	  (setq y4 (+ (+ txt10_y (* txt_40 0.5)) SP))
	  (setq y4 (+ txt_40 txt10_y sp))
	)
	(setq fi (list x3 y3))
	(setq sc (list x4 y4))
	(command "RECTANG" fi sc)
      )
    )
    (setq x1 x2)
  )
)


(defun fsw_mak (bar /  n txt_sel sel_len barmid txt_name txt_ent txt_50 txt_71 txt_10)
  (setq txt_sel (ssget "x" (list (cons 8 "txt"))))
  (setq sel_len (sslength txt_sel))
  (setq barmid (/ bar 2))
  (set_var)
  (setq n 0)
  (command "layer" "n" "CUT" "")
  (repeat sel_len
    (setq txt_name (ssname txt_sel n))
    (setq txt_ent (entget txt_name))
    (setq txt_50 (cdr (assoc 50 txt_ent)))
    (setq txt_71 (cdr (assoc 71 txt_ent)))
    (setq txt_10 (cdr (assoc 10 txt_ent)))
    (setq n (+ n 1))
    (rect txt_ent)
    (ro txt_50 txt_71 txt_10)
  )
  (command "layer" "m" "0" "")
  (command "purge" "a" "*" "n")
)


(defun ro (t_50 t_71 t_10 / ro_object txt10_y txt10_x ang)
  (setq txt10_x (car t_10))
  (setq txt10_y (cadr t_10))
  (setq ro_object (ssget "x" (list (cons 8 "tem"))))
  (if ro_object
    (progn
      (setq ang (atof (angtos t_50 0 2)))
      (if (= t_71 4)
	(mi_ox ro_object)
      )
      (if (= t_71 2)
	(mi_oy ro_object)
      )
      (if (= t_71 6)
	(ro_o ro_object 180)
      )
      (if (/= ang 0)
	(ro_o ro_object ang)
      )
      (command "change" ro_object "" "p" "layer" "CUT" "")
    )
  )
)


(defun ro_o (ro_object ang)
  (command "ROTATE" ro_object "" t_10 ang)
)

(defun mi_ox (ro_object)
  (command "mirror"
	   ro_object
	   ""
	   t_10
	   (list (+ txt10_x 2) txt10_y)
	   "Y"
  )
)

(defun mi_oy (ro_object)
  (command "mirror"
	   ro_object
	   ""
	   t_10
	   (list txt10_x (+ txt10_y 2))
	   "y"
  )
)

(defun maketxt (litxt txt_l txt_r inserpoint mid md_txt)
  (if (> mid 0)
    (setq txt_r (strcat (chr txt_r) (chr txt_r)))
    (if	(and (<= txt_l 9) md_txt)
      (setq txt_r (strcat " " (chr txt_r)))
      (setq txt_r (chr txt_r))
    )
  )
  (setq tytxt (strcat (itoa txt_l) txt_r))
  (setq	litxt (append litxt
		      (list (cons 1 tytxt))
		      (list inserpoint)
	      )
  )
  (entmake litxt)
)

(prompt "\n--������FSW���г���!")
(prompt "\n--����Ƿ�������Ӧ����ż����,�ɰ���û���������!")
(prompt "\n--����Ҫ�õ�ref��txt��,�벻Ҫ�Ƚ����˲�!")











