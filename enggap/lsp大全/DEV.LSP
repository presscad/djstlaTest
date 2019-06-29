


(defun c:dev()
  (setq glass_x (getreal "请输入图形X方向尺寸: "))
  (setq glass_y (getreal "请输入图形Y方向尺寸: "))					;(cond	(< glass_x glass_y)
  (setq glass_x1 glass_x)
  (setq glass_y1 glass_y)					;)
  (command "zoom" "w" (list 
  (setq c (getreal "请输入边框宽度: "))
  (setq lens (getint "请输入镜头"))	
  (setq	origin_x (/ glass_x1 2)
	origin_y (/ glass_y1 2)
  )
  (command "zoom" "w" (list (- origin_x) (- origin_y)) (list origin_x origin_y))


  
  (setq	p1  (list (- origin_x (+ 10.05 (/ c 2))) (- origin_y (/ c 2)))
	p2  (list (- (/ c 2) origin_x) (- origin_y (/ c 2)))
	p3  (list (- (/ c 2) origin_x) (- (/ c 2) origin_y))
	p4  (list (- origin_x (/ c 2)) (- (/ c 2) origin_y))
	p5  (list (- origin_x (/ c 2)) (- origin_y (/ c 2)))
	p6  (list (- origin_x (+ 10 (/ c 2))) (- origin_y (/ c 2)))
	p6  (list (- origin_x (+ 10 (/ c 2))) (- origin_y (/ c 2)))
	p7  (list (- origin_x (+ 10 (/ c 2))) (+ origin_y (/ c 2)))
	p8  (list (+ origin_x (/ c 2)) (+ origin_y (/ c 2)))
	p9  (list (+ origin_x (/ c 2)) (- 0 (+ origin_y (/ c 2))))
	p10 (list (- 0 (+ origin_x (/ c 2))) (- 0 (+ origin_y (/ c 2))))
	p11 (list (- 0 (+ origin_x (/ c 2))) (+ origin_y (/ c 2)))
	p12 (list (- origin_x (+ 10.05 (/ c 2))) (+ origin_y (/ c 2)))
  )
  (command "pline" p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 "c")
  (setq input (getstring "\n 是否要加钉? Yes/No (N/n): "))
  (if (or (= input "Y") (= input "y"))
    (progn
      (setq b (list (- 0 (+ (+ origin_x (/ c 2)) 0.1))
		    (- 0 (+ (+ origin_y (/ c 2)) 0.1))
	      )
      )
      (setq last_ss (entlast))
      (setq c1 b)
      (setq c2 (list (car p10) (cadr b)))
      (setq c3 p10)
      (setq c4 (list (car b) (cadr p10)))
      (command "pline" c1 c2 c3 c4 "c")

					;(command "rectang" p10 b)
      (setq e (ssget "L"))
      (command "array"
	       e
	       ""
	       "R"
	       2
	       2
	       (+ (+ glass_y1 c) 0.1)
	       (+ (+ glass_x1 c) 0.1)
      )
    )
  )

)