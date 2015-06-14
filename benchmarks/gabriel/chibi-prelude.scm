
(import (chibi ast) (chibi time) (scheme cxr) (srfi 33) (srfi 39))

(define (timeval->milliseconds tv)
  (quotient (+ (* 1000000 (timeval-seconds tv)) (timeval-microseconds tv))
            1000))

(define (time* thunk)
  (call-with-output-string
    (lambda (out)
      (let* ((start (car (get-time-of-day)))
             (gc-start (gc-usecs))
             (result (parameterize ((current-output-port out)) (thunk)))
             (end (car (get-time-of-day)))
             (gc-end (gc-usecs))
             (gc-msecs (quotient (- gc-end gc-start) 1000))
             (msecs (- (timeval->milliseconds end)
                       (timeval->milliseconds start))))
        (display "user: ")
        (display msecs)
        (display " system: 0")
        (display " real: ")
        (display msecs)
        (display " gc: ")
        (display gc-msecs)
        (newline)
        (display "result: ")
        (write result)
        (newline)
        result))))

(define-syntax time
  (syntax-rules ()
    ((_ expr) (time* (lambda () expr)))))
