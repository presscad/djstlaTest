(defun c:selln( / entall sslen rstSS n flag ent)   ;select hyptical or locatical lines;
  (princ"��ѡ����Ҫ���˵�ʵ�弯:")
  (setq entall (ssget(list(cons 0 "line"))))  ;ѡȡ�߶μ���.
  (setq sslen (sslength entall))
  (setq rstSS (ssadd)) ;����װ�ش�ֱ�߻�ˮƽ��;

  (setq n 0 flag 0) ;n������ flag�ж��Ƿ�ֱ��ˮƽ��  
  (while (< n sslen)
       (setq ent(ssname entall n))
       (setq flag (prsline ent))
       (if (or (= 1 flag)(= 2 flag))
	 (progn
	   (ssadd ent rstSS) ;����ѡ��;
	 )
       )
       (setq n (+ n 1))    ;++
  );while

  ;����ֱ�߻�ˮƽ�߱任�㣻
  (command "layer" "n" "ttaacc01" "") ;�½�һ����;
  (command "change" rstSS "" "P" "la" "ttaacc01" "")
 )




(defun prsline(oneEnt / datalist tail head first flag x1 y1 x2 y2) ;�����߶��Ƿ�ֱ��ˮƽ; oneEnt:���жϵ��߶Σ�
  
  (setq datalist(entget oneEnt))
  (setq tail datalist)

  ;��datalist�ж϶���dxf����10
 
  (setq tail datalist)

  (while tail  ;tail��Ϊ��
    (setq head (car tail)) ;��ȡ��һ����
    (setq first (car head))
    (setq flag 0 x1 0 y1 0 x2 0 y2 0 rtn 0)
    
    (if (= first 10) ;flag == 0��ʾ��һ������dxf����10;
      (progn
	(setq x1(cadr head))
	(setq y1(caddr head))

	;��ȡ�ڶ�������
	(setq tail(cdr tail))
	(setq head(car tail))
	(setq x2(cadr head))
	(setq y2(caddr head))

	(setq tail nil) ;����ѭ��.
	;(setq flag 1)
      );progn
    );if

    (setq tail (cdr tail)) ;ѭ������.
  );while

  ;�ж��Ƿ�ֱ��ˮƽ
  (cond ((equal x1 x2 0.000005) 1);��ֱ
	((equal y1 y2 0.000005) 2);ˮƽ��
	(t 0);������
  )


);defun