;���飻 ��һ��Բ�Σ�������0,0�㣩���飻���������ɿ鲢�Ű���;
(defun create_circleblock (radiu blaockname /)
  (setq bnm blaockname)
  (setq pt (list 0 0)) ;Ĭ��������0��;
  (if (null (tblsearch "BLOCK" bnm))
	(PROGN
		  (ENTMAKE '((0 . "BLOCK")
			     (8 . "0")
			     (10 0.0 0.0 0.0)
			     ;(2 . "_NBT_cross")
			     (2 . bnm)
			     (70 . 2)
			     (1 . "")
			    )
		  )
		  (ENTMAKE (list '(0 . "CIRCLE") (cons 10 pt) (cons 40 radiu)))
		  (ENTMAKE '((0 . "Endblk")))
		)
    );if (null (tblsearch "BLOCK" bnm))
 )


;��ĳ�������Բ������
;num:���еĸ���
;blockname:����;
(defun arr_insert_n (num blockname pt /)
  ;(setq pt (list 0 0))
  (entmake (list  '(0 . "INSERT")  (cons  2  blockname) (cons 10 pt)))
  (setq ss1 (entlast))  
  (command "array" ss1 "" "p" "0,0" num 360 "y")
  )



; cal the radiu of the inner cicle of the ring which enclosed many circles;
;���ܣ�ȡ�û��ھ�
( defun calFirstCircleRadiuOfRing(n / f lamda num001 num002 radiusOfRing)
  (setq f (* 20 1000)) ; f= 20 m
  (setq lamda (/ 550 1000000.0)) ; lamda = 550 nm  
  (setq num001 (* n f lamda))
  (setq num002 (/ (* n n lamda lamda) 4.0))
  (setq radiusOfRing (sqrt (+ num001 num002)))
)


;cal the radiu of the circle in the ring
;ȡ��ĳһ���ڵ�Բ�εİ뾶;
(defun calRadiuOfCircle(n / r1 r2 radiusOfCircle k)
  (setq r1 (calFirstCircleRadiuOfRing n))
  (setq r2 (calFirstCircleRadiuOfRing (+ n 1)))
  (setq k 1.2)
  (setq radiusOfCircle (* k (- r2 r1)))
  )

;cal the center radiu of the ring
;ȡ��ĳһ���������İ뾶;
(defun calCenterRadiuOfTheRing(n / r1 r2)
  (setq r1 (calFirstCircleRadiuOfRing n))
  (setq r2 (calFirstCircleRadiuOfRing (+ n 1)))
  (setq centerRadiuOfRing(/ (+ r1 r2) 2.0))
  )


;cal number of cicles in the ring
;����ĳһ������Բ�εĸ���;
(defun calNumOfCirclesInOneRing(n / centerRadiuOfRing radiuOfCircles thirdEdge ang numOfCircls)
  (setq centerRadiuOfRing (calCenterRadiuOfTheRing  n))
  (setq radiuOfCircles (calRadiuOfCircle  n))
  ;(setq radiuOfCirclesHalf (/ radiuOfCircles 2.0))
  ;cal the edge
  (setq thirdEdge (sqrt (- (* centerRadiuOfRing centerRadiuOfRing) (* radiuOfCircles radiuOfCircles))))
  ;cal the ange between two circles
  (setq ang (atan (/ radiuOfCircles thirdEdge)))
  (setq numOfCircls (fix (/  3.1415926 ang)))
)


;cal the coordinate of the circles
;parameter: n-the num of the ring;  i-the index of the circle in the ring;
;m��ĳ������Բ�ε��ܸ���;
(defun calCoordOftheCircleCenter( n i m centerRadiuOfRing / x y co)
  (setq x (* centerRadiuOfRing (sin (* (* 2 3.1415926) (/ i m) ))))
  (setq y (* centerRadiuOfRing (cos (* (* 2 3.1415926) (/ i m) ))))
  (setq co (list x y)) ;return 
 )


;get the model space
(defun getModelSpace()
  (vl-load-com)
  (setq acadobject (VLAX-Get-ACAD-Object ))
  (setq acaddocument (vla-get-activedocument acadobject))
  (setq mspace (vla-get-modelspace acaddocument))
 )

;draw circle;
(defun drawOneCircle(mspace center3Dpoint radiu /)
  ;(setq mycircle (vla-addcircle mspace (vlax-3d-point '(0 0 0)) 100))
  (setq mycircle (vla-addcircle mspace center3Dpoint radiu))
 )


;draw first circle  in a ring
(defun drawFirstCirclesInRing(n /)
  (setq x 0)
  (setq y (calCenterRadiuOfTheRing n))
  (setq radiu (calRadiuOfCircle n))
  (setq mspace (getModelSpace))
  (setq objcircle (drawOneCircle mspace (vlax-3d-point (list x y 0)) radiu))
 )


;����n��ring
;����ring�뾶;
(defun draw_ring_n (n /)
  ;��һ��Բ���ģ��飩���ꣻ
  (setq x 0)
  (setq y (calCenterRadiuOfTheRing n))
  (setq pt (list x y))
  ;Բ�ΰ뾶;
  (setq radiu (calRadiuOfCircle n))
  ;��nȦ�ж��ٸ�Բ;
  (setq numOfCirclesInRing (calNumOfCirclesInOneRing n))
  ;���ɿ飬�Կ����Բ������;
  (setq blockname_pre "ganghua")
  (setq blockname_att (itoa n))
  (setq blockname (strcat blockname_pre blockname_att))
  (create_circleblock radiu blockname)
  ;�Կ����Բ������;
  (arr_insert_n numOfCirclesInRing blockname pt)
  ;����radiu�����ṩ�ϲ��жϰ뾶��С�������Ƿ������ͼ;
  (setq nntempt y)
  )



;test function:test drawFirstCirclesInRing
;��һȦһȦ�Ļ������ɶ��Բ���)
(defun c:test001( / maxsize radiu_ring_n n)
  (setq maxsize 50)
  (setq radiu_ring_n 0)
  (setq n 0)
  (while (<= radiu_ring_n maxsize)
    ()
    )
 )



;max_size:����ɸ���ߴ�,��λmm;
(defun drawAllCircles(max_size /)
  (setq radiusOfRing 0)
  (while (< radiusOfRing max_size)
    (setq i 0)
    (setq m 0)
    (setq radiusOfRing (calCenterRadiuOfTheRing n))
    )
  )