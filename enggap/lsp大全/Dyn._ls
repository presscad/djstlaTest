
(defun c:dyn ()
  (alert         "***注意客户的有用层为打开文件的显示层,
      关闭的图形内如有图形<孤点除外>要与客户沟通***")
  (defun set_str ()
    (defun draw_crs ()
      (command "pline"
	       (list -73.533 70.5988)
	       "w"
	       0
	       0
	       (list -74.549 70.5988)
	       (list -74.549 70.6496)
	       (list -73.533 70.6496)
	       "c"
      )
      (command "pline"
	       (list -73.0504 71.1322)
	       "w"
	       0
	       0
	       (list -72.9996 71.1322)
	       (list -72.9996 72.1482)
	       (list -73.0504 72.1482)
	       "c"
      )
      (command "pline"
	       (list -72.9996 70.6242)
	       "w"
	       0
	       0
	       (list -73.0001 70.6292)
	       (list -73.0015 70.634)
	       (list -73.0039 70.6384)
	       (list -73.007 70.6422)
	       (list -73.0109 70.6453)
	       (list -73.0153 70.6477)
	       (list -73.02 70.6491)
	       (list -73.025 70.6496)
	       (list -73.03 70.6491)
	       (list -73.0347 70.6477)
	       (list -73.0391 70.6453)
	       (list -73.043 70.6422)
	       (list -73.0461 70.6384)
	       (list -73.0485 70.634)
	       (list -73.0499 70.6292)
	       (list -73.0504 70.6242)
	       (list -73.0499 70.6193)
	       (list -73.0485 70.6145)
	       (list -73.0461 70.6101)
	       (list -73.043 70.6063)
	       (list -73.0391 70.6031)
	       (list -73.0347 70.6008)
	       (list -73.03 70.5993)
	       (list -73.025 70.5988)
	       (list -73.02 70.5993)
	       (list -73.0153 70.6008)
	       (list -73.0109 70.6031)
	       (list -73.007 70.6063)
	       (list -73.0039 70.6101)
	       (list -73.0015 70.6145)
	       (list -73.0001 70.6193)
	       "c"
      )
      (command "pline"
	       (list -72.517 70.5988)
	       "w"
	       0
	       0
	       (list -71.501 70.5988)
	       (list -71.501 70.6496)
	       (list -72.517 70.6496)
	       "c"
      )
      (command "pline"
	       (list -73.0504 69.9765)
	       "w"
	       0
	       0
	       (list -72.9996 69.9765)
	       (list -72.9996 70.1162)
	       (list -73.0504 70.1162)
	       "c"
      )
      (command "pline"
	       (list 72.9996 71.1322)
	       "w"
	       0
	       0
	       (list 73.0504 71.1322)
	       (list 73.0504 72.1482)
	       (list 72.9996 72.1482)
	       "c"
      )
      (command "pline"
	       (list 73.533 70.5988)
	       "w"
	       0
	       0
	       (list 74.549 70.5988)
	       (list 74.549 70.6496)
	       (list 73.533 70.6496)
	       "c"
      )
      (command "pline"
	       (list 72.9996 69.9765)
	       "w"
	       0
	       0
	       (list 73.0504 69.9765)
	       (list 73.0504 70.1162)
	       (list 72.9996 70.1162)
	       "c"
      )
      (command "pline"
	       (list 73.0504 70.6242)
	       "w"
	       0
	       0
	       (list 73.0499 70.6292)
	       (list 73.0485 70.634)
	       (list 73.0461 70.6384)
	       (list 73.043 70.6422)
	       (list 73.0391 70.6453)
	       (list 73.0347 70.6477)
	       (list 73.03 70.6491)
	       (list 73.025 70.6496)
	       (list 73.02 70.6491)
	       (list 73.0153 70.6477)
	       (list 73.0109 70.6453)
	       (list 73.007 70.6422)
	       (list 73.0039 70.6384)
	       (list 73.0015 70.634)
	       (list 73.0001 70.6292)
	       (list 72.9996 70.6242)
	       (list 73.0001 70.6193)
	       (list 73.0015 70.6145)
	       (list 73.0039 70.6101)
	       (list 73.007 70.6063)
	       (list 73.0109 70.6031)
	       (list 73.0153 70.6008)
	       (list 73.02 70.5993)
	       (list 73.025 70.5988)
	       (list 73.03 70.5993)
	       (list 73.0347 70.6008)
	       (list 73.0391 70.6031)
	       (list 73.043 70.6063)
	       (list 73.0461 70.6101)
	       (list 73.0485 70.6145)
	       (list 73.0499 70.6193)
	       "c"
      )
      (command "pline"
	       (list 72.517 70.5988)
	       "w"
	       0
	       0
	       (list 71.501 70.5988)
	       (list 71.501 70.6496)
	       (list 72.517 70.6496)
	       "c"
      )
    )
    (defun draw_frm () 
        (command "pline" (list 152.35 82.0000) "w" 0 0 
                         (list 152.35 -69.2415) 
                         (list -152.35 -69.2415) 
                         (list -152.35 82.8585) 
                         (list 152.35 82.8585) 
                         (list 152.35 82.2000) 
                         (list 152.45 82.2000) 
                         (list 152.45 82.9585) 
                         (list -152.45 82.9585) 
                         (list -152.45 -69.3415) 
                         (list 152.45 -69.3415) 
                         (list 152.45 82.0000) 
                         "c"
         )
        (command "pline" (list -152.45 -69.3415) "w" 0 0 
                         (list -152.55 -69.3415) 
                         (list -152.55 -69.4415) 
                         (list -152.45 -69.4415) 
                         "c"
         )
        (command "pline" (list -152.45 82.9585) "w" 0 0 
                         (list -152.55 82.9585) 
                         (list -152.55 83.0585) 
                         (list -152.45 83.0585) 
                         "c"
         )
        (command "pline" (list 152.45 -69.3415) "w" 0 0 
                         (list 152.55 -69.3415) 
                         (list 152.55 -69.4415) 
                         (list 152.45 -69.4415) 
                         "c"
         )
        (command "pline" (list 152.45 82.9585) "w" 0 0 
                         (list 152.55 82.9585) 
                         (list 152.55 83.0585) 
                         (list 152.45 83.0585) 
                         "c"
         )
  )
    (defun draw_a ()
      (command "pline"
	       (list 119.427 71.9199)
	       "w"
	       0
	       0
	       (list 122.091 71.9199)
	       "A"
	       (list 122.091 72.1199)
	       "L"
	       (list 119.427 72.1199)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 121.991 72.0199)
	       "w"
	       0
	       0
	       (list 121.991 70.6858)
	       "A"
	       (list 122.191 70.6858)
	       "L"
	       (list 122.191 72.0199)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 120.669 74.6415)
	       "w"
	       0
	       0
	       (list 122.002 71.9752)
	       "A"
	       (list 122.181 72.0646)
	       "L"
	       (list 120.848 74.7309)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 119.516 71.9752)
	       "w"
	       0
	       0
	       (list 120.848 74.6415)
	       "A"
	       (list 120.669 74.7309)
	       "L"
	       (list 119.337 72.0646)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 119.527 70.6858)
	       "w"
	       0
	       0
	       (list 119.527 72.0199)
	       "A"
	       (list 119.327 72.0199)
	       "L"
	       (list 119.327 70.6858)
	       "A"
	       "close"
      )
    )
    (defun C:draw_C () 
        (command "pline" (list 122.07 71.2374) "w" 0 0 
                         (list 121.404 70.5708)
		 "A"
                         (list 121.262 70.7122)
		 "L"
                         (list 121.929 71.3788)
		 "A"  "CLOSE"
         )
        (command "pline" (list 121.333 70.5415) "w" 0 0 
                         (list 120.0 70.5415)
		 "A"
                         (list 120.0 70.7415)
		 "L"
                         (list 121.333 70.7415) 
                 "A"  "CLOSE"
         )
        (command "pline" (list 119.929 70.5708) "w" 0 0 
                         (list 119.263 71.2374)
		 "A"
                         (list 119.404 71.3788)
		 "L"
                         (list 120.071 70.7122)
		 "A"  "CLOSE"                         
         )
        (command "pline" (list 119.234 71.3081) "w" 0 0 
                         (list 119.234 73.9751)
		 "A"
                         (list 119.434 73.9751)
		 "L"
                         (list 119.434 71.3081)
		 "A"  "CLOSE"                         
         )
        (command "pline" (list 119.263 74.0458) "w" 0 0 
                         (list 119.929 74.7124)
		 "A"
                         (list 120.071 74.571)
		 "L"
                         (list 119.404 73.9044)
		 "A"  "CLOSE"                         
         )
        (command "pline" (list 120.0 74.7417) "w" 0 0 
                         (list 121.333 74.7417)
		 "A"
                         (list 121.333 74.5417)
		 "L"
                         (list 120.0 74.5417)
		 "A"  "CLOSE"
	)
        (command "pline" (list 121.404 74.7124) "w" 0 0 
                         (list 122.07 74.0458)
		 "A"
                         (list 121.929 73.9044)
		 "L"
                         (list 121.262 74.571)
		 "A"  "CLOSE"
         )
  )
    (defun draw_b ()
      (command "pline"
	       (list 119.497 70.4862)
	       "w"
	       0
	       0
	       (list 121.496 70.4862)
	       "A"
	       (list 121.496 70.6862)
	       "L"
	       (list 119.497 70.6862)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 121.566 70.5155)
	       "w"
	       0
	       0
	       (list 122.233 71.1821)
	       "A"
	       (list 122.091 71.3235)
	       "L"
	       (list 121.425 70.6569)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 122.262 71.2528)
	       "w"
	       0
	       0
	       (list 122.262 71.9194)
	       "A"
	       (list 122.062 71.9194)
	       "L"
	       (list 122.062 71.2528)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 122.233 71.9901)
	       "w"
	       0
	       0
	       (list 121.566 72.6567)
	       "A"
	       (list 121.425 72.5153)
	       "L"
	       (list 122.091 71.8487)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 121.496 72.686)
	       "w"
	       0
	       0
	       (list 120.163 72.686)
	       "A"
	       (list 120.163 72.486)
	       "L"
	       (list 121.496 72.486)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 121.566 72.5153)
	       "w"
	       0
	       0
	       (list 122.233 73.1825)
	       "A"
	       (list 122.091 73.3239)
	       "L"
	       (list 121.425 72.6567)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 122.262 73.2532)
	       "w"
	       0
	       0
	       (list 122.262 73.9198)
	       "A"
	       (list 122.062 73.9198)
	       "L"
	       (list 122.062 73.2532)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 122.233 73.9905)
	       "w"
	       0
	       0
	       (list 121.566 74.6571)
	       "A"
	       (list 121.425 74.5157)
	       "L"
	       (list 122.091 73.8491)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 121.496 74.6864)
	       "w"
	       0
	       0
	       (list 119.497 74.6864)
	       "A"
	       (list 119.497 74.4864)
	       "L"
	       (list 121.496 74.4864)
	       "A"
	       "close"
      )
      (command "pline"
	       (list 120.063 74.5864)
	       "w"
	       0
	       0
	       (list 120.063 70.5862)
	       "A"
	       (list 120.263 70.5862)
	       "L"
	       (list 120.263 74.5864)
	       "A"
	       "close"
      )
    )

    (setvar "CECOLOR" "BYLAYER")
