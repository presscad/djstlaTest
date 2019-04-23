(defun c:selln( / entall sslen rstSS n flag ent)   ;select hyptical or locatical lines;
  (princ"请选择需要过滤的实体集:")
  (setq entall (ssget(list(cons 0 "line"))))  ;选取线段集合.
  (setq sslen (sslength entall))
  (setq rstSS (ssadd)) ;用来装载垂直线或水平线;

  (setq n 0 flag 0) ;n计数； flag判断是否垂直或水平线  
  (while (< n sslen)
       (setq ent(ssname entall n))
       (setq flag (prsline ent))
       (if (or (= 1 flag)(= 2 flag))
	 (progn
	   (ssadd ent rstSS) ;加入选择集;
	 )
       )
       (setq n (+ n 1))    ;++
  );while

  ;将垂直线或水平线变换层；
  (command "layer" "n" "ttaacc01" "") ;新建一个层;
  (command "change" rstSS "" "P" "la" "ttaacc01" "")
 )




(defun prsline(oneEnt / datalist tail head first flag x1 y1 x2 y2) ;分析线段是否垂直或水平; oneEnt:待判断的线段；
  
  (setq datalist(entget oneEnt))
  (setq tail datalist)

  ;对datalist判断顶点dxf组码10
 
  (setq tail datalist)

  (while tail  ;tail不为空
    (setq head (car tail)) ;获取第一个表
    (setq first (car head))
    (setq flag 0 x1 0 y1 0 x2 0 y2 0 rtn 0)
    
    (if (= first 10) ;flag == 0表示第一次碰到dxf组码10;
      (progn
	(setq x1(cadr head))
	(setq y1(caddr head))

	;获取第二个顶点
	(setq tail(cdr tail))
	(setq head(car tail))
	(setq x2(cadr head))
	(setq y2(caddr head))

	(setq tail nil) ;结束循环.
	;(setq flag 1)
      );progn
    );if

    (setq tail (cdr tail)) ;循环条件.
  );while

  ;判断是否垂直或水平
  (cond ((equal x1 x2 0.000005) 1);垂直
	((equal y1 y2 0.000005) 2);水平；
	(t 0);其它；
  )


);defun