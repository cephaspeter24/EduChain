;; Institution Integration Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

(define-map institution-databases
  principal
  {
    name: (string-utf8 100),
    api-endpoint: (string-utf8 256)
  }
)

(define-public (register-institution-database (institution principal) (name (string-utf8 100)) (api-endpoint (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set institution-databases
      institution
      {
        name: name,
        api-endpoint: api-endpoint
      }
    ))))

(define-public (update-institution-database (institution principal) (name (string-utf8 100)) (api-endpoint (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set institution-databases
      institution
      {
        name: name,
        api-endpoint: api-endpoint
      }
    ))))

(define-read-only (get-institution-database (institution principal))
  (ok (unwrap! (map-get? institution-databases institution) err-not-found)))

