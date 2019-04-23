;劲加凸版制作程序
;在1999年7月5日前，ke1=0.9818  ce1=0.3800 kf1=0.0008 cf1=0.2600
;last modify 2001/3/13 防滑条改为0.1mm
;last modify 2001/9/25 应客户要求将单粒的中心下移2.5mm，使单粒中心与ITO对齐

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9816
                ce1 0.2800 
                kf1 0.0000 
                cf1 0.2200
                number_x 0
                number_y 0
                total_x 0
                total_y 0
                glass_x 212
                glass_y 272
                e_pi 0
                g_pi 0
                h_pi 0
                f_pi 0
                i_pi 0
                j_pi 0
                r_pi 0 
          )
  )

( defun get_stretch_distance (total now)
        ( cond ( (= total 1)    ;Only one need to be stretched
                 ( if (> now 1)
                   ( prompt "Fatal error found !")
                   ( setq dst 0.05) ;You can change the constant to any suitable number 
                  )
                )
               ( (= total 2)  ;Two 
                 ( if (> now 2)
                   ( prompt "Fatal error found !")
                   ( cond ( (= now 2)
                            ( setq dst 0.02)
                           )
                          ( (= now 1)
                            ( setq dst 0.04)
                           )
                    )
                  )
                )
               ( (= total 3)    ;Three
                 ( if (> now 3)
                   ( prompt "Fatal error found !")
                   ( cond ( (= now 3)
                            ( setq dst 0.01)
                           )
                          ( (= now 2)
                            ( setq dst 0.02)
                           )
                          ( (= now 1)
                            ( setq dst 0.05)
                           )
                    )
                  )
                )
               ( T
                 ( prompt "Fatal error found !")
                )
         )
 )

 (defun draw_edge () 
        (command "pline" (list 383.347 2.0) "w" 0 0 
                         (list 422.0 2.0) 
                         (list 422.0 36.855) 
                         (list 424.0 36.855) 
                         (list 424.0 0.0) 
                         (list 383.347 0.0) 
                         "c"
         )
        (command "pline" (list 0.0 36.855) "w" 0 0 
                         (list 0.0 0.0) 
                         (list 32.5551 0.0) 
                         (list 32.5551 2.0) 
                         (list 2.0 2.0) 
                         (list 2.0 36.855) 
                         "c"
         )
        (command "pline" (list 2.1 2.175) "w" 0 0 
                         (list 421.9 2.175) 
                         (list 421.9 2.075) 
                         (list 2.1 2.075) 
                         "c"
         )
        (command "pline" (list 2.1 3.175) "w" 0 0 
                         (list 421.9 3.175) 
                         (list 421.9 3.075) 
                         (list 2.1 3.075) 
                         "c"
         )
        (command "pline" (list 2.1 4.175) "w" 0 0 
                         (list 421.9 4.175) 
                         (list 421.9 4.075) 
                         (list 2.1 4.075) 
                         "c"
         )
        (command "pline" (list 2.1 5.175) "w" 0 0 
                         (list 421.9 5.175) 
                         (list 421.9 5.075) 
                         (list 2.1 5.075) 
                         "c"
         )
        (command "pline" (list 2.1 6.175) "w" 0 0 
                         (list 421.9 6.175) 
                         (list 421.9 6.075) 
                         (list 2.1 6.075) 
                         "c"
         )
        (command "pline" (list 2.1 7.175) "w" 0 0 
                         (list 421.9 7.175) 
                         (list 421.9 7.075) 
                         (list 2.1 7.075) 
                         "c"
         )
        (command "pline" (list 2.1 8.175) "w" 0 0 
                         (list 421.9 8.175) 
                         (list 421.9 8.075) 
                         (list 2.1 8.075) 
                         "c"
         )
        (command "pline" (list 2.1 9.175) "w" 0 0 
                         (list 421.9 9.175) 
                         (list 421.9 9.075) 
                         (list 2.1 9.075) 
                         "c"
         )
        (command "pline" (list 2.1 10.175) "w" 0 0 
                         (list 421.9 10.175) 
                         (list 421.9 10.075) 
                         (list 2.1 10.075) 
                         "c"
         )
        (command "pline" (list 2.1 11.175) "w" 0 0 
                         (list 421.9 11.175) 
                         (list 421.9 11.075) 
                         (list 2.1 11.075) 
                         "c"
         )
        (command "pline" (list 2.1 12.175) "w" 0 0 
                         (list 421.9 12.175) 
                         (list 421.9 12.075) 
                         (list 2.1 12.075) 
                         "c"
         )
        (command "pline" (list 2.1 13.175) "w" 0 0 
                         (list 421.9 13.175) 
                         (list 421.9 13.075) 
                         (list 2.1 13.075) 
                         "c"
         )
        (command "pline" (list 2.1 14.175) "w" 0 0 
                         (list 421.9 14.175) 
                         (list 421.9 14.075) 
                         (list 2.1 14.075) 
                         "c"
         )
        (command "pline" (list 2.1 15.175) "w" 0 0 
                         (list 421.9 15.175) 
                         (list 421.9 15.075) 
                         (list 2.1 15.075) 
                         "c"
         )
        (command "pline" (list 2.1 16.175) "w" 0 0 
                         (list 421.9 16.175) 
                         (list 421.9 16.075) 
                         (list 2.1 16.075) 
                         "c"
         )
        (command "pline" (list 2.1 17.175) "w" 0 0 
                         (list 421.9 17.175) 
                         (list 421.9 17.075) 
                         (list 2.1 17.075) 
                         "c"
         )
        (command "pline" (list 2.1 18.175) "w" 0 0 
                         (list 421.9 18.175) 
                         (list 421.9 18.075) 
                         (list 2.1 18.075) 
                         "c"
         )
        (command "pline" (list 2.1 19.175) "w" 0 0 
                         (list 421.9 19.175) 
                         (list 421.9 19.075) 
                         (list 2.1 19.075) 
                         "c"
         )
        (command "pline" (list 2.1 20.175) "w" 0 0 
                         (list 421.9 20.175) 
                         (list 421.9 20.075) 
                         (list 2.1 20.075) 
                         "c"
         )
        (command "pline" (list 2.1 21.175) "w" 0 0 
                         (list 421.9 21.175) 
                         (list 421.9 21.075) 
                         (list 2.1 21.075) 
                         "c"
         )
        (command "pline" (list 2.1 22.175) "w" 0 0 
                         (list 421.9 22.175) 
                         (list 421.9 22.075) 
                         (list 2.1 22.075) 
                         "c"
         )
        (command "pline" (list 2.1 23.175) "w" 0 0 
                         (list 421.9 23.175) 
                         (list 421.9 23.075) 
                         (list 2.1 23.075) 
                         "c"
         )
        (command "pline" (list 2.1 24.175) "w" 0 0 
                         (list 421.9 24.175) 
                         (list 421.9 24.075) 
                         (list 2.1 24.075) 
                         "c"
         )
        (command "pline" (list 2.1 25.175) "w" 0 0 
                         (list 421.9 25.175) 
                         (list 421.9 25.075) 
                         (list 2.1 25.075) 
                         "c"
         )
        (command "pline" (list 2.1 26.175) "w" 0 0 
                         (list 421.9 26.175) 
                         (list 421.9 26.075) 
                         (list 2.1 26.075) 
                         "c"
         )
        (command "pline" (list 2.1 522.825) "w" 0 0 
                         (list 421.9 522.825) 
                         (list 421.9 522.925) 
                         (list 2.1 522.925) 
                         "c"
         )
        (command "pline" (list 2.1 523.825) "w" 0 0 
                         (list 421.9 523.825) 
                         (list 421.9 523.925) 
                         (list 2.1 523.925) 
                         "c"
         )
        (command "pline" (list 2.1 524.825) "w" 0 0 
                         (list 421.9 524.825) 
                         (list 421.9 524.925) 
                         (list 2.1 524.925) 
                         "c"
         )
        (command "pline" (list 2.1 525.825) "w" 0 0 
                         (list 421.9 525.825) 
                         (list 421.9 525.925) 
                         (list 2.1 525.925) 
                         "c"
         )
        (command "pline" (list 2.1 526.825) "w" 0 0 
                         (list 421.9 526.825) 
                         (list 421.9 526.925) 
                         (list 2.1 526.925) 
                         "c"
         )
        (command "pline" (list 2.1 527.825) "w" 0 0 
                         (list 421.9 527.825) 
                         (list 421.9 527.925) 
                         (list 2.1 527.925) 
                         "c"
         )
        (command "pline" (list 2.1 528.825) "w" 0 0 
                         (list 421.9 528.825) 
                         (list 421.9 528.925) 
                         (list 2.1 528.925) 
                         "c"
         )
        (command "pline" (list 2.1 529.825) "w" 0 0 
                         (list 421.9 529.825) 
                         (list 421.9 529.925) 
                         (list 2.1 529.925) 
                         "c"
         )
        (command "pline" (list 2.1 530.825) "w" 0 0 
                         (list 421.9 530.825) 
                         (list 421.9 530.925) 
                         (list 2.1 530.925) 
                         "c"
         )
        (command "pline" (list 2.1 531.825) "w" 0 0 
                         (list 421.9 531.825) 
                         (list 421.9 531.925) 
                         (list 2.1 531.925) 
                         "c"
         )
        (command "pline" (list 2.1 532.825) "w" 0 0 
                         (list 421.9 532.825) 
                         (list 421.9 532.925) 
                         (list 2.1 532.925) 
                         "c"
         )
        (command "pline" (list 2.1 533.825) "w" 0 0 
                         (list 421.9 533.825) 
                         (list 421.9 533.925) 
                         (list 2.1 533.925) 
                         "c"
         )
        (command "pline" (list 2.1 534.825) "w" 0 0 
                         (list 421.9 534.825) 
                         (list 421.9 534.925) 
                         (list 2.1 534.925) 
                         "c"
         )
        (command "pline" (list 2.1 535.825) "w" 0 0 
                         (list 421.9 535.825) 
                         (list 421.9 535.925) 
                         (list 2.1 535.925) 
                         "c"
         )
        (command "pline" (list 2.1 536.825) "w" 0 0 
                         (list 421.9 536.825) 
                         (list 421.9 536.925) 
                         (list 2.1 536.925) 
                         "c"
         )
        (command "pline" (list 2.1 537.825) "w" 0 0 
                         (list 421.9 537.825) 
                         (list 421.9 537.925) 
                         (list 2.1 537.925) 
                         "c"
         )
        (command "pline" (list 2.1 538.825) "w" 0 0 
                         (list 421.9 538.825) 
                         (list 421.9 538.925) 
                         (list 2.1 538.925) 
                         "c"
         )
        (command "pline" (list 2.1 539.825) "w" 0 0 
                         (list 421.9 539.825) 
                         (list 421.9 539.925) 
                         (list 2.1 539.925) 
                         "c"
         )
        (command "pline" (list 2.1 540.825) "w" 0 0 
                         (list 421.9 540.825) 
                         (list 421.9 540.925) 
                         (list 2.1 540.925) 
                         "c"
         )
        (command "pline" (list 2.1 541.825) "w" 0 0 
                         (list 421.9 541.825) 
                         (list 421.9 541.925) 
                         (list 2.1 541.925) 
                         "c"
         )
        (command "pline" (list 2.1 542.825) "w" 0 0 
                         (list 421.9 542.825) 
                         (list 421.9 542.925) 
                         (list 2.1 542.925) 
                         "c"
         )
        (command "pline" (list 2.1 543.825) "w" 0 0 
                         (list 421.9 543.825) 
                         (list 421.9 543.925) 
                         (list 2.1 543.925) 
                         "c"
         )
        (command "pline" (list 2.1 544.825) "w" 0 0 
                         (list 421.9 544.825) 
                         (list 421.9 544.925) 
                         (list 2.1 544.925) 
                         "c"
         )
        (command "pline" (list 2.1 545.825) "w" 0 0 
                         (list 421.9 545.825) 
                         (list 421.9 545.925) 
                         (list 2.1 545.925) 
                         "c"
         )
        (command "pline" (list 2.1 546.825) "w" 0 0 
                         (list 421.9 546.825) 
                         (list 421.9 546.925) 
                         (list 2.1 546.925) 
                         "c"
         )
        (command "pline" (list 389.9 485.2) "w" 0 0 
                         (list 389.9 475.3) 
                         (list 399.8 475.3) 
                         (list 399.8 475.1) 
                         (list 389.9 475.1) 
                         (list 389.9 465.2) 
                         (list 389.7 465.2) 
                         (list 389.7 475.1) 
                         (list 379.8 475.1) 
                         (list 379.8 475.3) 
                         (list 389.7 475.3) 
                         (list 389.7 485.2) 
                         "c"
         )
        (command "pline" (list 34.1 485.2) "w" 0 0 
                         (list 34.1 475.3) 
                         (list 24.2 475.3) 
                         (list 24.2 475.1) 
                         (list 34.1 475.1) 
                         (list 34.1 465.2) 
                         (list 34.3 465.2) 
                         (list 34.3 475.1) 
                         (list 44.2 475.1) 
                         (list 44.2 475.3) 
                         (list 34.3 475.3) 
                         (list 34.3 485.2) 
                         "c"
         )
        (command "pline" (list 12.25 62.25) "w" 0 0 
                         (list 19.5 62.25) 
                         (list 19.5 61.75) 
                         (list 12.25 61.75) 
                         (list 12.25 57.0) 
                         (list 11.75 57.0) 
                         (list 11.75 61.75) 
                         (list 4.5 61.75) 
                         (list 4.5 62.25) 
                         (list 11.75 62.25) 
                         (list 11.75 72.0) 
                         (list 12.25 72.0) 
                         "c"
         )
        (command "pline" (list 34.1 58.8) "w" 0 0 
                         (list 34.1 68.7) 
                         (list 24.2 68.7) 
                         (list 24.2 68.9) 
                         (list 34.1 68.9) 
                         (list 34.1 78.8) 
                         (list 34.3 78.8) 
                         (list 34.3 68.9) 
                         (list 44.2 68.9) 
                         (list 44.2 68.7) 
                         (list 34.3 68.7) 
                         (list 34.3 58.8) 
                         "c"
         )
        (command "pline" (list 53.95 71.55) "w" 0 0 
                         (list 53.95 72.55) 
                         (list 54.45 72.55) 
                         (list 54.45 71.55) 
                         (list 55.45 71.55) 
                         (list 55.45 71.05) 
                         (list 54.45 71.05) 
                         (list 54.45 70.05) 
                         (list 53.95 70.05) 
                         (list 53.95 71.05) 
                         (list 52.95 71.05) 
                         (list 52.95 71.55) 
                         "c"
         )
        (command "pline" (list 43.95 71.55) "w" 0 0 
                         (list 43.95 72.55) 
                         (list 44.45 72.55) 
                         (list 44.45 71.55) 
                         (list 45.45 71.55) 
                         (list 45.45 71.05) 
                         (list 44.45 71.05) 
                         (list 44.45 70.05) 
                         (list 43.95 70.05) 
                         (list 43.95 71.05) 
                         (list 42.95 71.05) 
                         (list 42.95 71.55) 
                         "c"
         )
        (command "pline" (list 411.75 62.25) "w" 0 0 
                         (list 404.5 62.25) 
                         (list 404.5 61.75) 
                         (list 411.75 61.75) 
                         (list 411.75 57.0) 
                         (list 412.25 57.0) 
                         (list 412.25 61.75) 
                         (list 419.5 61.75) 
                         (list 419.5 62.25) 
                         (list 412.25 62.25) 
                         (list 412.25 72.0) 
                         (list 411.75 72.0) 
                         "c"
         )
        (command "pline" (list 389.9 58.8) "w" 0 0 
                         (list 389.9 68.7) 
                         (list 399.8 68.7) 
                         (list 399.8 68.9) 
                         (list 389.9 68.9) 
                         (list 389.9 78.8) 
                         (list 389.7 78.8) 
                         (list 389.7 68.9) 
                         (list 379.8 68.9) 
                         (list 379.8 68.7) 
                         (list 389.7 68.7) 
                         (list 389.7 58.8) 
                         "c"
         )
        (command "pline" (list 380.05 71.55) "w" 0 0 
                         (list 380.05 72.55) 
                         (list 379.55 72.55) 
                         (list 379.55 71.55) 
                         (list 378.55 71.55) 
                         (list 378.55 71.05) 
                         (list 379.55 71.05) 
                         (list 379.55 70.05) 
                         (list 380.05 70.05) 
                         (list 380.05 71.05) 
                         (list 381.05 71.05) 
                         (list 381.05 71.55) 
                         "c"
         )
        (command "pline" (list 370.05 71.55) "w" 0 0 
                         (list 370.05 72.55) 
                         (list 369.55 72.55) 
                         (list 369.55 71.55) 
                         (list 368.55 71.55) 
                         (list 368.55 71.05) 
                         (list 369.55 71.05) 
                         (list 369.55 70.05) 
                         (list 370.05 70.05) 
                         (list 370.05 71.05) 
                         (list 371.05 71.05) 
                         (list 371.05 71.55) 
                         "c"
         )
        (command "pline" (list 12.25 267.0) "w" 0 0 
                         (list 11.75 267.0) 
                         (list 11.75 277.0) 
                         (list 12.25 277.0) 
                         "c"
         )
        (command "pline" (list 53.95 472.45) "w" 0 0 
                         (list 53.95 471.45) 
                         (list 54.45 471.45) 
                         (list 54.45 472.45) 
                         (list 55.45 472.45) 
                         (list 55.45 472.95) 
                         (list 54.45 472.95) 
                         (list 54.45 473.95) 
                         (list 53.95 473.95) 
                         (list 53.95 472.95) 
                         (list 52.95 472.95) 
                         (list 52.95 472.45) 
                         "c"
         )
        (command "pline" (list 43.95 472.45) "w" 0 0 
                         (list 43.95 471.45) 
                         (list 44.45 471.45) 
                         (list 44.45 472.45) 
                         (list 45.45 472.45) 
                         (list 45.45 472.95) 
                         (list 44.45 472.95) 
                         (list 44.45 473.95) 
                         (list 43.95 473.95) 
                         (list 43.95 472.95) 
                         (list 42.95 472.95) 
                         (list 42.95 472.45) 
                         "c"
         )
        (command "pline" (list 411.75 267.0) "w" 0 0 
                         (list 412.25 267.0) 
                         (list 412.25 277.0) 
                         (list 411.75 277.0) 
                         "c"
         )
        (command "pline" (list 380.05 472.45) "w" 0 0 
                         (list 380.05 471.45) 
                         (list 379.55 471.45) 
                         (list 379.55 472.45) 
                         (list 378.55 472.45) 
                         (list 378.55 472.95) 
                         (list 379.55 472.95) 
                         (list 379.55 473.95) 
                         (list 380.05 473.95) 
                         (list 380.05 472.95) 
                         (list 381.05 472.95) 
                         (list 381.05 472.45) 
                         "c"
         )
        (command "pline" (list 370.05 472.45) "w" 0 0 
                         (list 370.05 471.45) 
                         (list 369.55 471.45) 
                         (list 369.55 472.45) 
                         (list 368.55 472.45) 
                         (list 368.55 472.95) 
                         (list 369.55 472.95) 
                         (list 369.55 473.95) 
                         (list 370.05 473.95) 
                         (list 370.05 472.95) 
                         (list 371.05 472.95) 
                         (list 371.05 472.45) 
                         "c"
         )
        (command "pline" (list 12.25 491.75) "w" 0 0 
                         (list 19.5 491.75) 
                         (list 19.5 492.25) 
                         (list 12.25 492.25) 
                         (list 12.25 497.0) 
                         (list 11.75 497.0) 
                         (list 11.75 492.25) 
                         (list 4.5 492.25) 
                         (list 4.5 491.75) 
                         (list 11.75 491.75) 
                         (list 11.75 482.0) 
                         (list 12.25 482.0) 
                         "c"
         )
        (command "pline" (list 411.75 491.75) "w" 0 0 
                         (list 404.5 491.75) 
                         (list 404.5 492.25) 
                         (list 411.75 492.25) 
                         (list 411.75 497.0) 
                         (list 412.25 497.0) 
                         (list 412.25 492.25) 
                         (list 419.5 492.25) 
                         (list 419.5 491.75) 
                         (list 412.25 491.75) 
                         (list 412.25 482.0) 
                         (list 411.75 482.0) 
                         "c"
         )
        (command "pline" (list 0.0 512.145) "w" 0 0 
                         (list 0.0 549.0) 
                         (list 32.5551 549.0) 
                         (list 32.5551 547.0) 
                         (list 2.0 547.0) 
                         (list 2.0 512.145) 
                         "c"
         )
        (command "pline" (list 383.347 547.0) "w" 0 0 
                         (list 422.0 547.0) 
                         (list 422.0 512.145) 
                         (list 424.0 512.145) 
                         (list 424.0 549.0) 
                         (list 383.347 549.0) 
                         "c"
         )
  )

 ( defun auto_fix ( / move_step handle_number count
                      now_y all dst stretch_number
                      stretch_start_count
                   )
                  (setq handle_number (/ number_y 4))
                  ( if (< (* handle_number 4) number_y)
                    ( setq handle_number (1+ handle_number))
                    ( setq handle_number handle_number)
                   )

                  (if (>= handle_number 3)
                      (setq stretch_number 3)
                      (setq stretch_number handle_number)
                   )

                  (setq move_step (getreal "Input total moving distance : "))
                  (if (> handle_number 0)
                     (setq move_step (/ move_step handle_number)) 
                   )

                  (setq count 0)
                  (while (< count handle_number)
                         (setq now_y ( get_off_set count e_pi g_pi h_pi))
                         (setq all (ssget "c" (list -1 (1+ now_y)) (list (1+ total_x) (+ now_y (/ e_pi 2)))))
                         (if (< count stretch_number)
                             ( progn
                               (command "erase" all "")
                               (setq dst (get_stretch_distance stretch_number (1+ count)))
                               (draw_many_cells 0 (- now_y dst) f_pi (+ e_pi dst) number_x 1 i_pi j_pi g_pi h_pi)
                               (setq all (ssget "c" (list -1 (1+ now_y)) (list (1+ total_x) (+ now_y (/ e_pi 2)))))
                              )
                          )
                         (command "move" all "" (list 0 now_y) (list 0 (- now_y (* move_step (- handle_number count)))))
                         (setq count (1+ count))
                   )
  )

  ( defun get_off_set ( number width jj1 jj2 / number1 number2)
                      ( setq number1 ( fix ( / number 2)))
                      ( setq number2 ( rem number 2))
                      (+ ( * number1 ( + jj1 jj2 )) ( * number2 jj1  ) ( * number width ))
   )

  ( defun copy_many_cells ( copy_ss1 start_x start_y width_x width_y number_x number_y jj_x_1 jj_x_2 jj_y_1 jj_y_2 / count_x count_y offset_x offset_y)
                          ( setq count_y 0)
                          ( while ( < count_y number_y)
                                  ( setq count_x 0)
                                  ( while ( < count_x number_x)
                                          ( if ( and (= count_y 0) (= count_x 0))
                                               ( print "")
                                               ( progn
                                                 ( setq offset_x ( get_off_set count_x width_x jj_x_1 jj_x_2))
                                                 ( setq offset_y ( get_off_set count_y width_y jj_y_1 jj_y_2))
                                                 ( command "copy" copy_ss1 "" ( list start_x start_y) ( list ( + start_x offset_x) ( + start_y offset_y)))
                                                )
                                            )
                                           ( setq count_x (1+ count_x))
                                   )
                                  ( setq count_y (1+ count_y))
                            )
   )

  (defun draw_many_cells (start_x start_y f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi / p1 p2  p3 p4 ss1)
               ;Draw a pi cell
               (setq p1 (list start_x start_y) 
                     p2 (list (+ start_x f_pi) start_y)
                     p3 (list (+ start_x f_pi) (+ start_y e_pi))
                     p4 (list start_x (+ start_y e_pi)) 
                )
               (command "pline" p1 "w" 0 0 p2 p3 p4 "c")
               (setq ss1 (ssget "l"))
               (setvar "filletrad" r_pi)
               (command "fillet" "P" ss1)
               (copy_many_cells ss1 start_x start_y f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
   )
  
  ( defun get_input( / e_input g_input h_input f_input i_input j_input tmp)
	(defun chk_total (e g h n str_drct)
		  (setq et_input (getreal (strcat "请输入" str_drct "方向单料外边到ITO边的距离: ")))
	  	  (if (= str_drct "E")
		    (setq et_input (- 406.4 (* 2 et_input)))
		    (setq et_input (- 355.6 (* 2 et_input)))
	  	  )
		  (if (= (rem n 2) 1)
		    (setq et_cul (+ (* e n)
				    (* g (/ (- n 1) 2))
				    (* h (/ (- n 1) 2))
				 )
		    )
		    (setq et_cul (+ (* e n)
				    (* g (/ n 2))
				    (* h (- (/ n 2) 1))
				 )
		    )
		  )
		  (if (not (equal et_input et_cul 0.001))
		    (progn
		      (getstring (strcat "计算出的" str_drct "Total不同，请确认！"))
		      (getstring "可能是本款图形不居中，或输入的单料数值有误!")
		      (quit)
		    )
		  )
		)    
               ( setq e_input ( getreal "输入Y方向粒长E: ")
                      g_input ( getreal "输入Y方向间长G: ")
                      h_input ( getreal "输入Y方向间长H: ")
                      number_y ( getint "输入Y方向粒数EN: ")
		)
    		(chk_total e_input g_input h_input number_y "E")
    		(setq f_input ( getreal "输入X方向粒长F: ")
                      i_input ( getreal "输入X方向间长I: ")
                      j_input ( getreal "输入X方向间长J: ")
                      number_x ( getint "输入X方向粒数FN: ")
		)
    		(chk_total f_input i_input j_input number_x "F")    
    		(setq r_pi ( getreal "输入圆角孤半径R: ")
                      ke1 (+ ke1 (* 0.00003 number_y) )
                )

               (if (= (rem number_y 2) 1)
                 (progn
                    (setq tmp g_input)
                    (setq g_input h_input)
                    (setq h_input tmp)
                  )
                )

                ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
                       g_pi (* ke1 (+ g_input ce1))
                       h_pi (* ke1 (+ h_input ce1))
                       f_pi (- f_input (+ cf1 (* kf1 f_input)))
                       i_pi (+ i_input (+ cf1 (* kf1 f_input)))
                       j_pi (+ j_input (+ cf1 (* kf1 f_input)))
                 )
                
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )
  


;Main Program
(defun c:jinjia()
  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (command "mirror" "ALL" "" (list (/ total_x 2) 0) (list (/ total_x 2) 1) "Y")
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list glass_x glass_y))
  (draw_edge)
  (setq input_text ( strcase ( getstring T "输入产品编号和公司标记: ")))
  (setq txt_dt (list (cons 0 "TEXT") (cons 1 input_text)(cons 10 '(86 55)) (cons 40 6.3)))
  (entmake txt_dt)
  )
(prompt "\n输入JINJIA,运行程序，右上角正常方法读数")
  ;(command "text" (list 86 55) 6.3 0 input_text)

