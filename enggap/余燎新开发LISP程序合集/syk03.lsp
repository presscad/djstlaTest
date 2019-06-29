(princ "\n ****请输入SYK03运行程序****")
(defun step0 ()
  (command "pline"
	   (list -57.3664 -60.6638)
	   "w"
	   0
	   0
	   (list -56.7664 -60.6638)
	   (list -56.7664 -60.6638)
	   (list -56.7664 -61.3823)
	   (list -56.7664 -62.1008)
	   (list -56.7664 -64.2562)
	   (list -59.1723 -64.2562)
	   (list -59.1723 -60.6638)
	   (list -57.3664 -60.6638)
	   (list -57.3664 -61.3823)
	   (list -58.5723 -61.3823)
	   (list -58.5723 -61.3823)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -62.8192)
	   (list -58.5723 -63.5377)
	   (list -57.3664 -63.5377)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -61.3823)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step1 ()
  (command "pline"
	   (list -58.2694 -63.6562)
	   "w"
	   0
	   0
	   (list -59.1723 -63.6562)
	   (list -59.1723 -64.2562)
	   (list -56.7664 -64.2562)
	   (list -56.7664 -63.6562)
	   (list -57.6694 -63.6562)
	   (list -57.6694 -60.6638)
	   (list -58.7209 -60.6638)
	   (list -58.7209 -61.2638)
	   (list -58.2694 -61.2638)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step2 ()
  (command "pline"
	   (list -59.1723 -62.1008)
	   "w"
	   0
	   0
	   (list -57.3664 -62.1008)
	   (list -57.3664 -61.3823)
	   (list -59.1723 -61.3823)
	   (list -59.1723 -60.6638)
	   (list -56.7664 -60.6638)
	   (list -56.7664 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -58.5723 -62.8192)
	   (list -58.5723 -63.5377)
	   (list -57.3664 -63.5377)
	   (list -56.7664 -63.5377)
	   (list -56.7664 -64.2562)
	   (list -59.1723 -64.2562)
	   "c"
  )
  (command "change" (entlast)  "" "p" "la" "fc" "")
)
(defun step3 ()
  (command "pline"
	   (list -59.1723 -64.2562)
	   "w"
	   0
	   0
	   (list -59.1723 -63.5377)
	   (list -58.5723 -63.5377)
	   (list -57.3664 -63.5377)
	   (list -57.3664 -62.8192)
	   (list -58.5723 -62.8192)
	   (list -59.1723 -62.8192)
	   (list -59.1723 -62.1008)
	   (list -57.3664 -62.1008)
	   (list -57.3664 -61.3823)
	   (list -59.1723 -61.3823)
	   (list -59.1723 -60.6638)
	   (list -56.7664 -60.6638)
	   (list -56.7664 -64.2562)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step4 ()
  (command "pline"
	   (list -56.7664 -62.1008)
	   "w"
	   0
	   0
	   (list -56.7664 -61.3823)
	   (list -56.7664 -60.6638)
	   (list -57.3664 -60.6638)
	   (list -57.3664 -62.1008)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -62.8192)
	   (list -58.5723 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -63.5377)
	   (list -57.3664 -64.2562)
	   (list -56.7664 -64.2562)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step5 ()
  (command "pline"
	   (list -56.7664 -62.1008)
	   "w"
	   0
	   0
	   (list -58.5723 -62.1008)
	   (list -58.5723 -61.3823)
	   (list -56.7664 -61.3823)
	   (list -56.7664 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -62.8192)
	   (list -58.5723 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -63.5377)
	   (list -58.5723 -63.5377)
	   (list -59.1723 -63.5377)
	   (list -59.1723 -64.2562)
	   (list -56.7664 -64.2562)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step6 ()
  (command "pline"
	   (list -57.3664 -62.1008)
	   "w"
	   0
	   0
	   (list -58.5723 -62.1008)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -61.3823)
	   (list -56.7664 -61.3823)
	   (list -56.7664 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -64.2562)
	   (list -56.7664 -64.2562)
	   (list -56.7664 -62.1008)
	   (list -57.3664 -62.1008)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -63.5377)
	   (list -58.5723 -63.5377)
	   (list -58.5723 -62.8192)
	   (list -57.3664 -62.8192)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step7 ()
  (command "pline"
	   (list -56.7664 -64.2562)
	   "w"
	   0
	   0
	   (list -56.7664 -62.1008)
	   (list -56.7664 -61.3823)
	   (list -56.7664 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -62.1008)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -61.3823)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -64.2562)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)
