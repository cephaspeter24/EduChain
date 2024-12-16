;; Verification Portal Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

(define-map verified-employers principal bool)
(define-map credentials uint
  {
    recipient: principal,
    uri: (string-utf8 256),
    institution: (string-utf8 100),
    credential-type: (string-utf8 50),
    issue-date: uint,
    expiration-date: uint
  }
)

(define-data-var last-credential-id uint u0)

(define-public (add-verified-employer (employer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set verified-employers employer true))))

(define-public (remove-verified-employer (employer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-delete verified-employers employer))))

(define-public (add-credential (credential {
    recipient: principal,
    uri: (string-utf8 256),
    institution: (string-utf8 100),
    credential-type: (string-utf8 50),
    issue-date: uint,
    expiration-date: uint
  }))
  (let
    ((credential-id (+ (var-get last-credential-id) u1)))
    (asserts! (default-to false (map-get? verified-employers tx-sender)) err-owner-only)
    (map-set credentials credential-id credential)
    (var-set last-credential-id credential-id)
    (ok credential-id)))

(define-read-only (verify-credential (credential-id uint))
  (ok (unwrap! (map-get? credentials credential-id) err-not-found)))

