(prompt
  "\n 此程序用来连接搭在一起而不能闭合的多义线
	 ************请输入toon运行程序***********"
)
(defun c:toon (/ )
  (setq obj(ssget))
  (setq n(sslength obj))
  (setq q 0)
  (repeat  n 
    (setq a (ssname obj q))
    (setq a_data (entget a))
    (setq b_data (reverse a_data))
    (setq new (assoc 10 a_data))
    (setq old (assoc 10 b_data))
    (setq b_data (subst new old b_data))
    (setq c_data (reverse b_data))
    (setq f (assoc 8 c_data))
    (setq ff (cons 8 "ok"))
    (setq c_data (subst ff f c_data))
    (entmake c_data)
    (setq q (+ q 1))
  )
)