(defun step8 ()
  (command "pline"
	   (list -57.3664 -62.1008)
	   "w"
	   0
	   0
	   (list -57.3664 -62.1008)
	   (list -57.3664 -62.1008)
	   (list -57.3664 -62.1008)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -61.3823)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -64.2562)
	   (list -56.7664 -64.2562)
	   (list -56.7664 -62.1008)
	   (list -56.7664 -61.3823)
	   (list -56.7664 -60.6638)
	   (list -57.3664 -60.6638)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -62.1008)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -63.5377)
	   (list -58.5723 -63.5377)
	   (list -58.5723 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -62.8192)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)


(defun step9 ()
  (command "pline"
	   (list -57.3664 -60.6638)
	   "w"
	   0
	   0
	   (list -59.1723 -60.6638)
	   (list -59.1723 -60.6638)
	   (list -59.1723 -62.8192)
	   (list -57.3664 -62.8192)
	   (list -57.3664 -63.5377)
	   (list -59.1723 -63.5377)
	   (list -59.1723 -64.2562)
	   (list -56.7664 -64.2562)
	   (list -56.7664 -60.6638)
	   (list -57.3664 -60.6638)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -62.1008)
	   (list -57.3664 -62.1008)
	   (list -58.5723 -62.1008)
	   (list -58.5723 -61.3823)
	   (list -57.3664 -61.3823)
	   (list -57.3664 -61.3823)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
)



					;main process .
(defun c:syk03 (/ oldosmode oldorthomode str st n m os o)
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (setq oldorthomode (getvar "orthomode"))
  (setvar "orthomode" 0)
  (setq str (getstring "\n 请输入编码(拷贝市场部的备注):"))
  (setq st (substr str 3))
  (setq n (strlen st))
  (command "-layer" "n" "fc" "")
  (command "-layer" "c" "3" "fc" "")
  (command "pline"
	   (list -59.5197 -60.66)
	   "w"
	   0
	   0
	   (list -59.5197 -61.36)
	   (list -59.5197 -61.7014)
	   (list -60.4197 -62.6014)
	   (list -60.4197 -64.26)
	   (list -61.0197 -64.26)
	   (list -61.0197 -62.6014)
	   (list -61.9197 -61.7014)
	   (list -61.9197 -61.36)
	   (list -61.9197 -60.66)
	   (list -61.3197 -60.66)
	   (list -61.3197 -61.16)
	   (list -61.3197 -61.4186)
	   (list -60.7197 -62.0186)
	   (list -60.1197 -61.4186)
	   (list -60.1197 -61.16)
	   (list -60.1197 -60.66)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
  (command "pline"
	   (list -64.67 -63.8256)
	   "w"
	   0
	   0
	   (list -64.67 -63.2179)
	   (list -64.1332 -63.2179)
	   (list -64.1332 -63.5576)
	   (list -63.9992 -63.6916)
	   (list -62.9408 -63.6916)
	   (list -62.8068 -63.5576)
	   (list -62.8068 -62.8782)
	   (list -62.9408 -62.7442)
	   (list -64.2671 -62.7442)
	   (list -64.67 -62.3098)
	   (list -64.67 -61.0944)
	   (list -64.2671 -60.66)
	   (list -62.6729 -60.66)
	   (list -62.27 -61.0944)
	   (list -62.27 -61.7021)
	   (list -62.8068 -61.7021)
	   (list -62.8068 -61.3624)
	   (list -62.9408 -61.2284)
	   (list -63.9992 -61.2284)
	   (list -64.1332 -61.3624)
	   (list -64.1332 -62.0418)
	   (list -63.9992 -62.1758)
	   (list -62.6729 -62.1758)
	   (list -62.27 -62.6102)
	   (list -62.27 -63.8256)
	   (list -62.6729 -64.26)
	   (list -64.2671 -64.26)
	   "c"
  )
  (command "change" (entlast) "" "p" "la" "fc" "")
  (setq m 1)
  (repeat n
    (setq os (substr st m 1))
    (setq o (atoi os))
    (if	(= o 0)
      (progn
	(step0)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 1)
      (progn
	(step1)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 2)
      (progn
	(step2)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 3)
      (progn
	(step3)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 4)
      (progn
	(step4)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 5)
      (progn
	(step5)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 6)
      (progn
	(step6)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 7)
      (progn
	(step7)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 8)
      (progn
	(step8)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (if	(= o 9)
      (progn
	(step9)
	(command "move"
		 (entlast)
		 ""
		 "0,0"
		 (list (* (- m 1) 2.7503) 0)
	)
      )
    )
    (setq m (+ m 1))
  )
  (setvar "osmode" oldosmode)
  (setvar "orthomode" oldorthomode)
)