(defun draw_set()
    (command "pline"
	     (list 113.502 70.6151)
	     "w"
	     0
	     0
	     (list 114.169 71.2821)
	     "A"
	     (list 114.027 71.4235)
	     "L"
	     (list 113.36 70.7565)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 112.695 71.2822)
	     "w"
	     0
	     0
	     (list 113.36 70.6152)
	     "A"
	     (list 113.502 70.7564)
	     "L"
	     (list 112.836 71.4234)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 112.666 74.6862)
	     "w"
	     0
	     0
	     (list 112.666 71.3528)
	     "A"
	     (list 112.866 71.3528)
	     "L"
	     (list 112.866 74.6862)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 111.433 73.2521)
	     "w"
	     0
	     0
	     (list 114.098 73.2521)
	     "A"
	     (list 114.098 73.4521)
	     "L"
	     (list 111.433 73.4521)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 108.104 70.5858)
	     "w"
	     0
	     0
	     (list 109.436 70.5858)
	     "A"
	     (list 109.436 70.7858)
	     "L"
	     (list 108.104 70.7858)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 107.366 71.2821)
	     "w"
	     0
	     0
	     (list 108.033 70.6151)
	     "A"
	     (list 108.175 70.7565)
	     "L"
	     (list 107.508 71.4235)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 107.337 72.685)
	     "w"
	     0
	     0
	     (list 107.337 71.3528)
	     "A"
	     (list 107.537 71.3528)
	     "L"
	     (list 107.537 72.685)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 108.033 73.4228)
	     "w"
	     0
	     0
	     (list 107.366 72.7558)
	     "A"
	     (list 107.508 72.6143)
	     "L"
	     (list 108.175 73.2814)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 109.436 73.4521)
	     "w"
	     0
	     0
	     (list 108.104 73.4521)
	     "A"
	     (list 108.104 73.2521)
	     "L"
	     (list 109.436 73.2521)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 110.172 72.7557)
	     "w"
	     0
	     0
	     (list 109.507 73.4227)
	     "A"
	     (list 109.365 73.2815)
	     "L"
	     (list 110.03 72.6144)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 109.507 71.9492)
	     "w"
	     0
	     0
	     (list 110.172 72.6143)
	     "A"
	     (list 110.031 72.7558)
	     "L"
	     (list 109.365 72.0906)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 107.437 71.9199)
	     "w"
	     0
	     0
	     (list 109.436 71.9199)
	     "A"
	     (list 109.436 72.1199)
	     "L"
	     (list 107.437 72.1199)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 105.369 74.6156)
	     "w"
	     0
	     0
	     (list 106.034 73.9485)
	     "A"
	     (list 106.175 74.0897)
	     "L"
	     (list 105.51 74.7568)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 104.107 74.5862)
	     "w"
	     0
	     0
	     (list 105.439 74.5862)
	     "A"
	     (list 105.439 74.7862)
	     "L"
	     (list 104.107 74.7862)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 103.511 73.9484)
	     "w"
	     0
	     0
	     (list 104.178 74.6155)
	     "A"
	     (list 104.037 74.7569)
	     "L"
	     (list 103.369 74.0898)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 106.175 71.4235)
	     "w"
	     0
	     0
	     (list 103.511 74.0898)
	     "A"
	     (list 103.369 73.9485)
	     "L"
	     (list 106.034 71.2822)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 105.51 70.6152)
	     "w"
	     0
	     0
	     (list 106.175 71.2822)
	     "A"
	     (list 106.034 71.4234)
	     "L"
	     (list 105.369 70.7564)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 104.107 70.5858)
	     "w"
	     0
	     0
	     (list 105.439 70.5858)
	     "A"
	     (list 105.439 70.7858)
	     "L"
	     (list 104.107 70.7858)
	     "A"
	     "close"
    )
    (command "pline"
	     (list 103.369 71.2821)
	     "w"
	     0
	     0
	     (list 104.037 70.6151)
	     "A"
	     (list 104.178 70.7565)
	     "L"
	     (list 103.511 71.4235)
	     "A"
	     "close"
    )
    )
    (initget "A B C N")
    (setq set_no (getkword "请输入SET号（A/B/C/None)"))
    (initget 0)
    (cond ((= set_no "A") (progn (draw_set) (draw_a)))
	  ((= set_no "B") (progn (draw_set) (draw_b)))
	  ((= set_no "C") (progn (draw_set) (draw_c)))
    )
    (draw_frm)
    (command "layer" "M" "cross_tmp" "COLOR" "RED" "" "")
    (draw_crs)
  )
  (defun ext21 (layer_name)
    (setq
      polyline_ss
       (ssget "X"
	      (list (cons 0 "POLYLINE"))
       )
    )
    (if	polyline_ss
      (progn
	(command "convert" "P" "A")
      )
    )
    (setq
      polyline_ss
       (ssget "X"
	      (list (cons 0 "LWPOLYLINE")
		    (cons 8 layer_name)
		    (cons 210 '(0 0 -1))
	      )
       )
    )
    (if	(/= polyline_ss nil)
      (progn
	(setq cnt_all (sslength polyline_ss))
	(setq cnt 0)
	(while (< cnt cnt_all)
	  (setq ent_name (ssname polyline_ss cnt))
	  (setq l_dt (entget ent_name))
	  (if (member (cons 210 '(0 0 -1)) l_dt )
	    (progn
	  	(setq
	    		l_dt1 (subst (cons 210 '(0 0 1)) (cons 210 '(0 0 -1)) l_dt)
	  	)
	  	(entmod l_dt1)
	    )
	    (progn
	      (getstring "/n有程序无法处理的图形,请重新打开图形,然后运行dci-scd.lsp中的dci,再运行此程序!")
	      (exit)	      
	      )
	    )
	  (setq cnt (1+ cnt))
	)
      )
    )
    (command "mirror" polyline_ss "" '(0 0) '(0 100) "y")
    (setq polyline_ss nil)
  )
  (setvar "OSMODE" 0)
  (setvar "ORTHOMODE" 0)
  (setvar "PLINEWID" 0)
  (setvar "THICKNESS" 0)
  (setq layer_name_lst nil)
      (setq layer_name (cdadr (tblnext "LAYER" T)))
      (while layer_name
	(setq layer_name_lst
	       (append layer_name_lst (list layer_name))
	)
	(setq layer_name (cdadr (tblnext "LAYER")))
      )
      (setq I_th 0)
      (setq layer_name (nth i_th layer_name_lst))
      (while layer_name
	(ext21 layer_name)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
  (command "scale" "all" "" '(0 0) 25.4)
  (command "zoom" "e")
  (setvar "OSMODE" 2)
  (setq s_pt (getpoint "请点取左边'+'号的最左边的那条边的中点"))
  (setvar "OSMODE" 0)
  (command "move" "all" "" s_pt '(-74.548999 70.62423))
  (command "zoom" "e")
  (command "change" "all" "" "P" "LA" "0" "COLOR" "BYLAYER" "")
  (command "purge" "aLL" "" "N")
  (command "purge" "aLL" "" "N")
  (set_str)
)
(prompt "\n输入dyn运行,此程序，只进行改变PLINE延伸方向，加边框，加文字。\n对于存在的例如，PL，DBLCHK之类的工作，需要手工处理。\n程序会生成一个cross_tmp层用检查对位")






