(defun c:bb(/ ass_8 col_pd ent_move ent_old ent_over gr group group_name group_name_1 i jj k leng_all leng_move leng_old loop loop_all m move_name_start move_name_xh move_name_xh_all move_pp move_pp_group move_x move_xh move_xh_group move_y name name_go name_group name_group_all name_group_new_all name_move name_old name_start_a>b osmode pp_10 pp_10_new pp_10_x pp_10_y pp_11 pp_11_new pp_11_x pp_11_y pp_a>b pp_cen pp_gr pp_gr_in pp_in_nth pp_lst pp_lst_all pp_lst_all_new pp_move_left pp_move_right pp_new_lst row_width rr ss ss_all ss_move ss_move_all typ uu vv x_max x_min xh_new_lst xh_old_lst xh_over_lst xh_over_lst_old xh_pp xh_x xh_y y_gr y_max y_min y_su)
	(setvar "cmdecho" 0)
	(setq osmode (getvar "osmode"))
	(PROMPT "\ѡ����������ı�")
	(setq ss_all (ssget '((0 . "TEXT,MTEXT"))))
	(setq leng_all (sslength ss_all))
	(setq i -1 pp_lst_all '())
	(repeat leng_all 
		(setq i (1+ i))
		(setq name (ssname ss_all i))
		(setq pp_lst (by-get-box-pp name))
		(setq pp_lst_all (append pp_lst_all pp_lst))	
	)
	
	(setq x_min (car(car(vl-sort pp_lst_all (function(lambda(e1 e2)(< (car e1) (car e2))))))))
	(setq x_max (car(car(vl-sort pp_lst_all (function(lambda(e1 e2)(> (car e1) (car e2))))))))
	(setq y_min (cadr(car(vl-sort pp_lst_all (function(lambda(e1 e2)(< (cadr e1) (cadr e2))))))))
	(setq y_max (cadr(car(vl-sort pp_lst_all (function(lambda(e1 e2)(> (cadr e1) (cadr e2))))))))	
	
	(setq row_width (- x_max x_min))
	(command "_.undo" "be")
	(setq loop_all t)
	(while 	loop_all
		(setq i -1 pp_lst_all '())
		(repeat leng_all 
			(setq i (1+ i))
			(setq name (ssname ss_all i))
			(setq pp_cen (by-get-box-ppcen name))
			(setq group (list (list name) pp_cen))
			(setq pp_lst_all (append pp_lst_all (list group)))	
		)
		(setq pp_lst_all (by-lst-su-group pp_lst_all 1 1 20))
		(setq pp_lst_all_new '() name_group_all '() vv 0 move_name_xh_all '())
		(foreach m pp_lst_all 
			(setq vv (1+ vv))
			(setq m (vl-sort m (function(lambda(e1 e2)(<(car(cadr e1)) (car(cadr e2)))))))
			(setq name_group (cons vv (mapcar 'car m)))
			(setq name_group_all (append name_group_all (list name_group)));���+ͼԪ������//���µ���
			(setq move_name_xh (cons (car(mapcar 'car m)) vv))
			(setq move_name_xh_all (append move_name_xh_all (list move_name_xh)));����ͼԪ��+��ŵ��//���µ���
			
			
			(setq pp_lst_all_new (append pp_lst_all_new (list m)))
		)
		
		
		(setq pp_a>b (mapcar '(lambda(x)(cadr(car x))) pp_lst_all_new));��һ�������ļ���//���µ���
		(setq name_start_a>b (mapcar '(lambda(x)(car(car x))) pp_lst_all_new));��һ��ͼԪ���ļ���//���µ���
		(setq xh_old_lst (mapcar 'cdr move_name_xh_all))
		
		
		(setq ss_move_all (ssadd))
		
		(setq move_xh_group '())
		(WHILE (setq name_move (car(entsel "\nָ���ƶ���")))
			(setq move_y (cadr(by-get-box-ppcen name_move)))
			(setq pp_move_left (list x_min move_y))
			(setq pp_move_right (list x_max move_y))
			
			(command "_.zoom" "w" (list x_min y_min) (list x_max y_max))
			(setq ss_move (ssget "f" (list pp_move_left pp_move_right) '((0 . "TEXT,MTEXT"))))
			(setq move_name_start (ssname ss_move 0))
			(command "_.zoom" "p")
			
			(setq leng_move (sslength ss_move))
			
			(setq k -1)
			(repeat leng_move 
				(setq k (1+ k))
				(setq name_move (ssname ss_move k))
				(setq ent_move (entget name_move))
				(setq ass_8 (assoc 8 ent_move))
				(setq col_pd (assoc 62 ent_move))
				
				
				(if (= col_pd nil)
					(progn 
						(setq ent_move (entmod (subst (cons 62 181)(assoc 8 ent_move) ent_move)))
						(setq ent_move (entmod (subst ass_8 (assoc 410 ent_move) ent_move)))
					)
					(entmod (subst (cons 62 181)(assoc 62 ent_move) ent_move))
				)
				(ssadd name_move ss_move_all)	
			)
			(setq move_xh (cdr(assoc (list move_name_start) move_name_xh_all)))
			(setq move_xh_group (append move_xh_group (list move_xh)));�ƶ���������
			
		)
		
		(setq xh_new_lst '())
		(foreach n xh_old_lst
			(if(member n move_xh_group)
				t 
				(setq xh_new_lst (append xh_new_lst (list n)));����PP_GR���µ���ű�
			)
		)
		(setq rr 0 move_pp_group '())
		(foreach nn pp_a>b
			(setq rr (1+ rr))
			(if(member rr move_xh_group)
				t 
				(setq move_pp_group (append move_pp_group (list nn)));�ƶ��������������
			)
		)
		
		(setq loop t uu 0)
		(while loop 
			(setq uu (1+ uu))
			(Setq gr (grread t 8 0))
			(cond 
				((= (car gr) 5)
					(setq pp_gr (cadr gr))
					(setq y_gr (cadr pp_gr))
					(setq pp_gr_in (list x_min y_gr))
					(setq pp_new_lst (cons pp_gr_in move_pp_group))
					(setq pp_new_lst (vl-sort pp_new_lst (function(lambda(e1 e2)(< (cadr e1)(cadr e2))))));�����µ�PP_GR������������
				)
				((= (car gr) 3)(setq loop nil))
				((equal gr '(2 13)) (setq loop nil)(setq loop_all nil))
				((equal gr '(2 32)) (setq loop nil)(setq loop_all nil))
			)
			
			(if (/= loop_all nil)
				(progn 
					(setq pp_in_nth (+ (- (length move_pp_group) (length (member pp_gr_in pp_new_lst))) 1));����PP_GR���������λ��
					(if (= pp_in_nth 0)(setq pp_in_nth 1))
					
					(setq ss 0 xh_over_lst '())				
					(foreach mm xh_new_lst 
						(setq ss (1+ ss))
						(print (list (list ss pp_in_nth)(list  pp_in_nth (length move_pp_group))) )
						(if (= ss pp_in_nth)
							(cond 
								((= pp_in_nth 1)
									(progn
										(setq xh_over_lst (append xh_over_lst move_xh_group))
										(setq xh_over_lst (append xh_over_lst (list mm)))	
										
									)
								)
								((= pp_in_nth (length move_pp_group))
									(progn 			
										(setq xh_over_lst (append xh_over_lst (list mm)))	
										(setq xh_over_lst (append xh_over_lst move_xh_group))
									)
								)
								
								((and (/= pp_in_nth 0)(/= pp_in_nth (length move_pp_group)))
									(progn 
										(setq xh_over_lst (append xh_over_lst move_xh_group))
										(setq xh_over_lst (append xh_over_lst (list mm)))	
									)
								)
							)
							(setq xh_over_lst (append xh_over_lst (list mm)))
						)
						
						;(if (= ss pp_in_nth)
						;        
						;	
						;	(cond 
						;		((= pp_in_nth (length move_pp_group))
						;			(progn 
						;				(setq xh_over_lst (append xh_over_lst move_xh_group))
						;				(setq xh_over_lst (append xh_over_lst (list mm)))
						;						
						;			)
						;		)
						;		
						;		((and (/= pp_in_nth 0)(/= pp_in_nth (length move_pp_group)))
						;			(setq xh_over_lst (append xh_over_lst (list mm)))
						;		)
						;	)
						;	;���������λ
						;)
					)
					
					(setq name_group_new_all (mapcar  '(lambda(x)(cdr(assoc x name_group_all))) xh_over_lst))
					(setq i -1)
					(repeat (length name_group_new_all) 
						(setq i (1+ i))
						(setq group_name (nth i name_group_new_all))
						(setq xh_pp (nth i pp_a>b))
						(setq xh_x (car xh_pp))
						(setq xh_y (cadr xh_pp))
						(setq group_name_1 (car(nth 0 group_name)))
						(setq move_pp (by-get-box-ppcen group_name_1))
						(setq move_x (car move_pp))
						(setq move_y (cadr move_pp))
						(setq y_su (- xh_y move_y))
						
						(setq k -1)
						(repeat (length group_name)
							(setq k (1+ k))
							(setq name_go (car(nth k group_name)))
							(setq pp_10 (cdr(assoc 10 (entget name_go))))
							(setq typ (cdr(assoc 0 (entget name_go))))
							(setq  pp_10_x (car pp_10))
							(setq  pp_10_y (cadr pp_10))
							(IF (= TYP "TEXT")
								(progn								
									(setq pp_11 (cdr(assoc 11 (entget name_go))))
									(setq  pp_11_x (car pp_11))
									(setq  pp_11_y (cadr pp_11))
									(setq pp_11_new (list pp_11_x (+ pp_11_y y_su) 0.0))
								)
							)
							
							(setq pp_10_new (list pp_10_x (+ pp_10_y y_su) 0.0))
							(if (and(not(equal xh_over_lst_old xh_over_lst))(> uu 1))
								(PROGN 
									(SETQ ENT_OVER (entmod (subst (cons 10 pp_10_new)(assoc 10 (entget name_go)) (entget name_go))))
									(if (= typ "TEXT")
										(SETQ ENT_OVER (entmod (subst (cons 11 pp_11_new)(assoc 11 ENT_OVER) ENT_OVER)))
									)
									
								)
								
							)
							
						)	
					)	
					(setq xh_over_lst_old xh_over_lst)
				)
			)	
		)
		
		(setq leng_old (sslength ss_move_all))
		(setq jj -1)
		(repeat leng_old 
			(setq jj (1+ jj))
			(setq name_old (ssname  ss_move_all jj))
			(setq ent_old (entget name_old))
			(if (= col_pd nil)
				(progn 
					(setq ent_move (entmod (subst (cons 62 256)(assoc 62 ent_old) ent_old)))
					(entmod (subst ass_8 (assoc 410 ent_move) ent_move))
				)
				(entmod (subst (cons 62 (cdr col_pd))(assoc 62 ent_old) ent_old))
			)
		)
		
	)
	
	
	(command "_.undo" "e")
	
	
	
	
	
	
	(princ)
)


;��������ָ�������ּ������б��鲢���������ӱ�
;(by-lst-su-group '(((1 1 0) (1 2 0))((1 1 0) (1 2 0)))

(defun by-lst-su-group(lst nth1 nth2 num / each each_all i old)
	(setq lst (vl-sort lst (function(lambda(e1 e2)(< (nth nth2 (nth nth1 e1)) (nth nth2 (nth nth1 e2)))))) )
	(setq i 0 each_all '())
	(foreach m lst 
		(setq i (1+ i))
		(if (= i 1)
			(setq each (list m))
			(if (< (- (nth nth2 (nth nth1 m)) (nth nth2 (nth nth1 old))) num)
				(progn 
					(setq each (append each (list m)))
					(if (= i (length lst))
						(setq each_all (append each_all (list each)))
					)
				)
				(progn 
					(setq each_all (append each_all (list each)))
					(setq each (list m))
					(if (= i (length lst))
						(setq each_all (append each_all (list each)))
					)
				)
			)
		)
		(setq old m)
	)
	each_all
)



;���ѡ������Χ�����ĵ�����
(defun by-get-box-pp(name / *byacad* ang dist midpt objname p1 p2 p3 p4 pp_max pp_min pt1 pt2)
	(setq objname (vlax-ename->vla-object name))
	(setq *byacad*(vlax-get-acad-object))
	(vla-GetBoundingBox objname 'pp_min 'pp_max)
	(setq p3 (vlax-safearray->list pp_min)
		p2 (vlax-safearray->list pp_max)
	)
	(setq p1 (list (Car p3) (cadr p2)))
	(setq p4 (list (Car p2) (cadr p3)))
	(list p1 p2 p3 p4)
)

;���ѡ������Χ�����ĵ�����
(defun by-get-box-ppcen(name / *byacad* ang dist midpt objname p1 p2 p3 pp_max pp_min pt1 pt2)
	(setq objname (vlax-ename->vla-object name))
	(setq *byacad*(vlax-get-acad-object))
	(vla-GetBoundingBox objname 'pp_min 'pp_max)
	(setq p3 (vlax-safearray->list pp_min)
		p2 (vlax-safearray->list pp_max)
	)
	(polar p3 (angle p3 p2) (/ (distance p3 p2) 2.0))
)

(defun c:bb_jck ( / blknm pt pts ss)
  (coma)
  (xx-princa "��ǿ��ʾ����������������")
  (mapcar
    'setvar
    '("cmdecho" "osmode")
    '(0 0)
  )
  (setq blknm (xx-get-dxf 2 (car (xx-entsel '((0 . "insert")) "��"))));�������
  (xx-princ "����Բ��Բ����ֱ�ߡ��������ߡ�����ߣ�")
  (if (setq ss (ssget '((0 . "circle,ellipse,*line,*polyline,spline,arc"))))
    (progn
      (setq pts (xx-ss-inters ss 0))
      (if pts
	(foreach pt pts
	  (xx-mk-insert blknm pt 0)
	)
      )
    )
  )
  (comb)
)
 

(defun xx-get-dxf (code s1 / ent lst)
  (if (= (type code) 'list);�ж��Ƿ��Ǳ�
    (progn
      (setq ent(entget s1);��ȡ����
            lst '();���Ϊ��
      )
      (foreach a code ;����foreach����ѭ����ȡ���и�ֵ
        (setq lst (cons (list a (cdr(assoc a ent))) lst));���д����Ժ�ѭ�������
      )
      (reverse lst);�����Ԫ��˳���ú󷵻�
    )
    (if (= code -3)  
      (cdr(assoc code (entget s1 '("*"))));��ȡ��չ����
      (cdr(assoc code (entget s1)))
    )
   )
)

(defun xx-entsel (lst msg / el ss)
  (while 
    (and (setvar "errno" 0)
      (not 
        (and 
          (setq el (entsel (strcat "\n->���ѡ" msg ":")))
         (if (= (type el) 'str)
           el
          (if (setq ss (ssget (cadr el) lst))
            ss
           (progn 
             (princ "\n->��ѡ�Ĳ���:")(princ msg)(princ " ,����ѡ!")
             (setq ss nil)
           )
          );if
         );if
        );and
       );not
      (/= (getvar "errno") 52)
     );and
   );while
   (if (= (type el) 'list) (redraw (car el) 3) );����ѡ�еĶ���
   el
)

(defun xx-mk-insert (name pt ang)
  (entmake (list '(0 . "INSERT") (cons 2 name) (cons 10 pt) (cons 50 ang)))
)
;��ȡ����ѡ�񼯽���
;(xx-ss-inters ss full);ssΪѡ��,ɾ���ظ���ľ���
;(foreach name (xx-ss-inters (ssget) 0.01) (xx-mk-circle name 20))
(defun xx-ss-inters (ss full / lst lst1 pts ptl)
  (setq lst (xx-ax-EnLst))
  (while lst
    (setq e1   (car lst)
	  lst1 (cdr lst)
    )
    (while lst1
      (if (setq pts (vlax-invoke e1 'IntersectWith (car lst1) 0))
	(while pts
	  (setq	ptl (cons (list (car pts) (cadr pts) (caddr pts)) ptl)
		pts (cdddr pts)
	  )
	)
      )
      (setq lst1 (cdr lst1))
    )
    (setq lst (cdr lst))
  )
  (xx-p-del-RetPt ptl full)
)

;VLAѡ��תVLAͼԪ����
(defun xx-ax-EnLst (/ ol)
  (vlax-for obj	(xx-cset)
    (setq ol (cons obj ol))
  )
)
;CAD����
(defun xx-acad nil
  (eval (list 'defun 'xx-acad 'nil (vlax-get-acad-object)))
  (xx-acad)
)
;ȡ��ͼ�μ����ѡ��
(defun xx-cset ()
  (vla-get-activeselectionset (vla-get-activedocument (xx-acad)))
)

;�Ƴ��б����ظ����ֵĵ�
(defun xx-p-del-RetPt (pts  fuzz / remove i)
  (defun remove	(pts fuzz / ptl)
    (while pts
      (if (equal (caar pts) (caar ptl) fuzz)
	(setq pts (cdr pts))
	(setq ptl (cons (car pts) ptl)
	      pts (cdr pts)
	)
      )
    )
    ptl
  )
  (setq i 0 
  	pts (mapcar '(lambda (x) (cons x (setq i (1+ i)))) pts)
	pts (vl-sort pts
		     '(lambda (p1 p2)
			(if (= (cadar p1) (cadar p2))
			  (< (caar p1) (caar p2))
			  (< (cadar p1) (cadar p2))
			)
		      )
	    )
	pts (remove pts fuzz)
	pts (vl-sort pts
		     '(lambda (p1 p2)
			(if (= (caar p1) (caar p2))
			  (< (cadar p1) (cadar p2))
			  (< (caar p1) (caar p2))
			)
		      )
	    )
	pts (remove pts fuzz)
	pts (vl-sort pts
		     '(lambda (p1 p2) (< (cdr p1) (cdr p2)))
	    )
	pts (mapcar 'car pts)
  )
  pts
)
;************************************************
;��ȡϵͳ����
;(COMA)
(defun coma ()
  (if (> (atof (getvar "acadver")) 15.)
   (vl-load-com)
  )
  (defun *error* (msg);����ͨ�ú������˺���
    (princ "����ͨ�ú������� : ")
    (princ msg)
    (comb)
  )
  (setq *x-r*;��ȡϵͳ����
         '("aunits"      "auprec"      "attdia"      "blipmode"
           "cecolor"     "celtype"     "clayer"      "cmdecho"
           "dimzin"      "expert"      "highlight"   "lunits"
           "luprec"      "osmode"      "orthomode"   "textstyle"
           "plinewid"    "dimdec"      "dimadec"     "regenmode"
           "pickbox"
          )
  )
  (*x-ser*);������ϵͳ����
  (vla-startundomark (xx-doc));��ǿ�ʼ
  (princ)
)

(defun *x-ser* (/ sv)
  (if (= 'list (type *error*));�ж�ͨ�ú��������Ƿ�Ϊ��
    (princ "����ͨ�ú������ˣ����һ��(*x-ser*)����û����Ե�(*x-rer*)!")
    (progn
      (setq *x-er* '())
      (foreach sv *x-r*;ѭ����ÿһ��ϵͳ������ֵ��ȡ
        (setq *x-er* (cons (getvar sv) *x-er*))
      )
      (defun-q *error* (st) (*x-rer*));ͨ�ú�������ʱ��ԭϵͳ����
    )
  )
)

(defun xx-acad nil(eval (list 'defun 'xx-acad 'nil (vlax-get-acad-object)))(xx-acad))
(defun xx-doc nil(vla-get-activedocument (xx-acad)))
;----------------------------------------------------------------------------

;��ԭϵͳ����
;(COMB)
(defun comb ()
  (vla-endundomark (xx-doc));��ǽ���
  (*x-rer*);��ԭϵͳ����
  (princ)
)
(defun *x-rer* ()
  (if (= 'list (type *error*));Ϊͨ�ú������˱�ʱ
    (progn
      (mapcar 'setvar *x-r* (reverse *x-er*));ѭ����ԭϵͳ����
      (setq *error* nil)
    )
  )
)






;����ͷ��
;(xx-princA txt);txtΪҪ��ʾ�Ĳ�������  ����:(xx-princA "�����ע")
;�ַ����˱�ת�ַ����������ַ���ת��ķ���
(defun xx-princA (txt)
  (princ 
   (strcat 
    (vl-list->string '(00))
      txt 
    (vl-list->string '(00))
    (vl-list->string '(00))
   )
  )
)
;��������ʾ
;(xx-princ txt);txtΪҪ��ʾ����
(defun xx-princ (txt)
 (princ (strcat "\n-->��ȷ��" txt ":"))
(princ "\n���ﻶӭʹ��--����ǿ�����䡷--����     ��������ɽ�������") (princ)
)

;���������
;(xx-princB txt1 txt2);txt1ΪҪ��ʾ����  txt2ΪҪ��ʾ����
;(xx-princB "��ע" "AD")
;�ַ����˱�ת�ַ����������ַ���ת��ķ���
(defun xx-princB (txt1 txt2 / txt)
  (princ
    (strcat
     (vl-list->string '(10 161 190 236 197 207 232 67 65 68 178 229 188 254 161 191 45 45 45 185 166 196 220 58))
       txt1 
     (vl-list->string '(44 40 195 252 193 238 58))
       txt2
     (vl-list->string '(41 44 215 247 213 223 58 161 190 236 197 207 232 161 191 163 172 81 81 58 50 51 54 51 54 55 51 53 51 52))
    )
  )
 (princ)
)
(princ)






















